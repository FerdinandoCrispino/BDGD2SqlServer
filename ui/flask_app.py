import os
import sys
import time

import geopandas as gpd
import pandas as pd
from colour import Color
from flask import Flask, render_template, request, Response, url_for, redirect, jsonify
from flask import flash
from shapely.geometry import LineString, Point
import connected_segments as cs
import geo_tools
import io
import threading

# execução da geração dos arquivos DSS pelo navegador.
import core.electric_data as run_dss_files_generators

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)

import Tools.summary as resumo
from Tools.tools import return_query_as_dataframe, create_connection, load_config

task_running = False  # Variável para evitar múltiplas execuções simultâneas -- control_bus

sys.path.append('../')
# Configuração do Flask
server = Flask(__name__)
server.secret_key = "123456"
# Caminho para o arquivo Geodatabase
GDB_PATH = os.path.join(os.path.dirname(__file__), 'data', 'sin_data.gdb')


# Função para buscar as subestações com base na distribuidora
@server.route('/api/subestacoes/<distribuidora>', methods=['GET'])
def get_subestacoes(distribuidora):
    global engine
    try:
        conf = load_config(distribuidora)
        engine = create_connection(conf)
        query = f'''SELECT DISTINCT c.SUB, s.nome FROM sde.CTMT c
                      inner join sde.SUB s on s.COD_ID = c.sub
                      WHERE s.dist ='{distribuidora}'
                '''
        rows = return_query_as_dataframe(query, engine)
        rows['Combined'] = rows['SUB'].astype(str) + '-' + rows['nome']
        subestacoes = rows.values.tolist()
        return jsonify(subestacoes)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# Função para buscar os circuitos com base na subestação
@server.route('/api/circuitos/<subestacao>', methods=['GET'])
def get_circuitos(subestacao):
    query = f'''
            SELECT DISTINCT nome, cod_id FROM SDE.CTMT WHERE SUB ='{subestacao}'
            '''
    rows = return_query_as_dataframe(query, engine)
    circuitos = rows.values.tolist()
    return jsonify(circuitos)


def get_coords_from_db(sub, ctmt, table_name):
    if ctmt == "":
        query = f'''Select POINT_X, POINT_Y, CTMT, SUB
                    from sde.{table_name} 
                    where SUB= '{sub}' 
                ;   
                '''
    else:
        query = f'''Select POINT_X, POINT_Y, CTMT, SUB
                    from sde.{table_name}
                    where SUB= '{sub}' and ctmt = '{ctmt}'
                ;   
                '''
    rows = return_query_as_dataframe(query, engine)
    rows["nome"] = table_name
    points = [((row["POINT_X"], row["POINT_Y"]), rows["CTMT"], rows["nome"]) for index, row in rows.iterrows()]
    return points


def get_coords_trafos_from_db(sub, ctmt):
    if ctmt == "":
        query = f'''Select t.POINT_X, t.POINT_Y, t.CTMT, t.SUB, t.TEN_LIN_SE, t.POT_NOM, t.TIP_UNID, t.TIP_TRAFO,
                            v1.TEN/1000 as TEN_PRI, v2.TEN as TEN_SEC, t.COD_ID
                    from sde.UNTRMT t
                        inner join  sde.eqtrmt e on t.cod_id = e.UNI_TR_MT  
                        INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN v1 on v1.COD_ID = e.TEN_PRI
                        INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN v2 on v2.COD_ID = e.TEN_SEC
                    where SUB= '{sub}' 
                ;   
                '''
    else:
        query = f'''Select t.POINT_X, t.POINT_Y, t.CTMT, t.SUB, t.TEN_LIN_SE, t.POT_NOM, t.TIP_UNID, t.TIP_TRAFO,
                            v1.TEN/1000 as TEN_PRI, v2.TEN as TEN_SEC, t.COD_ID
                    from sde.UNTRMT t
                        inner join  sde.eqtrmt e on t.cod_id = e.UNI_TR_MT  
                        INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN v1 on v1.COD_ID = e.TEN_PRI
                        INNER JOIN [GEO_SIGR_DDAD_M10].sde.TTEN v2 on v2.COD_ID = e.TEN_SEC
                    where SUB= '{sub}' and ctmt = '{ctmt}'
                ;   
                '''
    rows = return_query_as_dataframe(query, engine)
    rows["nome"] = "UNTRMT"
    points = [((row["POINT_X"], row["POINT_Y"]), row["CTMT"], row["nome"], row["TEN_LIN_SE"],
               row["POT_NOM"], row["TIP_UNID"], row["TIP_TRAFO"], row["TEN_PRI"], row["TEN_SEC"], row["COD_ID"])
              for index, row in rows.iterrows()]
    return points


def get_coords_unsemt_from_db(sub, ctmt):
    if ctmt == "":
        query = f'''Select POINT_X, POINT_Y, COD_ID, COR_NOM, CAP_ELO, CTMT, 
                        CASE P_N_OPE 
                            when 'A' then 'OPEN' 
                            when 'F' then 'CLOSE' 
                            else P_N_OPE
                        END as P_N_OPE
                    from sde.UNSEMT 
                    where sub='{sub}' 
                ;   
                '''
    else:
        query = f'''Select POINT_X, POINT_Y, COD_ID,COR_NOM, CAP_ELO, CTMT,
                        CASE P_N_OPE 
                            when 'A' then 'OPEN' 
                            when 'F' then 'CLOSE' 
                            else P_N_OPE
                        END as P_N_OPE
                    from sde.UNSEMT                    
                    where sub='{sub}' and ctmt='{ctmt}'
                ;   
                '''
    rows = return_query_as_dataframe(query, engine)
    rows["TIPO"] = "UNSEMT"
    points = [((row["POINT_X"], row["POINT_Y"]), rows["COD_ID"], rows["P_N_OPE"], rows["COR_NOM"], rows["CAP_ELO"],
               rows["CTMT"], rows["TIPO"])
              for index, row in rows.iterrows()]
    return points


