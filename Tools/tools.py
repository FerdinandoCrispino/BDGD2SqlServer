# -*- encoding: utf-8 -*-

import os
import time

import pandas as pd
import geopandas as gpd
import logging
import pyodbc
import fiona
import yaml
from sqlalchemy import create_engine

application_path = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(application_path, r'../config_database.yml'), 'r') as file:
    config_bdgd = yaml.load(file, Loader=yaml.BaseLoader)

schema = config_bdgd['bancos']['schema']


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


# Ajusta o CodBnc dos reguladores
def ajust_regulators(dataFrame):
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
                                   ignore_geometry=True, use_arrow=True)
                print(f"Leitura de {len(df.index)} reg. em {round(time.time() - proc_table_parse_time_ini, 3)} de "
                      f"{round(time.time() - proc_table_time_ini, 3)} segundos.")

                if df.empty:
                    break

                df = df.rename(column_renames, axis='columns')
                df['OBJECTID'] = range(row_ini + 1, 1 + len(df) + row_ini)
                df['DATA_BASE'] = data_base
                df['DATA_CARGA'] = data_carga
                # df = df[['OBJECTID'] + [col for col in df.columns if col != 'OBJECTID']]

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
                    df.to_sql(table_name_sql, engine, schema=schema, index=False,
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
