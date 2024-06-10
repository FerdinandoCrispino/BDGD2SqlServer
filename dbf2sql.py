# -*- encoding: utf-8 -*-

import os
import glob
import pyodbc
import pandas as pd

from simpledbf import Dbf5
# from dbfread import DBF
from datetime import datetime

import logging
import yaml

from tools import *

# application_path = expandvars(r'$ADMS')
application_path = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(application_path, r'config_database.yml'), 'r') as file:
    config_bdgd = yaml.load(file, Loader=yaml.BaseLoader)


# Configuração do logger
logging.basicConfig(filename='processamento_dbf.log',level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')


#+ Diretório contendo os arquivos DBF
dbf_directory = config_bdgd['dbf_directory']

#+ Valores dos campos adicionais
data_base = "2019-12-31"
data_carga = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

if __name__ == "__main__":
    # Conectando ao banco de dados sqlserver
    conn = create_connection(config_bdgd)
    cursor = conn.cursor()

    # Buscando todos os arquivos DBF no diretório
    dbf_files = glob.glob(os.path.join(dbf_directory, '*.dbf'))

    for dbf_file in dbf_files:
        # Extraindo o nome do arquivo (sem extensão) para usar como nome da tabela
        table_name = os.path.splitext(os.path.basename(dbf_file))[0]
        if config_bdgd['bancos']['schema'] != '':
            table_name = f'{config_bdgd["bancos"]["schema"]}.{table_name}'

        try:
            # Lendo o arquivo DBF
            # table = DBF(dbf_file)
            dbf = Dbf5(dbf_file, codec='utf-8')

        except Exception as e:
            logging.info(f'Erro ao ler o arquivo {dbf_file}: {e}')
            print(f"Erro ao ler o arquivo {dbf_file}: {e}")
            continue

        df = dbf.to_dataframe(na='')

        # verifica se o dbf tem dados
        # if len(table) == 0:
        if df.size == 0:
            logging.info(f'Erro, arquivo sem dados {dbf_file}')
            print(f"Erro, arquivo sem dados {dbf_file}.")
            continue

        # Convertendo os dados para uma lista de dicionários
        # data = [record for record in table]
        data = df.to_dict(orient='records')

        # Alterando nome de colunas do dbf de algumas tabelas
        # if table_name in ('SDE.ARAT', 'SDE.CONJ', 'SDE.SSDAT'):
        #columns = data[0].keys().replace('Shape_Area', 'Shape_STArea__')
        #columns = columns.replace('Shape_Leng', 'Shape_STLength__')

        columns_rename = {'Shape_Leng': 'Shape_STLength__',
                          'Shape_Area': 'Shape_STArea__'}
        # df2 = pd.DataFrame(list)
        # data = pd.DataFrame(df.rename(columns=columns_rename))
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