def create_geojson_from_points_UNSEMT(points_unsemt):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos
    # lines = [LineString([start, end]) for start, end in line_segments]
    points = []
    # circ = []

    for pt, COD_ID, P_N_OPE, COR_NOM, CAP_ELO, CTMT, TIPO in points_unsemt:
        points.append(Point([pt]))
        # circ.append(ctmt)

    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': points, 'ctmt': CTMT, 'ope': P_N_OPE, 'cor_nom': COR_NOM, 'cap_elo': CAP_ELO,
                            'tipo': TIPO, 'cod_id': COD_ID}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()
    return geojson


def get_coords_ugbt_from_db(sub, ctmt):
    if ctmt == "":
        query = f'''Select POINT_X, POINT_Y, g.COD_ID, g.CEG, g.CTMT, g.POT_INST, g.FAS_CON, g.TEN_FORN, t.TEN
                    from sde.UGBT G
                    inner join GEO_SIGR_DDAD_M10.SDE.TTEN  t on t.COD_ID = g.TEN_FORN
                    where sub='{sub}' 
                ;   
                '''
    else:
        query = f'''Select POINT_X, POINT_Y, g.COD_ID, g.CEG, g.CTMT, g.POT_INST, g.FAS_CON, g.TEN_FORN, t.TEN
                    from sde.UGBT G
                    inner join GEO_SIGR_DDAD_M10.SDE.TTEN  t on t.COD_ID = g.TEN_FORN                 
                    where sub='{sub}' and ctmt='{ctmt}'
                ;   
                '''
    rows = return_query_as_dataframe(query, engine)
    rows["TIPO"] = "UGBT"
    points = [((row["POINT_X"], row["POINT_Y"]), rows["COD_ID"], rows["CEG"], rows["POT_INST"], rows["TEN"],
               rows["CTMT"], rows["FAS_CON"], rows["TIPO"])
              for index, row in rows.iterrows()]
    return points


def create_geojson_from_points_UGBT(points_ugbt):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos
    # lines = [LineString([start, end]) for start, end in line_segments]
    points = []
    # circ = []

    for pt, COD_ID, CEG, POT_INST, TEN, CTMT, FAS_CON, TIPO in points_ugbt:
        points.append(Point([pt]))
        # circ.append(ctmt)

    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': points, 'ctmt': CTMT, 'ceg': CEG, 'pot_inst': POT_INST, 'voltage': TEN,
                            'tipo': TIPO, 'fas_con': FAS_CON, 'cod_id': COD_ID}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()
    return geojson


def get_coords_ugmt_from_db(sub, ctmt):
    if ctmt == "":
        query = f'''Select POINT_X, POINT_Y, g.COD_ID, g.CEG_GD, g.CTMT, g.POT_INST, g.DEM_CONT, g.FAS_CON, 
                        g.TEN_FORN, g.TEN_CON, t.TEN
                    from sde.UGMT G
                    inner join GEO_SIGR_DDAD_M10.SDE.TTEN  t on t.COD_ID = g.TEN_CON
                    where sub='{sub}' 
                ;   
                '''
    else:
        query = f'''Select POINT_X, POINT_Y, g.COD_ID, g.CEG_GD, g.CTMT, g.POT_INST, g.DEM_CONT, g.FAS_CON, 
                        g.TEN_FORN, g.TEN_CON, t.TEN
                    from sde.UGMT G
                    inner join GEO_SIGR_DDAD_M10.SDE.TTEN  t on t.COD_ID = g.TEN_CON                
                    where sub='{sub}' and ctmt='{ctmt}'
                ;   
                '''
    rows = return_query_as_dataframe(query, engine)
    rows["TIPO"] = "UGMT"
    points = [((row["POINT_X"], row["POINT_Y"]), rows["COD_ID"], rows["CEG_GD"], rows["POT_INST"], rows["DEM_CONT"],
               rows["TEN"], rows["CTMT"], rows["FAS_CON"], rows["TIPO"])
              for index, row in rows.iterrows()]
    return points


def create_geojson_from_points_UGMT(points_ugmt):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos
    # lines = [LineString([start, end]) for start, end in line_segments]
    points = []
    # circ = []

    for pt, COD_ID, CEG, POT_INST, DEM_CONT, TEN, CTMT, FAS_CON, TIPO in points_ugmt:
        points.append(Point([pt]))
        # circ.append(ctmt)

    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': points, 'ctmt': CTMT, 'ceg': CEG, 'pot_inst': POT_INST, 'demanda': DEM_CONT,
                            'voltage': TEN, 'tipo': TIPO, 'fas_con': FAS_CON, 'cod_id': COD_ID}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()
    return geojson


