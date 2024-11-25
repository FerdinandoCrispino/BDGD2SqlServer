import os
import sys

import geopandas as gpd
import pandas as pd
from colour import Color

from flask import Flask, render_template, request, Response, url_for, redirect, jsonify
from flask import flash

from shapely.geometry import LineString, Point

import Tools.summary as resumo
from Tools.tools import return_query_as_dataframe, create_connection, load_config

sys.path.append('../')
# Configuração do Flask
app = Flask(__name__)
app.secret_key = "123456"


# Função para buscar as subestações com base na distribuidora
@app.route('/api/subestacoes/<distribuidora>', methods=['GET'])
def get_subestacoes(distribuidora):
    conf = load_config(distribuidora)
    global engine
    engine = create_connection(conf)
    query = f'''
            SELECT DISTINCT SUB FROM sde.CTMT WHERE dist ='{distribuidora}' 
            '''
    rows = return_query_as_dataframe(query, engine)
    subestacoes = rows.values.tolist()
    return jsonify(subestacoes)


# Função para buscar os circuitos com base na subestação
@app.route('/api/circuitos/<subestacao>', methods=['GET'])
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


def get_coords_sub_from_db(sub, ctmt):
    if ctmt == "":
        query = f'''Select POINT_X, POINT_Y, COD_ID, POS, NOME
                    from sde.SUB 
                    where COD_ID= '{sub}' 
                ;   
                '''
    else:
        query = f'''Select se.POINT_X, se.POINT_Y, se.COD_ID, se.POS, se.NOME, ct.COD_ID as CTMT
                    from sde.SUB se
                    inner join sde.CTMT ct on ct.SUB=se.COD_ID
                    where se.COD_ID= '{sub}' and ct.ctmt = '{ctmt}'
                ;   
                '''
    rows = return_query_as_dataframe(query, engine)
    rows["TIPO"] = "SUB"
    points = [((row["POINT_X"], row["POINT_Y"]), rows["COD_ID"], rows["POS"], rows["NOME"], rows["TIPO"])
              for index, row in rows.iterrows()]
    return points


def create_geojson_from_points_sub(points_sub):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos
    # lines = [LineString([start, end]) for start, end in line_segments]
    points = []
    #circ = []

    for pt, COD_ID, pos, nome, tipo in points_sub:
        points.append(Point([pt]))
        #circ.append(ctmt)

    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': points, 'sub': COD_ID, 'nome': nome, 'tipo': tipo}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()
    return geojson


def get_coords_ucmt_from_db(sub, ctmt):
    if ctmt == "":
        query = f'''Select POINT_X, POINT_Y, CTMT, SUB
                    from sde.UCMT 
                    where SUB= '{sub}' 
                ;   
                '''
    else:
        query = f'''Select POINT_X, POINT_Y, CTMT, SUB
                    from sde.UCMT
                    where SUB= '{sub}' and ctmt = '{ctmt}'
                ;   
                '''
    rows = return_query_as_dataframe(query, engine)
    rows["nome"] = "UCMT"
    points = [((row["POINT_X"], row["POINT_Y"]), rows["CTMT"], rows["nome"]) for index, row in rows.iterrows()]
    return points


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


def get_coords_tarfos_mt_from_db(sub, ctmt):
    if ctmt == "":
        query = f'''Select POINT_X, POINT_Y, CTMT, SUB
                    from sde.UNTRMT 
                    where SUB= '{sub}' 
                ;   
                '''
    else:
        query = f'''Select POINT_X, POINT_Y, CTMT, SUB
                    from sde.UNTRMT
                    where SUB= '{sub}' and ctmt = '{ctmt}'
                ;   
                '''
    rows = return_query_as_dataframe(query, engine)
    rows["nome"] = "trafos"
    points = [((row["POINT_X"], row["POINT_Y"]), rows["CTMT"], rows["nome"]) for index, row in rows.iterrows()]
    return points


def create_geojson_from_points_trafos(points_trafos):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos
    # lines = [LineString([start, end]) for start, end in line_segments]
    points = []
    circ = []

    for pt_trafo, ctmt, nome in points_trafos:
        points.append(Point([pt_trafo]))
        circ.append(ctmt)

    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': points, 'ctmt': ctmt, 'tipo': nome}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()
    return geojson


# Função para conectar ao SQL Server e obter coordenadas da tabela SSDMT
def get_coords_SSDMT_from_db(sub, ctmt):
    if ctmt == "":
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
    colour = ["blue", "green", "DarkKhaki", "purple", "orange", "DarkOliveGreen", "Brown", "DarkCyan", "pink"
                                                                                                       "SlateGray",
              "teal", "goldenrod", "chocolate", "darkred", "olivedrab", "aqua", "skyblue", "tan", "cyan"
                                                                                                  "violet", "silver",
              "indigo", "black"]

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


