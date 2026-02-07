import os
import sys

import geopandas as gpd
import pandas as pd
import numpy as np

from colour import Color
from flask import Flask, render_template, request, Response, url_for, redirect, jsonify
from flask import flash
from shapely.geometry import LineString, Point

import geo_tools
import io
import threading
from pathlib import Path
from datetime import datetime

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)

# execução da geração dos arquivos DSS pelo navegador.
import core.electric_data as run_dss_files_generators
import Tools.summary as resumo
from Tools.tools import return_query_as_dataframe, create_connection, load_config, \
    load_config_list_dist, list_states_curtail, list_years_curtail, rel_usina_conjunto

pd.options.mode.copy_on_write = True
task_running = False  # Variável para evitar múltiplas execuções simultâneas -- control_bus

sys.path.append('../')
# Configuração do Flask
server = Flask(__name__)
server.secret_key = "123456"

SIN_DATA_GDB = 'EPE_SIN_data.gdb'

# Caminho para o arquivo Geodatabase
GDB_PATH = os.path.join(os.path.dirname(__file__), 'data', SIN_DATA_GDB)


# request data for usianas selected into map
@server.route('/usinas_data')
def read_data_usinas():
    ceg = request.args.get('ceg')
    src = request.args.get('source')
    mes = request.args.get('mes')
    ano = request.args.get('ano')
    dia = request.args.get('dia')
    if dia in ['null', '', 'undefined']:
        dia = None

    # Caminho absoluto do arquivo atual
    current_file = Path(__file__).resolve()
    # Caminho da raiz do projeto (2 níveis acima do arquivo atual, ajuste se necessário)
    project_root = current_file.parents[1]  # se __file__ está em ui/, volta para BDGD2SqlServer
    path_result = project_root / 'ui' / 'curtailment'

    # path_result = os.path.abspath('curtailment')
    path_conf = os.path.join(path_result, "USINAS")

    try:
        # Leitura do arquivo de RELACIONAMENTO_USINA_CONJUNTO
        # file_name_rel = f'RELACIONAMENTO_USINA_CONJUNTO.parquet'
        # df_rel = pd.read_parquet(os.path.join(path_result, file_name_rel), filters=[('ceg', '==', f'{ceg}')])
        df_rel = rel_usina_conjunto(engine, ceg)

        file_name = f'GERACAO_USINA-2_{ano}_{mes}.parquet'

        if src in ["UHE", "CGH", "PCH"]:
            tipo = 'HIDROELÉTRICA'
        elif src in ["UTE"]:
            tipo = 'TÉRMICA'
        else:
            raise ValueError("source not find!")

        df_usinas = pd.read_parquet(os.path.join(path_conf, file_name), filters=[('nom_tipousina', '==', f'{tipo}')])
        df_usinas = df_usinas[df_usinas.ceg == ceg]
        # if df_usinas.empty:
        #    df_usinas_fill = df_usinas[df_usinas['id_ons'].astype(str).str.contains(df_rel['id_ons_conjunto'].iloc[0])]
        if dia is not None:
            df_usinas = df_usinas[df_usinas['din_instante'].dt.day == int(dia)]

        df_fill = df_usinas.fillna(0)

        df_usinas = df_usinas[['din_instante', 'val_geracao', 'nom_usina', 'id_ons', 'ceg']].copy()
        data = df_usinas.values.tolist()
        return jsonify(data)
    except Exception as e:
        print(f'Error with fife {file_name} - {e}')
        return jsonify({"error": str(e)}), 500


# request data for curtailment and capacity factor to UFV and EOL
@server.route('/curt_data')
def read_data_curt():
    ceg = request.args.get('ceg')
    src = request.args.get('source')
    mes = request.args.get('mes')
    ano = request.args.get('ano')
    dia = request.args.get('dia', None)

    if dia in ['null', '']:
        dia = None

    # Caminho absoluto do arquivo atual
    current_file = Path(__file__).resolve()
    # Caminho da raiz do projeto (2 níveis acima do arquivo atual, ajuste se necessário)
    project_root = current_file.parents[1]  # se __file__ está em ui/, volta para BDGD2SqlServer
    path_result = project_root / 'ui' / 'curtailment'

    #path_result = os.path.abspath('curtailment')
    path_conf = os.path.join(path_result, src)

    if src == "UFV":
        file_name = f'RESTRICAO_COFF_FOTOVOLTAICA_{ano}_{mes}.parquet'
    elif src == "EOL":
        file_name = f'RESTRICAO_COFF_EOLICA_{ano}_{mes}.parquet'

    try:
        # Leitura do arquivo de RELACIONAMENTO_USINA_CONJUNTO
        #file_name_rel = f'RELACIONAMENTO_USINA_CONJUNTO.parquet'
        #df_rel = pd.read_parquet(os.path.join(path_result, file_name_rel), filters=[('ceg', '==', f'{ceg}')])
        #df_rel.sort_values(by='dat_iniciorelacionamento', ascending=False, inplace=True)
        df_rel = rel_usina_conjunto(engine, ceg)

        # Leitura do arquivo das restrições das usinas EOL ou UFV
        df = pd.read_parquet(os.path.join(path_conf, file_name))
        df_fill = df[df.ceg == ceg]

        if df_fill.empty:
            # df_fc_fill = df_fc[df_fc.id_ons == df['id_ons'].iloc[0]]
            df_fill = df[df['id_ons'].astype(str).str.contains(df_rel['id_ons_conjunto'].iloc[0])]

        if not df_fill.empty:
            df_fill['curt'] = np.where(
                df_fill.loc[:, 'val_geracaoreferencia'] - df_fill.loc[:, 'val_geracaolimitada'] > 0,
                (df_fill.loc[:, 'val_geracaoreferencia'] - df_fill.loc[:, 'val_geracaolimitada']), 0)

            df_fill = df_fill[['din_instante', 'val_geracao', 'curt', 'val_geracaoreferencia', 'val_disponibilidade',
                               'val_geracaolimitada', 'id_ons', 'cod_razaorestricao', 'cod_origemrestricao']].copy()
            # Filter for workdays (Monday=0 to Friday=4)
            # df_workdays = df[df['Date'].dt.weekday < 5]
            if dia is not None:
                df_fill = df_fill[df_fill['din_instante'].dt.day == int(dia)]

            df_fill = df_fill.fillna(0)

        data = df_fill.values.tolist()

        # Leitura do arquivo do fator de capacidade dos empreendiemntos
        file_name_fc = f'FATOR_CAPACIDADE-2_{ano}_{mes}.parquet'

        df_fc = pd.read_parquet(os.path.join(path_result, file_name_fc))
        df_fc_fill = df_fc[df_fc.ceg == ceg]

        if df_fc_fill.empty:
            # df_fc_fill = df_fc[df_fc.id_ons == df['id_ons'].iloc[0]]
            df_fc_fill = df_fc[df_fc['id_ons'].astype(str).str.contains(df_rel['id_ons_conjunto'].iloc[0])]

        if not df_fc_fill.empty:
            df_fc_fill = df_fc_fill[['din_instante', 'val_fatorcapacidade', 'nom_usina_conjunto']].copy()
            # 'errors='coerce'' will turn non-convertible values into NaN (Not a Number)
            df_fc_fill['val_fatorcapacidade'] = pd.to_numeric(df_fc_fill['val_fatorcapacidade'], errors='coerce')

        if dia is not None:
            df_fc_fill = df_fc_fill[df_fc_fill['din_instante'].dt.day == int(dia)]

        data2 = df_fc_fill.values.tolist()
        data = [data, data2]

        return jsonify(data)
    except Exception as e:
        print(f'Error with fife {file_name} - {e}')
        return jsonify({"error": str(e)}), 500