def get_coords_ucmt_from_db(sub, ctmt):
    if ctmt == "":
        query = f'''Select POINT_X, POINT_Y, c.COD_ID, c.CEG_GD, c.CTMT, c.CAR_INST, c.GRU_TAR, c.LIV, 
                        c.TIP_CC, c.CLAS_SUB, c.FAS_CON, c.TEN_FORN, t.TEN
                    from sde.UCMT C
                    inner join GEO_SIGR_DDAD_M10.SDE.TTEN  t on t.COD_ID = c.TEN_FORN
                    where sub='{sub}' 
                ;   
                '''
    else:
        query = f'''Select POINT_X, POINT_Y, c.COD_ID, c.CEG_GD, c.CTMT, c.CAR_INST, c.GRU_TAR, c.LIV, 
                        c.TIP_CC, c.CLAS_SUB, c.FAS_CON, c.TEN_FORN, t.TEN
                    from sde.UCMT C
                    inner join GEO_SIGR_DDAD_M10.SDE.TTEN  t on t.COD_ID = c.TEN_FORN                
                    where sub='{sub}' and ctmt='{ctmt}'
                ;   
                '''
    rows = return_query_as_dataframe(query, engine)
    rows["TIPO"] = "UCMT"
    points = [((row["POINT_X"], row["POINT_Y"]), rows["COD_ID"], rows["CEG_GD"], rows["CAR_INST"], rows["GRU_TAR"],
               rows["TEN"], rows["CTMT"], rows["FAS_CON"], rows["LIV"], rows["GRU_TAR"], rows["TIPO"])
              for index, row in rows.iterrows()]
    return points


def create_geojson_from_points_UCMT(points_ucmt):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos
    # lines = [LineString([start, end]) for start, end in line_segments]
    points = []
    # circ = []

    for pt, COD_ID, CEG, CAR_INST, GRU_TAR, TEN, CTMT, FAS_CON, LIV, GRU_TAR, TIPO in points_ucmt:
        points.append(Point([pt]))
        # circ.append(ctmt)

    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': points, 'ctmt': CTMT, 'ceg': CEG, 'pot_inst': CAR_INST,
                            'voltage': TEN, 'tipo': TIPO, 'fas_con': FAS_CON, 'cod_id': COD_ID,
                            'livre': LIV, 'gru_tar': GRU_TAR}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()
    return geojson


def get_coords_unremt_from_db(sub, ctmt):
    if ctmt == "":
        query = f'''Select POINT_X, POINT_Y, CTMT, SUB, BANC, p.DESCR, c.TIP_REGU, FAS_CON, Format(TEN_REG, 'N', 'en-us') as TEN_REG
                    from sde.UNREMT c
                    INNER JOIN SDE.EQRE AS e 
                            ON (c.PAC_1 = e.PAC_1 OR c.PAC_2 = e.PAC_2 OR c.PAC_1 = e.PAC_2 OR c.PAC_2 = e.PAC_1)
                    inner join GEO_SIGR_DDAD_M10.SDE.TREGU p on p.COD_ID = c.TIP_REGU 
                    where SUB= '{sub}' 
                ;   
                '''
    else:
        query = f'''Select POINT_X, POINT_Y, CTMT, SUB, BANC, p.DESCR, c.TIP_REGU, FAS_CON, Format(TEN_REG, 'N', 'en-us') as TEN_REG
                    from sde.UNREMT c
                    INNER JOIN SDE.EQRE AS e 
                            ON (c.PAC_1 = e.PAC_1 OR c.PAC_2 = e.PAC_2 OR c.PAC_1 = e.PAC_2 OR c.PAC_2 = e.PAC_1)
                    inner join GEO_SIGR_DDAD_M10.SDE.TREGU p on p.COD_ID = c.TIP_REGU 
                    where SUB= '{sub}' and ctmt = '{ctmt}'
                ;   
                '''
    rows = return_query_as_dataframe(query, engine)
    rows["nome"] = "UNREMT"
    points = [((row["POINT_X"], row["POINT_Y"]), rows["CTMT"], rows["nome"], rows["SUB"], rows["BANC"],
               rows["FAS_CON"], rows["DESCR"], rows["TIP_REGU"], rows["TEN_REG"]) for index, row in rows.iterrows()]

    return points


def create_geojson_from_points_unremt(points_unremt):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos
    # lines = [LineString([start, end]) for start, end in line_segments]
    points = []
    circ = []

    for pt, ctmt, nome, sub, banc, fas_con, descr, tip_reg, ten_reg in points_unremt:
        points.append(Point([pt]))
        circ.append(ctmt)

    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': points, 'ctmt': ctmt, 'tipo': nome, 'sub': sub, 'banc': banc,
                            'fas_con': fas_con, 'tip_regu': descr, 'ten_reg': ten_reg}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()
    return geojson


def get_coords_uncrmt_from_db(sub, ctmt):
    if ctmt == "":
        query = f'''Select POINT_X, POINT_Y, CTMT, SUB, POT_NOM, BANC, p.POT
                    from sde.UNCRMT c
                    inner join GEO_SIGR_DDAD_M10.SDE.TPOTRTV p on p.COD_ID = c.POT_NOM 
                    where SUB= '{sub}' 
                ;   
                '''
    else:
        query = f'''Select POINT_X, POINT_Y, CTMT, SUB, POT_NOM, BANC, p.POT
                    from sde.UNCRMT c
                    inner join GEO_SIGR_DDAD_M10.SDE.TPOTRTV p on p.COD_ID = c.POT_NOM 
                    where SUB= '{sub}' and ctmt = '{ctmt}'
                ;   
                '''
    rows = return_query_as_dataframe(query, engine)
    rows["nome"] = "UNCRMT"
    points = [((row["POINT_X"], row["POINT_Y"]), rows["CTMT"], rows["nome"], rows["SUB"], rows["BANC"],
               rows["POT"]) for index, row in rows.iterrows()]

    return points


