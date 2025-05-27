# -*- encoding: utf-8 -*-
import math
import os
import time
import holidays
import pandas as pd
import geopandas as gpd
import logging
import pyodbc
import fiona
import yaml
from sqlalchemy import create_engine
import urllib.request
import json

pd.set_option('display.max_colwidth', None)
pd.set_option('display.max_columns', None)

list_names_tables = ['EQTRAT', 'EQTRMT', 'UNTRAT', 'UNTRMT']


def load_config(dist, config_path="../config_database.yml"):
    application_path = os.path.dirname(os.path.abspath(__file__))
    with open(os.path.join(application_path, config_path), 'r') as file:
        config = yaml.load(file, Loader=yaml.BaseLoader)

    config_bdgd = config.get("databases", {}).get(dist)
    if not config_bdgd:
        raise ValueError(f"Configurações para o banco de dados '{dist}' não foram encontradas.")

    return config_bdgd


def load_config_list_dist(config_path="../config_database.yml") -> list:
    """
    Lista o código e o nome da distribuidora cadastrada no arquivo de configuração yml
    :param config_path: arquivo de configuração.
    :return: list
    """
    application_path = os.path.dirname(os.path.abspath(__file__))
    with open(os.path.join(application_path, config_path), 'r') as file:
        config = yaml.load(file, Loader=yaml.BaseLoader)
    list_dist = []
    config_bdgd = list(config.get("databases", {}).keys())

    if not config_bdgd:
        raise ValueError(f"Erro no arquivo de configurações.")

    if 'Irradiance' in config_bdgd:
        config_bdgd.remove('Irradiance')

    for cod_dist in config_bdgd:
        name = config["databases"][cod_dist]['database']
        dist = config["databases"][cod_dist]['dist']
        short_name = name[16:]
        short_name =  config["databases"][cod_dist]['dist_name']
        list_dist.append([cod_dist, name, short_name, dist])
    return list_dist


def create_connection_pyodbc(config_bdgd):
    """Função para criar uma conexão com o banco de dados SQL Server"""
    conn_str = (
            'DRIVER={ODBC Driver 17 for SQL Server};'
            'SERVER=' + config_bdgd['databases']['server'] + ';'
            'DATABASE=' + config_bdgd['databases']['database'] + ';'
            'UID=' + config_bdgd['databases']['username'] + ';'
            'PWD=' + config_bdgd['databases']['password']
    )
    return pyodbc.connect(conn_str)


def create_connection(config_bdgd):
    """Função para criar uma conexão com o banco de dados SQL Server"""

    engine = create_engine(f"mssql+pyodbc://"
                           f"{config_bdgd['username']}:"
                           f"{config_bdgd['password']}@"
                           f"{config_bdgd['server']}/"
                           f"{config_bdgd['database']}?"
                           f"driver=ODBC+Driver+17+for+SQL+Server",
                           fast_executemany=True, pool_pre_ping=True)

    return engine


def remove_columns(data_dbf, columns_to_remove: list):
    """Remove colunas do dbf. Para o caso do SqlServer não ter a coluna no seu modelo de dados"""
    for record in data_dbf:
        for column in columns_to_remove:
            if column in record.keys():
                del record[column]
    return data_dbf


def rename_columns(data_dbf, columns_rename: dict):
    """Renomeia colunas do dbf. Para os casos onde o modelo de dados do sqlserver tem colunas com nome diferentes do dbf"""
    for record in data_dbf:
        for old_name, new_name in columns_rename.items():
            if old_name in record:
                record[new_name] = record.pop(old_name)
    return data_dbf


def insert_data(cursor, table_name, data, data_base, data_carga):
    """Função para inserir dados no banco de dados com tratamento de erro"""
    if not data:
        return

    # adiciona novos campos a todos os registros
    for record in data:
        record['DATA_BASE'] = data_base
        record['DATA_CARGA'] = data_carga

    placeholders = ', '.join('?' * len(data[0].keys()))
    columns = ', '.join(data[0].keys())

    #: tira _tab do nome da tabela para corresponder ao sql
    table_name_sql = table_name.replace('_tab', '')

    if table_name_sql in list_names_tables:
        # table_name_sql = table_name.replace('_tab', '')
        table_name_sql = table_name.replace('MT', 'D')
        table_name_sql = table_name.replace('AT', 'S')

    sql = f"INSERT INTO {table_name_sql} ({columns}) VALUES ({placeholders})"
    for row in data:
        try:
            print(sql)
            print(tuple(row.values()))
            cursor.execute(sql, tuple(row.values()))

            # * TODO cuidado o arquivo de log pode ficar muito grande
            logging.info(f'SQL: {sql} valores {tuple(row.values())}')

        except pyodbc.DatabaseError as e:
            logging.info(f'SQL Erro: tabela {table_name}: {e}')
            print(f"Erro ao inserir dados na tabela {table_name}: {e}")

            if e.args[0] == '42000':  # campos truncados
                cursor.execute('SET ANSI_WARNINGS off;')
                cursor.execute(sql, tuple(row.values()))

            if e.args[0] == '42S02':  # tabela não existe
                break  # exit for loop

        except Exception as e:
            logging.info(f'Erro inesperado ao inserir dados na tabela {table_name}: {e}')
            print(f"Erro inesperado ao inserir dados na tabela {table_name}: {e}")

    print(f"Dados inseridos com exito na tabela {table_name_sql}.  ")
    cursor.execute('SET ANSI_WARNINGS on;')


def ajust_regulators(dataFrame):
    '''Ajusta o CodBnc dos reguladores'''
    print("ajustando CodBnc EQRE")
    # Inicializa todos como bancos trifásicos
    dataFrame['CodBnc'] = 0

    # Localiza os que tem UN_RE duplicadas, ou seja, sao monofasicos
    one_phase_reg = dataFrame['UN_RE'][dataFrame['UN_RE'].duplicated(keep=False)].unique()

    # para os monofasicos, altera o CodBnc de acordo com a fase que estao ligados
    for index, value in enumerate(dataFrame["UN_RE"]):
        if value in one_phase_reg:
            if dataFrame.loc[index, "LIG_FAS_P"] == "AB":
                dataFrame.loc[index, "CodBnc"] = 1
            elif dataFrame.loc[index, "LIG_FAS_P"] == "BC":
                dataFrame.loc[index, "CodBnc"] = 2
            elif dataFrame.loc[index, "LIG_FAS_P"] == "CA":
                dataFrame.loc[index, "CodBnc"] = 3
    return dataFrame


def insert_BDGD_consolidada(conn, data_base, data_carga, dist, cod_bdgd):
    conn.execute(f"insert into [sde].[NVAL_BDGD_CONSOLIDADA] "
                 f"(OBJECTID,STATUS_CARGA,ENTIDADE,DATA_BASE,DIST,COD_BDGD,DATAHORA_CARGA,N_REGISTROS, DATA_BASE_DT) "
                 f"values(2,1,'BASE',{data_base},{dist},{cod_bdgd},{data_carga},1,{data_base})")