# request data for curtailment e capacity factor to UFV and EOL
@server.route('/curt_data_detail')
def read_data_curt_datail():
    ceg = request.args.get('ceg')
    src = request.args.get('source')
    mes = request.args.get('mes')
    ano = request.args.get('ano')
    dia = request.args.get('dia', None)

    if dia in ['null', '']:
        dia = None

    # Caminho absoluto do arquivo atual
    current_file = Path(__file__).resolve()
    # Caminho da raiz do projeto (2 níveis acima do arquivo atual, ajuste se necessário)
    project_root = current_file.parents[1]  # se __file__ está em ui/, volta para BDGD2SqlServer
    path_result = project_root / 'ui' / 'curtailment'

    # path_result = os.path.abspath('curtailment')
    path_conf = os.path.join(path_result, src)

    if src == "UFV":
        file_name = f'RESTRICAO_COFF_FOTOVOLTAICA_DETAIL_{ano}_{mes}.parquet'
        flag_column_mane = 'flg_dadoirradianciainvalido'

    elif src == "EOL":
        file_name = f'RESTRICAO_COFF_EOLICA_DETAIL_{ano}_{mes}.parquet'
        flag_column_mane = 'flg_dadoventoinvalido'

    try:
        df = pd.read_parquet(os.path.join(path_conf, file_name))
        df = df[df.ceg == ceg]
        df.rename(columns={flag_column_mane: 'flg_dado_invalido'}, inplace=True)
        # O dado é considerado inválido (flag = 1) e será atribuido 0 para o valor do coff
        df["coff"] = np.where((df["val_geracaoestimada"] - df["val_geracaoverificada"] < 0)
                              | (df['flg_dado_invalido']), 0,
                              (df["val_geracaoestimada"] - df["val_geracaoverificada"]))

        df = df[['din_instante', 'val_geracaoverificada', 'coff', 'id_ons']].copy()

        # Filter for workdays (Monday=0 to Friday=4)
        # df_workdays = df[df['Date'].dt.weekday < 5]
        if dia is not None:
            df = df[df['din_instante'].dt.day == int(dia)]

        data = df.values.tolist()

        # Leitura do arquivo de RELACIONAMENTO_USINA_CONJUNTO
        # file_name_rel = f'RELACIONAMENTO_USINA_CONJUNTO.parquet'
        # df_rel = pd.read_parquet(os.path.join(path_result, file_name_rel), filters=[('ceg', '==', f'{ceg}')])
        df_rel = rel_usina_conjunto(engine, ceg)

        # Leitura do arquivo do fator de capacidade dos empreendiemntos
        file_name_fc = f'FATOR_CAPACIDADE-2_{ano}_{mes}.parquet'

        df_fc = pd.read_parquet(os.path.join(path_result, file_name_fc))
        df_fc_fill = df_fc[df_fc.ceg == ceg]

        if df_fc_fill.empty:
            # df_fc_fill = df_fc[df_fc.id_ons == df['id_ons'].iloc[0]]
            df_fc_fill = df_fc[df_fc['id_ons'].astype(str).str.contains(df_rel['id_ons_conjunto'].iloc[0])]

        if not df_fc_fill.empty:
            df_fc_fill = df_fc_fill[['din_instante', 'val_fatorcapacidade', 'nom_usina_conjunto']].copy()
            # 'errors='coerce'' will turn non-convertible values into NaN (Not a Number)
            df_fc_fill['val_fatorcapacidade'] = pd.to_numeric(df_fc_fill['val_fatorcapacidade'], errors='coerce')

        if dia is not None:
            df_fc_fill = df_fc_fill[df_fc_fill['din_instante'].dt.day == int(dia)]

        data2 = df_fc_fill.values.tolist()
        data = [data, data2]

        return jsonify(data)
    except Exception as e:
        print(f'Error with fife {file_name} - {e}')
        return jsonify({"error": str(e)}), 500