def create_geojson_from_points_uncrmt(points_uncrmt):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos
    # lines = [LineString([start, end]) for start, end in line_segments]
    points = []
    circ = []

    for pt, ctmt, nome, sub, banc, pot in points_uncrmt:
        points.append(Point([pt]))
        circ.append(ctmt)

    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': points, 'ctmt': ctmt, 'tipo': nome, 'sub': sub, 'banc': banc,
                            'pot': pot}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()
    return geojson


def get_coords_ucbt_from_db(sub, ctmt):
    if ctmt == "":
        query = f'''Select POINT_X, POINT_Y, c.COD_ID, CEG_GD, CTMT, clas_sub, tip_cc, c.FAS_CON, c.TEN_FORN, t.TEN,
                    UNI_TR_MT, CAR_INST
                    from sde.UCBT c
                    inner join GEO_SIGR_DDAD_M10.SDE.TTEN  t on t.COD_ID = c.TEN_FORN
                    where sub='{sub}' and sit_ativ = 'AT'
                ;   
                '''
    else:
        query = f'''Select POINT_X, POINT_Y, c.COD_ID, CEG_GD, CTMT, clas_sub, tip_cc, c.FAS_CON, c.TEN_FORN, t.TEN,
                    UNI_TR_MT, CAR_INST
                    from sde.UCBT c
                    inner join GEO_SIGR_DDAD_M10.SDE.TTEN  t on t.COD_ID = c.TEN_FORN                 
                    where sub='{sub}' and ctmt='{ctmt}' and sit_ativ = 'AT'
                ;   
                '''
    rows = return_query_as_dataframe(query, engine)
    rows["TIPO"] = "UCBT"
    points = [((row["POINT_X"], row["POINT_Y"]), rows["COD_ID"], rows["CEG_GD"], rows["tip_cc"], rows["TEN"],
               rows["CTMT"], rows["FAS_CON"], rows["TIPO"], rows["UNI_TR_MT"], rows["CAR_INST"])
              for index, row in rows.iterrows()]
    return points


def create_geojson_from_points_UCBT(points_ucbt):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos
    # lines = [LineString([start, end]) for start, end in line_segments]
    points = []
    # circ = []

    for pt, COD_ID, CEG_GD, TIP_CC, TEN, CTMT, FAS_CON, TIPO, UNI_TR_MT, CAR_INST in points_ucbt:
        points.append(Point([pt]))
        # circ.append(ctmt)

    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': points, 'ctmt': CTMT, 'ceg': CEG_GD, 'tip_cc': TIP_CC, 'voltage': TEN,
                            'tipo': TIPO, 'fas_con': FAS_CON, 'cod_id': COD_ID, 'uni_tr_mt': UNI_TR_MT,
                            'car_inst': CAR_INST}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()
    return geojson


def get_coords_gerador_at_from_db():
    query = f'''
            SELECT g.POINT_X, g.POINT_Y, g.CTAT, g.PAC, g.SUB, g.CEG_GD, g.TEN_CON, g.POT_INST, t.TEN/1000 as TEN
                FROM [sde].[UGAT] G 
                inner join [GEO_SIGR_DDAD_M10].sde.TTEN t 
                    on g.TEN_CON = t.COD_ID
                ;    
            '''
    rows = return_query_as_dataframe(query, engine)
    rows["TIPO"] = "GERADOR_AT"
    points = [((row["POINT_X"], row["POINT_Y"]), rows["CEG_GD"], rows["TEN"], rows["SUB"], rows["CTAT"],
               rows["POT_INST"], rows["TIPO"]) for index, row in rows.iterrows()]
    return points


def create_geojson_from_points_gerador_at(points_ger_at):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos
    # lines = [LineString([start, end]) for start, end in line_segments]
    points = []
    # circ = []

    for pt, ceg, ten, sub, ctat, potencia, tipo in points_ger_at:
        points.append(Point([pt]))
        # circ.append(ctmt)

    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': points, 'ceg': ceg, 'voltage': ten, 'sub': sub, 'circ': ctat, 'power': potencia,
                            'tipo': tipo}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()
    return geojson


def get_coords_ssdat_from_db():
    query = f'''Select  point_x1 as start_longitude, POINT_y1 as start_latitude, 
                    point_x2 as end_longitude, POINT_y2 as end_latitude,
                    PAC_1, PAC_2, CT_COD_OP, COMP,  c.NOME, c.TEN_NOM, t.TEN
                from sde.SSDAT s
                left join sde.ctat c on c.PAC_INI = s.pac_1 or c.PAC_INI = s.PAC_2
                left join [GEO_SIGR_DDAD_M10].sde.TTEN t on c.TEN_NOM = t.COD_ID
                order by CT_COD_OP
                ;
                '''
    rows = return_query_as_dataframe(query, engine)
    # processo muito demorado para obter a tensão da linha para todos os trechos
    # TODO Buscar alternativa para a identificação da tensão de todos os trechos de uma linha de alta tensão
    """
    ssdat_ini = rows[rows['TEN'] > 0]
    for index, row in ssdat_ini.iterrows():
        pn_ini = row['PAC_1']
        voltage = row['TEN']
        # Construir o grafo
        graph = cs.build_graph(rows, 'PAC_1', 'PAC_2')
        # Encontrar e ordenar segmentos conectados usando DFS
        connected_segments = cs.dfs(graph, pn_ini)
    """
    ssdat_ini = rows[rows['TEN'] > 0]
    for index, row in ssdat_ini.iterrows():
        voltage = row['TEN']
        nome = row['NOME']
        linha = row['CT_COD_OP']
        rows.loc[rows['CT_COD_OP'] == linha, 'TEN'] = voltage


    rows["TIPO"] = "AT_SSD"
    points = [((row["start_longitude"], row["start_latitude"]), (row["end_longitude"], row["end_latitude"]),
               row["CT_COD_OP"], row["COMP"], row["NOME"], row["TEN"], rows["TIPO"])
              for index, row in rows.iterrows()]
    return points