def process_gdb_files(gdb_file, engine, schema, data_base, data_carga, column_renames):
    """Função para processar arquivos GeoDatabase"""
    with engine.connect() as conn, conn.begin():
        # gdf = gpd.read_file(gdb_file)
        layerlist = fiona.listlayers(gdb_file)

        for table_name in layerlist:
            print(f"{table_name}")

            proc_table_time_ini = time.time()

            # verifica se o arquivo já foi processado
            table_name_sql = table_name.replace('_tab', '')  # Deve ser removido o '_tab' do nome das tabelas
            table_name_ori = ""
            if table_name_sql in list_names_tables:
                table_name_ori = table_name  # Para gravar os dados nas duas tabela com final D e MT
                if 'MT' in table_name:
                    table_name_sql = table_name.replace('MT', 'D')
                if 'AT' in table_name:
                    table_name_sql = table_name.replace('AT', 'S')

            if schema != '':
                full_table_name = f'{schema}.{table_name_sql}'

            try:
                exist_info = pd.read_sql_query(f"SELECT TOP(1) * FROM {full_table_name}", conn)

                if len(exist_info) > 0:
                    logging.info(f"{table_name}: \tNão processado. Tabela possui dados.")
                    print(f"{table_name}: \tNão processado. Tabela possui dados.")

                    continue

            except Exception as e:
                if '42S02' in e.args[0]:  # tabela não existe
                    logging.info(f"{table_name}: \tNão existe no SQL Server.")
                    print(f"{table_name}: \tNão existe no SQL Server.")

                else:
                    print(e)
                    continue

            """
            Leitura e inserção de dados de um grupo limitado de linhas para evitar erro de falta de memoria.
            A variável row_step indica a quantidade de linhas lidas da tabela da BDGD e posterior inserção no SQLServer

            """
            row_ini = 0
            row_step = 100000
            row_end = row_step
            while True:
                proc_table_parse_time_ini = time.time()

                df = gpd.read_file(gdb_file, driver="pyogrio", layer=table_name, rows=slice(row_ini, row_end),
                                   ignore_geometry=False, use_arrow=True)
                print(f"Leitura de {len(df.index)} reg. em {round(time.time() - proc_table_parse_time_ini, 3)} de "
                      f"{round(time.time() - proc_table_time_ini, 3)} segundos.")

                if df.empty:
                    break

                # Altera a coluna CodBnc da tabela EQRE
                if table_name == "EQRE":
                    df = ajust_regulators(df)

                df = df.rename(column_renames, axis='columns')
                df['OBJECTID'] = range(row_ini + 1, 1 + len(df) + row_ini)
                df['DATA_BASE'] = data_base
                df['DATA_CARGA'] = data_carga
                # df = df[['OBJECTID'] + [col for col in df.columns if col != 'OBJECTID']]

                list_table_coords = ['PONNOT', 'SSDBT', 'SSDMT', 'SSDAT', 'UNTRMT', 'UNTRD',
                                     'UNTRAT', 'UNTRS', 'UNSEMT', 'UNSEAT', 'UNREMT', 'UNREAT',
                                     'UNCRMT', 'UNCRAT', 'UNCRBT', 'SUB', 'UNSEBT']
                # gdf = gpd.GeoDataFrame(geometry=lines, crs="EPSG:4326")
                if table_name_sql in list_table_coords:
                    if df.iloc[0]['geometry'].geom_type == 'Point':
                        df['POINT_Y'] = df['geometry'].y  # lat
                        df['POINT_X'] = df['geometry'].x  # lon

                    if df.iloc[0]['geometry'].geom_type == 'MultiPolygon':
                        # df['POINT_Y'] = df['geometry'].centroid.y  # lat
                        # df['POINT_X'] = df['geometry'].centroid.x  # lon
                        # CRS SISGRAS 2000
                        df['POINT_Y'] = df['geometry'].to_crs('EPSG:4674').centroid.to_crs(df.crs).y  # lat
                        df['POINT_X'] = df['geometry'].to_crs('EPSG:4674').centroid.to_crs(df.crs).x  # lat

                    if df.iloc[0]['geometry'].geom_type == 'MultiLineString':
                        bounds = df.geometry.boundary.explode(index_parts=True).unstack()
                        df['POINT_Y1'] = bounds[0].y
                        df['POINT_X1'] = bounds[0].x
                        df['POINT_Y2'] = bounds[1].y
                        df['POINT_X2'] = bounds[1].x

                    df.drop('geometry', axis=1, inplace=True)

                row_ini += row_step
                row_end = row_ini + row_step

                # Localizando colunas que não exitem nas tabelas do sqlserver
                list_col = conn.execute(f"SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE "
                                        f"TABLE_NAME='{table_name_sql}'")
                rows = list_col.all()
                if len(rows) != 0:
                    listColSql = [row[0] for row in rows]
                    listColDbf = df.columns.values.tolist()
                    coldiff = [i.strip() for i in listColDbf if i.strip() not in listColSql]

                    # Removendo colunas que não exitem no sqlserver
                    if len(coldiff) > 0:
                        # ini = time.time()
                        # data = remove_columns(data_gpd, coldiff)
                        df = df.drop(columns=coldiff)
                        # fim = time.time()
                        # print(fim - ini)

                try:
                    # df.to_sql(table_name, engine, index=False, if_exists="append", chunksize=20, method='multi')
                    print(table_name_sql)
                    df.to_sql(table_name_sql, con=conn, schema=schema, index=False,
                              if_exists="append", chunksize=None, method=None)
                    print(f"Concluído em {round(time.time() - proc_table_time_ini, 3)} segundos.")
                    logging.info(f"{table_name}: \tProc concluído em {time.time() - proc_table_time_ini} sec.")

                    if table_name_ori != "":
                        print(table_name_ori)
                        df.to_sql(table_name_ori, con=conn, schema=schema, index=False,
                                  if_exists="append", chunksize=None, method=None)
                        print(f"Concluído em {round(time.time() - proc_table_time_ini, 3)} segundos.")
                        logging.info(f"{table_name}: \tProc concluído em {time.time() - proc_table_time_ini} sec.")
                except Exception as e:
                    logging.info(f'SQL Erro: tabela {table_name}: {e}')
                    print(f"Erro ao inserir dados na tabela {table_name}: {e}")

                    # Falha de vínculo de comunicação. O banco de dados pode fechar a conexão se ficar
                    # muito tempo sem atividade.
                    if '08S01' in e.args[0]:
                        time.sleep(5)
                        # engine = create_connection()
                        time.sleep(5)
                        df.to_sql(table_name_sql,
                                  con=conn,
                                  schema=schema,
                                  index=False,
                                  if_exists="append",
                                  chunksize=None,
                                  method=None)
                    else:
                        logging.error(f"Erro ao ler o arquivo {gdb_file}: {e}")
                        return

            if df.empty:
                logging.info(f"{table_name}: da BDGD sem dados.")
                print(f"{table_name}: da BDGD sem dados..")
                continue


def return_query_as_dataframe(query: str, engine) -> pd.DataFrame:
    df = pd.DataFrame([])
    retry_flag = True
    retry_count = 0
    while retry_flag and retry_count < 10:
        try:
            df = pd.read_sql_query(sql=query, con=engine)
            retry_flag = False
        except Exception as e:
            retry_count = retry_count + 1
            print(e)
            time.sleep(20)
    return df


def exec_query(query: str, engine):
    with engine.begin() as conn:  # TRANSACTION
        conn.execute(query)