@server.route('/z_data')
def read_surface_data():
    distribuidora = request.args.get('distribuidora')
    subestacao = request.args.get('subestacao')
    scenario = request.args.get('scenario', 'base')
    circuito = request.args.get('circuito')
    tipo_dia = request.args.get('tipo_dia')
    mes = request.args.get('mes')
    ano = request.args.get('ano')
    type_case = request.args.get('type_case')

    if not circuito:
        circuito = f'SUB_{subestacao}'

    # Caminho absoluto do arquivo atual
    current_file = Path(__file__).resolve()
    # Caminho da raiz do projeto (2 níveis acima do arquivo atual, ajuste se necessário)
    project_root = current_file.parents[1]  # se __file__ está em ui/, volta para BDGD2SqlServer
    path_conf = project_root / 'ui' / 'static' / 'scenarios' / scenario / str(distribuidora) / subestacao / circuito / tipo_dia / ano / mes

    #path_conf = os.path.abspath(
    #    f'static/scenarios/{scenario}/{str(distribuidora)}/{subestacao}/{circuito}/{tipo_dia}/{ano}/{mes}')

    if not distribuidora:
        print(f'Selecione uma distribuidora')
        return jsonify("error Selecione uma distribuidora"), 404

    files = []
    if type_case == 'case1':
        file = f'{ano}_{tipo_dia}_{mes}_{circuito}_VminVmax.csv'
    elif type_case == 'case2':
        file = f'{ano}_{tipo_dia}_{mes}_{circuito}_Vmin.csv'
    elif type_case == 'case3':
        file = f'{ano}_{tipo_dia}_{mes}_{circuito}_Vmax.csv'

    elif type_case in ('PF_Losses', 'PF_RPF', 'Power Transformer Loading'):
        path_dir_base = 'PF Study Scenario'
        files = [f'{path_dir_base}/{ano}_{tipo_dia}_{mes}_{circuito}_0.9.csv',
                 f'{path_dir_base}/{ano}_{tipo_dia}_{mes}_{circuito}_-0.9.csv',
                 f'{path_dir_base}/{ano}_{tipo_dia}_{mes}_{circuito}_0.95.csv',
                 f'{path_dir_base}/{ano}_{tipo_dia}_{mes}_{circuito}_-0.95.csv',
                 f'{path_dir_base}/{ano}_{tipo_dia}_{mes}_{circuito}_1.0.csv']

    elif type_case in ('BESS_Losses', 'BESS_RPF'):
        path_dir_base = 'BESS Study Scenario'
        files = [f'{path_dir_base}/{ano}_{tipo_dia}_{mes}_{circuito}_5_5.csv',
                 f'{path_dir_base}/{ano}_{tipo_dia}_{mes}_{circuito}_6_4.csv',
                 f'{path_dir_base}/{ano}_{tipo_dia}_{mes}_{circuito}_7_3.csv',
                 f'{path_dir_base}/{ano}_{tipo_dia}_{mes}_{circuito}_9_1.csv']

    try:
        if len(files) > 0:
            all_data = []
            medium_data = []
            for file in files:
                df = pd.read_csv(os.path.join(path_conf, file), na_filter=False)
                df_medium_data = df.groupby("Pen")[
                    ["Energy Losses", "Min Fluxo Subestacao", "B VminVmax", "Max_Cargamento_Trafo_pct"]].median().reset_index()
                data_medium = df_medium_data.values.tolist()
                data = df.values.tolist()
                all_data.append(data)
                medium_data.append(data_medium)

            # acrescenta a lista com os valores das medianas.
            all_data.append(medium_data)
            return jsonify(all_data)

        df = pd.read_csv(os.path.join(path_conf, file), header=None, na_filter=False)
        data = df.values.tolist()
        # print(data)
        return jsonify(data)
    except Exception as e:
        print(f'Error with fife {file}')
        return jsonify({"error": str(e)}), 500


# dados para os filtros do curtailment
SOURCES = ['WIND', 'SOLAR']
#TODO selecionar dados de estados do banco de dados
ESTADOS = ['All', 'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MS', 'MT', 'MG', 'PA', 'PB', 'PR',
           'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO']
conf = load_config('curtailment')
engine = create_connection(conf)
ESTADOS = list_states_curtail(engine=engine)
ESTADOS.append('All')
# ESTADOS.insert(0, 'All')  # primeira posição

ANOS = [2025, 2024]
ANOS = list_years_curtail(engine=engine)

MESES = list(range(1, 13))
MESES.insert(0, 'All')
DIAS = list(range(1, 29))
DIAS.insert(0, 'All')


@server.route('/dashcurtailment')
def render_dashcurtailment():
    return render_template('dashcurtailment.html', estados=ESTADOS, anos=ANOS, sources=SOURCES)


@server.route("/get_date_options", methods=["POST"])
def get_date_options():
    ano = int(request.json.get("ano", datetime.now().year))
    return jsonify({"meses": MESES, "dias": DIAS, "sources": SOURCES})