def create_geojson_from_points_SSDAT(points_ssdat):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos
    # lines = [LineString([start, end]) for start, end in line_segments]
    lines = []
    ct_cod_at = []
    comp_linha = []
    nome_linha = []
    voltage = []

    for start, end, ct_cod, comp, nome, ten_nom, tipo in points_ssdat:
        lines.append(LineString([start, end]))
        ct_cod_at.append(ct_cod)
        comp_linha.append(comp)
        nome_linha.append(nome)
        voltage.append(ten_nom/1000)

    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': lines, 'linha': ct_cod_at, 'nome': nome,  'voltage': voltage, 'tipo': tipo},
                           crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()
    return geojson


def get_coords_sub_from_db(sub=None):
    if sub is None:
        query = f'''SELECT s.POINT_X, s.POINT_Y, s.COD_ID, s.NOME, s.POS          
                      ,count( distinct c.UNI_TR_AT) as TR_AT, count(c.NOME) as CTMT
                    FROM [sde].[CTMT] c  
                    inner join sde.SUB S on c.sub = s.COD_ID
                    group by s.COD_ID, s.NOME, s.POINT_X, s.POINT_Y, s.POS
                ;   
                '''
    else:
        query = f'''SELECT s.POINT_X, s.POINT_Y, s.COD_ID, s.NOME, s.POS          
                      ,count( distinct c.UNI_TR_AT) as TR_AT, count(c.NOME) as CTMT
                    FROM [sde].[CTMT] c  
                    inner join sde.SUB S on c.sub = s.COD_ID
                    where c.sub = '{sub}' 
                    group by s.COD_ID, s.NOME, s.POINT_X, s.POINT_Y, s.POS
                ;   
                '''

    rows = return_query_as_dataframe(query, engine)
    rows["TIPO"] = "SUB"
    points = [((row["POINT_X"], row["POINT_Y"]), rows["COD_ID"], rows["POS"], rows["NOME"], rows["TR_AT"], rows["TIPO"])
              for index, row in rows.iterrows()]
    return points


def create_geojson_from_points_sub(points_sub):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos
    # lines = [LineString([start, end]) for start, end in line_segments]
    points = []
    # circ = []

    for pt, COD_ID, pos, nome, tr_at, tipo in points_sub:
        points.append(Point([pt]))
        # circ.append(ctmt)

    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': points, 'sub': COD_ID, 'nome': nome, 'num_trafos': tr_at,
                            'tipo': tipo}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()
    return geojson


def create_geojson_from_points_ucmt(points_ucmt):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos
    # lines = [LineString([start, end]) for start, end in line_segments]
    points = []
    circ = []

    for pt, ctmt, nome in points_ucmt:
        points.append(Point([pt]))
        circ.append(ctmt)

    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': points, 'ctmt': ctmt, 'tipo': nome}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()
    return geojson


def create_geojson_from_points_trafos(points_trafos):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos
    # lines = [LineString([start, end]) for start, end in line_segments]
    points = []
    ten_lin_se_ct = []
    pot_nom_ct = []
    tip_unid_ct = []
    tip_trafo_ct = []
    ten_pri_ct = []
    tr_cod_id = []

    for pt_trafo, ctmt, nome, ten_lin_se, pot_nom, tip_unid, tip_trafo, ten_pri, ten_sec, cod_id in points_trafos:
        points.append(Point([pt_trafo]))
        ten_lin_se_ct.append(ten_lin_se)
        pot_nom_ct.append(pot_nom)
        tip_unid_ct.append(tip_unid)
        tip_trafo_ct.append(tip_trafo)
        ten_pri_ct.append(ten_pri)
        tr_cod_id.append(cod_id)

    # Criar um DataFrame com os dados
    df = pd.DataFrame({
        'ctmt': ctmt,
        'tipo': nome,
        'v_prim': ten_pri_ct,
        'v_lin_se': ten_lin_se_ct,
        'pot': pot_nom_ct,
        'tip': tip_unid_ct,
        'tip_tr': tip_trafo_ct,
        'cod_id': tr_cod_id
    })

    # Transformar o DataFrame em um GeoDataFrame
    gdf = gpd.GeoDataFrame(df, geometry=points, crs="EPSG:4326")

    # Criar um GeoDataFrame com as geometrias e dados extras
    # gdf = gpd.GeoDataFrame({'geometry': points, 'ctmt': ctmt, 'tipo': nome, 'v_prim': ten_pri, 'v_lin_se': ten_lin_se,
    #                        'pot': pot_nom, 'tip': tip_unid}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()
    return geojson