def write_to_dss(dist, sub, circuito, linhas_arquivos_list: list, nome_arquivo: str, dss_files_folder) -> bool:
    """
    Função que escreve arquivos DSS (OpenDSS) representativos dos objetos de rede carregada em memória.
    :param dss_files_folder:
    :param nome_arquivo:
    :param circuito:
    :param sub:
    :param linhas_arquivos_list: Lista de dicionários, sendo um referente a cada circuito.
    :return: bool
    """
    # Escreve os arquivos DSS, sendo agrupados num diretório para cada circuito
    if circuito == '':
        nome_arquivo += '_' + sub
    else:
        nome_arquivo += '_' + circuito

    try:
        path_dss_files = os.path.expanduser(dss_files_folder)
        # Verifica se existe diretório 'dss'
        if not os.path.isdir(path_dss_files):
            os.mkdir(path_dss_files)

        # Verifica se existe diretório dist
        dist_path = os.path.join(path_dss_files, dist)
        if not os.path.isdir(dist_path):
            os.mkdir(dist_path)

        sub_path = os.path.join(dist_path, sub)
        if not os.path.isdir(sub_path):
            os.mkdir(sub_path)

        final_path = os.path.join(sub_path, circuito)
        if os.path.isdir(final_path):
            for file_name in os.listdir(final_path):
                if file_name == nome_arquivo + '.dss':
                    os.remove(os.path.join(final_path, file_name))
                else:
                    pass
        else:
            os.mkdir(final_path)

        # Insere as linhas do arquivo DSS
        with open(fr"{final_path}\{nome_arquivo}.dss", "w") as file:
            file.write(f"! {nome_arquivo}\n")
            for linha in linhas_arquivos_list:
                file.write(f"{linha}\n")
    except Exception as e:
        print(e)
        return True

    return False


def numero_fases_segmento(strFases) -> str:
    if strFases == "A" or strFases == "B" or strFases == "C" or strFases == "AN" or strFases == "BN" or strFases == "CN":
        return "1"
    elif strFases == "AB" or strFases == "BC" or strFases == "CA" or strFases == "ABN" or strFases == "BCN" or strFases == "CAN":
        return "2"
    elif strFases == "ABC" or strFases == "ABCN":
        return "3"
    else:
        return ""


def numero_fases_segmento_neutro(strFases) -> str:
    if strFases == "A" or strFases == "B" or strFases == "C":
        return "1"
    elif strFases == "AB" or strFases == "BC" or strFases == "CA" or strFases == "AN" or strFases == "BN" or strFases == "CN":
        return "2"
    elif strFases == "ABC" or strFases == "ABN" or strFases == "BCN" or strFases == "CAN":
        return "3"
    elif strFases == "ABCN":
        return "4"
    else:
        return ""


def numero_fases(strFases) -> int:
    if strFases == "A" or strFases == "B" or strFases == "C" or strFases == "AN" or strFases == "BN" or strFases == "CN":
        return 1
    elif strFases == "AB" or strFases == "BA" or strFases == "BC" or strFases == "CB" or \
            strFases == "CA" or strFases == "AC" or strFases == "ABN" or strFases == "BAN" or \
            strFases == "BCN" or strFases == "CBN" or strFases == "CAN" or strFases == "ACN":
        return 2
    elif strFases == "ABC" or strFases == "ABCN":
        return 3
    else:
        return 0


def numero_fases_carga(strFases):
    if strFases == "A" or strFases == "B" or strFases == "C" or strFases == "AN" or strFases == "BN" or strFases == "CN":
        return "1"
    elif strFases == "AB" or strFases == "BA" or strFases == "BC" or strFases == "CB" or \
            strFases == "CA" or strFases == "AC" or strFases == "ABN" or strFases == "BAN" or \
            strFases == "BCN" or strFases == "CBN" or strFases == "CAN" or strFases == "ACN":
        return "2"
    elif strFases == "ABC" or strFases == "ABCN":
        return "3"
    else:
        return ""


def ligacao_carga(strCodFas):
    if strCodFas == "A" or strCodFas == "B" or strCodFas == "C" or strCodFas == "AN" or strCodFas == "BN" or \
            strCodFas == "CN":
        return "Wye"  # LN
    elif strCodFas == "AB" or strCodFas == "BC" or strCodFas == "CA" or strCodFas == "ABN" or strCodFas == "BCN" or \
            strCodFas == "CAN" or strCodFas == "ABC" or strCodFas == "ABCN":
        return "Delta"  # LL
    else:
        return ""


def nos_com_neutro(strFases) -> str:
    if strFases == "A":
        return ".1"
    elif strFases == "B":
        return ".2"
    elif strFases == "C":
        return ".3"
    elif strFases == "AN":
        return ".1.4"
    elif strFases == "BN":
        return ".2.4"
    elif strFases == "CN":
        return ".3.4"
    elif strFases == "AB":
        return ".1.2"
    elif strFases == "BC":
        return ".2.3"
    elif strFases == "CA":
        return ".3.1"
    elif strFases == "ABN":
        return ".1.2.4"
    elif strFases == "BCN":
        return ".2.3.4"
    elif strFases == "CAN":
        return ".3.1.4"
    elif strFases == "ABC":
        return ".1.2.3"
    elif strFases == "ABCN":
        return ".1.2.3.4"
    else:
        return ""


def nos_terciario(strFases) -> str:
    if strFases == "AN":
        return ".0.1"
    elif strFases == "BN":
        return ".0.2"
    elif strFases == "CN":
        return ".0.3"
    else:
        return ""


def nos_terciario_neutro(strFases) -> str:
    if strFases == "AN":
        return ".4.1"
    elif strFases == "BN":
        return ".4.2"
    elif strFases == "CN":
        return ".4.3"
    else:
        return ""


def nos_com_neutro_trafo(strCodFas1, strCodFas2, strCodFas3, dblTensaoSecuTrafo_kV, strBus1, strBus2) -> str:
    if dblTensaoSecuTrafo_kV > 1:
        if strCodFas3 == "BN" or strCodFas3 == "CN" or strCodFas3 == "AN" or strCodFas2 == "ABN":
            return '"' + strBus1 + nos(strCodFas1) + '"' + ' "' + strBus2 + nos(
                strCodFas2) + '"' + ' "' + strBus2 + nos_terciario(strCodFas3) + '"'
        elif strCodFas3 == "0" or strCodFas2 == "AN" or strCodFas2 == "BN" or strCodFas2 == "CN" or strCodFas2 == "AB" or strCodFas2 == "BC" or strCodFas2 == "CA" or strCodFas2 == "AC" or strCodFas2 == "ABCN" or strCodFas2 == "ABC":
            return '"' + strBus1 + nos(strCodFas1) + '"' + ' "' + strBus2 + nos(strCodFas2) + '"'
        else:
            return ""
    else:
        if strCodFas3 == "BN" or strCodFas3 == "CN" or strCodFas3 == "AN" or strCodFas2 == "ABN":
            return '"' + strBus1 + nos(strCodFas1) + '"' + ' "' + strBus2 + nos_com_neutro(
                strCodFas2) + '"' + ' "' + strBus2 + nos_terciario_neutro(strCodFas3) + '"'
        elif strCodFas3 == "0" or strCodFas2 == "AN" or strCodFas2 == "BN" or strCodFas2 == "CN" or strCodFas2 == "AB" or strCodFas2 == "BC" or strCodFas2 == "CA" or strCodFas2 == "AC" or strCodFas2 == "ABCN" or strCodFas2 == "ABC":
            return '"' + strBus1 + nos(strCodFas1) + '"' + ' "' + strBus2 + nos_com_neutro(
                strCodFas2) + '"'
        else:
            return ""


def tap_trafo(strCodFas3, tap_pu, tip_trafo=None) -> str:
    if tip_trafo == 'DA':
        tap_pu = "1.0"
    if strCodFas3 != "0":
        return "1 " + tap_pu + " " + tap_pu
    else:
        return "1 " + tap_pu