def read_json_from_result(distribuidora, subestacao, circuito):
    import json
    path_flask_static = 'static/scenarios/base'
    if circuito == '':
        dados_combinados = {}
        path_json_file = os.path.join(path_flask_static, distribuidora, subestacao)
        try:
            json_files = [pos_json for pos_json in os.listdir(path_json_file) if pos_json.endswith('.json')]
        except Exception as e:
            print(f"Resultados não encontrados: {path_json_file}. {e}")
            return None

        for index, js in enumerate(json_files):
            print(js)
            with open(os.path.join(path_json_file, js), 'r') as json_file:
                json_text = json.load(json_file)[12]
                dados_combinados.update(json_text)
        return dados_combinados
    else:
        # Opening JSON file
        json_file = f"{circuito}.json"
        path_json_file = os.path.join(path_flask_static, distribuidora, subestacao, json_file)
        print(path_json_file)
        try:
            f = open(path_json_file, 'r')
            result = json.load(f)[12]
            # returns JSON object as a list
            return result  # para testes será utilizado a hora 12
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
    bus = []
    circ = []
    for start, end, pac, ctmt, cor, nome in line_segments:
        lines.append(LineString([start, end]))
        if json_data is not None:
            voltage_bus = json_data.get(f"{pac}.1".lower())  # para testes - somente node=1
        else:
            voltage_bus = ''
        # color_intensity = (voltage_bus - voltage_min) / (voltage_max - voltage_min)
        # cores.append(str(Color(cor, luminance=f'{color_intensity}', equality=RGB_equivalence)))
        if voltage_bus != '' and voltage_bus is not None:
            if float(voltage_bus) > 1.05 or float(voltage_bus) < 0.95:
                cor = 'red'
        cores.append(cor)
        bus.append(voltage_bus)
        circ.append(ctmt)
    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': lines, 'color': cores, 'ctmt': ctmt, 'bus': bus, 'tipo': nome}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()

    return geojson


# Rota principal para visualizar o mapa
@app.route('/')
def index():
    return render_template('index.html')


@app.route('/api/SUB')
def sub():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    point_cr = get_coords_sub_from_db(subestacao, circuito)
    geojson = create_geojson_from_points_sub(point_cr)
    return geojson, 200, {'Content-Type': 'application/json'}


@app.route('/api/UNCRMT')
def crmt():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    point_cr = get_coords_from_db(subestacao, circuito, "UNCRMT")
    geojson = create_geojson_from_points_ucmt(point_cr)
    return geojson, 200, {'Content-Type': 'application/json'}


@app.route('/api/UNREMT')
def regu():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    point_regu = get_coords_from_db(subestacao, circuito, "UNREMT")
    if not point_regu:
        return Response(status=400)
    geojson = create_geojson_from_points_ucmt(point_regu)
    return geojson, 200, {'Content-Type': 'application/json'}


@app.route('/api/UGMT')
def ugmt():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    point_ugmt = get_coords_from_db(subestacao, circuito, "UGMT")
    geojson = create_geojson_from_points_ucmt(point_ugmt)
    return geojson, 200, {'Content-Type': 'application/json'}


@app.route('/api/UCMT')
def ucmt():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    point_ucmt = get_coords_from_db(subestacao, circuito, "UCMT")
    geojson = create_geojson_from_points_ucmt(point_ucmt)
    return geojson, 200, {'Content-Type': 'application/json'}


@app.route('/api/trafos')
def trafos():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    point_trafos = get_coords_from_db(subestacao, circuito, "UNTRMT")
    geojson = create_geojson_from_points_trafos(point_trafos)
    return geojson, 200, {'Content-Type': 'application/json'}


# Função que busca os segmentos de reta filtrados
@app.route('/api/segments')
def segments():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    if subestacao == '':
        print(f"Selecione uma subestação!")
        return None  # retornar erro!
    line_segments = get_coords_SSDMT_from_db(subestacao, circuito)
    # Leitura do arquiso de resultados do fluxo de potencia
    json_data = read_json_from_result(distribuidora, subestacao, circuito)
    geojson = create_geojson_from_segments(line_segments, json_data)
    return geojson, 200, {'Content-Type': 'application/json'}


# Rota para visualizar o mapa com segmentos de reta
@app.route('/map')
def map_view():
    return render_template('map.html')


@app.route('/login', methods=['GET', 'POST'])
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
@app.route('/list')
def list_table_view():
    return render_template('list.html')


# API para listar o conteúdo de uma tabela
@app.route('/api/list')
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


if __name__ == '__main__':
    app.run(use_reloader=False, debug=True)