# Função para conectar ao SQL Server e obter coordenadas da tabela SSDMT
def get_coords_SSDMT_from_db(sub, ctmt):
    if ctmt == "" or ctmt == 'undefined':
        query = f'''Select  point_x1 as start_longitude, POINT_y1 as start_latitude, 
                        point_x2 as end_longitude, POINT_y2 as end_latitude,
                        ss.CTMT, ss.PAC_1, ss.PAC_2, ss.SUB
                    from sde.ssdmt ss
                    where ss.SUB= '{sub}' 
                ;   
                '''
    else:
        query = f'''Select  point_x1 as start_longitude, POINT_y1 as start_latitude, 
                        point_x2 as end_longitude, POINT_y2 as end_latitude,
                        ss.CTMT, ss.PAC_1, ss.PAC_2, SS.SUB
                    from sde.ssdmt ss
                    where ss.SUB= '{sub}' and ss.ctmt = '{ctmt}'
                ;   
                '''
    rows = return_query_as_dataframe(query, engine)
    # coordinates = [(row["longitude"], row["latitude"]) for index, row in rows.iterrows()]
    # color "red" utilizado para indicar problemas na rede como sobre tensões subtensões ou sobrecorrentes
    colour = ["blue", "green", "purple", "orange", "DarkOliveGreen", "Brown", "DarkCyan", "DarkKhaki",
              "SlateGray", "teal", "goldenrod", "chocolate", "darkred", "olivedrab", "aqua", "skyblue", "tan", "cyan",
              "violet", "silver", "indigo", "pink", "black"]

    # rows["cor"] = [np.random.choice(colour) for i in range(rows.shape[0])]
    # rows['cor'] = rows['CTMT'].groupby(rows['CTMT']).transform(lambda x: np.random.choice(colour))

    grupos_unicos = rows['CTMT'].unique()

    red = Color("red")
    blue = Color("blue")
    colour1 = list(red.range_to(blue, len(grupos_unicos)))
    # Convertendo a lista de objetos Color para uma lista de strings
    color_values = [str(color) for color in colour1]

    # Truncar a lista se for maior que o número de grupos
    valores_truncados = colour[:len(grupos_unicos)]
    # Criar um mapeamento de grupos para valores
    mapa_grupos = dict(zip(grupos_unicos, valores_truncados))
    rows['cor'] = rows['CTMT'].map(mapa_grupos)
    rows["nome"] = "segmentos"
    line_segments = [((row["start_longitude"], row["start_latitude"]), (row["end_longitude"], row["end_latitude"]),
                      row["PAC_2"], rows["CTMT"], rows["cor"][index], rows["nome"]) for index, row in rows.iterrows()]

    return line_segments


"""
# Função para conectar ao SQL Server e obter coordenadas da tabela PONNOT
def get_line_segments_from_db():
    query = f'''Select  pn_1.point_x as start_longitude, pn_1.POINT_Y as start_latitude, 
                        pn_2.point_x as end_longitude, pn_2.POINT_Y as end_latitude 
                from sde.ssdmt ss
                inner join sde.PONNOT pn_1
                    on ss.PN_CON_1 = pn_1.COD_ID
                inner join sde.PONNOT pn_2
                    on ss.PN_CON_2 = pn_2.COD_ID
                where ss.SUB='JNO' and ss.ctmt = 'RJNO1302'
                    ;   
                '''
    rows = return_query_as_dataframe(query)
    # coordinates = [(row["longitude"], row["latitude"]) for index, row in rows.iterrows()]

    line_segments = [((row["start_longitude"], row["start_latitude"]), (row["end_longitude"], row["end_latitude"]))
                     for index, row in rows.iterrows()]

    return line_segments
"""


def read_json_from_result(distribuidora, subestacao, circuito, scenario, tipo_dia, ano, mes, hora):
    import json
    path_flask_static = 'ui/static/scenarios/'

    if circuito.strip() == '':
        circuito = 'SUB_' + subestacao
        dados_combinados = {}
        path_json_file = os.path.join(parent, path_flask_static, scenario, distribuidora, subestacao, circuito,
                                      tipo_dia, ano, mes).replace('\\', '/')

        try:
            json_files = [pos_json for pos_json in os.listdir(path_json_file) if pos_json.endswith('.json')]

        except Exception as e:
            print(f"Resultados não encontrados: {path_json_file}. {e}")
            return None

        for index, js in enumerate(json_files):
            print(js)
            with open(os.path.join(path_json_file, js), 'r') as json_file:
                json_text = json.load(json_file)[hora-1]
                dados_combinados.update(json_text)
        return dados_combinados
    else:
        # Opening JSON file
        month = 1  # TODO mes da simulação anual. Por enquanto, sempre sera utilizado o mes 1
        if scenario.lower() == 'base':
            json_file = f"{circuito}.json"
        else:
            json_file = f"{circuito}_sc{month}.json"

        path_json_file = os.path.join(parent, path_flask_static, scenario, distribuidora, subestacao, circuito,
                                      tipo_dia, ano, mes, json_file).replace('\\', '/')
        print(path_json_file)
        try:
            f = open(path_json_file, 'r')
            result = json.load(f)[hora-1]
            # returns JSON object as a list
            return result
        except Exception as e:
            print(f"File not found: {path_json_file}. {e}")
            return None