def nos(strFases) -> str:
    if strFases == "A":
        return ".1"
    elif strFases == "B":
        return ".2"
    elif strFases == "C":
        return ".3"
    elif strFases == "AN":
        return ".1.0"
    elif strFases == "BN":
        return ".2.0"
    elif strFases == "CN":
        return ".3.0"
    elif strFases == "AB":
        return ".1.2"
    elif strFases == "BA":
        return ".2.1"
    elif strFases == "BC":
        return ".2.3"
    elif strFases == "CB":
        return ".3.2"
    elif strFases == "CA":
        return ".3.1"
    elif strFases == "AC":
        return ".1.3"
    elif strFases == "ABN":
        return ".1.2.0"
    elif strFases == "BAN":
        return ".2.1.0"
    elif strFases == "BCN":
        return ".2.3.0"
    elif strFases == "CBN":
        return ".3.2.0"
    elif strFases == "CAN":
        return ".3.1.0"
    elif strFases == "ACN":
        return ".1.3.0"
    elif strFases == "ABC":
        return ".1.2.3"
    elif strFases == "ABCN":
        return ".1.2.3.0"
    else:
        return ".erro"


def numero_fases_transformador(strFases) -> str:
    if strFases == "A" or strFases == "B" or strFases == "C" or strFases == "AN" or strFases == "BN" or \
            strFases == "CN" or strFases == "AB" or strFases == "BA" or strFases == "BC" or strFases == "CB" or \
            strFases == "CA" or strFases == "AC" or strFases == "ABN" or strFases == "BAN" or \
            strFases == "BCN" or strFases == "CBN" or strFases == "CAN" or strFases == "ACN":
        return "1"
    elif strFases == "ABC" or strFases == "ABCN":
        return "3"
    else:
        return ""


def conexoes_trafo(strCodFas1, strCodFas2, strCodFas3) -> str:
    if strCodFas3 == "BN" or strCodFas3 == "CN" or strCodFas3 == "AN" or strCodFas2 == "ABN":
        return ligacao_trafo(strCodFas1) + " " + ligacao_trafo(strCodFas2) + " " + ligacao_trafo(strCodFas3)
    elif strCodFas3 == "0" or strCodFas2 == "AN" or strCodFas2 == "BN" or strCodFas2 == "CN" or strCodFas2 == "AB" or strCodFas2 == "BC" or strCodFas2 == "CA" or strCodFas2 == "AC" or strCodFas2 == "ABCN" or strCodFas2 == "ABC":
        return ligacao_trafo(strCodFas1) + " " + ligacao_trafo(strCodFas2)
    else:
        return ""


def kvas_trafo(strCodFas2, strCodFas3, dblPotNom_kVA) -> str:
    if strCodFas3 == "BN" or strCodFas3 == "CN" or strCodFas3 == "AN" or strCodFas2 == "ABN":
        return str(dblPotNom_kVA) + " " + str(dblPotNom_kVA) + " " + str(dblPotNom_kVA)
    elif strCodFas3 == "0" or strCodFas2 == "AN" or strCodFas2 == "BN" or strCodFas2 == "CN" or \
            strCodFas2 == "AB" or strCodFas2 == "BC" or strCodFas2 == "CA" or strCodFas2 == "AC" or \
            strCodFas2 == "ABCN" or strCodFas2 == "ABC":
        return str(dblPotNom_kVA) + " " + str(dblPotNom_kVA)
    else:
        return ""


def tensao_enrolamento(strCodFas, dblTensao_kV):
    """
    Uma vez que o manual da BDGD aponta que esta tensão já é a tensão do equipamento em si,
     basta adotar estão tensão informada, sem precisar dividir por raiz de 3.
    :param strCodFas:
    :param dblTensao_kV:
    :return:
    """
    if strCodFas == "A" or strCodFas == "B" or strCodFas == "C" or \
            strCodFas == "AN" or strCodFas == "BN" or strCodFas == "CN":
        return f'{dblTensao_kV / math.sqrt(3):.4}'
        # return dblTensao_kV
    elif strCodFas == "ABN" or strCodFas == "BCN" or strCodFas == "CAN" or strCodFas == "ABCN":
        return dblTensao_kV
    elif strCodFas == "AB" or strCodFas == "BC" or strCodFas == "CA" or strCodFas == "ABC":
        return dblTensao_kV
    else:
        return 0.0


def kvs_trafo(intTipTrafo, strCodFas1, strCodFas2, strCodFas3, dblTensaoPrimTrafo_kV, dblTensaoSecuTrafo_kV) -> str:
    if intTipTrafo == 4:
        return str(dblTensaoPrimTrafo_kV) + " " + str(dblTensaoSecuTrafo_kV)
    elif strCodFas3 == "BN" or strCodFas3 == "CN" or strCodFas3 == "AN" or strCodFas2 == "ABN":
        return str(tensao_enrolamento(strCodFas1, dblTensaoPrimTrafo_kV)) + " " + \
               str(dblTensaoSecuTrafo_kV / 2) + " " + str(dblTensaoSecuTrafo_kV / 2)
    elif strCodFas3 == "0" and (strCodFas2 == "AN" or strCodFas2 == "BN" or strCodFas2 == "CN"):
        return str((tensao_enrolamento(strCodFas1, dblTensaoPrimTrafo_kV))) + " " + \
               f'{(dblTensaoSecuTrafo_kV / 2):.4f}'
        # f'{(dblTensaoSecuTrafo_kV / math.sqrt(3)):.4f}'
    elif strCodFas3 == "0" and (strCodFas2 == "AB" or strCodFas2 == "BC" or strCodFas2 == "CA" or
                                strCodFas2 == "ABN" or strCodFas2 == "BCN" or strCodFas2 == "CAN"):
        return str((tensao_enrolamento(strCodFas1, dblTensaoPrimTrafo_kV))) + " " + str(dblTensaoSecuTrafo_kV)
    else:
        return ""


def nome_banco(intCodBnc) -> str:
    if intCodBnc == 1:
        return "A"
    elif intCodBnc == 2:
        return "B"
    elif intCodBnc == 3:
        return "C"
    elif intCodBnc == 4:
        return "D"
    elif intCodBnc == 5:
        return "E"
    elif intCodBnc == 6:
        return "F"
    else:
        return ""


def lig_trafo(str_lig):
    if str_lig in ('1', '2', '3', '10'):
        return "Wye"
    else:
        return "Delta"


def ligacao_trafo(strCodFas) -> str:
    if strCodFas == "A" or strCodFas == "B" or strCodFas == "C" or strCodFas == "AN" or strCodFas == "BN" or \
            strCodFas == "CN" or strCodFas == "ABN" or strCodFas == "BCN" or strCodFas == "CAN" or strCodFas == "ABCN":
        return "Wye"
    elif strCodFas == "AB" or strCodFas == "BC" or strCodFas == "CA" or strCodFas == "ABC":
        return "Delta"
    else:
        return ""


