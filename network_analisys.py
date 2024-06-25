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

            sql = f"SELECT PAC_1, PAC_2, PN_CON_1, PN_CON_2, objectid ctmt FROM SDE.SSDMT Where ctmt='{ctmt}' "
            ssdmt_pacs = pd.read_sql_query(sql, conn)
            print(f"Total segmentos: {len(ssdmt_pacs)}")
            # Construir o grafo
            graph = cs.build_graph(ssdmt_pacs, start, end)
            # Encontrar e ordenar segmentos conectados usando DFS
            connected_segments = cs.dfs(graph, pn_ini)
            print(connected_segments)
            print(f"Segmentos conectados: {len(connected_segments)}")
            print("Não conectados:")

            all_segments = list(zip(ssdmt_pacs[start], ssdmt_pacs[end]))
            unconnected_segments = cs.find_unconnected_segments(all_segments, connected_segments)
            print(len(unconnected_segments))
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

    check_connect_ssdmt(engine, '58', 'PN_CON')  # PAC or PN_CON