@server.route("/get_data", methods=["POST"])
def get_data():
    source = request.json.get("source", "wind")
    estado = request.json.get("estado")
    ano = request.json.get("ano")
    mes = request.json.get("mes")

    query_estado = ''
    if estado != 'All':
        query_estado = f" and id_estado = '{estado}'"
    query_mes = ''
    if mes != 'All':
        query_mes = f" and MONTH(din_instante) = '{mes}'"

    try:
        conf = load_config('curtailment')
        engine = create_connection(conf)

        query = f'''
                SELECT din_instante, id_estado,  nom_usina, cod_razaorestricao,  val_geracaoreferencia , 
                val_geracaolimitada, geracaoReal, GeracaoCortada
                    FROM [DBONS].[dbo].[{source}_CURTAILMENT]      
                    WHERE YEAR(din_instante) = {ano} {query_estado} {query_mes}
                    and cod_razaorestricao not in ('nan', '')
                '''
        rows = return_query_as_dataframe(query, engine)
        if rows.empty:
            raise ValueError("No data found in the specified source.")

        rows = rows.fillna(0)
        # Create a new column based on a condition (like CASE WHEN)
        # rows['curt'] = np.where(rows['val_geracaoreferencia'] - rows['val_geracaolimitada'] > 0,
        #                        (rows['val_geracaoreferencia'] - rows['val_geracaolimitada']) / 2000, 0)
        rows['curt'] = rows['GeracaoCortada']
        # Copy columns to a new DataFrame
        coff_usinas = rows[['nom_usina', 'cod_razaorestricao', 'curt']].copy()
        # Group by power plant
        coff_usinas = coff_usinas.groupby(['nom_usina', 'cod_razaorestricao'])['curt'].sum().reset_index()
        # PIVOT table from cod_razaorestricao
        coff_usinas = coff_usinas.pivot(index='nom_usina', columns='cod_razaorestricao', values='curt')
        coff_usinas = coff_usinas.fillna(0)
        # sort values
        # coff_usinas['row_sum'] = coff_usinas.sum(axis=1)
        # coff_usinas = coff_usinas.sort_values(by='row_sum', ascending=False)  # For descending order
        coff_usinas = coff_usinas.reset_index()

        # Curtailment Rate (%) = (Curtailment Energy / Total Potential Generation) x 100
        curt_total_all_plant = rows['curt'].sum()
        energy_max_all_plant = rows['val_geracaoreferencia'].sum() / 2000
        coff_ratio = rows[['nom_usina', 'curt']].copy()
        coff_ratio = coff_ratio.groupby(['nom_usina', ])['curt'].sum().reset_index()
        # Curtailment Rate (%)
        coff_ratio['coff_ratio'] = (coff_ratio['curt'] / (curt_total_all_plant + energy_max_all_plant)) * 100
        coff_ratio = coff_ratio.sort_values(by='coff_ratio', ascending=False)

        # Copy columns to a new DataFrame
        coff_estado = rows[['id_estado', 'cod_razaorestricao', 'curt']].copy()
        # Group by state
        coff_estado = coff_estado.groupby(['id_estado', 'cod_razaorestricao'])['curt'].sum().reset_index()
        coff_estado = coff_estado.pivot(index='id_estado', columns='cod_razaorestricao', values='curt')
        coff_estado = coff_estado.fillna(0)

        coff_estado['row_sum'] = coff_estado.sum(axis=1)
        coff_estado = coff_estado.sort_values(by='row_sum', ascending=True)  # For descending order
        coff_estado = coff_estado.reset_index()

        # Copy columns to a new DataFrame
        coff_mes = rows[['din_instante', 'cod_razaorestricao', 'curt']].copy()
        coff_mes['mes'] = coff_mes['din_instante'].dt.month
        coff_mes['mes_abr'] = coff_mes['din_instante'].dt.month_name().str[:3]
        coff_mes = coff_mes[['mes_abr', 'mes', 'cod_razaorestricao', 'curt']]
        # Group by state
        coff_mes = coff_mes.groupby(['mes_abr', 'mes', 'cod_razaorestricao'])['curt'].sum().reset_index()
        coff_mes = coff_mes.pivot(index=['mes_abr', 'mes'], columns='cod_razaorestricao', values='curt')
        coff_mes = coff_mes.fillna(0)
        coff_mes = coff_mes.reset_index()
        coff_mes = coff_mes.sort_values(by='mes', ascending=True)

        # Copy columns to a new DataFrame
        coff_dia = rows[['din_instante', 'cod_razaorestricao', 'curt']].copy()
        coff_dia['dia'] = coff_dia['din_instante'].dt.day_name()
        coff_dia['ndia'] = coff_dia['din_instante'].dt.weekday
        coff_dia = coff_dia[['ndia', 'dia', 'cod_razaorestricao', 'curt']]
        # Group by state
        coff_dia = coff_dia.groupby(['ndia', 'dia', 'cod_razaorestricao'])['curt'].sum().reset_index()
        coff_dia = coff_dia.pivot(index=['ndia', 'dia'], columns='cod_razaorestricao', values='curt')
        coff_dia = coff_dia.fillna(0)
        coff_dia = coff_dia.reset_index()
        coff_dia = coff_dia.sort_values(by='ndia', ascending=True)

        # Copy columns to a new DataFrame
        coff_hour = rows[['din_instante', 'cod_razaorestricao', 'curt']].copy()
        coff_hour['hour'] = coff_hour['din_instante'].dt.hour

        coff_hour = coff_hour[['hour', 'cod_razaorestricao', 'curt']]
        # Group by state
        coff_hour = coff_hour.groupby(['hour', 'cod_razaorestricao'])['curt'].sum().reset_index()
        coff_hour = coff_hour.pivot(index=['hour'], columns='cod_razaorestricao', values='curt')
        coff_hour = coff_hour.fillna(0)
        coff_hour = coff_hour.reset_index()
        coff_hour = coff_hour.sort_values(by='hour', ascending=True)

        """
        query = f'''
                    SELECT nom_usina, cod_razaorestricao,  
                    SUM(CASE 
                                WHEN ([val_disponibilidade] - [val_geracao]) > 0 
                                THEN ([val_disponibilidade] - [val_geracao]) 
                                ELSE 0 
                            END
                        )/2000 AS curt
                    FROM [DBONS].[dbo].[CURTAILMENT]      
                    where YEAR(din_instante) ='{ano}' and cod_razaorestricao not in ('nan', '')
                    group by nom_usina, cod_razaorestricao
                    order by  nom_usina
                '''
        rows = return_query_as_dataframe(query, engine)
        rows = rows.fillna(0)
        # pivoted_table = rows.pivot_table(index='nom_usina', columns='cod_razaorestricao', values='curt', aggfunc=None)
        coff_usinas = rows.pivot(index='nom_usina', columns='cod_razaorestricao', values='curt')
        coff_usinas = coff_usinas.fillna(0)
        coff_usinas = coff_usinas.reset_index()
        
        query = f'''
                    SELECT id_estado,  cod_razaorestricao,  
                        SUM(CASE 
                                WHEN ([val_disponibilidade] - [val_geracao]) > 0 
                                THEN ([val_disponibilidade] - [val_geracao]) 
                                ELSE 0 
                            END
                        )/2000 AS curt
                    FROM [DBONS].[dbo].[CURTAILMENT]      
                    WHERE YEAR(din_instante) = {ano} and cod_razaorestricao not in ('nan', '')
                    GROUP BY id_estado, cod_razaorestricao
                    ORDER BY id_estado, cod_razaorestricao;
                '''
        rows = return_query_as_dataframe(query, engine)
        rows = rows.fillna(0)
        coff_estado = rows.pivot(index='id_estado', columns='cod_razaorestricao', values='curt')
        coff_estado = coff_estado.fillna(0)
        coff_estado = coff_estado.reset_index()

        query = f'''
                    SELECT  MONTH(din_instante) mes, cod_razaorestricao,  
                        SUM(CASE 
                                WHEN ([val_disponibilidade] - [val_geracao]) > 0 
                                THEN ([val_disponibilidade] - [val_geracao]) 
                                ELSE 0 
                            END
                        )/2000 AS curt
                    FROM [DBONS].[dbo].[CURTAILMENT]      
                    where YEAR(din_instante) = {ano} and cod_razaorestricao not in ('nan', '')
                    group by MONTH(din_instante), cod_razaorestricao
                    order by MONTH(din_instante), cod_razaorestricao;
                '''
        rows = return_query_as_dataframe(query, engine)
        rows = rows.fillna(0)
        coff_mes = rows.pivot(index='mes', columns='cod_razaorestricao', values='curt')
        coff_mes = coff_mes.fillna(0)
        coff_mes = coff_mes.reset_index()
        """
        charts = []
        for i in range(6):
            if i == 0:
                x = coff_usinas['nom_usina']
                y1 = coff_usinas['CNF']
                y2 = coff_usinas['ENE']
                y3 = coff_usinas['REL']
            elif i == 1:
                x = coff_ratio['nom_usina']
                y1 = coff_ratio['coff_ratio']
                y2 = pd.Series([])
                y3 = pd.Series([])
            elif i == 2:
                x = coff_estado['id_estado']
                y1 = coff_estado['CNF']
                y2 = coff_estado['ENE']
                y3 = coff_estado['REL']
            elif i == 3:
                x = coff_mes['mes_abr']
                y1 = coff_mes['CNF']
                y2 = coff_mes['ENE']
                y3 = coff_mes['REL']
            elif i == 4:
                x = coff_dia['dia']
                y1 = coff_dia['CNF']
                y2 = coff_dia['ENE']
                y3 = coff_dia['REL']
            elif i == 5:
                x = coff_hour['hour']
                y1 = coff_hour['CNF']
                y2 = coff_hour['ENE']
                y3 = coff_hour['REL']

            charts.append({"x": x.tolist(), "y1": y1.tolist(), "y2": y2.tolist(), "y3": y3.tolist()})
        return jsonify(charts)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@server.route('/dashboard')
