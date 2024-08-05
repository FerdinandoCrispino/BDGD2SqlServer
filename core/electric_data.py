from Tools.tools import return_query_as_dataframe, write_to_dss, ajust_eqre_codbanc
import pandas as pd
import dss_files_generator as dss_g
import time
import sys

"""
# @Date    : 20/06/2024
# @Author  : Ferdinano Crispino
Implemeta funcionalidades de leitua dos dados da BDGD para escrita dos arquivos do openDSS

# @Edited by: 
# @Date     :

"""


class ElectricDataPort:
    """
    Classe de comunicação com bancos de dados.
    """

    def __init__(self, dist, sub, mes, tipo_dia):
        # self.memoria_interna = memoria_interna
        self.sub = sub
        self.dist = dist
        self.mes = mes
        self.tipo_dia = tipo_dia
        self.circuitos = []
        self.curvas_cargas = []
        self.condutores = []
        self.chaves_mt = []
        self.reatores = []
        self.trafos = []
        self.trechos_mt = []
        self.cargas_mt = []
        self.cargas_mt_ssdmt = []
        self.carga_fc = []
        self.gerador_mt = []
        self.gerador_mt_ssdmt = []
        self.gerador_bt = []
        self.capacitors = []
        self.cargas_bt = []
        self.cargas_pip = []
        self.monitors = []

    def query_circuitos(self) -> bool:
        """
        Busca os dados de circuitos
        :return:
        """
        query = f'''
            SELECT c.[COD_ID], c.PAC_INI, c.TEN_OPE, t.TEN 
            FROM SDE.CTMT as c, [GEO_SIGR_DDAD_M10].SDE.TTEN as T 
            WHERE sub='{self.sub}' and c.TEN_NOM = t.COD_ID
            ;
        '''
        self.circuitos = return_query_as_dataframe(query)
        return True

    def query_reatores_mt(self, ctmt=None) -> bool:
        """
        Busca os dados de reatores MT
        :return:
        """
        if ctmt is None:
            query = f'''
                 SELECT c.COD_ID, c.PAC_1, c.PAC_2, c.Sub, c.TIP_REGU, c.BANC, c.FAS_CON, c.CTMT,
                        e.[POT_NOM], e.[TEN_REG], e.[LIG_FAS_P], e.[LIG_FAS_S], e.[COR_NOM], 
                        e.[REL_TP], e.[REL_TC], e.[PER_FER], e.[PER_TOT], e.[R], e.[XHL], e.[CODBNC], e.[GRU_TEN]
                 FROM SDE.UNREMT as c, SDE.EQRE as e 
                 WHERE c.dist = '{self.dist}' and c.sub='{self.sub}' and c.SIT_ATIV = 'AT' and 
                 (c.pac_1 = e.pac_1 or c.pac_2 = e.pac_2 or c.pac_1 = e.pac_2 or c.pac_2 = e.pac_1)
                 ;
            '''
        else:
            query = f'''
                 SELECT c.COD_ID, c.PAC_1, c.PAC_2, c.Sub, c.TIP_REGU, c.BANC, c.FAS_CON, c.CTMT,
                        e.[POT_NOM], e.[TEN_REG], e.[LIG_FAS_P], e.[LIG_FAS_S], e.[COR_NOM], 
                        e.[REL_TP], e.[PER_FER], e.[PER_TOT], e.[R], e.[XHL], e.[CODBNC], e.[GRU_TEN]
                 FROM SDE.UNREMT as c, SDE.EQRE as e 
                 WHERE c.dist = '{self.dist}' and c.sub='{self.sub}' and c.ctmt='{ctmt}' and c.SIT_ATIV = 'AT' and 
                 (c.pac_1 = e.pac_1 or c.pac_2 = e.pac_2 or c.pac_1 = e.pac_2 or c.pac_2 = e.pac_1)
                 ;
            '''
        self.reatores = return_query_as_dataframe(query)
        return True

    def query_crvcrg(self) -> bool:
        """
        Busca dados de curvas de cargas
        :return:
        """

        query = f'''
            SELECT *
            FROM SDE.CRVCRG 
            WHERE dist='{self.dist}' 
            ;
        '''
        self.curvas_cargas = return_query_as_dataframe(query)
        return True

    def query_segcon(self) -> bool:
        """
        Busca dados de condutores (LineCode)
        :return:
        """

        query = f'''
            SELECT COD_ID, R1, X1, CNOM
            FROM sde.SEGCON 
            WHERE dist='{self.dist}' 
            ;
        '''
        self.condutores = return_query_as_dataframe(query)
        return True

    def query_trafos_mt(self, ctmt=None) -> bool:
        """
        Busca dados de transformadores MT
        :return:
        """
        if ctmt is None:
            query = f'''
                SELECT u.COD_ID, u.CTMT, u.PAC_1, u.PAC_2, u.PAC_3, u.FAS_CON_P, u.FAS_CON_S, u.FAS_CON_T, 
                u.TIP_TRAFO, u.PER_TOT, u.PER_FER, u.POT_NOM, u.POS, u.TEN_LIN_SE, u.MRT, u.TAP, u.BANC,            
                t1.TEN as TEN_PRI, t2.TEN as TEN_SEC, t3.TEN as TEN_TER, 
                e.LIG, e.FAS_CON, e.POT_NOM as POT_NOM_EQ
                FROM (select distinct * from sde.EQTRMT) e
                INNER JOIN (select distinct * from sde.UNTRMT) U
                    on u.dist='{self.dist}' and u.sub='{self.sub}' and 
                    u.cod_id = e.UNI_TR_MT and u.POT_NOM > 0 and u.SIT_ATIV='AT'
                INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t1
                    on  t1.cod_id = e.TEN_PRI
                INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t2
                    on  t2.cod_id = e.TEN_SEC
                INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t3
                    on  t3.cod_id = e.TEN_TER                
                ;
            '''
        else:
            query = f'''
                SELECT u.COD_ID, u.CTMT, u.PAC_1, u.PAC_2, u.PAC_3, u.FAS_CON_P, u.FAS_CON_S, u.FAS_CON_T, 
                u.TIP_TRAFO, u.PER_TOT, u.PER_FER, u.POT_NOM, u.POS, u.TEN_LIN_SE, u.MRT, u.TAP, u.BANC,             
                t1.TEN as TEN_PRI, t2.TEN as TEN_SEC, t3.TEN as TEN_TER,
                e.LIG, e.FAS_CON, e.POT_NOM as POT_NOM_EQ
                FROM sde.EQTRMT e
                INNER JOIN  sde.UNTRMT U
                    on u.dist='{self.dist}' and u.sub='{self.sub}' and u.ctmt='{ctmt}' and 
                    u.cod_id = e.UNI_TR_MT and u.POT_NOM > 0 and u.SIT_ATIV='AT'
                INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t1
                    on  t1.cod_id = e.TEN_PRI
                INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t2
                    on  t2.cod_id = e.TEN_SEC
                INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t3
                    on  t3.cod_id = e.TEN_TER
                ;
            '''
        self.trafos = return_query_as_dataframe(query)
        return True

    def query_chaves_mt(self, ctmt=None) -> bool:
        """
        Busca dados de chaves MT
        :ctmt: Optional
        :return:
        """
        if ctmt is None:
            query = f'''
                SELECT COD_ID, CTMT, PAC_1, PAC_2, FAS_CON, P_N_OPE
                FROM sde.UNSEMT 
                WHERE dist='{self.dist}' and sub='{self.sub}' and SIT_ATIV='AT'
                ;
            '''
        else:
            query = f'''
                SELECT COD_ID, CTMT, PAC_1, PAC_2, FAS_CON, P_N_OPE
                FROM sde.UNSEMT 
                WHERE dist='{self.dist}' and sub='{self.sub}' and CTMT='{ctmt}' and SIT_ATIV='AT'
                ;
            '''
        self.chaves_mt = return_query_as_dataframe(query)
        return True

    def query_trechos_mt(self, ctmt):
        if ctmt is None:
            query = f'''
                SELECT COD_ID, CTMT, PAC_1, PAC_2, POS, FAS_CON, TIP_CND, COMP
                FROM sde.SSDMT 
                WHERE dist='{self.dist}' and sub='{self.sub}' 
                ;
            '''
        else:
            query = f'''
                SELECT COD_ID, CTMT, PAC_1, PAC_2, POS, FAS_CON, TIP_CND, COMP
                FROM sde.SSDMT 
                WHERE dist='{self.dist}' and sub='{self.sub}' and CTMT='{ctmt}' 
                ;
            '''
        self.trechos_mt = return_query_as_dataframe(query)
        return True

    def query_cargas_mt(self, ctmt=None) -> bool:
        """
        Busca dados das Cargas de Média Tensão para a escrever dos arquivos DSS
        :param ctmt:
        :return:
        """
        if ctmt is None:
            query = f'''
                SELECT u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TIP_CC, u.TEN_FORN, u.CEG_GD,
                    u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                    u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12,
                    [DEM_01],[DEM_02],[DEM_03],[DEM_04],[DEM_05],[DEM_06],
                    [DEM_07],[DEM_08],[DEM_09],[DEM_10],[DEM_11],[DEM_12],                
                    t1.TEN/1000 as KV_NOM, year(u.DATA_BASE) as ANO_BASE, t.POT_NOM
                FROM sde.UCMT u 
                LEFT JOIN sde.unTRmt t
                on u.pac = t.pac_1 or u.pac=t.PAC_2 
                INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t1
                    on u.dist='{self.dist}' and u.sub='{self.sub}' and t1.cod_id = u.TEN_FORN and u.sit_ativ = 'AT'
                        and u.pn_con != '0'
                ;
            '''
        else:
            query = f'''
                SELECT u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TIP_CC, u.TEN_FORN, u.CEG_GD,
                    u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                    u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12,                    
                    [DEM_01],[DEM_02],[DEM_03],[DEM_04],[DEM_05],[DEM_06],
                    [DEM_07],[DEM_08],[DEM_09],[DEM_10],[DEM_11],[DEM_12],                
                    t1.TEN/1000 as KV_NOM, year(u.DATA_BASE) as ANO_BASE, t.POT_NOM
                FROM sde.UCMT u 
                LEFT JOIN sde.unTRmt t
                on u.pac = t.pac_1 or u.pac=t.PAC_2 
                INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t1
                    on  u.dist='{self.dist}' and u.sub='{self.sub}' and u.CTMT='{ctmt}' and 
                    t1.cod_id = u.TEN_FORN and u.sit_ativ = 'AT' and u.pn_con != '0'
                ;
            '''
        self.cargas_mt = return_query_as_dataframe(query)
        return True

    def query_cargas_bt(self, ctmt=None) -> bool:
        """
        Busca dados das Cargas de Baixa Tensão para a escrever dos arquivos DSS
        As cargas são conectadas no transformador de média Tensão
        Busca dados de Cargas BT
        :return:
        """
        if ctmt is None:
            query = f'''
                SELECT distinct u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TIP_CC, u.TEN_FORN, u.CEG_GD,
                    u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                    u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12, 
                    t.TIP_TRAFO, t.TEN_LIN_SE, t.POT_NOM, t.PAC_2, year(t.DATA_BASE) as ANO_BASE
                FROM sde.UCBT u    
                INNER JOIN sde.UNTRMT T
                    on  t.COD_ID = u.UNI_TR_MT 
                where u.dist='{self.dist}' and u.sub = '{self.sub}' and u.sit_ativ = 'AT' and 
                    u.pn_con != '0'
                order by cod_id
                ;
            '''
        else:
            query = f'''
                SELECT distinct u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TIP_CC, u.TEN_FORN, u.CEG_GD,
                    u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                    u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12, 
                    t.TIP_TRAFO, t.TEN_LIN_SE, t.POT_NOM, t.PAC_2, year(t.DATA_BASE) as ANO_BASE
                FROM sde.UCBT u    
                INNER JOIN sde.UNTRMT T
                    on  t.COD_ID = u.UNI_TR_MT 
                where u.dist='{self.dist}' and u.sub = '{self.sub}' and u.ctmt = '{ctmt}' and u.sit_ativ = 'AT' and 
                    u.pn_con != '0'
                order by cod_id
                ;
            '''
        self.cargas_bt = return_query_as_dataframe(query)
        return True

    def query_cargas_pip(self, ctmt=None) -> bool:
        """
         Busca dados das Cargas de Iluminação Pública para a escrever nos arquivos DSS
         As cargas são conectadas no transformador de média Tensão
         :param ctmt:
         :return:
         """

        if ctmt is None:
            query = f'''
                SELECT distinct p.COD_ID, p.CTMT, p.PAC, p.FAS_CON, p.TIP_CC, p.TEN_FORN,
                     p.ENE_01, p.ENE_02, p.ENE_03, p.ENE_04, p.ENE_05, p.ENE_06, 
                     p.ENE_07, p.ENE_08, p.ENE_09, p.ENE_10, p.ENE_11, p.ENE_12, 
                     t.TIP_TRAFO, t.TEN_LIN_SE, t.POT_NOM, t.PAC_2, year(t.DATA_BASE) as ANO_BASE
                FROM sde.PIP P    
                INNER JOIN sde.UNTRMT T
                     on t.COD_ID = p.UNI_TR_MT 
                WHERE p.dist='{self.dist}' and p.sub = '{self.sub}' and p.sit_ativ = 'AT' and 
                    p.pn_con != '0'
                 ;
             '''
        else:
            query = f'''
                SELECT distinct p.COD_ID, p.CTMT, p.PAC, p.FAS_CON, p.TIP_CC, p.TEN_FORN,
                     p.ENE_01, p.ENE_02, p.ENE_03, p.ENE_04, p.ENE_05, p.ENE_06, 
                     p.ENE_07, p.ENE_08, p.ENE_09, p.ENE_10, p.ENE_11, p.ENE_12, 
                     t.TIP_TRAFO, t.TEN_LIN_SE, t.POT_NOM, t.PAC_2, year(t.DATA_BASE) as ANO_BASE
                FROM sde.PIP P    
                INNER JOIN sde.UNTRMT T
                     on t.COD_ID = p.UNI_TR_MT 
                WHERE p.dist='{self.dist}' and p.sub = '{self.sub}' and p.ctmt = '{ctmt}' and p.sit_ativ = 'AT' and 
                    p.pn_con != '0'
                ;
             '''
        self.cargas_pip = return_query_as_dataframe(query)
        return True

    def query_check_cod_ten_gerador_mt(self):
        """
        Verifica se a tensão do gerador é igual a tensõa do transformador da linha onde ele está conectado.
        Verificar se é possivel fazer um update na tabela UGMT substituindo o cod da tensão pelo cod da tensão do trafo.
        :return:
        """
        query = f'''
            SELECT u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TEN_FORN, u.CEG_GD, q.TEN_PRI
            FROM sde.UGMT u
            INNER JOIN sde.UNTRMT T
                on u.PAC = T.PAC_1
            INNER JOIN sde.EQTRMT Q
                on T.COD_ID = q.UNI_TR_MT
            where q.TEN_PRI != u.TEN_FORN
            ;
        '''

    def query_generators_bt(self, ctmt=None) -> bool:
        """

        :param ctmt:
        :return:
        """
        if ctmt is None:
            query = f'''
                SELECT u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TEN_FORN, u.CEG_GD,
                     u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                     u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12,
                     t1.TEN/1000 as KV_NOM, year(u.DATA_BASE) as ANO_BASE, 
                     q.TEN_PRI, q.TEN_SEC, t2.TEN/1000 as kv_sec, u.TEN_CON, 
                     t.TIP_TRAFO, t.PAC_2 as PAC_TRAFO, T.FAS_CON_P, T.FAS_CON_S, T.FAS_CON_T
                FROM sde.UGBT u
                INNER JOIN sde.UNTRMT T
                     on u.UNI_TR_MT = T.COD_ID
                INNER JOIN sde.EQTRMT Q
                     on T.COD_ID = q.UNI_TR_MT
                INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN t2
                     on  t2.cod_id = q.TEN_SEC
                INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN t1
                     on u.dist = '{self.dist}' and u.sub='{self.sub}' and u.SIT_ATIV='AT' and t1.cod_id = u.TEN_CON
                ;  
             '''
        else:
            query = f'''
                SELECT u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TEN_FORN, u.CEG_GD,
                     u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                     u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12,
                     t1.TEN/1000 as KV_NOM, year(u.DATA_BASE) as ANO_BASE, 
                     q.TEN_PRI, q.TEN_SEC, t2.TEN/1000 as KV_TRAFO_SEC, u.TEN_CON, 
                     t.TIP_TRAFO, t.PAC_2 as PAC_TRAFO, T.FAS_CON_P, T.FAS_CON_S, T.FAS_CON_T
                FROM sde.UGBT u
                INNER JOIN sde.UNTRMT T
                     on u.UNI_TR_MT = T.COD_ID
                INNER JOIN sde.EQTRMT Q
                     on T.COD_ID = q.UNI_TR_MT
                INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN t2
                     on  t2.cod_id = q.TEN_SEC
                INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN t1
                     on u.dist = '{self.dist}' and u.sub='{self.sub}' and u.ctmt='{ctmt}' and u.SIT_ATIV='AT' and 
                     t1.cod_id = u.TEN_CON
                 ;  
             '''

        self.gerador_bt = return_query_as_dataframe(query)
        return True

    def query_generators_mt(self, ctmt=None) -> bool:
        """
        Busca dados dos GERADORES de Média Tensão para a escrever dos arquivos DSS
        Geradores conectados aos transformadores de média tensão
        :param ctmt:
        :return:

        """
        if ctmt is None:
            query = f'''
                SELECT u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TEN_FORN, u.CEG_GD,
                    u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                    u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12,
                    [DEM_01],[DEM_02],[DEM_03],[DEM_04],[DEM_05],[DEM_06],
                    [DEM_07],[DEM_08],[DEM_09],[DEM_10],[DEM_11],[DEM_12],                
                    t1.TEN/1000 as KV_NOM, year(u.DATA_BASE) as ANO_BASE, 
                    q.TEN_PRI, q.TEN_PRI/100 as KV_TRAFO, u.TEN_CON
                FROM sde.UGMT u
                INNER JOIN sde.UNTRMT T
                    on u.PAC = T.PAC_1
                INNER JOIN sde.EQTRMT Q
                    on T.COD_ID = q.UNI_TR_MT
                INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN t2
                     on  t2.cod_id = q.TEN_PRI
                INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN t1
                    on u.dist = '{self.dist}' and u.sub='{self.sub}' and u.SIT_ATIV='AT' and t1.cod_id = u.TEN_FORN
                ;  
            '''
        else:
            query = f'''
                SELECT u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TEN_FORN, u.CEG_GD,
                    u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                    u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12,
                    [DEM_01],[DEM_02],[DEM_03],[DEM_04],[DEM_05],[DEM_06],
                    [DEM_07],[DEM_08],[DEM_09],[DEM_10],[DEM_11],[DEM_12],                
                    t1.TEN/1000 as KV_NOM, year(u.DATA_BASE) as ANO_BASE, 
                    q.TEN_PRI, q.TEN_PRI/100 as KV_TRAFO, u.TEN_CON
                FROM sde.UGMT u
                INNER JOIN sde.UNTRMT T
                    on u.PAC = T.PAC_1
                INNER JOIN sde.EQTRMT Q
                    on T.COD_ID = q.UNI_TR_MT
                INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN t2
                     on  t2.cod_id = q.TEN_PRI
                INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN t1
                    on u.dist = '{self.dist}' and u.sub='{self.sub}' and u.ctmt='{ctmt}' and u.SIT_ATIV='AT' and 
                    t1.cod_id = u.TEN_FORN
                ;  
            '''
        self.gerador_mt = return_query_as_dataframe(query)
        return True

    def query_generators_mt_ssdmt(self, ctmt=None) -> bool:
        """
        Busca dados dos GERADORES de Média Tensão para a escrever dos arquivos DSS
        Geradores conectados aos segmentos de média tensão
        :param ctmt:
        :return:

        """
        if ctmt is None:
            query = f'''
                SELECT distinct u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TEN_FORN, u.CEG_GD,
                    u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                    u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12,   
                    t1.TEN/1000 as KV_FORM, t2.TEN/1000 as KV_CON, year(u.DATA_BASE) as ANO_BASE, 
                    u.TEN_CON 
                FROM sde.UGMT u
                INNER JOIN sde.SSDMT T
                    on u.dist = '{self.dist}' and u.sub='{self.sub}' and u.SIT_ATIV='AT' and  
                   (u.PAC = T.PAC_1 or u.PAC = T.PAC_2)
                left JOIN [GEO_SIGR_DDAD_M10].sde.TTEN t1
                    on t1.cod_id = u.TEN_FORN
                left JOIN [GEO_SIGR_DDAD_M10].sde.TTEN t2
                    on t2.cod_id = u.TEN_CON
                 ;  
             '''
        else:
            query = f'''
                SELECT distinct u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TEN_FORN, u.CEG_GD,
                    u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                    u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12,   
                    t1.TEN/1000 as KV_FORM, t2.TEN/1000 as KV_CON,  year(u.DATA_BASE) as ANO_BASE, 
                    u.TEN_CON 
                FROM sde.UGMT u
                INNER JOIN sde.SSDMT T
                    on u.dist = '{self.dist}' and u.sub='{self.sub}' and u.ctmt='{ctmt}' and u.SIT_ATIV='AT' and  
                    (u.PAC = T.PAC_1 or u.PAC = T.PAC_2)
                left JOIN [GEO_SIGR_DDAD_M10].sde.TTEN t1
                    on t1.cod_id = u.TEN_FORN
                left JOIN [GEO_SIGR_DDAD_M10].sde.TTEN t2
                    on t2.cod_id = u.TEN_CON
                ;  
             '''
        self.gerador_mt_ssdmt = return_query_as_dataframe(query)
        return True

    def query_fator_de_carga(self) -> bool:
        """
        O fator de carga é utilizado para calcular a demanda máxima a partir da energia para nos casos
        que não é fornecido a demanda mensal.
        :param cod_id: Codigo da curva de carga.
        :param tipo_dia: DO, DU ou SA
        :return:
        """

        query = f'''
            select s.COD_ID, s.TIP_DIA, (s.DEM_MED/s.DEN_MAX) as FC
            from (
            SELECT COD_ID, TIP_DIA, GREATEST(
            [POT_01] ,[POT_02] ,[POT_03] ,[POT_04] ,[POT_05] ,[POT_06] ,[POT_07] ,[POT_08] ,[POT_09],
            [POT_10] ,[POT_11] ,[POT_12] ,[POT_13],[POT_14] ,[POT_15] ,[POT_16] ,[POT_17] ,[POT_18],[POT_19],
            [POT_20] ,[POT_21], [POT_22] ,[POT_23],[POT_24] ,[POT_25] ,[POT_26] ,[POT_27] ,[POT_28],[POT_29] ,[POT_30],
            [POT_31] ,[POT_32] ,[POT_33] ,[POT_34],[POT_35] ,[POT_36] ,[POT_37] ,[POT_38] ,[POT_39],[POT_40] ,[POT_41],
            [POT_42] ,[POT_43] ,[POT_44] ,[POT_45],[POT_46] ,[POT_47], [POT_48] ,[POT_49] ,[POT_50],[POT_51] ,[POT_52],
            [POT_53] ,[POT_54] ,[POT_55] ,[POT_56],[POT_57] ,[POT_58] ,[POT_59] ,[POT_60], [POT_61],[POT_62] ,[POT_63],
            [POT_64] ,[POT_65] ,[POT_66] ,[POT_67],[POT_68] ,[POT_69] ,[POT_70] ,[POT_71], [POT_72],[POT_73] ,[POT_74],
            [POT_75] ,[POT_76] ,[POT_77] ,[POT_78],[POT_79] ,[POT_80] ,[POT_81] ,[POT_82], [POT_83],[POT_84] ,[POT_85],
            [POT_86] ,[POT_87] ,[POT_88], [POT_89],[POT_90] ,[POT_91], [POT_92] ,[POT_93] ,[POT_94],[POT_95] ,[POT_96]
            ) as DEN_MAX
            ,([POT_01] +[POT_02] +[POT_03] +[POT_04] +[POT_05] +[POT_06] +[POT_07] +[POT_08] +[POT_09] +[POT_10]
             +[POT_11] +[POT_12] +[POT_13] +[POT_14] +[POT_15] +[POT_16] +[POT_17] +[POT_18] +[POT_19] +[POT_20] 
             +[POT_21] +[POT_22] +[POT_23] +[POT_24] +[POT_25] +[POT_26] +[POT_27] +[POT_28] +[POT_29] +[POT_30] 
             +[POT_31] +[POT_32] +[POT_33] +[POT_34] +[POT_35] +[POT_36] +[POT_37] +[POT_38] +[POT_39] +[POT_40] 
             +[POT_41] +[POT_42] +[POT_43] +[POT_44] +[POT_45] +[POT_46] +[POT_47] +[POT_48] +[POT_49] +[POT_50]
             +[POT_51] +[POT_52] +[POT_53] +[POT_54] +[POT_55] +[POT_56] +[POT_57] +[POT_58] +[POT_59] +[POT_60] 
             +[POT_61] +[POT_62] +[POT_63] +[POT_64] +[POT_65] +[POT_66] +[POT_67] +[POT_68] +[POT_69] +[POT_70] 
             +[POT_71] +[POT_72] +[POT_73] +[POT_74] +[POT_75] +[POT_76] +[POT_77] +[POT_78] +[POT_79] +[POT_80] 
             +[POT_81] +[POT_82] +[POT_83] +[POT_84] +[POT_85] +[POT_86] +[POT_87] +[POT_88] +[POT_89] +[POT_90] 
             +[POT_91] +[POT_92] +[POT_93] +[POT_94]+ [POT_95] +[POT_96])/(4*24) as DEM_MED
              FROM [sde].[CRVCRG] 
              ) as s
            ;
        '''
        self.carga_fc = return_query_as_dataframe(query)
        return True

    def query_monitors(self, ctmt) -> bool:
        query = f'''
                SELECT E.COD_ID, E.ELEM FROM (
                    SELECT  'Line.SMT_' + A.COD_ID AS COD_ID, 'SSDMT' AS ELEM FROM sde.SSDMT A
                    INNER JOIN sde.CTMT  B
                    ON A.PAC_1 = B.PAC_INI WHERE B.sub='{self.sub}' and B.COD_ID='{ctmt}'
                    UNION ALL
                    SELECT TOP 1 'Line.SMT_' + A.COD_ID AS COD_ID, 'SSDMT' AS ELEM FROM sde.SSDMT A
                    INNER JOIN sde.CTMT  B
                    ON A.PAC_2 = B.PAC_INI WHERE B.sub='{self.sub}' and B.COD_ID='{ctmt}'
                    UNION ALL
                    SELECT TOP 1 'Line.CMT_' + C.COD_ID AS COD_ID, 'UNSEMT' AS ELEM FROM sde.UNSEMT C
                    INNER JOIN sde.CTMT  D
                    ON C.PAC_1 = D.PAC_INI WHERE D.sub='{self.sub}' and D.COD_ID='{ctmt}' AND C.P_N_OPE='F'
                    UNION ALL
                    SELECT TOP 1 'Line.CMT_' + C.COD_ID AS COD_ID, 'UNSEMT' AS ELEM FROM sde.UNSEMT C
                    INNER JOIN sde.CTMT  D
                    ON C.PAC_2 = D.PAC_INI WHERE D.sub='{self.sub}' and D.COD_ID='{ctmt}' AND C.P_N_OPE='F'
                ) E
                ;
            '''
        self.monitors = return_query_as_dataframe(query)
        return True

    def query_capacitor(self, ctmt):
        query = f'''                       
                SELECT A.COD_ID, A.POT_NOM, A.PAC_1, A.FAS_CON, B.POT, S.COD_ID as LiNE_COD, V.TEN
                FROM SDE.UNCRMT A 
                INNER JOIN sde.ctmt C
                    on A.CTMT = C.COD_ID 
                INNER JOIN sde.ssdmt S
                    on A.PAC_1 = S.PAC_1
                INNER JOIN [GEO_SIGR_DDAD_M10].sde.TPOTRTV B
                    ON A.POT_NOM = B.COD_ID 
                INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN V
                    on V.COD_ID = C.TEN_NOM
                WHERE s.dist = '{self.dist}' and s.sub='{self.sub}' and A.CTMT='{ctmt}' and A.SIT_ATIV='AT'
                ;
            '''
        self.capacitors = return_query_as_dataframe(query)
        return True

    def query_cargas_mt_ssdmt(self, ctmt=None) -> bool:
        """
        Busca dados das Cargas de Média Tensão para a escrever dos arquivos DSS
        Seleciona as Cargas conectadas no Segmento
        :param ctmt:
        :return:
        """

        query = f'''
            SELECT distinct u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TIP_CC, u.TEN_FORN, u.CEG_GD,
                u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12,                    
                t1.TEN/1000 as KV_NOM, year(u.DATA_BASE) as ANO_BASE, t.FAS_CON as FAS_CON_SSDMT, 
                c.TEN_NOM, t2.TEN/1000 as KV_CTMT
            FROM sde.UCMT u 
            INNER JOIN sde.SSDMT t
               on u.pac = t.pac_1 or u.pac=t.PAC_2 
            inner join (select distinct cod_id, ten_nom from sde.ctmt) c
                on c.cod_id = u.CTMT
            INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t1                
                on t1.cod_id = u.TEN_FORN 
            INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t2              
                on t2.cod_id = c.TEN_NOM 
            Where  u.dist='{self.dist}' and u.sub='{self.sub}' and u.CTMT='{ctmt}' and 
                u.sit_ativ = 'AT' and u.pn_con != '0'
            ;
        '''
        self.cargas_mt_ssdmt = return_query_as_dataframe(query)
        return True

    def voltage_bases(self, df_voltage) -> list:
        voltagebases = []
        vbase = df_voltage[['TEN_PRI', 'TEN_SEC', 'TEN_TER']].copy()

        vbase_1 = vbase.iloc[0:, [0]].drop_duplicates().values.tolist()
        for xs in vbase_1:
            for x in xs:
                if int(x) > 0:
                    x = x / 1000
                    voltagebases.append(x)

        vbase_2 = vbase.iloc[0:, [1]].drop_duplicates().values.tolist()
        for xs in vbase_2:
            for x in xs:
                if int(x) > 0:
                    x = x / 1000
                    voltagebases.append(x)
                    # voltagebases.append(x / 2)  # tensão do secundario de trafo MRT

        vbase_3 = vbase.iloc[0:, [2]].drop_duplicates().values.tolist()
        for xs in vbase_3:
            for x in xs:
                if int(x) > 0:
                    x = x / 1000
                    voltagebases.append(x)

        return voltagebases