def tens_regulador(rel_tp_id):
    if int(rel_tp_id) == 1:
        ten_pri_eq = 138 / math.sqrt(3)
    elif int(rel_tp_id) == 2:
        ten_pri_eq = 69 / math.sqrt(3)
    elif int(rel_tp_id) == 3:
        ten_pri_eq = 34.5 / math.sqrt(3)
    elif int(rel_tp_id) == 4:
        ten_pri_eq = 25 / math.sqrt(3)
    elif int(rel_tp_id) == 5:
        ten_pri_eq = 24.9
    elif int(rel_tp_id) == 6:
        ten_pri_eq = 23 / math.sqrt(3)
    elif int(rel_tp_id) in (7, 8, 9):
        ten_pri_eq = 14.4
    elif int(rel_tp_id) == 10:
        ten_pri_eq = 14.4 / math.sqrt(3)
    elif int(rel_tp_id) == 15:
        ten_pri_eq = 13.8 / math.sqrt(3)
    elif int(rel_tp_id) == 16:
        ten_pri_eq = 7.6
    elif int(rel_tp_id) == 17:
        ten_pri_eq = 7.6 / math.sqrt(3)
    elif int(rel_tp_id) == 18:
        ten_pri_eq = 92 / math.sqrt(3)
    elif int(rel_tp_id) == 19:
        ten_pri_eq = 34.5
    elif int(rel_tp_id) == 20:
        ten_pri_eq = 25
    elif int(rel_tp_id) == 21:
        ten_pri_eq = 23
    elif int(rel_tp_id) == 22:
        ten_pri_eq = 14.4
    elif int(rel_tp_id) in (11, 12, 13, 14, 23):
        ten_pri_eq = 13.8
    elif int(rel_tp_id) == 24:
        ten_pri_eq = 7.6
    else:
        ten_pri_eq = 0.0

    return ten_pri_eq


def quantidade_enrolamentos(strCodFas1, strCodFas2) -> str:
    if strCodFas1 == "BN" or strCodFas1 == "CN" or strCodFas1 == "AN" or strCodFas2 == "ABN":
        return "3"
    else:
        return "2"


def tipo_dia(intTipoDia):
    if intTipoDia == 1:
        return "DU"
    elif intTipoDia == 2:
        return "SA"
    elif intTipoDia == 3:
        return "DO"
    else:
        return ""


def get_tipo_trafo(codi_tipo_trafo):
    # Avalia o tipo do trafo
    if codi_tipo_trafo == 'M':
        tipo_trafo = 1
    elif codi_tipo_trafo == 'MT':
        tipo_trafo = 2
    elif codi_tipo_trafo == 'B':
        tipo_trafo = 3
    elif codi_tipo_trafo == 'T':
        tipo_trafo = 4
    elif codi_tipo_trafo == 'DF':
        tipo_trafo = 5
    elif codi_tipo_trafo == 'DA':
        tipo_trafo = 6
    else:
        tipo_trafo = 0
    return tipo_trafo


def kv_carga(strCodFas, dblTenSecu_kV, intTipTrafo):
    intFase = numero_fases(strCodFas)
    kVCarga = 0.0
    if intTipTrafo == 4:  # trafo trifasico
        if intFase == 1:  # carga monofasica
            kVCarga = f"{(dblTenSecu_kV / math.sqrt(3)):.3f}"
        else:
            kVCarga = str(dblTenSecu_kV)

    if intTipTrafo == 3 or intTipTrafo == 5 or intTipTrafo == 6:  # trafo bifasico ou delta aberto
        if intFase == 1:  # carga monofasica
            kVCarga = f"{(dblTenSecu_kV / 2):.3f}"
        else:
            kVCarga = str(dblTenSecu_kV)

    elif intTipTrafo == 1:  # trafo monofasico
        kVCarga = str(dblTenSecu_kV)

    elif intTipTrafo == 2:  # MRT
        if intFase == 1:
            kVCarga = str(dblTenSecu_kV / 2)
        else:
            kVCarga = str(dblTenSecu_kV)

    return kVCarga


def numero_fases_carga_dss(strFases):
    if strFases == "A" or strFases == "B" or strFases == "C" or strFases == "AN" or strFases == "BN" or \
            strFases == "CN" or strFases == "AB" or strFases == "BC" or strFases == "CA" or strFases == "ABN" or \
            strFases == "BCN" or strFases == "CAN":
        return "1"
    elif strFases == "ABC" or strFases == "ABCN":
        return "3"
    else:
        return ""


def ligacao_gerador(strCodFas, tip_trafo=None):
    # Para gerador bt ligado no secundário do transformador, caso o transformador for tipo Delta Aberto
    # e o gerador trifásico a conexão do gerador deverá ser Delta
    if strCodFas == "ABCN" and tip_trafo == 'DA':
        return "Delta"
    if strCodFas == "A" or strCodFas == "B" or strCodFas == "C" or strCodFas == "AN" or strCodFas == "BN" or \
            strCodFas == "CN" or strCodFas == "ABCN":
        return "Wye"
    # elif strCodFas == "AB" or strCodFas == "BC" or strCodFas == "CA" or strCodFas == "ABN" or strCodFas == "BCN" or \
    #        strCodFas == "CAN" or strCodFas == "ABC":
    # return "Delta"
    else:
        return "Delta"


def get_coord_load(dist, load):
    config = load_config(dist)
    engine = create_connection(config)

    # coordenadas a partir dos dados dos geradores na mesma instalação do consumidor bt
    query_coods = f''' select POINT_X as x, POINT_Y as y
                       from sde.UCBT               
                       where COD_ID = '{load}'           
                    '''
    with engine.connect() as conn:
        coords = conn.execute(query_coods)

    return coords