def render_dashboard():
    dist = request.args.get('codigoDistribuidora')
    print(dist)
    return render_template('dash1.html', dist=dist)


@server.route('/daily_power_circuit')
def daily_power_circuit():
    distribuidora = request.args.get('distribuidora')
    subestacao = request.args.get('subestacao')
    circuito = request.args.get('circuito')
    scenario = request.args.get('scenario', 'base')
    # tipo_dia = request.args.get('tipo_dia')  # Não necessario. Será criado gráfico comparativo entre DO e DU
    mes = request.args.get('mes')
    ano = request.args.get('ano')
    print(f'route data: {distribuidora} {subestacao}')

    list_data = []
    list_data_dict = dict()
    tipo_dia = ''

    # Caminho absoluto do arquivo atual
    current_file = Path(__file__).resolve()
    # Caminho da raiz do projeto
    project_root = current_file.parents[1]  # se __file__ está em ui/, volta para BDGD2SqlServer
    # Caminho fixo para static/scenarios
    path_conf_teste = project_root / 'ui' / 'static' / 'scenarios' / scenario / conf['dist'] / subestacao

    path_conf = os.path.join(os.path.dirname(__file__), 'static/scenarios', scenario, conf['dist'], subestacao).replace(
        '\\', '/')

    if not distribuidora:
        print(f'Select a utility!')
        return jsonify("Error: Select a utility"), 404

    if circuito:
        path_conf = os.path.join(path_conf, circuito)

    file_results = [f'DO_{ano}_{mes}_all_power.xlsx', f'DU_{ano}_{mes}_all_power.xlsx']
    for root, dirs, files in os.walk(path_conf):
        for file in files:
            if file.endswith(tuple(file_results)) and not (file.startswith('~') or file.startswith('.')):
                print(root)
                print(file)
                if 'DO_' in file:
                    tipo_dia = 'DO'
                else:
                    tipo_dia = 'DU'

                try:
                    df = pd.read_excel(os.path.join(root, file))
                    print(df)
                    df_data = df[['SUB', 'circuit', 'P1', 'P2', 'P3']].copy()
                    df_data['P'] = df_data['P1'] + df_data['P2'] + df_data['P3']
                    df_data['TIME'] = df_data.index
                    label_time = df_data['TIME'].values.tolist()
                    data_list = df_data['P'].values.tolist()

                    list_data_dict = {'values': data_list, 'ctmt': str(df_data['circuit'][0]), 'time': label_time,
                                      'sub': df_data['SUB'][0], 'tipo_dia': tipo_dia}

                    list_data.append(list_data_dict.copy())

                except Exception as e:
                    print(f'Error with fife {root}/{file}')
                    return jsonify({"error": str(e)}), 500

    if not list_data:
        print(f'Dados inexistentes {path_conf}')
        return jsonify("error Dados inexistentes"), 404

    list_data = sorted(list_data, key=lambda x: (x['tipo_dia'], x['ctmt']))
    return jsonify(list_data)


@server.route('/dash_losses')
def dash_losses():
    return render_template('dash_losses.html')


@server.route('/data_losses')
def render_data_losses():
    distribuidora = request.args.get('distribuidora')
    subestacao = request.args.get('subestacao')
    circuito = request.args.get('circuito')
    scenario = request.args.get('scenario', 'base')
    tipo_dia = request.args.get('tipo_dia')
    ano = request.args.get('ano')
    mes = request.args.get('mes')

    list_data = []

    # Caminho absoluto do arquivo atual
    current_file = Path(__file__).resolve()
    # Caminho da raiz do projeto (2 níveis acima do arquivo atual, ajuste se necessário)
    project_root = current_file.parents[1]  # se __file__ está em ui/, volta para BDGD2SqlServer
    path_result = project_root / 'ui' / 'static' / 'scenarios' / 'base' / conf['dist']

    #path_result = os.path.abspath(f"static/scenarios/base/{conf['dist']}")
    file_results = [f'{ano}_DO_{mes}_sub_losses.xlsx', f'{ano}_DU_{mes}_sub_losses.xlsx']

    """
    if circuito:
        path_result = os.path.abspath('static/scenarios')
        path_result = os.path.join(path_result, scenario, conf['dist'], subestacao, circuito, tipo_dia, ano, mes)
        file_results = [f'{distribuidora}_{circuito}_DO_{ano}_{mes}_losses.xlsx',
                        f'{distribuidora}_{circuito}_DU_{ano}_{mes}_losses.xlsx']
        # file_results = f'{distribuidora}_{circuito}_{tipo_dia}_{ano}_{mes}_losses.xlsx'
        # '391_RAPA1301_DO_2022_12_losses'
    """
    try:
        for file_result in file_results:
            path_all_result = os.path.join(path_result, file_result)
            xls = pd.ExcelFile(path_all_result)
            df1 = xls.parse(xls.sheet_names[0])
            df_data = df1[['SUB', 'circuit', 'losses']].copy()
            if subestacao:
                df_data = df_data[(df_data.SUB == subestacao)]
            df_data['circuit'] = df_data['circuit'].astype(str)
            label_list = df_data['circuit'].values.tolist()
            label_list1 = df_data['SUB'].values.tolist()
            data_list_losses = df_data['losses'].values.tolist()
            data_losses = {k: v for k, v in zip(label_list, data_list_losses)}
            list_data.append(data_losses)
            data_label = {k: v for k, v in zip(label_list, label_list)}
            list_data.append(data_label)
            data_label1 = {k: v for k, v in zip(label_list, label_list1)}
            list_data.append(data_label1)

        return jsonify(list_data)
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500