# Função para criar GeoJSON a partir dos segmentos de retas
def create_geojson_from_segments(line_segments, json_data):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos

    # voltage_max = max(json_data.items(), key=lambda x: x[1])[1]
    # voltage_min = min(json_data.items(), key=lambda x: x[1])[1]

    # lines = [LineString([start, end]) for start, end in line_segments]
    lines = []
    cores = []
    colorByCircuit = []
    bus1 = []
    bus2 = []
    bus3 = []
    circ = []
    pac2 = []
    for start, end, pac, ctmt, cor, nome in line_segments:
        lines.append(LineString([start, end]))
        colorByCircuit.append(cor)
        if json_data is not None:
            voltage_bus1 = json_data.get(f"{pac}.1".lower())  # para testes - somente node=1
            voltage_bus2 = json_data.get(f"{pac}.2".lower())
            voltage_bus3 = json_data.get(f"{pac}.3".lower())
        else:
            voltage_bus1 = ''
            voltage_bus2 = ''
            voltage_bus3 = ''
        # color_intensity = (voltage_bus - voltage_min) / (voltage_max - voltage_min)
        # cores.append(str(Color(cor, luminance=f'{color_intensity}', equality=RGB_equivalence)))

        voltage_list = [item for item in [voltage_bus1, voltage_bus2, voltage_bus3] if
                        (item != '' and item is not None)]
        voltage_list_a = [float(item) for item in voltage_list]
        if any(overvoltage > 1.05 for overvoltage in voltage_list_a) or \
                any(undervoltage < 0.95 for undervoltage in voltage_list_a):
            cor = 'red'

        cores.append(cor)
        bus1.append(voltage_bus1)
        bus2.append(voltage_bus2)
        bus3.append(voltage_bus3)
        circ.append(ctmt)
        pac2.append(pac)
    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': lines, 'color': cores, 'colorbycircuit': colorByCircuit,
                            'ctmt': ctmt, 'bus1': bus1, 'bus2': bus2, 'bus3': bus3,
                            'tipo': nome, 'pac': pac2}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()

    return geojson


# Rota principal para visualizar o mapa
@server.route('/')
def index():
    return render_template('index.html')


@server.route('/api/SUB')
def sub():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    # circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    point_cr = get_coords_sub_from_db(subestacao)
    geojson = create_geojson_from_points_sub(point_cr)
    return geojson, 200, {'Content-Type': 'application/json'}


@server.route('/api/UNCRMT')
def crmt():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    point_cr = get_coords_uncrmt_from_db(subestacao, circuito)
    if not point_cr:
        return Response(status=404)
    geojson = create_geojson_from_points_uncrmt(point_cr)
    return geojson, 200, {'Content-Type': 'application/json'}


@server.route('/api/UNREMT')
def regu():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    point_regu = get_coords_unremt_from_db(subestacao, circuito)
    if not point_regu:
        return Response(status=404)  # HTTP response not found
    geojson = create_geojson_from_points_unremt(point_regu)
    return geojson, 200, {'Content-Type': 'application/json'}


@server.route('/api/UGMT')
def ugmt():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    point_ugmt = get_coords_ugmt_from_db(subestacao, circuito)
    if not point_ugmt:
        return Response(status=404)
    geojson = create_geojson_from_points_UGMT(point_ugmt)
    return geojson, 200, {'Content-Type': 'application/json'}


@server.route('/api/UCMT')
def ucmt():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    point_ucmt = get_coords_ucmt_from_db(subestacao, circuito)
    if not point_ucmt:
        return Response(status=404)
    geojson = create_geojson_from_points_UCMT(point_ucmt)
    return geojson, 200, {'Content-Type': 'application/json'}


@server.route('/api/UGBT')
def ugbt():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    point_ugbt = get_coords_ugbt_from_db(subestacao, circuito)
    if not point_ugbt:
        return Response(status=404)
    geojson = create_geojson_from_points_UGBT(point_ugbt)
    return geojson, 200, {'Content-Type': 'application/json'}


@server.route('/api/UCBT')
def ucbt():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    point_ucbt = get_coords_ucbt_from_db(subestacao, circuito)
    if not point_ucbt:
        return Response(status=404)
    geojson = create_geojson_from_points_UCBT(point_ucbt)
    return geojson, 200, {'Content-Type': 'application/json'}


@server.route('/api/UNSEMT')
def unsemt():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    point_unsemt = get_coords_unsemt_from_db(subestacao, circuito)
    geojson = create_geojson_from_points_UNSEMT(point_unsemt)
    return geojson, 200, {'Content-Type': 'application/json'}


@server.route('/api/trafos')
def trafos():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    point_trafos = get_coords_trafos_from_db(subestacao, circuito)
    geojson = create_geojson_from_points_trafos(point_trafos)
    return geojson, 200, {'Content-Type': 'application/json'}


# Função que busca os segmentos - circuitos
@server.route('/api/ssdat')
def ssdat():
    distribuidora = request.args.get('distribuidora', '')
    if distribuidora == '':
        mens = {'error': 'Select an Utility!'}
        print(f"{mens}")
        return mens, 500, {'Content-Type': 'application/json'}
    try:
        line_ssdat = get_coords_ssdat_from_db()
        geojson = create_geojson_from_points_SSDAT(line_ssdat)

        return geojson, 200, {'Content-Type': 'application/json'}
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@server.route('/api/subat')
def subat():
    distribuidora = request.args.get('distribuidora', '')
    if distribuidora == '':
        mens = {'error': 'Select an Utility!'}
        print(f"{mens}")
        return mens, 500, {'Content-Type': 'application/json'}
    try:
        pt_subs = get_coords_sub_from_db()
        geojson = create_geojson_from_points_sub(pt_subs)

        return geojson, 200, {'Content-Type': 'application/json'}
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@server.route('/api/gerador_at')
def gerador_at():
    distribuidora = request.args.get('distribuidora', '')
    if distribuidora == '':
        mens = {'error': 'Select an Utility!'}
        print(f"{mens}")
        return mens, 500, {'Content-Type': 'application/json'}
    try:
        pt_subs = get_coords_gerador_at_from_db()
        geojson = create_geojson_from_points_gerador_at(pt_subs)

        return geojson, 200, {'Content-Type': 'application/json'}
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# Função que busca os segmentos - circuitos
@server.route('/api/segments')
def segments():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito').strip()
    scenario = request.args.get('scenario', 'base')
    tipo_dia = request.args.get('tipo_dia', 'DU')
    ano = request.args.get('ano', 'defaultano')
    mes = request.args.get('mes', 'defaultmes')
    hora = int(request.args.get('hora', 'defaultmes'))

    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    line_segments = get_coords_SSDMT_from_db(subestacao, circuito)
    # Leitura do arquiso de resultados do fluxo de potencia
    json_data = read_json_from_result(distribuidora, subestacao, circuito, scenario, tipo_dia, ano, mes, hora)
    geojson = create_geojson_from_segments(line_segments, json_data)
    return geojson, 200, {'Content-Type': 'application/json'}