def set_coords(engine):
    #config = load_config(dist)
    #engine = create_connection(config)
    proc_time_ini = time.time()

    # Atualiza coordenadas UCAT
    query_ucat_ponnot = f'''
                Update sde.ucat set [POINT_Y] = q.Y, [POINT_X] = q.x
                FROM (
                    select  uc.cod_id, pn.[POINT_Y] as Y ,pn.[POINT_X] as X
                    from sde.UCAT uc
                    inner join sde.ponnot pn on pn.COD_ID = uc.PN_CON 
                    ) q
                where sde.UCAT.COD_ID = q.cod_id
                  '''
    with engine.connect() as conn:
        result = conn.execute(query_ucat_ponnot)
        print(f'coords UCAT: {result.rowcount}')

    # Atualiza coordenadas UGAT
    query_ugat_ponnot = f'''
                Update sde.UGAT set [POINT_Y] = q.Y, [POINT_X] = q.x
                FROM (
                    select  ug.cod_id, pn.[POINT_Y] as Y ,pn.[POINT_X] as X
                    from sde.UGAT ug
                    inner join sde.ponnot pn on pn.COD_ID = ug.PN_CON 
                    ) q
                where sde.UGAT.COD_ID = q.cod_id
                  '''
    result = engine.execute(query_ugat_ponnot)
    print(f'coords UGAT: {result.rowcount}')

    # busca coordenadas da subestação conectado ao gerador
    query_ugat_ponnot = f'''
                    Update sde.UGAT set [POINT_Y] = q.Y, [POINT_X] = q.x
                    FROM (
                        select  ug.cod_id, pn.[POINT_Y] as Y ,pn.[POINT_X] as X
                        from sde.UGAT ug
                        inner join sde.ponnot pn on pn.COD_ID = ug.sub 
                        ) q
                    where sde.UGAT.COD_ID = q.cod_id
                      '''
    result = engine.execute(query_ugat_ponnot)
    print(f'coords UGAT by sub: {result.rowcount}')

    query_ucmt_ponnot = f'''
              update sde.ucmt set [POINT_Y] = q.Y, [POINT_X] = q.x
                  FROM (
                      select  uc.cod_id, pn.[POINT_Y] as Y ,pn.[POINT_X] as X
                      from sde.ucmt uc
                      inner join sde.ponnot pn on pn.COD_ID = uc.PN_CON 
                  ) q
              where sde.ucmt.cod_id = q.cod_id
              '''
    result = engine.execute(query_ucmt_ponnot)
    print(f'coords UCMT: {result.rowcount}')

    "Verifica se existem consumidores com coordenadas nulas e utiliza o segmento para associar as coordenadas deles"
    query_coods_ucmt_ssdmt = f'''  
            update sde.ucmt set [POINT_Y] = q.Y, [POINT_X] = q.x
                FROM (
                    select  uc.cod_id, pn.[POINT_Y1] as Y ,pn.[POINT_X1] as X
                    from sde.ucmt uc
                    inner join sde.SSDMT pn on pn.PAC_1 = uc.PAC OR pn.PAC_2=UC.PAC
                    WHERE UC.POINT_X IS NULL
                ) q
            where sde.ucmt.cod_id = q.cod_id
            '''
    result = engine.execute(query_coods_ucmt_ssdmt)
    print(f'coords UCMT_ssdmt: {result.rowcount}')

    query_coods_ugmt_ponnot = f'''
             update sde.ugmt set [POINT_Y] = q.Y, [POINT_X] = q.x
                FROM (
                    select  ug.cod_id, pn.[POINT_Y] as Y ,pn.[POINT_X] as X
                    from sde.ugmt ug
                    inner join sde.ponnot pn on pn.COD_ID = ug.PN_CON 
                ) q
                where sde.ugmt.cod_id = q.cod_id
             '''
    result = engine.execute(query_coods_ugmt_ponnot)
    print(f'coords UGMT: {result.rowcount}')

    query_coods_ugbt_ponnot = f'''
            update sde.ugbt set [POINT_Y] = q.Y, [POINT_X] = q.x
                FROM (
                    select  ugbt.cod_id, pn.[POINT_Y] as Y ,pn.[POINT_X] as X
                    from sde.ugbt ugbt
                    inner join sde.ponnot pn on pn.COD_ID = ugbt.PN_CON 
                ) q
                where sde.ugbt.cod_id = q.cod_id
             '''
    result = engine.execute(query_coods_ugbt_ponnot)
    print(f'coords UGBT: {result.rowcount}')

    query_coods_ucbt_ponnot = f'''
            update sde.ucbt set [POINT_Y] = q.Y, [POINT_X] = q.x
                FROM (
                    select  ucbt.cod_id, pn.[POINT_Y] as Y ,pn.[POINT_X] as X
                    from sde.ucbt ucbt
                    inner join sde.ponnot pn on pn.COD_ID = ucbt.PN_CON 
                ) q
                where sde.ucbt.cod_id = q.cod_id
             '''
    result = engine.execute(query_coods_ucbt_ponnot)
    print(f'coords UCBT: {result.rowcount}')

    # coordenadas a partir dos dados dos geradores na mesma instalação do consumidor bt
    query_coods_ucbt_ugbt = f'''
        update sde.ucbt set [POINT_Y] = q.Y, [POINT_X] = q.x
            FROM (
                select g.POINT_X as x, g.POINT_Y as y, c.sub, c.COD_ID from sde.ucbt c
                inner join sde.ugbt g on c.CEG=g.CEG
                where c.POINT_X is null
            ) as q
        WHERE sde.ucbt.cod_id = q.cod_id 
    '''
    x = engine.execute(query_coods_ucbt_ugbt)
    print(f'coords UCBT_UGBT: {x.rowcount} - time:{round(time.time() - proc_time_ini, 2)} seg')

    "Verifica se existem consumidores BT com coordenadas nulas e utiliza o segmento BT para associar suas coordenadas"
    subs = return_query_as_dataframe("select cod_id from sde.sub where pos='PD' order by cod_id", engine)
    for sub in subs['cod_id']:
        query_coods_ucbt_ssdmt = f'''  
            WITH CTE_UCBT AS (
                SELECT
                    cod_id,
                    PAC
                FROM
                    sde.ucbt
                WHERE
                    POINT_X IS NULL and sub='{sub}'
            ),
            CTE_RAMLIG AS (
                SELECT
                    PAC_1,
                    PAC_2
                FROM
                    sde.ramlig where sub='{sub}'
            ),
            CTE_SSDBT AS (
                SELECT
                    PAC_1,
                    PAC_2,
                    POINT_X1,
                    POINT_Y1
                FROM
                    sde.SSDBT where sub='{sub}'
            )
            update sde.ucbt set [POINT_Y] = q.Y, [POINT_X] = q.x
               FROM (
            SELECT
                uc.cod_id,
                pn.POINT_Y1 as y,
                pn.POINT_X1 as x
            FROM
                CTE_UCBT uc
            INNER JOIN
                CTE_RAMLIG rm
                ON rm.PAC_1 = uc.PAC OR rm.PAC_2 = uc.PAC			
            INNER JOIN
                CTE_SSDBT pn
                ON pn.PAC_1 IN (rm.PAC_1, rm.PAC_2) OR pn.PAC_2 IN (rm.PAC_1, rm.PAC_2)					
            ) q
            where sde.ucbt.cod_id = q.cod_id
            '''
        x = engine.execute(query_coods_ucbt_ssdmt)
        print(f'coords UCBT_SSDBT: {sub} - {x.rowcount} - {time.time() - proc_time_ini}')

        query_ucbt_untrmt = f"""
                update sde.ucbt set [POINT_Y] = q.Y, [POINT_X] = q.x
                    FROM (
                        select tr.POINT_X as x, tr.POINT_Y as y, uc.sub, uc.COD_ID, uc.PAC, rm.PAC_2
                        from sde.ucbt uc
                        inner join sde.RAMLIG rm ON rm.PAC_1 = uc.PAC OR rm.PAC_2 = uc.PAC
                        inner join sde.UNTRMT tr ON rm.pac_1 = tr.PAC_2 or rm.PAC_2 = tr.PAC_2
                        where uc.POINT_X is null and uc.sub = '{sub}'
                    ) as q
                WHERE sde.ucbt.cod_id = q.cod_id 
                """
        result = engine.execute(query_ucbt_untrmt)
        print(f'coords UCBT_untrmt: {sub} - {result.rowcount} - {time.time() - proc_time_ini}')

    print(f"Processo concluído em {time.time() - proc_time_ini}")


def ajust_eqre_codbanc(dist, engine):
    """
    Obtém os valores de CodBNC a partir da sequência de dados da UNREMT
    :return: Dicionário com os codi_id da tabela EQRE com os respetivos valores de CodBNC
    """
    query = f'''
        SELECT c.COD_ID, c.PAC_1, c.PAC_2, c.Sub, c.TIP_REGU, c.BANC, c.FAS_CON, c.CTMT,
            e.cod_id as COD_ID_RE, e.[POT_NOM], e.[TEN_REG], e.[LIG_FAS_P], e.[LIG_FAS_S], e.[COR_NOM], 
            e.[REL_TP], e.[REL_TC], e.[PER_FER], e.[PER_TOT], e.[R], e.[XHL], e.[CodBnc], e.[GRU_TEN]
        FROM SDE.UNREMT as c, SDE.EQRE as e 
         WHERE c.dist = '{dist}' and c.SIT_ATIV = 'AT' and (
         (c.pac_1 = e.pac_1 or c.pac_2 = e.pac_2 or c.pac_1 = e.pac_2 or c.pac_2 = e.pac_1) or c.COD_ID = e.UN_RE)
         order by c.[COD_ID]
        ;
    '''
    eqre_data = return_query_as_dataframe(query, engine)
    # codbanc_re = []
    i = 0
    unremt_id = ''
    # strcodbanc_re = ''
    for index in range(eqre_data.shape[0]):
        if unremt_id != eqre_data.loc[index]['COD_ID']:
            i = 1
        else:
            i += 1
        unremt_id = eqre_data.loc[index]['COD_ID']
        eqre_id = eqre_data.loc[index]['COD_ID_RE']
        # strcodbanc_re = {'cod_id': eqre_id, 'codBNC': i}
        # codbanc_re.append(strcodbanc_re)

        sql = f"update SDE.EQRE SET codBNC={i} where COD_ID='{eqre_id}'"
        exec_query(sql, engine)

    # return codbanc_re