@server.route('/data', methods=['GET'])
def render_data():
    # print(f'route data: {distribuidora}')
    sub = request.args.get('subestacao')
    ano = request.args.get('ano')
    mes = request.args.get('mes')
    list_data = []
    # path_result = 'static/scenarios/base'
    tipo_dias = ['DO', 'DU']

    # Caminho absoluto do arquivo atual
    current_file = Path(__file__).resolve()
    # Caminho da raiz do projeto (2 níveis acima do arquivo atual, ajuste se necessário)
    project_root = current_file.parents[1]  # se __file__ está em ui/, volta para BDGD2SqlServer
    path_result = project_root / 'ui' / 'static' / 'scenarios' / 'base'

    for tipo_dia in tipo_dias:
        file_result = f'{ano}_{tipo_dia}_{mes}_sub_analysis.xlsx'
        path_all_result = os.path.join(path_result, conf['dist'], file_result)
        print(path_all_result)

        # Verifique se o caminho está correto
        if not os.path.exists(path_all_result):
            print(f"Erro: O arquivo '{path_all_result}' não existe. Verifique o caminho e tente novamente.")
            return jsonify("error Dados inexistentes"), 404
        else:
            try:
                xls = pd.ExcelFile(path_all_result)
                df1 = xls.parse(xls.sheet_names[0])
                df_data = df1[['nome', 'sub', 'P_max', 'P_min', 'P_time_max', 'P_time_min']].copy()
                # filtrar por subestação
                if sub != '':
                    df_data = df_data[df_data['sub'] == sub]

                df_data['nome'] = df_data['nome'].str[5:-3]

                label_list = df_data['nome'].values.tolist()
                label_list1 = df_data['sub'].values.tolist()
                data_list_pmax_0 = df_data['P_max'].values.tolist()
                data_list_pmin_1 = df_data['P_min'].values.tolist()
                data_list_time_max_2 = df_data['P_time_max'].values.tolist()
                data_list_time_min_3 = df_data['P_time_min'].values.tolist()

                data_pmax = {k: v for k, v in zip(label_list, label_list)}
                list_data.append(data_pmax)
                data_pmin = {k: v for k, v in zip(label_list, label_list1)}
                list_data.append(data_pmin)

                data_pmax = {k: v for k, v in zip(label_list, data_list_pmax_0)}
                list_data.append(data_pmax)
                data_pmin = {k: v for k, v in zip(label_list, data_list_pmin_1)}
                list_data.append(data_pmin)
                data_time_max = {k: v for k, v in zip(label_list, data_list_time_max_2)}
                list_data.append(data_time_max)
                data_time_min = {k: v for k, v in zip(label_list, data_list_time_min_3)}
                list_data.append(data_time_min)
            except Exception as e:
                print(f"Erro ao carregar o arquivo Excel: {e}")
                return jsonify({"error": str(e)}), 404

    return jsonify(list_data)


# Busca as distribuidoras cadastradas no arquivo de configuração
@server.route('/api/conf_dist', methods=['GET'])
def get_distribuidoras():
    try:
        list_dist = load_config_list_dist()
        return jsonify(list_dist)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# Função para buscar as subestações com base na distribuidora
@server.route('/api/subestacoes/<distribuidora>', methods=['GET'])
def get_subestacoes(distribuidora):
    global engine, conf
    try:
        conf = load_config(distribuidora)
        engine = create_connection(conf)
        query = f'''SELECT DISTINCT c.SUB, s.nome FROM sde.CTMT c
                      inner join sde.SUB s on s.COD_ID = c.sub
                      WHERE s.dist ='{conf['dist']}'
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
        query = f'''Select POINT_X, POINT_Y, g.COD_ID, g.CEG_GD as CEG, g.CTMT, g.POT_INST, g.FAS_CON, 
                    g.TEN_FORN, t.TEN, g.TEN_CON, t_con.TEN as TEN1
                    from sde.UGBT G
                    left join GEO_SIGR_DDAD_M10.SDE.TTEN  t on t.COD_ID = g.TEN_FORN
                    left join GEO_SIGR_DDAD_M10.SDE.TTEN  t_con on t_con.COD_ID = g.TEN_CON               
                    where sub='{sub}' 
                ;   
                '''
    else:
        query = f'''Select POINT_X, POINT_Y, g.COD_ID, g.CEG_GD as CEG, g.CTMT, g.POT_INST, g.FAS_CON, 
                    g.TEN_FORN, t.TEN, g.TEN_CON, t_con.TEN as TEN1
                    from sde.UGBT G
                    left join GEO_SIGR_DDAD_M10.SDE.TTEN  t on t.COD_ID = g.TEN_FORN  
                    left join GEO_SIGR_DDAD_M10.SDE.TTEN  t_con on t_con.COD_ID = g.TEN_CON               
                    where sub='{sub}' and ctmt='{ctmt}'
                ;   
                '''
    rows = return_query_as_dataframe(query, engine)
    rows["TIPO"] = "UGBT"

    # verifica se a tensão de fornecimento é None e utiliza então a tensão da conexão
    if rows["TEN"].isnull().values.any():
        rows["TEN"] = rows["TEN1"]

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
    query = f'''Select  b.cod_id as descr, b.dist, point_x1 as start_longitude, POINT_y1 as start_latitude, 
                    point_x2 as end_longitude, POINT_y2 as end_latitude,
                    PAC_1, PAC_2, CT_COD_OP, COMP,  c.NOME, c.TEN_NOM, t.TEN
                from sde.SSDAT s
                left join sde.ctat c on c.PAC_INI = s.pac_1 or c.PAC_INI = s.PAC_2
                left join [GEO_SIGR_DDAD_M10].sde.TTEN t on c.TEN_NOM = t.COD_ID
                left join sde.arat b on s.dist = b.dist
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
    # Considera que os trechos com o mesmo CT_COD_OP tem a mesma tensão.
    ssdat_ini = rows[rows['TEN'] > 0]

    #
    if ssdat_ini.empty:
        query = f'''Select  b.cod_id as descr, b.dist, point_x1 as start_longitude, POINT_y1 as start_latitude, 
                        point_x2 as end_longitude, POINT_y2 as end_latitude,
                        PAC_1, PAC_2, CT_COD_OP, COMP,  c.NOME, c.TEN_NOM, t.TEN
                    from sde.SSDAT s
                    left join sde.ctat c on c.COD_ID = s.CT_COD_OP
                    left join [GEO_SIGR_DDAD_M10].sde.TTEN t on c.TEN_NOM = t.COD_ID
                    left join sde.arat b on s.dist = b.dist
                    order by CT_COD_OP
                    ;
                    '''
        rows = return_query_as_dataframe(query, engine)
        ssdat_ini = rows[rows['TEN'] > 0]

    for index, row in ssdat_ini.iterrows():
        voltage = row['TEN']
        nome = row['NOME']
        linha = row['CT_COD_OP']
        rows.loc[rows['CT_COD_OP'] == linha, 'TEN'] = voltage

    rows["TIPO"] = "AT_SSD"
    points = [((row["start_longitude"], row["start_latitude"]), (row["end_longitude"], row["end_latitude"]),
               row["CT_COD_OP"], row["COMP"], row["NOME"], row["TEN"], row["TIPO"], row["descr"], row["dist"])
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

    for start, end, ct_cod, comp, nome, ten_nom, tipo, descr, dist in points_ssdat:
        lines.append(LineString([start, end]))
        ct_cod_at.append(ct_cod)
        comp_linha.append(comp)
        nome_linha.append(nome)
        voltage.append(ten_nom / 1000)

    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': lines, 'linha': ct_cod_at, 'nome': nome, 'voltage': voltage, 'tipo': tipo,
                            'desc': descr, 'dist': dist}, crs="EPSG:4326")
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

