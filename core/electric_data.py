from Tools.tools import return_query_as_dataframe, write_to_dss, ajust_eqre_codbanc
import pandas as pd
import dss_files_genetator as dss_g
import time

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

    def __init__(self, dist, sub):
        # self.memoria_interna = memoria_interna
        self.sub = sub
        self.dist = dist
        self.circuitos = []
        self.curvas_cargas = []
        self.condutores = []
        self.chaves_mt = []
        self.reatores = []
        self.trafos = []
        self.trechos_mt = []
        self.cargas_mt = []
        self.carga_fc = []
        self.gerador_mt = []
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
                 WHERE c.dist = '{self.dist}' and c.ctmt='{ctmt}' and c.SIT_ATIV = 'AT' and 
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
                u.TIP_TRAFO, u.PER_TOT, u.PER_FER, u.POT_NOM, u.POS, u.TEN_LIN_SE, u.MRT,
                e.TEN_PRI, e.TEN_SEC, e.TEN_TER,
                t1.TEN as TEN_PRI, t2.TEN as TEN_SEC, t3.TEN as TEN_TER
                FROM sde.EQTRMT e
                INNER JOIN  sde.UNTRMT U
                    on u.dist='{self.dist}' and u.sub='{self.sub}' and u.cod_id = e.UNI_TR_MT 
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
                u.TIP_TRAFO, u.PER_TOT, u.PER_FER, u.POT_NOM, u.POS, u.TEN_LIN_SE, u.MRT, u.TAP,
                e.TEN_PRI, e.TEN_SEC, e.TEN_TER,
                t1.TEN as TEN_PRI, t2.TEN as TEN_SEC, t3.TEN as TEN_TER
                FROM sde.EQTRMT e
                INNER JOIN  sde.UNTRMT U
                    on u.dist='{self.dist}' and u.ctmt='{ctmt}' and u.cod_id = e.UNI_TR_MT 
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
                SELECT COD_ID, CTMT, PAC_1, PAC_2, FAS_CON
                FROM sde.UNSEMT 
                WHERE dist='{self.dist}' and sub='{self.sub}' and P_N_OPE='F' and SIT_ATIV='AT'
                ;
            '''
        else:
            query = f'''
                SELECT COD_ID, CTMT, PAC_1, PAC_2, FAS_CON
                FROM sde.UNSEMT 
                WHERE dist='{self.dist}' and sub='{self.sub}' and CTMT='{ctmt}' and P_N_OPE='F' and SIT_ATIV='AT'
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
        Busca dados de Cargas MT
        :return:
        """
        if ctmt is None:
            query = f'''
                SELECT u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TIP_CC, u.TEN_FORN, u.CEG_GD,
                    u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                    u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12,
                    [DEM_01],[DEM_02],[DEM_03],[DEM_04],[DEM_05],[DEM_06],
                    [DEM_07],[DEM_08],[DEM_09],[DEM_10],[DEM_11],[DEM_12],                
                    t1.TEN/1000 as KV_NOM
                FROM sde.UCMT u                
                INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t1
                    on  u.dist='{self.dist}' and u.sub='{self.sub}' and t1.cod_id = u.TEN_FORN
                ;
            '''
        else:
            query = f'''
                SELECT u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TIP_CC, u.TEN_FORN, u.CEG_GD,
                    u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                    u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12,                    
                    [DEM_01],[DEM_02],[DEM_03],[DEM_04],[DEM_05],[DEM_06],
                    [DEM_07],[DEM_08],[DEM_09],[DEM_10],[DEM_11],[DEM_12],                
                    t1.TEN/1000 as KV_NOM
                FROM sde.UCMT u                
                INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t1
                    on  u.dist='{self.dist}' and u.sub='{self.sub}' and t1.cod_id = u.TEN_FORN 
                ;
            '''
        self.cargas_mt = return_query_as_dataframe(query)
        return True

    def query_gerador_mt(self) -> bool:
        """
        Busca dados de Geradores MT
        :return:
        """
        query = f'''
            SELECT u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TEN_FORN, u.CEG,
                u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12,
                [DEM_01],[DEM_02],[DEM_03],[DEM_04],[DEM_05],[DEM_06],
                [DEM_07],[DEM_08],[DEM_09],[DEM_10],[DEM_11],[DEM_12],                
                t1.TEN/1000 as KV_NOM
            FROM sde.UGMT u                
            INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t1
                on  u.dist = '{self.dist}' and u.sub='{self.sub}' and t1.cod_id = u.TEN_FORN
            ;  
            '''
        self.gerador_mt = return_query_as_dataframe(query)
        return True

    def query_fator_de_carga(self) -> bool:
        """

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
            [POT_64] ,[POT_65] ,[POT_66] ,[POT_67],[POT_68] ,[POT_69] ,[POT_70] ,[POT_71], [POT_72],[POT_73], [POT_74],
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
             +[POT_71] +[POT_72] +[POT_73] +[POT_74] +[POT_75] +[POT_76] +[POT_77] +[POT_78]+ [POT_79] +[POT_80] 
             +[POT_81] +[POT_82]+[POT_83]  +[POT_84] +[POT_85] +[POT_86]+[POT_87] +[POT_88]+[POT_89] +[POT_90] 
             +[POT_91] +[POT_92] +[POT_93] +[POT_94]+[POT_95] +[POT_96])/(4*30) as DEM_MED
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
                    ON A.PAC_1 = B.PAC WHERE B.COD_ID='{ctmt}'
                    UNION ALL
                    SELECT TOP 1 'Line.SMT_' + A.COD_ID AS COD_ID, 'SSDMT' AS ELEM FROM sde.SSDMT A
                    INNER JOIN sde.CTMT  B
                    ON A.PAC_2 = B.PAC WHERE B.COD_ID='{ctmt}'
                    UNION ALL
                    SELECT TOP 1 'Line.CMT_' + C.COD_ID AS COD_ID, 'UNSEMT' AS ELEM FROM sde.UNSEMT C
                    INNER JOIN sde.CTMT  D
                    ON C.PAC_1 = D.PAC WHERE D.COD_ID='{ctmt}' AND C.P_N_OPE='F'
                    UNION ALL
                    SELECT TOP 1 'Line.CMT_' + C.COD_ID AS COD_ID, 'UNSEMT' AS ELEM FROM sde.UNSEMT C
                    INNER JOIN sde.CTMT  D
                    ON C.PAC_2 = D.PAC WHERE D.COD_ID='{ctmt}' AND C.P_N_OPE='F'
                ) E
                ;
            '''

        self.monitors = return_query_as_dataframe(query)
        return True
    
    
if __name__ == "__main__":
    sub = '58'
    dist = '404'
    nome_arquivo_crv = f'CurvaCarga_{dist}_{sub}'
    nome_arquivo_sup = f'Circuito_{dist}_{sub}'
    nome_arquivo_cnd = f'CodCondutores_{dist}_{sub}'
    nome_arquivo_chv_mt = f'ChavesMT_{dist}_{sub}'
    nome_arquivo_re_mt = f'ReatoresMT_{dist}_{sub}'
    nome_arquivo_tr_mt = f'TrafosMT_{dist}_{sub}'
    nome_arquivo_seg_mt = f'TrechoMT_{dist}_{sub}'
    nome_arquivo_crg_mt = f'CargasMT_{dist}_{sub}'
    nome_arquivo_monitors = f'Monitors_{dist}_{sub}'
    nome_arquivo_master = f'Master_{dist}_{sub}'

    list_files_dss = [nome_arquivo_crv, nome_arquivo_sup, nome_arquivo_cnd, nome_arquivo_chv_mt, nome_arquivo_re_mt,
                      nome_arquivo_tr_mt, nome_arquivo_seg_mt, nome_arquivo_crg_mt, nome_arquivo_monitors]

    linhas_suprimento_dss = []
    linhas_curvas_carga_dss = []
    linhas_condutores_dss = []
    linhas_chaves_mt_dss = []
    linhas_reatores_mt_dss = []
    linhas_trafos_mt_dss = []
    linhas_trechos_mt_dss = []
    linhas_cargas_mt_dss = []
    linhas_monitors_dss = []
    linhas_master = []

    # inicializa classes de manipulação dos dados da bdgd
    dss_adapter = dss_g.DssFilesGenerator()
    bdgd_read = ElectricDataPort(dist, sub)

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
    dss_adapter.get_lines_curvas_carga(bdgd_read.curvas_cargas, linhas_curvas_carga_dss)

    # leitura de dados de gerador mt
    print(f'Process Generator....')
    bdgd_read.query_gerador_mt()

    # Fator de carga
    bdgd_read.query_fator_de_carga()

    for i in range(bdgd_read.circuitos.shape[0]):
        cod_circuito = bdgd_read.circuitos.loc[i]['COD_ID']
        print(f'Process circuit:{cod_circuito}')

        # Grava arquivo DSS de curva de cargas
        # No mesmo arquivo as curvas de carga tipicas AT, MT e BT e diferentes tipos de dias (DU, SA, DO).
        write_to_dss(sub, cod_circuito, linhas_curvas_carga_dss, nome_arquivo_crv)

        # Grava arquivo DSS LineCode
        write_to_dss(sub, cod_circuito, linhas_condutores_dss, nome_arquivo_cnd)

        circuito_dict = bdgd_read.circuitos.loc[i].to_dict()
        # print(circuito_dict)

        dss_adapter.get_lines_suprimento_circuito(sub, circuito_dict, linhas_suprimento_dss)
        # print(linhas_suprimento_dss)

        # leitura de dados das chaves MT por circuito
        bdgd_read.query_chaves_mt(cod_circuito)
        dss_adapter.get_lines_chaves_mt(bdgd_read.chaves_mt, linhas_chaves_mt_dss)
        # Grava arquivo DSS Chaves_MT
        write_to_dss(sub, cod_circuito, linhas_chaves_mt_dss, nome_arquivo_chv_mt)

        # Grava arquivo DSS para o circuito
        write_to_dss(sub, cod_circuito, linhas_suprimento_dss, nome_arquivo_sup)
        linhas_suprimento_dss = []

        # Grava arquivo DSS para o reatores
        bdgd_read.query_reatores_mt(cod_circuito)
        dss_adapter.get_lines_reguladores(bdgd_read.reatores, linhas_reatores_mt_dss)
        write_to_dss(sub, cod_circuito, linhas_reatores_mt_dss, nome_arquivo_re_mt)

        # Grava arquivo DSS para o Transformadores MT
        bdgd_read.query_trafos_mt(cod_circuito)
        dss_adapter.get_lines_trafos(bdgd_read.trafos, linhas_trafos_mt_dss)
        write_to_dss(sub, cod_circuito, linhas_trafos_mt_dss, nome_arquivo_tr_mt)

        # Grava arquivo DSS para o Trechos MT
        bdgd_read.query_trechos_mt(cod_circuito)
        is_bt = False
        dss_adapter.get_lines_trechos_mt(is_bt, bdgd_read.trechos_mt, linhas_trechos_mt_dss)
        write_to_dss(sub, cod_circuito, linhas_trechos_mt_dss, nome_arquivo_seg_mt)

        # Grava arquivo DSS para o cargas MT
        bdgd_read.query_cargas_mt(cod_circuito)
        dss_adapter.get_lines_cargas_mt(bdgd_read.cargas_mt, bdgd_read.carga_fc, linhas_cargas_mt_dss)
        write_to_dss(sub, cod_circuito, linhas_cargas_mt_dss, nome_arquivo_crg_mt)

        # Grava arquivo DSS para monitores
        bdgd_read.query_monitors(cod_circuito)
        dss_adapter.get_lines_medidores(bdgd_read.monitors, linhas_monitors_dss)
        write_to_dss(sub, cod_circuito, linhas_monitors_dss, nome_arquivo_monitors)

        # Grava arquivo DSS para o master
        dss_adapter.get_lines_master(cod_circuito, list_files_dss, linhas_trafos_mt_dss, linhas_master)
        write_to_dss(sub, cod_circuito, linhas_master, nome_arquivo_master)
