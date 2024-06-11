import os
import time
import pandas as pd
import geopandas as gpd
import fiona
from datetime import datetime
import yaml
import logging
import sqlalchemy

# Leitura do arquivo de configuração
application_path = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(application_path, r'config_database.yml'), 'r') as file:
    config_bdgd = yaml.load(file, Loader=yaml.BaseLoader)

# Configuração do logger
logging.basicConfig(filename='processamento_dados.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')

# Mapeamento de renomeação de colunas: {'nome_antigo': 'nome_novo'}
columns_rename = {'Shape_Leng': 'Shape_STLength__',
                  'Shape_Length': 'Shape_STLength__',
                  'Shape_Area': 'Shape_STArea__'}


# Função para criar uma conexão com o banco de dados SQL Server
def create_connection():
    return sqlalchemy.create_engine(f"mssql+pyodbc://"
                                    f"{config_bdgd['bancos']['username']}:"
                                    f"{config_bdgd['bancos']['password']}@"
                                    f"{config_bdgd['bancos']['server']}/"
                                    f"{config_bdgd['bancos']['database']}?"
                                    f"driver=ODBC+Driver+17+for+SQL+Server",
                                    fast_executemany=True, pool_pre_ping=True)


def insert_BDGD_consolidada(conn, data_base, data_carga, dist, cod_bdgd):
    conn.execute(f"insert into [sde].[NVAL_BDGD_CONSOLIDADA] "
                 f"(OBJECTID,STATUS_CARGA,ENTIDADE,DATA_BASE,DIST,COD_BDGD,DATAHORA_CARGA,N_REGISTROS, DATA_BASE_DT) "
                 f"values(2,1,'BASE',{data_base},{dist},{cod_bdgd},{data_carga},1,{data_base})")


# Função para processar arquivos GeoDatabase
def process_gdb_files(gdb_file, engine, data_base, data_carga, column_renames):
    with engine.connect() as conn:
        # gdf = gpd.read_file(gdb_file)
        layerlist = fiona.listlayers(gdb_file)
        for table_name in layerlist:
            print(f"{table_name}")
            proc_table_time_ini = time.time()

            # verifica se o arquivo já foi processado
            table_name_sql = table_name.replace('_tab', '')
            if config_bdgd['bancos']['schema'] != '':
                full_table_name = f'{config_bdgd["bancos"]["schema"]}.{table_name_sql}'
            try:
                exist_info = pd.read_sql_query(f"SELECT TOP(1) * FROM {full_table_name}", conn)
            except Exception as e:
                if '42S02' in e.args[0]:  # tabela não existe
                    logging.info(f"{table_name}: \tNão existe no SQL Server.")
                    print(f"{table_name}: \tNão existe no SQL Server.")
                    continue

            if len(exist_info) > 0:
                logging.info(f"{table_name}: \tNão processado. Tabela possui dados.")
                print(f"{table_name}: \tNão processado. Tabela possui dados.")
                continue
            """
            Leitura e inserção de dados de um grupo limitado de linhas para evitar erro de falta de memoria. A
            variavel row_step indica a quantidade de linhas lidas da tabela da BDGD e posterior inserção no SQLServer
            
            """
            row_ini = 0
            row_step = 100000
            row_end = row_step
            while True:
                proc_table_parse_time_ini = time.time()
                df = gpd.read_file(gdb_file, driver="pyogrio", layer=table_name, rows=slice(row_ini, row_end, 1),
                                   ignore_geometry=True, use_arrow=True)
                row_ini += row_step
                row_end = row_ini + row_step
                print(f"Leitura de {len(df.index)} reg. em {round(time.time() - proc_table_parse_time_ini, 3)} de "
                      f"{round(time.time() - proc_table_time_ini, 3)} segundos.")
                if df.empty:
                    break

                df = df.rename(column_renames, axis='columns')
                df['OBJECTID'] = range(1, 1 + len(df))
                df['DATA_BASE'] = data_base
                df['DATA_CARGA'] = data_carga
                # df = df[['OBJECTID'] + [col for col in df.columns if col != 'OBJECTID']]

                # Localizando colunas que não exitem nas tabelas do sqlserver
                list_col = conn.execute("SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=?",
                                        table_name_sql)
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
                    df.to_sql(table_name_sql, engine, schema=config_bdgd['bancos']['schema'], index=False,
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
                        df.to_sql(table_name_sql, engine, schema=config_bdgd['bancos']['schema'], index=False,
                                  if_exists="append", chunksize=None, method=None)
                    else:
                        logging.error(f"Erro ao ler o arquivo {gdb_file}: {e}")
                        return

            if df.empty:
                logging.info(f"{table_name}: da BDGD sem dados.")
                print(f"{table_name}: da BDGD sem dados..")
                continue


if __name__ == "__main__":
    proc_time_ini = time.time()
    # Conectando ao banco de dados sqlserver using sqlalchemy
    try:
        engine = create_connection()
    except Exception as e:
        logging.error(f"Erro ao conectar ao banco de dados: {e}")
        exit(1)

    # Tipo do arquivo para processamento
    data_type = config_bdgd['tipo_arquivo']
    # Valores dos campos adicionais
    data_base = config_bdgd['data_base']
    data_carga = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    # localização do arquivo do BDGD
    gdb_file = os.path.join(config_bdgd['gdb_directory'], config_bdgd['gdb_file'])

    # Processa o arquivo de dados da BDGD
    process_gdb_files(gdb_file, engine, data_base, data_carga, columns_rename)

    engine.dispose()
    logging.info(f"Processo concluído em {time.time() - proc_time_ini} ")
    print(f"Processo concluído em {time.time() - proc_time_ini}")