# Função para conectar ao SQL Server e obter coordenadas da tabela SSDBT
def get_coords_SSDBT_from_db(sub, ctmt):
    if ctmt == "" or ctmt == 'undefined':
        query = f'''Select  point_x1 as start_longitude, POINT_y1 as start_latitude, 
                            point_x2 as end_longitude, POINT_y2 as end_latitude,
                            ss.CTMT, ss.PAC_1, ss.PAC_2, ss.SUB
                        from sde.SSDBT ss
                        where ss.SUB='{sub}' 
                    ;   
                    '''
    else:
        query = f'''Select  point_x1 as start_longitude, POINT_y1 as start_latitude, 
                            point_x2 as end_longitude, POINT_y2 as end_latitude,
                            ss.CTMT, ss.PAC_1, ss.PAC_2, SS.SUB
                        from sde.SSDBT ss
                        where ss.SUB='{sub}' and ss.ctmt='{ctmt}'
                    ;   
                    '''
    rows = return_query_as_dataframe(query, engine)


    colour = ["green", "purple", "orange", "DarkOliveGreen", "Brown", "DarkCyan", "DarkKhaki",
              "SlateGray", "teal", "goldenrod", "chocolate", "darkred", "olivedrab", "aqua", "skyblue", "tan", "cyan",
              "violet", "silver", "indigo", "pink", "black"]

    grupos_unicos = rows['CTMT'].unique()
    # Truncar a lista se for maior que o número de grupos
    valores_truncados = colour[:len(grupos_unicos)]
    # Criar um mapeamento de grupos para valores
    mapa_grupos = dict(zip(grupos_unicos, valores_truncados))
    rows['cor'] = rows['CTMT'].map(mapa_grupos)
    rows["nome"] = "segmentosBT"

    line_segmentsBT = [((row["start_longitude"], row["start_latitude"]), (row["end_longitude"], row["end_latitude"]),
                        row["PAC_2"], row["CTMT"], rows["cor"][index], rows["nome"] ) for index, row in rows.iterrows()]
    return line_segmentsBT

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
        path_json_file = os.path.join(parent, path_flask_static, scenario, conf['dist'], subestacao, circuito,
                                      tipo_dia, ano, mes).replace('\\', '/')

        try:
            json_files = [pos_json for pos_json in os.listdir(path_json_file) if pos_json.endswith('.json')]

        except Exception as e:
            print(f"Resultados não encontrados: {path_json_file}. {e}")
            return None

        for index, js in enumerate(json_files):
            print(js)
            with open(os.path.join(path_json_file, js), 'r') as json_file:
                json_text = json.load(json_file)[hora - 1]
                dados_combinados.update(json_text)
        return dados_combinados
    else:
        # Opening JSON file
        # month = 1
        if scenario.lower() == 'base':
            json_file = f"{circuito}.json"
        elif scenario.lower() == 'hosting capacity':
            json_file = f"{circuito}.json"
        else:
            json_file = f"{circuito}_sc{mes}.json"

        path_json_file = os.path.join(parent, path_flask_static, scenario, distribuidora, subestacao, circuito,
                                      tipo_dia, ano, mes, json_file).replace('\\', '/')
        print(path_json_file)
        try:
            with open(path_json_file, 'r') as f:
                result = json.load(f)[hora - 1]
                # returns JSON object as a list
                return result
        except Exception as e:
            print(f"File not found: {path_json_file}. {e}")
            return None


# Função para criar GeoJSON a partir dos segmentos de retas e dados de hosting capacity
def create_geojson_from_segments_hc(line_segments, json_data):
    # Criar uma lista de geometria de segmentos de linha a partir dos pontos
    if json_data is None:
        print('Erro: dados inexistentes de HC!')
        return

    hc_max = max(json_data.items(), key=lambda x: x[1])[1]
    # hc_min = min(json_data.items(), key=lambda x: x[1])[1]
    hc_min = 0

    # lines = [LineString([start, end]) for start, end in line_segments]
    lines = []
    cores = []
    colorByCircuit = []
    bus1 = []
    bus2 = []
    bus3 = []
    circ = []
    pac2 = []
    # Define the start and end colors
    start_color = Color("red")
    end_color = Color("blue")
    gradient_colors = list(start_color.range_to(end_color, len(line_segments)))

    for start, end, pac, ctmt, cor, nome in line_segments:
        lines.append(LineString([start, end]))
        colorByCircuit.append(cor)

        hc_bus1 = json_data.get(f"{pac}".lower())
        if hc_bus1 is None:
            print('Erro: Verifique os dados de resultado do HC!')
            # hc_bus1 = hc_max

        color_intensity = (hc_bus1 - hc_min) / (hc_max - hc_min)
        cores.append(str(gradient_colors[int(color_intensity * (len(line_segments) - 1))]))

        # cores.append(cor)
        bus1.append(hc_bus1)
        circ.append(ctmt)
        pac2.append(pac)
    # Criar um GeoDataFrame com as geometrias e dados extras
    gdf = gpd.GeoDataFrame({'geometry': lines, 'color': cores, 'colorbycircuit': colorByCircuit,
                            'ctmt': ctmt, 'bus1': bus1,
                            'tipo': nome, 'pac': pac2}, crs="EPSG:4326")
    # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4674")

    # Converter o GeoDataFrame para GeoJSON
    geojson = gdf.to_json()

    return geojson


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
        # Prodist modulo 8
        if any(overvoltage > 1.05 for overvoltage in voltage_list_a) or \
                any(undervoltage < 0.93 for undervoltage in voltage_list_a):
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