def add_id_banc_to_dataframe(df, df_column_ref):
    i = 0
    ref_count = ''
    df.sort_values(by=['COD_ID'], ascending=True, inplace=True)
    df.reset_index(drop=True, inplace=True)
    for index in range(df.shape[0]):
        if ref_count != df.loc[index][df_column_ref]:
            i = 1
        else:
            i += 1
        ref_count = df.loc[index][df_column_ref]
        df.at[index, 'ID_BANC'] = i


def calc_du_sa_do_mes(ano, mes: int) -> dict:
    # Gerar intervalo de datas para o mês especificado
    data_inicial = f'{ano}-{mes:02d}-01'
    data_final = pd.Period(f'{ano}-{mes:02d}').end_time.strftime('%Y-%m-%d')
    dias = pd.date_range(start=data_inicial, end=data_final)

    # Criar um conjunto de feriados para São Paulo, Brasil
    feriados_brasil = holidays.Brazil(state='SP')

    # Inicializar contadores
    uteis = 0
    sabados = 0
    domingos = 0
    feriados = 0

    for dia in dias:
        if dia in feriados_brasil:
            # Contar como feriado, mesmo que caia em sábado ou domingo
            feriados += 1
        elif dia.weekday() == 5:  # Sábado
            sabados += 1
        elif dia.weekday() == 6:  # Domingo
            domingos += 1
        else:  # Dias úteis
            uteis += 1

    return {
        'DU': uteis,
        'SA': sabados,
        'DO': domingos + feriados
    }


def circuit_by_bus(pac: str, dist):
    config = load_config(dist)
    engine = create_connection(config)
    pac = pac.upper()
    query = f'''
         SELECT DISTINCT CTMT
         FROM SDE.SSDMT 
         WHERE pac_1 = '{pac}' or pac_2 = '{pac}'
         ;
    '''
    ctmt = return_query_as_dataframe(query, engine)
    if ctmt.empty:
        ctmt["CTMT"] = [pac]
    return ctmt


def municipio_from_load(load, dist):
    """
    Obtem o cod do munício onde está instalada uma carga.
    :return:
    """
    config = load_config(dist)
    engine = create_connection(config)
    # load = load.upper()
    tabelas = ["UCBT", "UCMT"]
    for table in tabelas:
        query = f'''
             SELECT distinct MUN FROM SDE.{table} 
             WHERE COD_ID = '{load}' 
             ;
        '''

        mun = return_query_as_dataframe(query, engine)
        if not mun.empty:
            return mun['MUN'].iloc[0]

    return False


def irrad_by_municipio(cod_municipio, mes,  dist):
    config = load_config(dist)
    engine = create_connection(config)
    query = f'''
                SELECT avg([GT(I)_MEAN]) as irrad, avg([GT(I)_STD]) as irrad_std, hora
                FROM [IRRADIANCIA].SDE.IRRAD 
                WHERE cod_municipio = '{cod_municipio}' and mes = '{mes}'
                group by COD_MUNICIPIO, hora
                order by hora
                ;
            '''
    irrad = return_query_as_dataframe(query, engine)
    if irrad.empty:
        irrad_list = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.213170, 0.493614, 0.767539, 0.930065, 1.000000,
                0.908147, 0.682011, 0.461154, 0.024685, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        return irrad_list
    return irrad['irrad'].tolist()


def temp_amb_by_municipio(cod_municipio, mes,  dist):
    config = load_config(dist)
    engine = create_connection(config)
    query = f'''
            SELECT avg(T2M_MEAN) as temperatura, avg(T2M_STD) as temp_std, hora
            FROM [IRRADIANCIA].SDE.IRRAD 
            WHERE cod_municipio = '{cod_municipio}' and mes = '{mes}'
            group by COD_MUNICIPIO, hora
            order by hora
            ;
        '''
    temp_ta = return_query_as_dataframe(query, engine)
    return temp_ta['temperatura'].tolist()


def temp_amb_to_temp_pv(crv_g=None, crv_ta=None) -> dict:
    """
    Converte a curva de temperatura ambiente em curva de temperatura na superficie do painel solar
    LASNIER, F.; ANG, T. G. Photovoltaic Engineering Handbook, New York, Adam Hilger, pp: 258, 1990.
    𝑇𝑐 = 30.006 + 0.0175(𝐺 −300)+1.14(𝑇𝑎 −25)
    Ta = Temperatura ambiente em oC
    G  = Irradiância total em W/m²

    Schott, T., 1985. Operation temperatures of PV 78: 163-176.
    modules. Proceedings of the sixth E.C. photovoltaic 24. Mondol, J.D., Y.G. Yohanis and B. Norton, 2007a.
    solar energy conference, London, UK, pp: 392-396.
    Tc = Ta + (0.028 × G) – 1

    :return: dict
    """
    if crv_g is None or not crv_g:
        # valor default para quando não existir dados de irradiação solar
        crv_g = [0, 0, 0, 0, 0, 0, 53.84, 186.42, 371.93, 491.11, 634.01, 722.82, 795.12, 736.89, 641.51, 476.68,
                 252.55, 121.78, 32.7, 0, 0, 0, 0, 0]
    if crv_ta is None or not crv_ta:
        # valor default para quando não existir dados de temperatura ambiente
        crv_ta = [21.81, 21.48, 21.24, 20.98, 20.78, 20.62, 20.59, 21.88, 23.21, 24.36, 25.36, 26.17, 26.76, 27.2,
                  27.61, 28.73, 27.11, 26.03, 25.25, 24.32, 23.6, 23.45, 22.82, 22.22]

    # Verifica se as listas são do mesmo tamanho
    if len(crv_g) != len(crv_ta):
        raise ValueError("As listas de temp. ambiente e de irradiação devem ter o mesmo tamanho.")

    data = {'crv_ta': crv_ta,
            'crv_g': crv_g,
            'crv_g_norm': [round(irrad / max(crv_g), 6) for irrad in crv_g],
            'crv_t_pv_1': [round(30.006 + 0.0175 * (crv_g[i] - 300) + 1.14 * (crv_ta[i] - 25), 2)
                           for i in range(len(crv_g))],
            'crv_t_pv_2': [round(crv_ta[i] + (0.028 * crv_g[i]) - 1, 2) for i in range(len(crv_g))]
            }
    return data


def fator_autoconsumo(classe):
    """
    Fatores típicos de autoconsumo definido pela EPE
    :param classe:
    :return:
    """
    fator_auto = None
    if classe == 1:  # residencial
        fator_auto =  0.4
    elif classe == 2:  # comercial bt
        fator_auto =  0.5
    elif classe == 3:  # comercial mt
        fator_auto =  0.8
    return fator_auto


