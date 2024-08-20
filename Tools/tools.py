# -*- encoding: utf-8 -*-
import math
import os
import time

import pandas as pd
import geopandas as gpd
import logging
import pyodbc
import fiona
import yaml
from sqlalchemy import create_engine

list_names_tables = ['EQTRAT', 'EQTRMT', 'UNTRAT', 'UNTRMT']

application_path = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(application_path, r'../config_database.yml'), 'r') as file:
    config_bdgd = yaml.load(file, Loader=yaml.BaseLoader)

schema = config_bdgd['bancos']['schema']

print(os.path.expanduser(config_bdgd['dss_files_folder']))


def create_connection_pyodbc():
    """Função para criar uma conexão com o banco de dados SQL Server"""
    conn_str = (
            'DRIVER={ODBC Driver 17 for SQL Server};'
            'SERVER=' + config_bdgd['bancos']['server'] + ';'
                                                          'DATABASE=' + config_bdgd['bancos']['database'] + ';'
                                                                                                            'UID=' +
            config_bdgd['bancos']['username'] + ';'
                                                'PWD=' + config_bdgd['bancos']['password']
    )
    return pyodbc.connect(conn_str)


def create_connection():
    """Função para criar uma conexão com o banco de dados SQL Server"""

    engine = create_engine(f"mssql+pyodbc://"
                           f"{config_bdgd['bancos']['username']}:"
                           f"{config_bdgd['bancos']['password']}@"
                           f"{config_bdgd['bancos']['server']}/"
                           f"{config_bdgd['bancos']['database']}?"
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

            # * cuidado o arquivo de log pode ficar muito grande
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


def process_gdb_files(gdb_file, engine, data_base, data_carga, column_renames):
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

                df = gpd.read_file(gdb_file, driver="pyogrio", layer=table_name, rows=slice(row_ini, row_end, 1),
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
                                     'UNTRAT', 'UNTRS', 'UNSEMT', 'UNSEAT']
                if table_name_sql in list_table_coords:
                    if df.iloc[0]['geometry'].geom_type == 'Point':
                        df['POINT_Y'] = df['geometry'].y  # lat
                        df['POINT_X'] = df['geometry'].x  # lon

                    if df.iloc[0]['geometry'].geom_type == 'MultiLineString':
                        df['POINT_Y1'] = df['geometry'][0].bounds[0]
                        df['POINT_X1'] = df['geometry'][0].bounds[1]
                        df['POINT_Y2'] = df['geometry'][1].bounds[0]
                        df['POINT_X2'] = df['geometry'][1].bounds[1]

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
                    df.to_sql(table_name_sql, engine, schema=schema, index=False,
                              if_exists="append", chunksize=None, method=None)
                    print(f"Concluído em {round(time.time() - proc_table_time_ini, 3)} segundos.")
                    logging.info(f"{table_name}: \tProc concluído em {time.time() - proc_table_time_ini} sec.")

                    if table_name_ori != "":
                        print(table_name_ori)
                        df.to_sql(table_name_ori, engine, schema=schema, index=False,
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
                        engine = create_connection()
                        time.sleep(5)
                        df.to_sql(table_name_sql,
                                  engine,
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


def return_query_as_dataframe(query: str) -> pd.DataFrame:
    engine = create_connection()
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


def exec_query(query: str):
    engine = create_connection()
    with engine.begin() as conn:  # TRANSACTION
        conn.execute(query)


def write_to_dss(dist, sub, circuito, linhas_arquivos_list: list, nome_arquivo: str) -> bool:
    """
    Função que escreve arquivos DSS (OpenDSS) representativos dos objetos de rede carregada em memória.
    :param nome_arquivo:
    :param circuito:
    :param sub:
    :param linhas_arquivos_list: lista de dicionários, sendo um referente a cada circuito.
    :return: bool
    """
    # Escreve os arquivos DSS, sendo agrupados em um diretório para cada circuito
    nome_arquivo += '_' + circuito
    try:
        path_dss_files = os.path.expanduser(config_bdgd['dss_files_folder'])
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


def tap_trafo(strCodFas3, tap_pu) -> str:
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
    elif strCodFas3 == "0" or strCodFas2 == "AN" or strCodFas2 == "BN" or strCodFas2 == "CN" or strCodFas2 == "AB" or strCodFas2 == "BC" or strCodFas2 == "CA" or strCodFas2 == "AC" or strCodFas2 == "ABCN" or strCodFas2 == "ABC":
        return str(dblPotNom_kVA) + " " + str(dblPotNom_kVA)
    else:
        return ""


def tensao_enrolamento(strCodFas, dblTensao_kV):
    """
    Uma vez que o manual da BDGD aponta que esta tensão já é a tensão do equipamento em si,
     basta adotar estão tensão informada, sem precisar divir por raiz de 3.
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


def ligacao_trafo(strCodFas) -> str:
    if strCodFas == "A" or strCodFas == "B" or strCodFas == "C" or strCodFas == "AN" or strCodFas == "BN" or \
            strCodFas == "CN" or strCodFas == "ABN" or strCodFas == "BCN" or strCodFas == "CAN" or strCodFas == "ABCN":
        return "Wye"
    elif strCodFas == "AB" or strCodFas == "BC" or strCodFas == "CA" or strCodFas == "ABC":
        return "Delta"
    else:
        return ""


def tens_regulador(rel_tp_id):
    if int(rel_tp_id) == 3:
        ten_pri_eq = 34.5 / math.sqrt(3)
    elif int(rel_tp_id) == 4:
        ten_pri_eq = 25 / math.sqrt(3)
    elif int(rel_tp_id) == 6:
        ten_pri_eq = 23 / math.sqrt(3)
    elif int(rel_tp_id) == 10:
        ten_pri_eq = 14.4 / math.sqrt(3)
    elif int(rel_tp_id) == 15:
        ten_pri_eq = 13.8 / math.sqrt(3)
    elif int(rel_tp_id) == 17:
        ten_pri_eq = 7.6 / math.sqrt(3)
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
    if intTipTrafo == 4: # trafo trifasico
        if intFase == 1: # carga monofasica
            kVCarga = f"{(dblTenSecu_kV / math.sqrt(3)):.3f}"
        else:
            kVCarga = str(dblTenSecu_kV)

    if intTipTrafo == 3 or intTipTrafo == 5 or intTipTrafo == 6:  # trafo bifasico
        if intFase == 1: # carga monofasica
            kVCarga = f"{(dblTenSecu_kV / 2):.3f}"
        else:
            kVCarga = str(dblTenSecu_kV)

    elif intTipTrafo == 1:   # trafo monofasico
        kVCarga = str(dblTenSecu_kV)

    elif intTipTrafo == 2:   # MRT
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


def ligacao_gerador(strCodFas):
    if strCodFas == "A" or strCodFas == "B" or strCodFas == "C" or strCodFas == "AN" or strCodFas == "BN" or \
            strCodFas == "CN" or strCodFas == "ABCN":
        return "Wye"
    # elif strCodFas == "AB" or strCodFas == "BC" or strCodFas == "CA" or strCodFas == "ABN" or strCodFas == "BCN" or \
    #        strCodFas == "CAN" or strCodFas == "ABC":
    # return "Delta"
    else:
        return "Delta"


def ajust_eqre_codbanc(dist):
    """
    Obtém os valores de CodBNC a partir da sequencia de dados da UNREMT
    :return: Dicionário com os codi_id da tabela EQRE com os respectivos valores de CodBNC
    """
    query = f'''
         SELECT c.COD_ID, c.PAC_1, c.PAC_2, c.Sub, c.TIP_REGU, c.BANC, c.FAS_CON, c.CTMT,
                e.cod_id as COD_ID_RE, e.[POT_NOM], e.[TEN_REG], e.[LIG_FAS_P], e.[LIG_FAS_S], e.[COR_NOM],
                e.[REL_TP], e.[REL_TC], e.[PER_FER], e.[PER_TOT], e.[R], e.[XHL], e.[CodBnc], e.[GRU_TEN]
         FROM SDE.UNREMT as c, SDE.EQRE as e
         WHERE c.dist = '{dist}' and c.SIT_ATIV = 'AT' and
         (c.pac_1 = e.pac_1 or c.pac_2 = e.pac_2 or c.pac_1 = e.pac_2 or c.pac_2 = e.pac_1) order by c.[COD_ID]
         ;
    '''
    eqre_data = return_query_as_dataframe(query)
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
        exec_query(sql)

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