# Função de busca os segmentos de baixa tensão
@server.route('/api/segmentsBT')
def segmentsBT():
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
        mens = {'error': 'Select an Utility!'}
        print(f"{mens}")
        return mens, 500, {'Content-Type': 'application/json'}
    line_segments = get_coords_SSDBT_from_db(subestacao, circuito)
    json_data = read_json_from_result(conf['dist'], subestacao, circuito, scenario, tipo_dia, ano, mes, hora)
    geojson = create_geojson_from_segments(line_segments, json_data)
    return geojson, 200, {'Content-Type': 'application/json'}

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
        mens = {'error': 'Select an Utility!'}
        print(f"{mens}")
        return mens, 500, {'Content-Type': 'application/json'}
    line_segments = get_coords_SSDMT_from_db(subestacao, circuito)
    if scenario == "Hosting Capacity":
        # Leitura do arquivo de resultados do hosting capacity
        json_data_hc = read_json_from_result(conf['dist'], subestacao, circuito, scenario, tipo_dia, ano, mes, 0)
        if json_data_hc is None:
            return jsonify({"error: No Data found to Hosting Capacity!"}), 500
        geojson = create_geojson_from_segments_hc(line_segments, json_data_hc)
    else:
        # Leitura do arquivo de resultados do fluxo de potencia
        json_data = read_json_from_result(conf['dist'], subestacao, circuito, scenario, tipo_dia, ano, mes, hora)
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
    conf = load_config(distribuidora)
    dist = conf['dist']
    subestacao = request.args.get('subestacao', 'defaultSubestacao')
    circuito = request.args.get('circuito', 'defaultCircuito')
    id_summary = request.args.get('idSummary', '0')

    sumario = resumo.Summary(engine=engine, sub=subestacao, dist=dist)
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
@server.route('/get_data_at_SIN_Subsystems')
def get_data_at_SIN_Subsystems():
    my_gdb_sin = geo_tools.GeoDataSIN(SIN_DATA_GDB, 'Subsistema_do_Sistema_Interligado_Nacional')
    return my_gdb_sin.read_gdb_SIN_subsistema_to_json()


# leitura dos dados do arquivo GDB do SIN
@server.route('/get_data_at_UTE_BIOMASS')
def get_data_at_UTE_BIOMASS():
    my_gdb_sin = geo_tools.GeoDataSIN(SIN_DATA_GDB, 'UTE_Biomassa___Base_Existente')
    return my_gdb_sin.read_gdb_UTE_BIOMASS_to_json()


# leitura dos dados do arquivo GDB do SIN
@server.route('/get_data_at_UTE_FOSSIL')
def get_data_at_UTE_FOSSIL():
    my_gdb_sin = geo_tools.GeoDataSIN(SIN_DATA_GDB, 'UTE_Fóssil___Base_Existente')
    return my_gdb_sin.read_gdb_UTE_FOSSIL_to_json()


# leitura dos dados do arquivo GDB do SIN
@server.route('/get_data_at_CGH')
def get_data_at_CGH():
    my_gdb_sin = geo_tools.GeoDataSIN(SIN_DATA_GDB, 'CGH___Base_Existente')
    return my_gdb_sin.read_gdb_CGH_to_json()


# leitura dos dados do arquivo GDB do SIN
@server.route('/get_data_at_PCH')
def get_data_at_PCH():
    my_gdb_sin = geo_tools.GeoDataSIN(SIN_DATA_GDB, 'PCH___Base_Existente')
    return my_gdb_sin.read_gdb_PCH_to_json()


# leitura dos dados do arquivo GDB do SIN
@server.route('/get_data_at_UHE')
def get_data_at_UHE():
    my_gdb_sin = geo_tools.GeoDataSIN(SIN_DATA_GDB, 'UHE___Base_Existente')
    return my_gdb_sin.read_gdb_uhe_to_json()


# leitura dos dados do arquivo GDB do SIN
@server.route('/get_data_at_UFV')
def get_data_at_UFV():
    my_gdb_sin = geo_tools.GeoDataSIN(SIN_DATA_GDB, 'UFV___Base_Existente')
    return my_gdb_sin.read_gdb_ufv_to_json()


# leitura dos dados do arquivo GDB do SIN
@server.route('/get_data_at_EOL')
def get_data_at_EOL():
    my_gdb_sin = geo_tools.GeoDataSIN(SIN_DATA_GDB, 'EOL___Base_Existente')
    return my_gdb_sin.read_gdb_eol_to_json()


# leitura dos dados do arquivo GDB do SIN
@server.route('/get_data_at_sub')
def get_data_at_sub():
    # my_gdb_sin = geo_tools.GeoDataSIN('subs_SIN.geojson')
    # return my_gdb_sin.read_geojson_subs()

    my_gdb_sin = geo_tools.GeoDataSIN(SIN_DATA_GDB, 'Subestações___Base_Existente')
    return my_gdb_sin.read_gdb_sub_to_json()


# leitura dos dados do arquivo GDB do SIN
@server.route('/get_data_at')
def get_data_at():
    my_gdb_sin = geo_tools.GeoDataSIN('Linhas_SIN.geojson')
    return my_gdb_sin.read_geojson_line()

    # my_gdb_sin = geo_tools.GeoDataSIN(SIN_DATA_GDB, 'Linhas_de_Transmissão___Base_Existente')
    # return my_gdb_sin.read_gdb_line_to_json()


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
    # Caminho absoluto do arquivo atual
    current_file = Path(__file__).resolve()
    # Caminho da raiz do projeto (2 níveis acima do arquivo atual, ajuste se necessário)
    project_root = current_file.parents[1]  # se __file__ está em ui/, volta para BDGD2SqlServer
    # Caminho fixo para static/scenarios
    scenarios_path = project_root / 'ui' / 'static' / 'scenarios'
    # root = 'static/scenarios'
    # current = os.path.dirname(os.path.realpath(__file__))
    # scenarios_path = os.path.join(current, root).replace('\\', '/')
    print(scenarios_path)
    dir_list = os.listdir(scenarios_path)
    print(dir_list)
    return jsonify(dir_list), 200


"""
@server.before_request
def before_request():
    if not request.is_secure:
        url = request.url.replace('http://', 'https://', 1)
        code = 301
        return redirect(url, code=code)
"""

if __name__ == '__main__':
    # server.run(host='0.0.0.0', use_reloader=False, debug=True, ssl_context=('cert.pem', 'key.pem'))
    server.run(host='0.0.0.0', use_reloader=False, debug=True)
    # Para rodar na linha de comando
    # C:\_BDGD2SQL\BDGD2SqlServer\venv\Scripts\activate.bat && python.exe C:\_BDGD2SQL\BDGD2SqlServer\ui\flask_app.py
