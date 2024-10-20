import os
import sys

import geopandas as gpd
import pandas as pd
from colour import Color
from flask import Flask, render_template, jsonify, request
from shapely.geometry import LineString

import Tools.summary as resumo
from Tools.tools import return_query_as_dataframe, create_connection, load_config

sys.path.append('../')
# Configuração do Flask
app = Flask(__name__)


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


# Função para conectar ao SQL Server e obter coordenadas da tabela SSDMT
def get_coords_SSDMT_from_db(sub, ctmt):
    if ctmt == "":
        query = f'''Select  point_x1 as start_longitude, POINT_y1 as start_latitude, 
                            point_x2 as end_longitude, POINT_y2 as end_latitude,
                            ss.CTMT, ss.PAC_1, ss.PAC_2
                            from sde.ssdmt ss
                            where ss.SUB= '{sub}' 
                ;   
                '''
    else:
        query = f'''Select  point_x1 as start_longitude, POINT_y1 as start_latitude, 
                            point_x2 as end_longitude, POINT_y2 as end_latitude,
                            ss.CTMT, ss.PAC_1, ss.PAC_2
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

    line_segments = [((row["start_longitude"], row["start_latitude"]), (row["end_longitude"], row["end_latitude"]),
                      row["PAC_2"], rows["CTMT"], rows["cor"][index]) for index, row in rows.iterrows()]

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
    for start, end, pac, ctmt, cor in line_segments:
        lines.append(LineString([start, end]))
        if json_data is not None:
            voltage_bus = json_data.get(f"{pac}.1".lower())  # para testes - somente node=1
        else:
            voltage_bus = ''
        # color_intensity = (voltage_bus - voltage_min) / (voltage_max - voltage_min)
        # cores.append(str(Color(cor, luminance=f'{color_intensity}', equality=RGB_equivalence)))
        if voltage_bus != '':
            if float(voltage_bus) > 1.05 or float(voltage_bus) < 0.95:
                cor = 'red'
        cores.append(cor)
        bus.append(voltage_bus)
        circ.append(ctmt)
    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': lines, 'color': cores, 'ctmt': ctmt, 'bus': bus}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()

    return geojson


# Rota principal para visualizar o mapa
@app.route('/')
def index():
    return render_template('index.html')


# Função que busca os segmentos de reta filtrados
@app.route('/api/segments')
def segments():
    distribuidora = request.args.get('distribuidora', 'defaultDistribuidora')
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')

    line_segments = get_coords_SSDMT_from_db(subestacao, circuito)
    # Leitura do arquiso de resultados do fluxo de potencia
    json_data = read_json_from_result(distribuidora, subestacao, circuito)
    geojson = create_geojson_from_segments(line_segments, json_data)
    return geojson, 200, {'Content-Type': 'application/json'}


# Rota para visualizar o mapa com segmentos de reta
@app.route('/map')
def map_view():
    return render_template('map.html')


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

    res = resumo.Summary(engine=engine, sub=subestacao, dist=distribuidora)
    table_data = get_table_data(res, id_summary)

    return jsonify(table_data), 200


def get_table_data(res, id_summary):
    df_summary = pd.DataFrame()
    if id_summary == '0':
        res.query_sumario_sub()
        print(res.summary_sub)
        df_summary = res.summary_sub
    elif id_summary == '1':
        res.query_sumario_trafos_at()
        df_summary = res.summary_sub_at
    elif id_summary == '2':
        res.query_sumario_ctmt()
        df_summary = res.max_demand_mt()
    elif id_summary == '3':
        res.query_sumario_ctmt()
        df_summary = res.max_energy_bt()

    table_data = df_summary.to_dict(orient='records')
    return table_data


if __name__ == '__main__':
    app.run(debug=True)
