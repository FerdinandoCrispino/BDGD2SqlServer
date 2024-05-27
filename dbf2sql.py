import os
import glob
import pyodbc
from dbfread import DBF
from datetime import datetime
import pandas as pd
import logging

# Configuração do logger
logging.basicConfig(filename='processamento_dbf.log',level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')


# Função para criar uma conexão com o banco de dados SQL Server
def create_connection(server, database, username, password):
    conn_str = (
            'DRIVER={ODBC Driver 17 for SQL Server};'
            'SERVER=' + server + ';'
                                 'DATABASE=' + database + ';'
                                                          'UID=' + username + ';'
                                                                              'PWD=' + password
    )
    return pyodbc.connect(conn_str)


# Remove colunas do dbf. Para o caso do SqlServer não ter a coluna no seu modelo de dados
def remove_columns(data_dbf, columns_to_remove: list):
    for record in data_dbf:
        for column in columns_to_remove:
            if column in record.keys():
                del record[column]
    return data_dbf


# Renomeia colunas do dbf. Para os casos onde o modelo de dados do sqlserver tem colunas com nome diferentes do dbf
def rename_columns(data_dbf, columns_rename: dict):
    for record in data_dbf:
        for old_name, new_name in columns_rename.items():
            if old_name in record:
                record[new_name] = record.pop(old_name)
    return data_dbf


# Função para inserir dados no banco de dados com tratamento de erro
def insert_data(cursor, table_name, data, data_base, data_carga):
    if not data:
        return

    # adiciona novos campos a todos os registros
    for record in data:
        record['DATA_BASE'] = data_base
        record['DATA_CARGA'] = data_carga

    placeholders = ', '.join('?' * len(data[0].keys()))
    columns = ', '.join(data[0].keys())

    sql = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"
    for row in data:
        try:
            print(sql)
            print(tuple(row.values()))
            cursor.execute(sql, tuple(row.values()))
            # cuidado o arquivo de log pode ficar muito grande
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
    print(f"Dados inseridos com exito na tabela {table_name}.  ")
    cursor.execute('SET ANSI_WARNINGS on;')


# Configurações de conexão com o SQL Server
server = 'localhost'
database = 'GEO_SIGR_PERDAS'
username = 'usr_GeoPerdas'
password = '123456'
schema = 'SDE'

# Diretório contendo os arquivos DBF
dbf_directory = 'D:\\Doutorado\\PD\dados\\BDGD\\Energisa\\Shapefile'

# Valores dos campos adicionais
data_base = "2022-12-31"
data_carga = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

if __name__ == "__main__":
    # Conectando ao banco de dados sqlserver
    conn = create_connection(server, database, username, password)
    cursor = conn.cursor()

    # Buscando todos os arquivos DBF no diretório
    dbf_files = glob.glob(os.path.join(dbf_directory, '*.dbf'))

    for dbf_file in dbf_files:
        # Extraindo o nome do arquivo (sem extensão) para usar como nome da tabela
        table_name = os.path.splitext(os.path.basename(dbf_file))[0]
        if schema != '':
            table_name = f'{schema}.{table_name}'

        try:
            # Lendo o arquivo DBF
            table = DBF(dbf_file)
        except Exception as e:
            logging.info(f'Erro ao ler o arquivo {dbf_file}: {e}')
            print(f"Erro ao ler o arquivo {dbf_file}: {e}")
            continue

        # verifica se o dbf tem dados
        if len(table) == 0:
            logging.info(f'Erro, arquivo sem dados {dbf_file}')
            print(f"Erro, arquivo sem dados {dbf_file}.")
            continue

        # Convertendo os dados para uma lista de dicionários
        data = [record for record in table]

        # Alterando nome de colunas do dbf de algumas tabelas
        # if table_name in ('SDE.ARAT', 'SDE.CONJ', 'SDE.SSDAT'):
        #columns = data[0].keys().replace('Shape_Area', 'Shape_STArea__')
        #columns = columns.replace('Shape_Leng', 'Shape_STLength__')

        columns_rename = {'Shape_Leng': 'Shape_STLength__', 'Shape_Area': 'Shape_STArea__'}
        data = rename_columns(data, columns_rename)

        # Localizando colunas do dbf que não exitem no sqlserver
        cursor.execute("SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=?",
                       table_name.split(".")[1])
        listCol = cursor.fetchall()
        if len(listCol) > 0:
            listColSql = [row[0] for row in listCol]
            columns = ', '.join(data[0].keys())
            listColDbf = columns.split(',')

            coldiff = [i.strip() for i in listColDbf if i.strip() not in listColSql]

        # Removendo colunas do dbf que não exitem no sqlserver
        if len(coldiff) > 0:
            data = remove_columns(data, coldiff)

        # Inserindo os dados no banco de dados
        insert_data(cursor, table_name, data, data_base, data_carga)

    # Commitando a transação e fechando a conexão
    try:
        conn.commit()
    except pyodbc.Error as e:
        logging.info(f'Erro ao fazer commit da transação: {e}')
        print(f"Erro ao fazer commit da transação: {e}")
    finally:
        cursor.close()
        conn.close()
    logging.info(f'Processo concluído.')
    print("Processo concluído.")