def list_substation(dist):
    """
    Busca a lista de códigos de subestações próprias de uma distribuidora.
    :param dist:
    :return:
    """
    config = load_config(dist)
    engine = create_connection(config)
    query = f'''
                SELECT COD_ID 
                FROM SDE.SUB 
                WHERE dist = {dist}  and POS = 'PD"              
                order by sub
                ;
            '''
    list_sub = return_query_as_dataframe(query, engine)

    return list_sub['COD_ID'].tolist()


def exec_sp_atualiza_v10(dist, data_base, engine):
    """
    Executa stored procedure no banco de dados para atualização de pacs.
    :param dist:
    :param data_base:
    :param engine:
    :return:
    """
    query = f'''
    SET NOCOUNT ON;
    DECLARE @return_value int
    EXEC @return_value = [sde].[_ATUALIZA_V1.0] 
        @dist = N'{dist}', 
        @data_base = '{data_base}'
    SELECT 'Return Value' = @return_value
    '''

    connection = engine.raw_connection()
    # engine.autocommit = True
    sleep = 0
    timeout = 200
    try:
        cursor = connection.cursor()
        cursor.execute(query)
        while cursor.nextset():
            if sleep >= timeout:
                break
            time.sleep(1)
            sleep += 1
        print(sleep)
        cursor.close()
        connection.commit()
    finally:
        connection.close()


def get_coods_by_annel(ceg):
    """
    Busca diretamento do site da ANEEL as informações da base de dados de empreendimentos de geração
    as coordenadas são utilizadas para atualizar as informações da BDGD
    https://dadosabertos.aneel.gov.br/dataset/siga-sistema-de-informacoes-de-geracao-da-aneel/resource/11ec447d-698d-4ab8-977f-b424d5deee6a
    :return:
    """
    '4318d38a-0bcd-421d-afb1-fb88b0c92a87' # código da api para acesso a UCAT_PJ.csv
    'f6671cba-f269-42ef-8eb3-62cb3bfa0b98' # código da api para acesso a UCMT_PJ.csv

    # url = 'https://dadosabertos.aneel.gov.br/api/3/action/datastore_search_sql?sql=SELECT%20*%20FROM%20%22fcf2906c-7c32-4b9b-a637-054e7a5234f4%22%20WHERE%20%22SigAgente%22%20%3D%20%27Equatorial%20AL%27%20AND%20%22DscSubGrupo%22%20%3D%20%27B3%27%20AND%20%22DscClasse%22%20%3D%20%27N%C3%A3o%20se%20aplica%27%20AND%20%22SigAgenteAcessante%22%20IN%20(%27NA%27,%20%27N%C3%A3o%20se%20aplica%27)%20AND%20%22DscBaseTarifaria%22%20%3D%20%27Tarifa%20de%20Aplica%C3%A7%C3%A3o%27%20AND%20%22DscSubClasse%22%20%3D%20%27N%C3%A3o%20se%20aplica%27%20AND%20%22DscModalidadeTarifaria%22%20%3D%20%27Convencional%27%20AND%20%22NomPostoTarifario%22%20%3D%20%27N%C3%A3o%20se%20aplica%27%20ORDER%20BY%20%22DatInicioVigencia%22%20DESC%20LIMIT%201'
    # url = 'https://dadosabertos.aneel.gov.br/api/3/action/datastore_search?resource_id=2f65a1b0-19b8-4360-8238-b34ab4693d55&limit=5&'
    # url = 'https://dadosabertos.aneel.gov.br/api/3/action/datastore_search_sql?sql=SELECT%20*%20from%20%222f65a1b0-19b8-4360-8238-b34ab4693d55%22%20WHERE%20_id=1'
    # url = 'https://dadosabertos.aneel.gov.br/api/3/action/datastore_search_sql?sql=SELECT%20*%20from%20%222f65a1b0-19b8-4360-8238-b34ab4693d55%22%20WHERE%20%22_id%22=1'
    # url = 'https://dadosabertos.aneel.gov.br/api/3/action/datastore_search?resource_id=2f65a1b0-19b8-4360-8238-b34ab4693d55&limit=5'

    campo = 'CodCEG'
    valor = 'PCH.PH.MG.000008%'
    valor = f'{ceg}%'
    url = f'https://dadosabertos.aneel.gov.br/api/3/action/datastore_search_sql?sql=SELECT%20*%20from%20%222f65a1b0-19b8-4360-8238-b34ab4693d55%22%20WHERE%20%22{campo}%22%20LIKE%20%27{valor}%27%20'

    req = urllib.request.Request(url)
    with urllib.request.urlopen(req) as response:
        page = response.read()
        # print(page)
        encoding = response.info().get_content_charset('utf-8')
        JSON_object = json.loads(page.decode(encoding))
        json_result = JSON_object.get('result')
        json_records = json_result.get('records')
    return json_records


def get_list_ceg(dist, engine):
    query = f'''
                SELECT CEG FROM SDE.UGAT where dist ='{dist}' order by sub        
                ;
            '''
    list_sub = return_query_as_dataframe(query, engine)
    return list_sub['CEG'].tolist()


def update_coords_by_aneel(dist, engine):
    """
    Atualiza a base de dados da BDGD com as coordenadas obtidas da base de dados de empreendimentos da ANEEL
    :param dist:
    :param engine:
    :return:
    """
    dist = dist
    list_ceg = get_list_ceg(dist, engine)

    ceg = 'UTE.AI.RN.028605-2'
    for ceg in list_ceg:
        coord_aneel_dict = get_coods_by_annel(ceg)
        y = coord_aneel_dict[0].get('NumCoordNEmpreendimento').replace(',', '.')
        x = coord_aneel_dict[0].get('NumCoordEEmpreendimento').replace(',', '.')
        """
        print(coord_aneel_dict[0].get('CodCEG'))
        print(coord_aneel_dict[0].get('MdaPotenciaOutorgadaKw'))
        print(coord_aneel_dict[0].get('MdaPotenciaFiscalizadaKw'))
        print(coord_aneel_dict[0].get('DscTipoOutorga'))
        print(x)
        print(y)
        """
        query = f'''Update sde.UGAT set [POINT_Y]={y}, [POINT_X]={x} Where sde.UGAT.CEG='{ceg}' '''
        print(query)
        connection = engine.raw_connection()
        try:
            cursor = connection.cursor()
            cursor.execute(query)
            cursor.close()
            connection.commit()
        finally:
            connection.close()
    print('Fim!')


if __name__ == "__main__":

    database = '404'
    #database = '6600_2022'
    config = load_config(database)
    dist = config['dist']

    engine = create_connection(config)
    update_coords_by_aneel(dist, engine)

    # set_coords(engine)

    """
    import matplotlib.pyplot as plt
    import matplotlib
    matplotlib.use('TKAgg')
    t = temp_amb_by_municipio('3539806', 7, '391')
    print(t)

    ir = irrad_by_municipio('3539806', 7, '391')
    print(ir)

    test = temp_amb_to_temp_pv(ir, t)  # teste temperatura ambiente para temperatura do pv.
    print(test['crv_t_pv_1'])
    print(test['crv_t_pv_2'])
    print(test['crv_g_norm'])

    plt.plot(t)
    plt.plot(test['crv_t_pv_1'])
    plt.plot(test['crv_t_pv_2'])
    plt.show()
    """


