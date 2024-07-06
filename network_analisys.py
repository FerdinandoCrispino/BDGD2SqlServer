# -*- encoding: utf-8 -*-

import pandas as pd
import connected_segments as cs
from Tools.tools import create_connection

"""
# @Date    : 20/062024
# @Author  : Ferdinano Crispino
Análise da conectividade elétrica dos segmentos de média tensão
"""


def check_connect_ssdmt(engine, sub: str, type_connected="PN_CON"):
    """

    :param engine: Coneção com o banco de dados.
    :param sub: Codigo da subestação analisada.
    :param type_connected: Campo da tabela SSDMT que será utilizado para a verificação da conectividade (DE/PARA).
    :return:
    """
    with engine.connect() as conn:
        ctmt_pac_ini = pd.read_sql_query(f"SELECT PAC, SUB, cod_id FROM SDE.CTMT Where SUB='{sub}'", conn)
        for i in range(len(ctmt_pac_ini)):
            pac_ini = ctmt_pac_ini.iloc[i, 0]
            ctmt = ctmt_pac_ini.iloc[i, 2]
            print(pac_ini, ctmt_pac_ini.iloc[i, 1])
            sql = f"SELECT PAC_1, PAC_2, PN_CON_1, PN_CON_2, ctmt FROM SDE.SSDMT Where sub='{sub}' and PAC_1='{pac_ini}'"
            ssdmt_ini = pd.read_sql_query(sql, conn)

            if len(ssdmt_ini) == 1:
                if type_connected.upper() == 'PN_CON':
                    pn_ini = ssdmt_ini.iloc[0, 2]
                    start = 'PN_CON_1'
                    end = 'PN_CON_2'
                else:
                    pn_ini = ssdmt_ini.iloc[0, 0]
                    start = 'PAC_1'
                    end = 'PAC_2'

            # Trechos MT
            sql = f"SELECT PAC_1, PAC_2, PN_CON_1, PN_CON_2, COD_ID, ctmt FROM SDE.SSDMT Where ctmt='{ctmt}' "
            ssdmt_pacs = pd.read_sql_query(sql, conn)

            # Chaves MT
            sql = f"SELECT PAC_1, PAC_2, COD_ID, ctmt FROM SDE.UNSEMT Where ctmt='{ctmt}' and P_N_OPE='F' "
            unsemt_pacs = pd.read_sql_query(sql, conn)

            # Transformadores MT
            sql = f"SELECT PAC_1, PAC_2, COD_ID, ctmt FROM SDE.UNTRMT Where ctmt='{ctmt}' and SIT_ATIV='AT' "
            untrmt_pacs = pd.read_sql_query(sql, conn)

            print(f"Total Trechos: {len(ssdmt_pacs)}, Chaves: {len(unsemt_pacs)}, Trafos: {len(untrmt_pacs)}")

            total_seg = pd.concat([ssdmt_pacs, unsemt_pacs, untrmt_pacs], sort=False)
            # Construir o grafo
            graph = cs.build_graph(total_seg, start, end)
            # Encontrar e ordenar segmentos conectados usando DFS
            connected_segments = cs.dfs(graph, pn_ini)
            #print(connected_segments)
            print(f"Segmentos conectados: {len(connected_segments)}")

            all_segments = list(zip(total_seg[start], total_seg[end]))
            unconnected_segments = cs.find_unconnected_segments(all_segments, connected_segments)
            print(f"Não conectados: {len(unconnected_segments)}")
            print(unconnected_segments)

            print(ctmt + '\n')

    print('Fim')


if __name__ == "__main__":
    # Conectando ao banco de dados sqlserver using sqlalchemy
    try:
        engine = create_connection()
    except Exception as e:
        print(f"Erro ao conectar ao banco de dados: {e}")
        exit(1)

    check_connect_ssdmt(engine, '58', 'PAC')  # PAC or PN_CON
