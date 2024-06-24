# -*- encoding: utf-8 -*-

import logging
import pyodbc

def create_connection(config_bdgd):
    """Função para criar uma conexão com o banco de dados SQL Server"""
    conn_str = (
            'DRIVER={ODBC Driver 17 for SQL Server};'
            'SERVER=' + config_bdgd['bancos']['server'] + ';'
                                 'DATABASE=' + config_bdgd['bancos']['database'] + ';'
                                                          'UID=' + config_bdgd['bancos']['username'] + ';'
                                                                              'PWD=' + config_bdgd['bancos']['password']
    )
    return pyodbc.connect(conn_str)


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

    sql = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"
    for row in data:
        try:
            print(sql)
            print(tuple(row.values()))
            cursor.execute(sql, tuple(row.values()))

            #* cuidado o arquivo de log pode ficar muito grande
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

#Ajusta o CodBnc dos reguladores
def ajust_regulators(dataFrame):

    #Inicializa todos como bancos trifásicos
    dataFrame['CodBnc'] = 0

    #Localiza os que tem UN_RE duplicadas, ou seja, sao monofasicos
    one_phase_reg = dataFrame['UN_RE'][dataFrame['UN_RE'].duplicated(keep=False)].unique()

    #para os monofasicos, altera o CodBnc de acordo com a fase que estao ligados
    for index, value in enumerate(dataFrame["UN_RE"]):
        if value in one_phase_reg:
            if dataFrame.loc[index,"LIG_FAS_P"] == "AB":
                dataFrame.loc[index,"CodBnc"] = 1
            elif dataFrame.loc[index,"LIG_FAS_P"] == "BC":
                dataFrame.loc[index,"CodBnc"] = 2
            elif dataFrame.loc[index,"LIG_FAS_P"] == "CA":
                dataFrame.loc[index,"CodBnc"] = 3
    return dataFrame