def write_files_dss(cod_sub, cod_dist, mes, tipo_dia):
    # Definir código da subestação (sub) e da distribuidora (dist)
    sub = cod_sub
    dist = cod_dist
    mes = mes
    tipo_dia = tipo_dia

    print(f"Tratamento para empresa: {dist} subestação: {sub}, mes: {mes} e tipo dia: {tipo_dia}")
    nome_arquivo_crv = f'{tipo_dia}_{mes}_CurvaCarga_{dist}_{sub}'
    nome_arquivo_sup = f'{tipo_dia}_{mes}_Circuito_{dist}_{sub}'
    nome_arquivo_cnd = f'{tipo_dia}_{mes}_CodCondutores_{dist}_{sub}'
    nome_arquivo_chv_mt = f'{tipo_dia}_{mes}_ChavesMT_{dist}_{sub}'
    nome_arquivo_re_mt = f'{tipo_dia}_{mes}_ReatoresMT_{dist}_{sub}'
    nome_arquivo_tr_mt = f'{tipo_dia}_{mes}_TrafosMT_{dist}_{sub}'
    nome_arquivo_seg_mt = f'{tipo_dia}_{mes}_TrechoMT_{dist}_{sub}'
    nome_arquivo_crg_mt = f'{tipo_dia}_{mes}_CargasMT_{dist}_{sub}'
    nome_arquivo_monitors = f'{tipo_dia}_{mes}_Monitors_{dist}_{sub}'
    nome_arquivo_capacitors = f'{tipo_dia}_{mes}_Capacitors_{dist}_{sub}'
    nome_arquivo_crg_bt = f'{tipo_dia}_{mes}_CargasBT_{dist}_{sub}'
    nome_arquivo_generators_mt_dss = f'{tipo_dia}_{mes}_GeradoresMT_{dist}_{sub}'
    nome_arquivo_generators_bt_dss = f'{tipo_dia}_{mes}_GeradoresBT_{dist}_{sub}'
    nome_arquivo_master = f'{tipo_dia}_{mes}_Master_{dist}_{sub}'

    list_files_dss = [nome_arquivo_crv, nome_arquivo_sup, nome_arquivo_cnd, nome_arquivo_chv_mt, nome_arquivo_re_mt,
                      nome_arquivo_tr_mt, nome_arquivo_seg_mt, nome_arquivo_crg_mt, nome_arquivo_monitors,
                      nome_arquivo_capacitors, nome_arquivo_crg_bt, nome_arquivo_generators_mt_dss,
                      nome_arquivo_generators_bt_dss]

    linhas_suprimento_dss = []
    linhas_curvas_carga_dss = []
    linhas_condutores_dss = []
    linhas_chaves_mt_dss = []
    linhas_reatores_mt_dss = []
    linhas_trafos_mt_dss = []
    linhas_trechos_mt_dss = []
    linhas_cargas_mt_dss = []
    linhas_monitors_dss = []
    linhas_capacitors_dss = []
    linhas_cargas_bt_dss = []
    linhas_generators_mt_dss = []
    linhas_generators_bt_dss = []
    linhas_master = []

    multi_ger = []
    multi_ger.append(['GeradorMT-Tipo1',
                      [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.213170, 0.493614, 0.767539, 0.930065, 1.000000,
                       0.908147,
                       0.682011, 0.461154, 0.024685, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]])
    multi_ger.append(['GeradorBT-Tipo1',
                      [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.213170, 0.493614, 0.767539, 0.930065, 1.000000,
                       0.908147,
                       0.682011, 0.461154, 0.024685, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]])

    # inicializa classes de manipulação dos dados da bdgd
    dss_adapter = dss_g.DssFilesGenerator()
    bdgd_read = ElectricDataPort(dist, sub, mes, tipo_dia)

    print(f'Ajusting CodBNC....')
    ajust_eqre_codbanc(dist)

    # Leitura de dados dos circuitos de uma subestação da bdgd
    print(f'Process Circuit....')
    bdgd_read.query_circuitos()

    # leitura de dados de condutores
    print(f'Process LineCode....')
    bdgd_read.query_segcon()
    dss_adapter.get_lines_condutores(bdgd_read.condutores, linhas_condutores_dss)

    # leitura de dados de curvas de carga da bdgd
    print(f'Process LoadShape....')
    bdgd_read.query_crvcrg()
    dss_adapter.get_lines_curvas_carga(bdgd_read.curvas_cargas, multi_ger, linhas_curvas_carga_dss)

    # Fator de carga
    bdgd_read.query_fator_de_carga()

    for i in range(bdgd_read.circuitos.shape[0]):
        cod_circuito = bdgd_read.circuitos.loc[i]['COD_ID']
        print(f'Process circuit:{cod_circuito}')

        # Grava arquivo DSS de curva de cargas
        # No mesmo arquivo as curvas de carga tipicas AT, MT e BT e diferentes tipos de dias (DU, SA, DO).
        write_to_dss(dist, sub, cod_circuito, linhas_curvas_carga_dss, nome_arquivo_crv)

        # Grava arquivo DSS LineCode
        write_to_dss(dist, sub, cod_circuito, linhas_condutores_dss, nome_arquivo_cnd)

        #  leitura de dados do circuito
        circuito_dict = bdgd_read.circuitos.loc[i].to_dict()
        dss_adapter.get_lines_suprimento_circuito(sub, circuito_dict, linhas_suprimento_dss)
        # Grava arquivo DSS para o circuito
        write_to_dss(dist, sub, cod_circuito, linhas_suprimento_dss, nome_arquivo_sup)

        # leitura de dados das chaves MT por circuito
        bdgd_read.query_chaves_mt(cod_circuito)
        dss_adapter.get_lines_chaves_mt(bdgd_read.chaves_mt, linhas_chaves_mt_dss)
        # Grava arquivo DSS Chaves_MT
        write_to_dss(dist, sub, cod_circuito, linhas_chaves_mt_dss, nome_arquivo_chv_mt)

        # Grava arquivo DSS para o reatores
        bdgd_read.query_reatores_mt(cod_circuito)
        dss_adapter.get_lines_reguladores(bdgd_read.reatores, linhas_reatores_mt_dss)
        write_to_dss(dist, sub, cod_circuito, linhas_reatores_mt_dss, nome_arquivo_re_mt)

        # Grava arquivo DSS para o Transformadores MT
        bdgd_read.query_trafos_mt(cod_circuito)
        dss_adapter.get_lines_trafos(bdgd_read.trafos, linhas_trafos_mt_dss)
        write_to_dss(dist, sub, cod_circuito, linhas_trafos_mt_dss, nome_arquivo_tr_mt)

        # Grava arquivo DSS para o Trechos MT
        bdgd_read.query_trechos_mt(cod_circuito)
        is_bt = False
        dss_adapter.get_lines_trechos_mt(is_bt, bdgd_read.trechos_mt, linhas_trechos_mt_dss)
        write_to_dss(dist, sub, cod_circuito, linhas_trechos_mt_dss, nome_arquivo_seg_mt)

        # Grava arquivo DSS para o cargas MT
        # bdgd_read.query_cargas_mt(cod_circuito)
        # dss_adapter.get_lines_cargas_mt(bdgd_read.cargas_mt, bdgd_read.carga_fc, linhas_cargas_mt_dss)
        # write_to_dss(dist, sub, cod_circuito, linhas_cargas_mt_dss, nome_arquivo_crg_mt)
        # ...conectados nos segmentos
        bdgd_read.query_cargas_mt_ssdmt(cod_circuito)
        dss_adapter.get_lines_cargas_mt_ssdmt(bdgd_read.cargas_mt_ssdmt, bdgd_read.carga_fc, linhas_cargas_mt_dss)
        write_to_dss(dist, sub, cod_circuito, linhas_cargas_mt_dss, nome_arquivo_crg_mt)

        # Grava arquivo DSS para monitores
        bdgd_read.query_monitors(cod_circuito)
        dss_adapter.get_lines_medidores(bdgd_read.monitors, linhas_monitors_dss)
        write_to_dss(dist, sub, cod_circuito, linhas_monitors_dss, nome_arquivo_monitors)

        # Grava arquivo DSS para capacitors
        bdgd_read.query_capacitor(cod_circuito)
        dss_adapter.get_line_capacitor(bdgd_read.capacitors, linhas_capacitors_dss)
        write_to_dss(dist, sub, cod_circuito, linhas_capacitors_dss, nome_arquivo_capacitors)

        # Grava arquivo DSS para cargas BT
        bdgd_read.query_cargas_bt(cod_circuito)
        bdgd_read.query_cargas_pip(cod_circuito)
        dss_adapter.get_lines_cargas_bt(bdgd_read.cargas_bt, bdgd_read.carga_fc, bdgd_read.cargas_pip,
                                        linhas_cargas_bt_dss)
        write_to_dss(dist, sub, cod_circuito, linhas_cargas_bt_dss, nome_arquivo_crg_bt)

        # leitura de dados dos Geradores mt conectados nos trafos
        # bdgd_read.query_generators_mt(cod_circuito)  # conetados no trafo
        # dss_adapter.get_lines_generators_mt(bdgd_read.gerador_mt, multi_ger, linhas_generators_mt_dss)
        # ...conectados nos segmentos
        bdgd_read.query_generators_mt_ssdmt(cod_circuito)
        dss_adapter.get_lines_generators_mt_ssdmt(bdgd_read.gerador_mt_ssdmt, multi_ger, linhas_generators_mt_dss)
        write_to_dss(dist, sub, cod_circuito, linhas_generators_mt_dss, nome_arquivo_generators_mt_dss)

        # Grava arquivo DSS para o Gerador BT
        bdgd_read.query_generators_bt(cod_circuito)
        dss_adapter.get_lines_generators_bt(bdgd_read.gerador_bt, multi_ger, linhas_generators_bt_dss)
        write_to_dss(dist, sub, cod_circuito, linhas_generators_bt_dss, nome_arquivo_generators_bt_dss)

        # Grava arquivo DSS para o master
        voltagebases = bdgd_read.voltage_bases(bdgd_read.trafos)
        dss_adapter.get_lines_master(cod_circuito, voltagebases, list_files_dss, linhas_trafos_mt_dss, linhas_master)
        write_to_dss(dist, sub, cod_circuito, linhas_master, nome_arquivo_master)


if __name__ == "__main__":
    # Definir código da subestação (sub) e da distribuidora (dist)

    dist = '404'  # Energisa MS
    #ist_sub = ['40', '100', '58', '95', '96', '97']
    list_sub = ['100']

    # dist = '391'  # EDP_SP
    # list_sub = ['ITQ']
    mes = 1  # [1 12] mes do ano de referência para os dados de cargas e geração
    tipo_de_dias = ['DU', 'DO', 'SA']  # tipo de dia para referência para as curvas típicas de carga e geração

    control_of_run = True  # controle de execução para apenas um primeiro mes e um primeiro tipo de dia
    for tipo_dia in tipo_de_dias:
        for mes in range(1, 13):
            for sub in list_sub:
                write_files_dss(sub, dist, mes, tipo_dia)
            if control_of_run:
                break
        if control_of_run:
            break
