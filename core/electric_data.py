import time
from Tools.tools import return_query_as_dataframe, write_to_dss, ajust_eqre_codbanc, \
    create_connection, load_config
import dss_files_generator as dss_g
import pandas as pd
import connected_segments as cs
from multiprocessing import Pool, cpu_count

"""
# @Date    : 20/06/2024
# @Author  : Ferdinano Crispino
Implemeta funcionalidades de leitua dos dados da BDGD para escrita dos arquivos do openDSS

# @Edited by: 
# @Date     :

"""


# rum multiprocessing for substations
def run_multi(subs, config, mes_ini, tipo_de_dias, control_mes, control_tipo_dia):
    proc_time_ini = time.time()

    ano = config['data_base'].split('-')[0]
    dist = config['dist']
    engine = create_connection(config)
    dss_files_folder = config['dss_files_folder']

    print(f'Ajusting CodBNC....')
    ajust_eqre_codbanc(dist, engine)

    # controles de execução para apenas um primeiro mes e um primeiro tipo de dia da lista 'tipo_de_dias'
    for tipo_dia in tipo_de_dias:
        for mes in range(mes_ini, 13):
            for sub in subs:
                print(sub)
                # Gera arquivo com execução do fluxo de potência para toda a subestação
                write_sub_dss(sub, dist, mes, tipo_dia, engine, dss_files_folder)
                # Gera arquivos do openDSS para cada circuito de uma subestação
                write_files_dss(sub, dist, ano, mes, tipo_dia, dss_files_folder, model_type=1,
                                engine=engine)  # model_type=1 PVSystem else Generator
            if control_mes:
                break
        if control_tipo_dia:
            break
    print(f"Processo concluído em {time.time() - proc_time_ini}")


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
        self.trafos_at = []
        self.trafo_mtmt_connected_segments = []
        self.trafo_mtmt = []
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
        self.voltage_tr_sec = []
        self.propor = 0

    def query_trafo_mt_mt(self, engine, ctmt=None):
        """
        Verifica se existe transformador MT-MT no circuito e retorna os valores desse.
        Tip_unid = 54 -> transformador MT MT
        :return:
        """
        if ctmt is None:
            query = f'''         
                    SELECT t.sub, t.ctmt, t.cod_id, t.PAC_1, t.PAC_2, v1.TEN as TEN_PRI, v2.TEN as TEN_SEC
                    FROM sde.untrmt t
                        inner join  sde.eqtrmt e on t.cod_id = e.UNI_TR_MT  
                        INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN v1 on v1.COD_ID = e.TEN_PRI
                        INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN v2 on v2.COD_ID = e.TEN_SEC
                    WHERE t.dist = '{self.dist}' and t.sub = '{self.sub}' and t.TIP_UNID = 54       
                 ;
            '''
        else:
            query = f'''         
                    SELECT t.sub, t.ctmt, t.cod_id, t.PAC_1, t.PAC_2, v1.TEN as TEN_PRI, v2.TEN as TEN_SEC
                     FROM sde.untrmt t
                        inner join  sde.eqtrmt e on t.cod_id = e.UNI_TR_MT  
                        INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN v1 on v1.COD_ID = e.TEN_PRI
                        INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN v2 on v2.COD_ID = e.TEN_SEC
                    WHERE t.dist =' {self.dist}' and t.sub = '{self.sub}' and t.CTMT='{ctmt}' and t.TIP_UNID = 54       
                 ;
            '''
        self.trafo_mtmt = return_query_as_dataframe(query, engine)

    def trafo_mtmt_find_capacitor(self, engine, ctmt):

        # leitura de trafos mt-mt.
        trafos_mt_mt = self.trafo_mtmt
        connected_segments = []
        if not trafos_mt_mt.empty:
            tr_mt_mt = trafos_mt_mt.loc[trafos_mt_mt['ctmt'] == ctmt]
            pn_ini = trafos_mt_mt['PAC_2'][0]

            # Trechos MT
            sql = f"SELECT PAC_1, PAC_2, COD_ID, ctmt FROM SDE.SSDMT Where ctmt='{ctmt}' "
            ssdmt_pacs = pd.read_sql_query(sql, engine)

            # Chaves MT
            sql = f"SELECT PAC_1, PAC_2, COD_ID, ctmt FROM SDE.UNSEMT Where ctmt='{ctmt}' and P_N_OPE='F' "
            unsemt_pacs = pd.read_sql_query(sql, engine)

            # Transformadores MT
            sql = f"SELECT PAC_1, PAC_2, COD_ID, ctmt FROM SDE.UNTRMT Where ctmt='{ctmt}' and SIT_ATIV='AT' "
            untrmt_pacs = pd.read_sql_query(sql, engine)

            print(f"Total Trechos: {len(ssdmt_pacs)}, Chaves: {len(unsemt_pacs)}, Trafos: {len(untrmt_pacs)}")

            total_seg = pd.concat([ssdmt_pacs, unsemt_pacs, untrmt_pacs], sort=False)
            # Construir o grafo
            graph = cs.build_graph(total_seg, 'PAC_1', 'PAC_2')
            # Encontrar e ordenar segmentos conectados usando DFS
            connected_segments = cs.dfs(graph, pn_ini)

        self.trafo_mtmt_connected_segments = connected_segments

    def query_circuitos(self, engine) -> bool:
        """
        Busca os dados de circuitos
        :return:
        """
        query = f'''
            SELECT c.COD_ID, c.PAC_INI, c.UNI_TR_AT, c.TEN_OPE, t.TEN, p.POT
            FROM SDE.CTMT as c
            left join [GEO_SIGR_DDAD_M10].SDE.TTEN as T  on c.TEN_NOM = t.COD_ID			
            left join sde.EQTRAT e on c.UNI_TR_AT = e.UNI_TR_AT
            left join GEO_SIGR_DDAD_M10.sde.TPOTAPRT p on e.POT_NOM = p.COD_ID
            WHERE sub='{self.sub}' Order by COD_ID
            ;
        '''
        self.circuitos = return_query_as_dataframe(query, engine)
        return True

    def query_trafos_at(self, engine):
        query = f'''
                SELECT t1.TEN as TEN_PRI, t2.TEN as TEN_SEC, t3.TEN as TEN_TER, e.TIP_INST,T.[COD_ID],[PAC_1],[PAC_2]
                    ,[PAC_3],[FAS_CON_P],[FAS_CON_S],[FAS_CON_T],[SIT_ATIV],T.[POT_NOM], [LIG]
                    ,T.[PER_FER], T.[PER_TOT], [BANC], [TIP_TRAFO],[ENES_01],[ENES_02],[ENES_03],[ENES_04],[ENES_05]
                    ,[ENES_06],[ENES_07],[ENES_08],[ENES_09],[ENES_10],[ENES_11],[ENES_12],[ENET_01],[ENET_02]
                    ,[ENET_03],[ENET_04],[ENET_05],[ENET_06],[ENET_07],[ENET_08],[ENET_09],[ENET_10],[ENET_11]
                    ,[ENET_12],[ENES_01_IN],[ENES_02_IN],[ENES_03_IN],[ENES_04_IN],[ENES_05_IN],[ENES_06_IN]                    
                FROM [sde].[UNTRAT] T
                INNER JOIN sde.EQTRAT E
                    on e.UNI_TR_AT = t.COD_ID
                INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t1
                    on  t1.cod_id = e.TEN_PRI
                INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t2
                    on  t2.cod_id = e.TEN_SEC
                INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN t3
                    on  t3.cod_id = e.TEN_TER
                Where t.dist='{self.dist}' and t.sub='{self.sub}' and t.SIT_ATIV='AT'
              ;
        '''
        self.trafos_at = return_query_as_dataframe(query, engine)
        if self.trafos_at.empty:
            return False
        else:
            return True

    def query_reatores_mt(self, ctmt, engine) -> bool:
        """
        Busca os dados de reatores MT
        :return:
        """
        if ctmt is None:
            query = f'''
                    SELECT g.*, cr.TEN_NOM, t.TEN
                    FROM (
                        SELECT c.COD_ID, c.PAC_1, c.PAC_2, c.Sub, c.TIP_REGU, c.BANC, c.FAS_CON, c.CTMT, 
                            p.POT, e.TEN_REG, e.LIG_FAS_P, e.LIG_FAS_S,  e.COR_NOM, e.REL_TP, e.REL_TC, 
                            e.PER_FER, e.PER_TOT, e.R, e.XHL, e.CODBNC, e.GRU_TEN, e.COD_ID AS EQRE_COD_ID
                        FROM SDE.UNREMT AS c
                        INNER JOIN SDE.EQRE AS e 
                            ON (c.PAC_1 = e.PAC_1 OR c.PAC_2 = e.PAC_2 OR c.PAC_1 = e.PAC_2 OR c.PAC_2 = e.PAC_1)
                        INNER JOIN [GEO_SIGR_DDAD_M10].sde.TPOTAPRT AS p ON p.COD_ID = e.POT_NOM
                        WHERE c.DIST = '{self.dist}' and c.sub='{self.sub}'  AND c.SIT_ATIV = 'AT'
                    ) AS g
                    INNER JOIN sde.CTMT AS cr ON cr.COD_ID = g.CTMT
                    INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN AS t ON t.COD_ID = cr.TEN_NOM
                    ;
            '''
        else:
            query = f'''
                    SELECT g.*, cr.TEN_NOM, t.TEN
                    FROM (
                        SELECT c.COD_ID, c.PAC_1, c.PAC_2, c.Sub, c.TIP_REGU, c.BANC, c.FAS_CON, c.CTMT, 
                            p.POT, e.TEN_REG, e.LIG_FAS_P, e.LIG_FAS_S,  e.COR_NOM, e.REL_TP, e.REL_TC, 
                            e.PER_FER, e.PER_TOT, e.R, e.XHL, e.CODBNC, e.GRU_TEN, e.COD_ID AS EQRE_COD_ID
                        FROM SDE.UNREMT AS c
                        INNER JOIN SDE.EQRE AS e 
                            ON (c.PAC_1 = e.PAC_1 OR c.PAC_2 = e.PAC_2 OR c.PAC_1 = e.PAC_2 OR c.PAC_2 = e.PAC_1)
                        INNER JOIN [GEO_SIGR_DDAD_M10].sde.TPOTAPRT AS p ON p.COD_ID = e.POT_NOM
                        WHERE c.DIST = '{self.dist}' and c.sub='{self.sub}' and c.ctmt='{ctmt}' AND c.SIT_ATIV = 'AT'
                    ) AS g
                    INNER JOIN sde.CTMT AS cr ON cr.COD_ID = g.CTMT
                    INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TTEN AS t ON t.COD_ID = cr.TEN_NOM
                    ;
            '''
        self.reatores = return_query_as_dataframe(query, engine)
        return True

    def query_crvcrg(self, engine) -> bool:
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
        self.curvas_cargas = return_query_as_dataframe(query, engine)
        return True

    def query_segcon(self, engine) -> bool:
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
        self.condutores = return_query_as_dataframe(query, engine)
        return True

    def query_trafos_mt(self, ctmt, engine) -> bool:
        """
        Busca dados de transformadores MT
        :return:
        """
        if ctmt is None:
            query = f'''
                SELECT u.COD_ID, u.CTMT, u.PAC_1, u.PAC_2, u.PAC_3, u.FAS_CON_P, u.FAS_CON_S, u.FAS_CON_T, 
                u.TIP_TRAFO, u.PER_TOT, u.PER_FER, u.POT_NOM, u.POS, u.TEN_LIN_SE, u.MRT, u.TAP, u.BANC,            
                t1.TEN as TEN_PRI, t2.TEN as TEN_SEC, t3.TEN as TEN_TER, 
                e.LIG, e.FAS_CON, e.POT_NOM as COD_POT_EQ, t4.POT as POT_NOM_EQ, 
                e.LIG_FAS_P, e.LIG_FAS_S, e.LIG_FAS_T
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
                INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TPOTAPRT t4
                    on  t4.COD_ID = e.POT_NOM                
                ;
            '''
        else:
            query = f'''
                SELECT u.COD_ID, u.CTMT, u.PAC_1, u.PAC_2, u.PAC_3, u.FAS_CON_P, u.FAS_CON_S, u.FAS_CON_T, 
                u.TIP_TRAFO, u.PER_TOT, u.PER_FER, u.POT_NOM, u.POS, u.TEN_LIN_SE, u.MRT, u.TAP, u.BANC,             
                t1.TEN as TEN_PRI, t2.TEN as TEN_SEC, t3.TEN as TEN_TER,
                e.LIG, e.FAS_CON, e.POT_NOM as COD_POT_EQ, t4.POT as POT_NOM_EQ, 
                e.LIG_FAS_P, e.LIG_FAS_S, e.LIG_FAS_T
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
                INNER JOIN  [GEO_SIGR_DDAD_M10].sde.TPOTAPRT t4
                    on  t4.COD_ID = e.POT_NOM
                ;
            '''
        self.trafos = return_query_as_dataframe(query, engine)
        return True

    def query_chaves_mt(self, ctmt, engine) -> bool:
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
        self.chaves_mt = return_query_as_dataframe(query, engine)
        return True

    def query_trechos_mt(self, ctmt, engine):
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
        self.trechos_mt = return_query_as_dataframe(query, engine)
        return True

    def query_cargas_mt(self, ctmt, engine) -> bool:
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
        self.cargas_mt = return_query_as_dataframe(query, engine)
        return True

    def query_cargas_bt(self, ctmt, engine) -> bool:
        """
        Busca dados das Cargas de Baixa Tensão para a escrever dos arquivos DSS
        As cargas são conectadas no transformador de média Tensão
        Busca dados de Cargas BT
        Podem existir cargas duplicadas onde o valor da energia para um determinado mes pode estar em
            diferentes registros.
            Assim remover a condição de selecionar somente carga Ativa e realizar o tratamento dos valores
            diplicados e a escolha do registro da energia a posteriore

        :return:
        """
        if ctmt is None:
            query = f'''
                SELECT distinct u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TIP_CC, u.TEN_FORN, u.CEG_GD
                    , u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06
                    , u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12 
                    , t.TIP_TRAFO, t.TEN_LIN_SE, t.POT_NOM, t.PAC_2, year(t.DATA_BASE) as ANO_BASE
                    , m.FAS_CON as M_FAS_CON, v.TEN
                FROM sde.UCBT u    
                INNER JOIN sde.UNTRMT T
                    on  t.COD_ID = u.UNI_TR_MT 
                inner join [GEO_SIGR_DDAD_M10].sde.tten as v on u.TEN_FORN = v.COD_ID 
                left join sde.eqme M
                    on u.COD_ID = m.UC_UG and u.PAC = m.PAC
                where u.dist='{self.dist}' and u.sub = '{self.sub}' and 
                    u.pn_con != '0'
                order by cod_id
                ;
            '''

            """
            WITH UCBT_CTE AS (
            SELECT COD_ID, CTMT, PAC, FAS_CON, TIP_CC, TEN_FORN, CEG_GD,
                   ENE_01, ENE_02, ENE_03, ENE_04, ENE_05, ENE_06, 
                   ENE_07, ENE_08, ENE_09, ENE_10, ENE_11, ENE_12,
                   UNI_TR_MT, DIST, SUB, SIT_ATIV, PN_CON
            FROM sde.UCBT
            WHERE DIST = '391' AND SUB = 'ITQ' AND SIT_ATIV = 'AT' AND PN_CON != '0'
            ),
            UNTRMT_CTE AS (
                SELECT COD_ID, TIP_TRAFO, TEN_LIN_SE, POT_NOM, PAC_2, DATA_BASE
                FROM sde.UNTRMT
            ),
            EQME_CTE AS (
                SELECT DISTINCT UC_UG, FAS_CON AS M_FAS_CON, PAC 
                FROM sde.EQME
            )
            
            SELECT DISTINCT u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, m.M_FAS_CON, u.TIP_CC, u.TEN_FORN, u.CEG_GD,
                            u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                            u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12, 
                            t.TIP_TRAFO, t.TEN_LIN_SE, t.POT_NOM, t.PAC_2, YEAR(t.DATA_BASE) AS ANO_BASE
            FROM UCBT_CTE u
            INNER JOIN UNTRMT_CTE t ON t.COD_ID = u.UNI_TR_MT
            LEFT JOIN EQME_CTE m ON u.COD_ID = m.UC_UG and u.PAC = m.PAC
            ORDER BY u.COD_ID;
            """
        else:
            query = f'''                    
                    SELECT u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TIP_CC, u.TEN_FORN, u.CEG_GD
                        , u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06 
                        , u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12 
                        , t.TIP_TRAFO, t.TEN_LIN_SE, t.POT_NOM, t.PAC_2, year(t.DATA_BASE) as ANO_BASE
                        , m.FAS_CON as M_FAS_CON, v.TEN
                    FROM sde.UCBT u    
                    INNER JOIN sde.UNTRMT T on  t.COD_ID = u.UNI_TR_MT 
                    inner join [GEO_SIGR_DDAD_M10].sde.tten as v on u.TEN_FORN = v.COD_ID
                    left join sde.eqme M
                        on u.COD_ID = m.UC_UG and u.PAC = m.PAC
                    where u.dist='{self.dist}' and u.sub = '{self.sub}' and u.ctmt = '{ctmt}' and 
                        u.pn_con != '0'
                    ;
                '''

            """            
            query = f'''
                select * from (      
                    SELECT  u.COD_ID, ROW_NUMBER() OVER(PARTITION BY u.COD_ID ORDER BY u.objectid DESC) rn
                        , u.CTMT, u.PAC, u.FAS_CON, u.TIP_CC, u.TEN_FORN, u.CEG_GD
                        , u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06 
                        , u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12 
                        , t.TIP_TRAFO, t.TEN_LIN_SE, t.POT_NOM, t.PAC_2, year(t.DATA_BASE) as ANO_BASE
                        , m.FAS_CON as M_FAS_CON, v.TEN
                    FROM sde.UCBT u    
                    INNER JOIN sde.UNTRMT T on  t.COD_ID = u.UNI_TR_MT 
                    inner join [GEO_SIGR_DDAD_M10].sde.tten as v on u.TEN_FORN = v.COD_ID
                    left join sde.eqme M
                        on u.COD_ID = m.UC_UG and u.PAC = m.PAC
                    where u.dist='{self.dist}' and u.sub = '{self.sub}' and u.ctmt = '{ctmt}' and u.sit_ativ = 'AT' and 
                        u.pn_con != '0'
                ) a
                where rn = 1
                order by a.cod_id
                ;
            '''
            """

        self.cargas_bt = return_query_as_dataframe(query, engine)
        return True

    def query_cargas_pip(self, ctmt, engine) -> bool:
        """
         Busca dados das Cargas de Iluminação Pública para a escrever nos arquivos DSS
         As cargas são conectadas no transformador de média Tensão
         :param ctmt:
         :return:
         """

        if ctmt is None:
            query = f'''
                SELECT distinct p.COD_ID, p.CTMT, p.PAC, p.FAS_CON, p.TIP_CC, p.TEN_FORN, v.TEN, 
                     p.ENE_01, p.ENE_02, p.ENE_03, p.ENE_04, p.ENE_05, p.ENE_06, 
                     p.ENE_07, p.ENE_08, p.ENE_09, p.ENE_10, p.ENE_11, p.ENE_12, 
                     t.TIP_TRAFO, t.TEN_LIN_SE, t.POT_NOM, t.PAC_2, year(t.DATA_BASE) as ANO_BASE
                FROM sde.PIP P  
                inner join [GEO_SIGR_DDAD_M10].sde.tten as v on p.TEN_FORN = v.COD_ID
                INNER JOIN sde.UNTRMT T
                     on t.COD_ID = p.UNI_TR_MT 
                WHERE p.dist='{self.dist}' and p.sub = '{self.sub}' and p.sit_ativ = 'AT' and 
                    p.pn_con != '0'
                 ;
             '''
        else:
            query = f'''
                SELECT distinct p.COD_ID, p.CTMT, p.PAC, p.FAS_CON, p.TIP_CC, p.TEN_FORN, v.TEN, 
                     p.ENE_01, p.ENE_02, p.ENE_03, p.ENE_04, p.ENE_05, p.ENE_06, 
                     p.ENE_07, p.ENE_08, p.ENE_09, p.ENE_10, p.ENE_11, p.ENE_12, 
                     t.TIP_TRAFO, t.TEN_LIN_SE, t.POT_NOM, t.PAC_2, year(t.DATA_BASE) as ANO_BASE
                FROM sde.PIP P  
                inner join [GEO_SIGR_DDAD_M10].sde.tten as v on p.TEN_FORN = v.COD_ID
                INNER JOIN sde.UNTRMT T
                     on t.COD_ID = p.UNI_TR_MT 
                WHERE p.dist='{self.dist}' and p.sub = '{self.sub}' and p.ctmt = '{ctmt}' and p.sit_ativ = 'AT' and 
                    p.pn_con != '0'
                ;
             '''
        self.cargas_pip = return_query_as_dataframe(query, engine)
        return True

    def query_check_cod_ten_gerador_mt(self, engine):
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

    def query_generators_bt(self, ctmt, engine) -> bool:
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
                     u.TEN_CON, 
                     t.TIP_TRAFO, t.PAC_2 as PAC_TRAFO, T.FAS_CON_P, T.FAS_CON_S, T.FAS_CON_T,
                     t.TEN_LIN_SE
                FROM sde.UGBT u
                INNER JOIN sde.UNTRMT T
                     on u.dist = '{self.dist}' and u.sub='{self.sub}' and u.SIT_ATIV='AT' and 
                     u.UNI_TR_MT = T.COD_ID and t.CTMT = u.ctmt
                INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN t1
                     on t1.cod_id = u.TEN_CON
                ;  
             '''
        else:
            query = f'''
                SELECT u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TEN_FORN, u.CEG_GD,
                     u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                     u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12,
                     t1.TEN/1000 as KV_NOM, year(u.DATA_BASE) as ANO_BASE, 
                     u.TEN_CON, 
                     t.TIP_TRAFO, t.PAC_2 as PAC_TRAFO, T.FAS_CON_P, T.FAS_CON_S, T.FAS_CON_T,
                     t.TEN_LIN_SE
                FROM sde.UGBT u
                INNER JOIN sde.UNTRMT T
                     on u.dist = '{self.dist}' and u.sub='{self.sub}' and u.ctmt='{ctmt}' and u.SIT_ATIV='AT' and 
                     u.UNI_TR_MT = T.COD_ID and t.CTMT = u.ctmt
                INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN t1
                     on t1.cod_id = u.TEN_CON
                 ;  
             '''

        self.gerador_bt = return_query_as_dataframe(query, engine)
        return True

    def query_generators_mt(self, ctmt, engine) -> bool:
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
        self.gerador_mt = return_query_as_dataframe(query, engine)
        return True

    def query_generators_mt_ssdmt(self, ctmt, engine) -> bool:
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
                    u.DEM_01, u.DEM_02, u.DEM_03, u.DEM_04, u.DEM_05, u.DEM_06, 
                    u.DEM_07, u.DEM_08, u.DEM_09, u.DEM_10, u.DEM_11, u.DEM_12, 
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
                    u.DEM_01, u.DEM_02, u.DEM_03, u.DEM_04, u.DEM_05, u.DEM_06, 
                    u.DEM_07, u.DEM_08, u.DEM_09, u.DEM_10, u.DEM_11, u.DEM_12, 
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
        self.gerador_mt_ssdmt = return_query_as_dataframe(query, engine)
        return True

    def query_fator_de_carga(self, engine) -> bool:
        """
        O fator de carga é utilizado para calcular a demanda máxima a partir da energia para nos casos
        que não é fornecido a demanda mensal.
        :param engine: conexão com o banco de dados
        :return:
        """

        query = f'''
            select s.COD_ID, s.TIP_DIA, (s.DEM_MED/s.DEN_MAX) as FC
            from (
            SELECT COD_ID, TIP_DIA, GREATEST(
            ([POT_01] + [POT_02] + [POT_03] + [POT_04])/4 ,([POT_05] + [POT_06] + [POT_07] + [POT_08])/4 ,
            ([POT_09] + [POT_10] + [POT_11] + [POT_12])/4 ,([POT_13] + [POT_14] + [POT_15] + [POT_16])/4 ,
            ([POT_17] + [POT_18] + [POT_19] + [POT_20])/4 ,([POT_21] + [POT_22] + [POT_23] + [POT_24])/4 ,
            ([POT_25] + [POT_26] + [POT_27] + [POT_28])/4 ,([POT_29] + [POT_30] + [POT_31] + [POT_32])/4 ,
            ([POT_33] + [POT_34] + [POT_35] + [POT_36])/4 ,([POT_37] + [POT_38] + [POT_39] + [POT_40])/4 ,
            ([POT_41] + [POT_42] + [POT_43] + [POT_44])/4 ,([POT_45] + [POT_46] + [POT_47] + [POT_48])/4 ,
            ([POT_49] + [POT_50] + [POT_51] + [POT_52])/4 ,([POT_53] + [POT_54] + [POT_55] + [POT_56])/4 ,
            ([POT_57] + [POT_58] + [POT_59] + [POT_60])/4 ,([POT_61] + [POT_62] + [POT_63] + [POT_64])/4 ,
            ([POT_65] + [POT_66] + [POT_67] + [POT_68])/4 ,([POT_69] + [POT_70] + [POT_71] + [POT_72])/4 ,
            ([POT_73] + [POT_74] + [POT_75] + [POT_76])/4 ,([POT_77] + [POT_78] + [POT_79] + [POT_80])/4 ,
            ([POT_81] + [POT_82] + [POT_83] + [POT_84])/4 ,([POT_85] + [POT_86] + [POT_87] + [POT_88])/4 , 
            ([POT_89] + [POT_90] + [POT_91] + [POT_92])/4 ,([POT_93] + [POT_94] + [POT_95] + [POT_96])/4
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
        self.carga_fc = return_query_as_dataframe(query, engine)
        return True

    def query_monitors(self, ctmt, engine) -> bool:
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
        self.monitors = return_query_as_dataframe(query, engine)
        return True

    def query_capacitor(self, ctmt, engine):
        query = f'''                       
                SELECT A.CTMT, A.COD_ID, A.POT_NOM, A.PAC_1, A.FAS_CON, B.POT, S.COD_ID as LINE_COD, V.TEN
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
        self.capacitors = return_query_as_dataframe(query, engine)
        return True

    def query_cargas_mt_ssdmt(self, ctmt, engine) -> bool:
        """
        Busca dados das Cargas de Média Tensão para a escrever dos arquivos DSS
        Não considerer a SIT_ATV pq se refere a sutuação do final do periodo e não reflete a situação mes a mes.
        Seleciona as Cargas conectadas no Segmento
        :param ctmt:
        :return:
        """

        query = f'''
            SELECT distinct u.COD_ID, u.CTMT, u.PAC, u.FAS_CON, u.TIP_CC, u.TEN_FORN, u.CEG_GD,
                u.ENE_01, u.ENE_02, u.ENE_03, u.ENE_04, u.ENE_05, u.ENE_06, 
                u.ENE_07, u.ENE_08, u.ENE_09, u.ENE_10, u.ENE_11, u.ENE_12, 
                u.DEM_01, u.DEM_02, u.DEM_03, u.DEM_04, u.DEM_05, u.DEM_06, 
                u.DEM_07, u.DEM_08, u.DEM_09, u.DEM_10, u.DEM_11, u.DEM_12,                       
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
                u.pn_con != '0'
            ;
        '''
        self.cargas_mt_ssdmt = return_query_as_dataframe(query, engine)
        return True

    def query_voltagebases_trafos_mt(self, engine):
        query = f'''
            Select distinct TEN_LIN_SE from sde.untrmt where sub='{self.sub}'
        '''
        self.voltage_tr_sec = return_query_as_dataframe(query, engine)
        return True

    def voltage_bases(self, circ, df_voltage) -> list:
        # Valor da tensão do circuito para os casos de circuitos sem transformadores
        voltagebases = [self.circuitos.loc[self.circuitos.index[0], ["TEN"]][0] / 1000]

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

        # remove duplicates
        voltagebases = list(dict.fromkeys(voltagebases))
        return voltagebases


def write_sub_dss(cod_sub, cod_dist, mes, tipo_dia, engine, dss_files_folder):
    """
    Gera arquivo master_substation.dss
    Esse arquivo faz a união dos trnasformadores de alta tensão com os seus cricuitos utilizando a modelagem do openDSS
    São criadas chaves ficticias para a conexão eletrica entre os transformadores e seus circuitos
    :param cod_sub:
    :param cod_dist:
    :param mes:
    :param tipo_dia:
    :return:
    """
    sub = cod_sub
    dist = cod_dist
    mes = mes
    tipo_dia = tipo_dia
    nome_arquivo_sub = f'{tipo_dia}_{mes}_Master_substation_{dist}'
    linhas_substation_dss = []

    # inicializa classes de manipulação dos dados da bdgd
    dss_adapter = dss_g.DssFilesGenerator(dist, sub)
    # bdgd_read = ElectricDataPort(dist, sub, mes, tipo_dia)
    bdgd_read = ElectricDataPort(dist, sub)

    # Leitura de dados dos circuitos de uma subestação da bdgd
    bdgd_read.query_circuitos(engine)
    if bdgd_read.circuitos.empty:
        print(f"{sub} - Subestação inexistente!!!")
        return

    # Leitura de dados de Trasformadores AT
    trafo_at_ok = bdgd_read.query_trafos_at(engine)
    if trafo_at_ok:
        bdgd_read.query_voltagebases_trafos_mt(engine)
        dss_adapter.get_lines_substation(bdgd_read.trafos_at, bdgd_read.circuitos, linhas_substation_dss,
                                         mes, tipo_dia, bdgd_read.voltage_tr_sec)
        write_to_dss(dist, sub, '', linhas_substation_dss, nome_arquivo_sub, dss_files_folder)
    else:
        print(f'Sem informações de Transformadores de Alta tensão para a SE: {sub}')


def write_files_dss(cod_sub, cod_dist, ano, mes, tipo_dia, dss_files_folder, engine, model_type=1):
    """
    Procedimento principal de controle dos metodos de extração dos dados da BDGD para todos os elementos
    de rede e cria lista com os modelos para o openDSS e gerência a escrita dos arquivos para o openDSS.
    :param cod_sub: código da subestação definido na BDGD
    :param cod_dist: código da distribuido definido na BDGD
    :param mes: mês de refeêencia para a associação das curvas de carga.
    :param tipo_dia: tipo de dia (DU, DO, SA) de referência para associação das curvas de carga.
    :return:
    """

    sub = cod_sub
    dist = cod_dist
    mes = mes
    tipo_dia = tipo_dia
    ano = ano
    tipo_modelo = model_type

    print(f"Tratamento para empresa: {dist}, subestação: {sub}, mes: {mes} e tipo dia: {tipo_dia}")
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
                       0.908147, 0.682011, 0.461154, 0.024685, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]])
    multi_ger.append(['GeradorBT-Tipo1',
                      [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.213170, 0.493614, 0.767539, 0.930065, 1.000000,
                       0.908147, 0.682011, 0.461154, 0.024685, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]])

    multi_ger.append(['GeradorBT-Tipo2', [0, 0, 0, 0, 0, 0, 0.1, 0.2, 0.3, 0.5, 0.8, 0.9, 1.0, 1.0, 0.99, 0.9, 0.7,
                                          0.4, 0.1, 0, 0, 0, 0, 0]])

    multi_ger.append(['PVIrrad_diaria', [0, 0, 0, 0, 0, 0, 0.1, 0.2, 0.3, 0.5, 0.8, 0.9, 1.0, 1.0, 0.99, 0.9, 0.7,
                                         0.4, 0.1, 0, 0, 0, 0, 0]])

    # inicializa classes de manipulação dos dados da bdgd
    dss_adapter = dss_g.DssFilesGenerator()
    # bdgd_read = ElectricDataPort(dist, sub, mes, tipo_dia)
    bdgd_read = ElectricDataPort(dist, sub)

    # Leitura de dados dos circuitos de uma subestação da bdgd
    print(f'Reading Circuit....')
    bdgd_read.query_circuitos(engine)

    # leitura de dados de condutores
    print(f'Reading LineCode....')
    bdgd_read.query_segcon(engine)
    dss_adapter.get_lines_condutores(bdgd_read.condutores, linhas_condutores_dss)

    # leitura de dados de curvas de carga da bdgd
    print(f'Reading LoadShape....')
    bdgd_read.query_crvcrg(engine)
    dss_adapter.get_lines_curvas_carga(bdgd_read.curvas_cargas, multi_ger, linhas_curvas_carga_dss)

    # Fator de carga
    bdgd_read.query_fator_de_carga(engine)

    for i in range(bdgd_read.circuitos.shape[0]):
        cod_circuito = bdgd_read.circuitos.loc[i]['COD_ID']
        print(f'Process circuit:{cod_circuito}')

        # Grava arquivo DSS de curva de cargas
        # No mesmo arquivo as curvas de carga tipicas AT, MT e BT e diferentes tipos de dias (DU, SA, DO).
        write_to_dss(dist, sub, cod_circuito, linhas_curvas_carga_dss, nome_arquivo_crv, dss_files_folder)

        # Grava arquivo DSS LineCode
        write_to_dss(dist, sub, cod_circuito, linhas_condutores_dss, nome_arquivo_cnd, dss_files_folder)

        #  leitura de dados do circuito
        circuito_dict = bdgd_read.circuitos.loc[i].to_dict()
        dss_adapter.get_lines_suprimento_circuito(sub, circuito_dict, linhas_suprimento_dss)
        # Grava arquivo DSS para o circuito
        write_to_dss(dist, sub, cod_circuito, linhas_suprimento_dss, nome_arquivo_sup, dss_files_folder)

        # leitura de dados das chaves MT por circuito
        bdgd_read.query_chaves_mt(cod_circuito, engine=engine)
        dss_adapter.get_lines_chaves_mt(bdgd_read.chaves_mt, linhas_chaves_mt_dss)
        # Grava arquivo DSS Chaves_MT
        write_to_dss(dist, sub, cod_circuito, linhas_chaves_mt_dss, nome_arquivo_chv_mt, dss_files_folder)

        # Grava arquivo DSS para o reguladores
        bdgd_read.query_reatores_mt(cod_circuito, engine=engine)
        dss_adapter.get_lines_reguladores(bdgd_read.reatores, linhas_reatores_mt_dss)
        write_to_dss(dist, sub, cod_circuito, linhas_reatores_mt_dss, nome_arquivo_re_mt, dss_files_folder)

        # Grava arquivo DSS para o Transformadores MT
        bdgd_read.query_trafos_mt(cod_circuito, engine=engine)
        dss_adapter.get_lines_trafos(bdgd_read.trafos, linhas_trafos_mt_dss)
        write_to_dss(dist, sub, cod_circuito, linhas_trafos_mt_dss, nome_arquivo_tr_mt, dss_files_folder)

        # Grava arquivo DSS para o Trechos MT
        bdgd_read.query_trechos_mt(cod_circuito, engine=engine)
        is_bt = False
        dss_adapter.get_lines_trechos_mt(is_bt, bdgd_read.trechos_mt, linhas_trechos_mt_dss)
        write_to_dss(dist, sub, cod_circuito, linhas_trechos_mt_dss, nome_arquivo_seg_mt, dss_files_folder)

        # Grava arquivo DSS para o cargas MT
        # bdgd_read.query_cargas_mt(cod_circuito)
        # dss_adapter.get_lines_cargas_mt(bdgd_read.cargas_mt, bdgd_read.carga_fc, linhas_cargas_mt_dss)
        # write_to_dss(dist, sub, cod_circuito, linhas_cargas_mt_dss, nome_arquivo_crg_mt)
        # ...conectados nos segmentos
        bdgd_read.query_cargas_mt_ssdmt(cod_circuito, engine=engine)
        dss_adapter.get_lines_cargas_mt_ssdmt(bdgd_read.curvas_cargas, bdgd_read.cargas_mt_ssdmt, bdgd_read.carga_fc,
                                              linhas_cargas_mt_dss, mes, tipo_dia)
        write_to_dss(dist, sub, cod_circuito, linhas_cargas_mt_dss, nome_arquivo_crg_mt, dss_files_folder)

        # Grava arquivo DSS para monitores
        bdgd_read.query_monitors(cod_circuito, engine=engine)
        dss_adapter.get_lines_medidores(bdgd_read.monitors, linhas_monitors_dss)
        write_to_dss(dist, sub, cod_circuito, linhas_monitors_dss, nome_arquivo_monitors, dss_files_folder)

        # Grava arquivo DSS para capacitors
        bdgd_read.query_capacitor(cod_circuito, engine=engine)
        bdgd_read.query_trafo_mt_mt(engine, cod_circuito)
        bdgd_read.trafo_mtmt_find_capacitor(engine, cod_circuito)
        dss_adapter.get_line_capacitor(bdgd_read.capacitors, bdgd_read.trafo_mtmt,
                                       bdgd_read.trafo_mtmt_connected_segments, linhas_capacitors_dss)
        write_to_dss(dist, sub, cod_circuito, linhas_capacitors_dss, nome_arquivo_capacitors, dss_files_folder)

        # Grava arquivo DSS para cargas BT
        bdgd_read.query_cargas_bt(cod_circuito, engine=engine)
        bdgd_read.query_cargas_pip(cod_circuito, engine=engine)
        dss_adapter.get_lines_cargas_bt(bdgd_read.curvas_cargas, bdgd_read.cargas_bt, bdgd_read.carga_fc,
                                        bdgd_read.cargas_pip, linhas_cargas_bt_dss, mes, tipo_dia)
        write_to_dss(dist, sub, cod_circuito, linhas_cargas_bt_dss, nome_arquivo_crg_bt, dss_files_folder)

        # leitura de dados dos Geradores mt conectados nos trafos
        # bdgd_read.query_generators_mt(cod_circuito)  # conetados no trafo
        # dss_adapter.get_lines_generators_mt(bdgd_read.gerador_mt, multi_ger, linhas_generators_mt_dss)
        # ...conectados nos segmentos
        bdgd_read.query_generators_mt_ssdmt(cod_circuito, engine=engine)
        dss_adapter.get_lines_generators_mt_ssdmt(bdgd_read.gerador_mt_ssdmt, multi_ger, linhas_generators_mt_dss,
                                                  mes, tipo_modelo)
        write_to_dss(dist, sub, cod_circuito, linhas_generators_mt_dss, nome_arquivo_generators_mt_dss,
                     dss_files_folder)

        # Grava arquivo DSS para o Gerador BT
        bdgd_read.query_generators_bt(cod_circuito, engine=engine)
        dss_adapter.get_lines_generators_bt(bdgd_read.gerador_bt, multi_ger, linhas_generators_bt_dss, mes, tipo_modelo)
        write_to_dss(dist, sub, cod_circuito, linhas_generators_bt_dss, nome_arquivo_generators_bt_dss,
                     dss_files_folder)

        # Grava arquivo DSS para o master
        voltagebases = bdgd_read.voltage_bases(cod_circuito, bdgd_read.trafos)
        dss_adapter.get_lines_master(cod_circuito, voltagebases, list_files_dss, linhas_trafos_mt_dss, linhas_master)
        write_to_dss(dist, sub, cod_circuito, linhas_master, nome_arquivo_master, dss_files_folder)


if __name__ == "__main__":
    proc_time_ini = time.time()
    config = load_config('391')
    # controles de execução para apenas um primeiro mes e um primeiro tipo de dia da lista 'tipo_de_dias'
    control_mes = True
    control_tipo_dia = True
    # set if multiprocessing will be used
    tip_process = 0

    mes_ini = 12  # [1 12] mes do ano de referência para os dados de cargas e geração
    tipo_de_dias = ['DU', 'DO', 'SA']  # tipo de dia para referência para as curvas típicas de carga e geração

    if tip_process == 0:
        list_sub = [['APA'], ['ARA'], ['ASP'], ['AVP'], ['BCU'], ['BIR'], ['BON'], ['CAC'], ['CAR'], ['CMB'], ['COL'],
                    ['CPA'], ['CRU'], ['CSO'], ['DBE'],
                    ['DUT'], ['FER'], ['GOP'], ['GUE'], ['GUL'], ['GUR'], ['INP'], ['IPO'], ['ITQ'], ['JAC'], ['JNO'],
                    ['JAM'], ['JAR'], ['JCE'], ['JUQ'],
                    ['KMA'], ['LOR'], ['MAP'], ['MAS'], ['MCI'], ['MRE'], ['MTQ'], ['OLR'], ['PED'], ['PID'], ['PIL'],
                    ['PME'], ['PNO'], ['POA'], ['PRT'],
                    ['PTE'], ['ROS'], ['SAT'], ['SBR'], ['SJC'], ['SKO'], ['SLU'], ['SLZ'], ['SSC'], ['SUZ'], ['TAU'],
                    ['UNA'], ['URB'], ['USS'], ['VGA'],
                    ['VHE'], ['VJS'], ['VSL']]
        # Obter os primeiros elementos
        # primeiros_elementos = [sublista[0] for sublista in list_sub]
        # print(primeiros_elementos)

        print(cpu_count())
        """
        # utilizando map (multi-args=no order result=yes)
        with Pool(processes=(cpu_count() - 1)) as p:
            print(p.map(run_multi, [['AVP'], ['GUE'], ]))
            #print(p.map(run_multi, list_sub))    
        """

        # utilizando apply_async (multi-args=yes order result=no)
        p = Pool(processes=(cpu_count() ))
        for sub in list_sub:
            print(sub)
            print(p.apply_async(run_multi, args=(sub, config, mes_ini, tipo_de_dias, control_mes, control_tipo_dia)))
        p.close()
        p.join()
        print(f"Elapsed time: {time.time() - proc_time_ini}")

    else:
        ano = config['data_base'].split('-')[0]
        dist = config['dist']
        engine = create_connection(config)
        dss_files_folder = config['dss_files_folder']

        # Definir código da subestação (sub) e da distribuidora (dist)
        # dist = '404'  # Energisa MS
        # list_sub = ['40', '100', '58', '95', '96', '97']
        # list_sub = ['100']

        # EDP_SP = 391
        list_sub = ['APA', 'ARA', 'ASP', 'AVP', 'BCU', 'BIR', 'BON', 'CAC', 'CAR', 'CMB', 'COL', 'CPA', 'CRU', 'CSO', 'DBE',
                    'DUT', 'FER', 'GOP', 'GUE', 'GUL', 'GUR', 'INP', 'IPO', 'ITQ', 'JAC', 'JNO', 'JAM', 'JAR', 'JCE', 'JUQ',
                    'KMA', 'LOR', 'MAP', 'MAS', 'MCI', 'MRE', 'MTQ', 'OLR', 'PED', 'PID', 'PIL', 'PME', 'PNO', 'POA', 'PRT',
                    'PTE', 'ROS', 'SAT', 'SBR', 'SJC', 'SKO', 'SLU', 'SLZ', 'SSC', 'SUZ', 'TAU', 'UNA', 'URB', 'USS', 'VGA',
                    'VHE', 'VJS', 'VSL']

        list_sub = ['APA']
        # 'UBA' sem circuitos e transformadores
        # 'GUL', 'IPO (104)'  CSO e USS Trafos 34,5 kv  SSC Sem info de TRAFO_AT  #JCE, PED ok dentro dos limites

        # Cosern = 40
        # list_sub = [ 'SBN', 'STO', 'MSU', 'JCT', 'CPG', 'AAF' ]
        # list_sub = ['MSU']

        print(f'Ajusting CodBNC....')
        ajust_eqre_codbanc(dist, engine)

        for tipo_dia in tipo_de_dias:
            for mes in range(mes_ini, 13):
                for sub in list_sub:
                    # Gera arquivo com execução do fluxo de potência para toda a subestação
                    write_sub_dss(sub, dist, mes, tipo_dia, engine, dss_files_folder)
                    # Gera arquivos do openDSS para cada circuito de uma subestação
                    write_files_dss(sub, dist, ano, mes, tipo_dia, dss_files_folder, model_type=1,
                                    engine=engine)  # model_type=1 PVSystem else Generator
                if control_mes:
                    break
            if control_tipo_dia:
                break
        print(f"Processo concluído em {time.time() - proc_time_ini}")

