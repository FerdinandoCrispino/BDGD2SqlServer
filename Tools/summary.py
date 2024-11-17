# -*- encoding: utf-8 -*-
from Tools.tools import return_query_as_dataframe, load_config, create_connection
import pandas as pd


class Summary:

    def __init__(self, engine, dist, sub):
        self.dist = dist
        self.sub = sub
        self.summary_sub = []
        self.summary_sub_at = []
        self.summary_ctmt = []
        self.summary_penetration = []
        self.engine = engine

    def query_sumario_sub(self):
        """
        Busca os dados de circuitos
        :return:
        """
        query = f'''            
                SELECT c.DIST, c.SUB, s.NOME            
                      ,count( distinct c.UNI_TR_AT) as TR_AT, count(c.NOME) as CIRC
                FROM [sde].[CTMT] c  
                inner join sde.SUB S on c.sub  = s.COD_ID
                where c.sub = '{self.sub}' and c.dist = '{self.dist}'
                group by c. dist, c.SUB, s.NOME  
            ;
        '''
        self.summary_sub = return_query_as_dataframe(query, self.engine)

    def query_sumario_trafos_at(self):
        """
        Busca os dados de circuitos
        :return:
        """
        query = f'''            
                select distinct c.UNI_TR_AT ,Format(p.POT,'0.00') as POT_NOM, 
                    Format(t1.TEN/1000, '0.00') as TEN_PRI, 
                    Format(t2.TEN/1000, '0.00') as TEN_SEC from sde.ctmt c 
                    inner join sde.EQTRAT e
                        on c.UNI_TR_AT = e.UNI_TR_AT
                    inner join GEO_SIGR_DDAD_M10.sde.TTEN t1
                        on e.TEN_PRI = t1.COD_ID
                    inner join GEO_SIGR_DDAD_M10.sde.TTEN t2
                        on e.TEN_SEC = t2.COD_ID
                    inner join GEO_SIGR_DDAD_M10.sde.TPOTAPRT p
                        on e.POT_NOM = p.COD_ID
                where c.sub = '{self.sub}' and c.dist = '{self.dist}'
                ;
                '''
        self.summary_sub_at = return_query_as_dataframe(query, self.engine)

    def query_sumario_ctmt(self):
        """
        Busca os dados de circuitos
        :return:
        """
        query = f'''            
                WITH CTMT_CTE AS (
                    SELECT c.COD_ID, c.NOME, 
                           COUNT(DISTINCT t.COD_ID) AS TRAFO_MT
                    FROM sde.ctmt c
                    Left JOIN sde.untrmt t ON c.COD_ID = t.CTMT
                    WHERE c.sub = '{self.sub}' and c.dist = '{self.dist}'
                    GROUP BY c.COD_ID, c.NOME
                ),
                UCMT_CTE AS (
                    SELECT cm.CTMT, 
                           COUNT(DISTINCT cm.COD_ID) AS UCMT, 
                           SUM(CASE WHEN (len(trim(cm.CEG_GD))) > 0 THEN 1 ELSE 0 END) AS GDMT,
                           Format(sum(cm.DEM_01),'0.00') as DEM_01,
                           Format(sum(cm.DEM_02),'0.00') as DEM_02,
                           Format(sum(cm.DEM_03),'0.00') as DEM_03,
                           Format(sum(cm.DEM_04),'0.00') as DEM_04,
                           Format(sum(cm.DEM_05),'0.00') as DEM_05,
                           Format(sum(cm.DEM_06),'0.00') as DEM_06,
                           Format(sum(cm.DEM_07),'0.00') as DEM_07,
                           Format(sum(cm.DEM_08),'0.00') as DEM_08,
                           Format(sum(cm.DEM_09),'0.00') as DEM_09,
                           Format(sum(cm.DEM_10),'0.00') as DEM_10,
                           Format(sum(cm.DEM_11),'0.00') as DEM_11,
                           Format(sum(cm.DEM_12),'0.00') as DEM_12
                    FROM sde.ucmt cm
                    WHERE cm.sub = '{self.sub}' and cm.dist = '{self.dist}'
                    GROUP BY cm.CTMT
                ),
                UCBT_CTE AS (
                    SELECT cb.CTMT, 
                        COUNT(DISTINCT cb.COD_ID) AS UCBT,                        
                        SUM(CASE WHEN (len(trim(cb.CEG_GD))) > 0 THEN 1 ELSE 0 END) AS UGBT,
                        Format(sum(cb.ENE_01),'0.00') as BT_ENE_01,
                        Format(sum(cb.ENE_02),'0.00') as BT_ENE_02,
                        Format(sum(cb.ENE_03),'0.00') as BT_ENE_03,
                        Format(sum(cb.ENE_04),'0.00') as BT_ENE_04,
                        Format(sum(cb.ENE_05),'0.00') as BT_ENE_05,
                        Format(sum(cb.ENE_06),'0.00') as BT_ENE_06,
                        Format(sum(cb.ENE_07),'0.00') as BT_ENE_07,
                        Format(sum(cb.ENE_08),'0.00') as BT_ENE_08,
                        Format(sum(cb.ENE_09),'0.00') as BT_ENE_09,
                        Format(sum(cb.ENE_10),'0.00') as BT_ENE_10,
                        Format(sum(cb.ENE_11),'0.00') as BT_ENE_11,
                        Format(sum(cb.ENE_12),'0.00') as BT_ENE_12
                    FROM sde.ucbt cb
                    WHERE cb.sub = '{self.sub}' and cb.dist = '{self.dist}'
                    GROUP BY cb.CTMT
                )
                SELECT t.COD_ID, t.NOME, 
                       t.TRAFO_MT, 
                       ISNULL(ucmt.UCMT, 0) AS UCMT, 
                       ISNULL(ucbt.UCBT, 0) AS UCBT, 
                       ISNULL(ucmt.GDMT, 0) AS GDMT, 
                       ISNULL(ucbt.UGBT, 0) AS GDBT,
                       ISNULL(ucmt.DEM_01, 0) AS MT_DEM_01,
                       ISNULL(ucmt.DEM_02, 0) AS MT_DEM_02,
                       ISNULL(ucmt.DEM_03, 0) AS MT_DEM_03,
                       ISNULL(ucmt.DEM_04, 0) AS MT_DEM_04,
                       ISNULL(ucmt.DEM_05, 0) AS MT_DEM_05,
                       ISNULL(ucmt.DEM_06, 0) AS MT_DEM_06,
                       ISNULL(ucmt.DEM_07, 0) AS MT_DEM_07,
                       ISNULL(ucmt.DEM_08, 0) AS MT_DEM_08,
                       ISNULL(ucmt.DEM_09, 0) AS MT_DEM_09,
                       ISNULL(ucmt.DEM_10, 0) AS MT_DEM_10,
                       ISNULL(ucmt.DEM_11, 0) AS MT_DEM_11,
                       ISNULL(ucmt.DEM_12, 0) AS MT_DEM_12,
                       ISNULL(ucbt.BT_ENE_01, 0) AS BT_ENE_01,
                       ISNULL(ucbt.BT_ENE_02, 0) AS BT_ENE_02,
                       ISNULL(ucbt.BT_ENE_03, 0) AS BT_ENE_03,
                       ISNULL(ucbt.BT_ENE_04, 0) AS BT_ENE_04,
                       ISNULL(ucbt.BT_ENE_05, 0) AS BT_ENE_05,
                       ISNULL(ucbt.BT_ENE_06, 0) AS BT_ENE_06,
                       ISNULL(ucbt.BT_ENE_07, 0) AS BT_ENE_07,
                       ISNULL(ucbt.BT_ENE_08, 0) AS BT_ENE_08,
                       ISNULL(ucbt.BT_ENE_09, 0) AS BT_ENE_09,
                       ISNULL(ucbt.BT_ENE_10, 0) AS BT_ENE_10,
                       ISNULL(ucbt.BT_ENE_11, 0) AS BT_ENE_11,
                       ISNULL(ucbt.BT_ENE_12, 0) AS BT_ENE_12
                FROM CTMT_CTE t
                LEFT JOIN UCMT_CTE ucmt ON t.COD_ID = ucmt.CTMT
                LEFT JOIN UCBT_CTE ucbt ON t.COD_ID = ucbt.CTMT;
                '''
        self.summary_ctmt = return_query_as_dataframe(query, self.engine)

    def max_demand_mt(self):
        self.summary_ctmt['MT_MAX_DEM'] = self.summary_ctmt[['MT_DEM_01', 'MT_DEM_02', 'MT_DEM_03',
                                                             'MT_DEM_04', 'MT_DEM_05', 'MT_DEM_06',
                                                             'MT_DEM_07', 'MT_DEM_08', 'MT_DEM_09',
                                                             'MT_DEM_10', 'MT_DEM_11', 'MT_DEM_12']].max(axis=1)
        return self.summary_ctmt[['NOME', 'UCMT', 'GDMT', 'MT_MAX_DEM']]

    def max_energy_bt(self):
        self.summary_ctmt['BT_MAX_ENE'] = self.summary_ctmt[['BT_ENE_01', 'BT_ENE_02', 'BT_ENE_03',
                                                             'BT_ENE_04', 'BT_ENE_05', 'BT_ENE_06',
                                                             'BT_ENE_07', 'BT_ENE_08', 'BT_ENE_09',
                                                             'BT_ENE_10', 'BT_ENE_11', 'BT_ENE_12']].max(axis=1)
        return self.summary_ctmt[['NOME', 'TRAFO_MT', 'UCBT', 'GDBT', 'BT_MAX_ENE']]

    def query_summary_penetration(self):
        """
        Algumas correções para casos de erros obivius de cadastro do valor da potência instalada dos geradores BT.
        Potencia instalada:
            maior que 1MW será dividido por 1000
            menor que 0,01 será multilicado por 1000

        :return:
        """
        query = f'''            
                WITH A AS (
                    select UNI_TR_AT, round(sum(POT_INST),2) AS TOTAL_GD_MT 
                    from sde.ugmt 
                    where sub = '{self.sub}' and dist = '{self.dist}' group by UNI_TR_AT
                    ),
                    B as (
                    select UNI_TR_AT, round(sum(case
                                                    when bt.POT_INST >= 1000 then bt.POT_INST/1000
                                                    when bt.POT_INST > 100 AND bt.POT_INST < 1000 then bt.POT_INST/100 
                                                    when bt.POT_INST <= 0.01 then bt.POT_INST*1000 
                                                    when (bt.POT_INST > 0.01 AND bt.POT_INST < 0.1) then bt.POT_INST*100 
                                                    else bt.POT_INST
                                                end) ,2) AS TOTAL_GD_BT 
                    from sde.ugbt bt 
                    where sub = '{self.sub}' and dist = '{self.dist}' group by UNI_TR_AT
                    )
                    select A.UNI_TR_AT, A.TOTAL_GD_MT, B.TOTAL_GD_BT 
                    from A 
                    inner join B on a.UNI_TR_AT = b.UNI_TR_AT
                    ;
                '''
        self.summary_penetration = return_query_as_dataframe(query, self.engine)


if __name__ == "__main__":
    config = load_config('391')
    engine = create_connection(config)
    sumario = Summary(engine, sub='CJO', dist='391')
    sumario.query_sumario_sub()
    sumario.query_sumario_trafos_at()
    sumario.query_summary_penetration()
    sumario.query_sumario_ctmt()

    print("--" * 30)
    print(sumario.summary_sub)
    print("--" * 30)
    print(sumario.summary_sub_at)
    print("--" * 30)
    print(sumario.summary_penetration)
    print(pd.merge(sumario.summary_sub_at, sumario.summary_penetration, how='inner', on='UNI_TR_AT'))

    print("--" * 30)
    print(sumario.max_demand_mt())
    print("--" * 30)
    print(sumario.max_energy_bt())
    # print(sumario.summary_ctmt)