# Rota para visualizar o mapa com segmentos de reta
@server.route('/map')
def map_view():
    return render_template('map.html')


@server.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        if request.form['username'] != 'admin' or \
                request.form['password'] != 'admin':
            error = 'Invalid username or password. Please try again!'
        else:
            flash('You were successfully logged in')
            return redirect(url_for('index'))
    return render_template('login.html', error=error)


# Rota para listar os dados de uma tabela
@server.route('/list')
def list_table_view():
    return render_template('list.html')


# API para listar o conteúdo de uma tabela
@server.route('/api/list')
def api_list_table():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    id_summary = request.args.get('idSummary', '0')

    sumario = resumo.Summary(engine=engine, sub=subestacao, dist=distribuidora)
    table_data = get_table_data(sumario, id_summary)

    return jsonify(table_data), 200


def get_table_data(sumario, id_summary):
    df_summary = pd.DataFrame()
    if id_summary == '0':
        sumario.query_sumario_sub()
        print(sumario.summary_sub)
        df_summary = sumario.summary_sub
    elif id_summary == '1':
        sumario.query_sumario_trafos_at()
        sumario.query_summary_penetration()
        sub_at = pd.merge(sumario.summary_sub_at, sumario.summary_penetration, how='left', on='UNI_TR_AT')
        sub_at = sub_at.fillna(0)
        print(sub_at)
        df_summary = sub_at
    elif id_summary == '2':
        sumario.query_sumario_ctmt()
        print(sumario.max_demand_mt())
        df_summary = sumario.max_demand_mt()
    elif id_summary == '3':
        sumario.query_sumario_ctmt()
        print(sumario.max_energy_bt())
        df_summary = sumario.max_energy_bt()

    table_data = df_summary.to_dict(orient='records')
    return table_data


# leitura dos dados do arquivo GDB do SIN
@server.route('/get_data_at_UFV')
def get_data_at_UFV():
    my_gdb_sin = geo_tools.GeoDataSIN('sin_data.gdb', 'UFV___Base_Existente')
    return my_gdb_sin.read_gdb_ufv_to_json()


# leitura dos dados do arquivo GDB do SIN
@server.route('/get_data_at_EOL')
def get_data_at_EOL():
    my_gdb_sin = geo_tools.GeoDataSIN('sin_data.gdb', 'EOL___Base_Existente')
    return my_gdb_sin.read_gdb_eol_to_json()


# leitura dos dados do arquivo GDB do SIN
@server.route('/get_data_at_sub')
def get_data_at_sub():
    #my_gdb_sin = geo_tools.GeoDataSIN('subs_SIN.geojson')
    #return my_gdb_sin.read_geojson_subs()

    my_gdb_sin = geo_tools.GeoDataSIN('sin_data.gdb', 'Subestações___Base_Existente')
    return my_gdb_sin.read_gdb_sub_to_json()


# leitura dos dados do arquivo GDB do SIN
@server.route('/get_data_at')
def get_data_at():
    #my_gdb_sin = geo_tools.GeoDataSIN('Linhas_SIN.geojson')
    #return my_gdb_sin.read_geojson_line()

    my_gdb_sin = geo_tools.GeoDataSIN('sin_data.gdb', 'Linhas_de_Transmissão___Base_Existente')
    return my_gdb_sin.read_gdb_line_to_json()


def long_running_task():
    """Exemplo de método com prints que serão enviados ao cliente."""
    global task_running
    task_running = True
    print("Iniciando a tarefa...")
    run_dss_files_generators.main()

    print("Tarefa finalizada!")
    task_running = False


def generate_events():
    """Captura as mensagens de print e envia como eventos SSE."""
    buffer = io.StringIO()
    sys.stdout = buffer

    try:
        long_running_task()
    finally:
        sys.stdout = sys.__stdout__

    for line in buffer.getvalue().splitlines():
        yield f"data: {line}\n\n"
    buffer.close()


@server.route('/start-task', methods=['POST'])
def start_task():
    """Endpoint para iniciar a tarefa em uma thread separada."""
    global task_running
    if task_running:
        return jsonify({"message": "A tarefa já está em execução."}), 409

    thread = threading.Thread(target=long_running_task)
    thread.start()
    return jsonify({"message": "Tarefa iniciada com sucesso."}), 202


@server.route('/progress')
def progress():
    """Endpoint SSE que envia o progresso da tarefa."""
    return Response(generate_events(), content_type='text/event-stream')


# Rota para listar os dados de uma tabela
@server.route('/control_bus')
def control_bus():
    return render_template('control_bus.html')


@server.route('/list_scenarios')
def list_scenarios():
    root = 'static/scenarios'

    dir_list = os.listdir(root)

    print(dir_list)
    return jsonify(dir_list), 200


if __name__ == '__main__':
    server.run(use_reloader=False, debug=True)

    # Para rodar na linha de comando
    # C:\_BDGD2SQL\BDGD2SqlServer\venv\Scripts\activate.bat && python.exe C:\_BDGD2SQL\BDGD2SqlServer\ui\flask_app.py
