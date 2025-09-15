# -*- encoding: utf-8 -*-
"""
 * Project Name: BDGD2SqlServer
 * Created by Ferdinando Crispino
 * Date: 12/07/2025
 * Resume: Implementa a importação dos dados do ONS em formato CSV para o banco de dados SQLServer
"""
import os
import pandas as pd
import numpy as np
from tools import create_connection, load_config
from sqlalchemy import text


class InportDataONS:
    def __init__(self, table_name_sql, file_name, sep=','):
        self.table_name_sql = table_name_sql
        self.file_name = file_name
        self.sep = sep
        self.config = load_config('curtailment')
        self.schema = self.config['schema']
        self.engine = create_connection(self.config)

    def del_table(self, table_name):
        if not table_name:
            return
        query = f"""Truncate table [{table_name}]"""
        # query = f"""Delete from [dbo].[{table_name}]"""
        with self.engine.begin() as conn:
            try:
                conn.execute(text(query))
                # conn.exec_driver_sql(query)
            except Exception as e:
                print(f"Erro ao truncar a tabela {table_name}: {e}")
        return

    def run_import_data(self):
        table_name_sql = self.table_name_sql
        file_name = self.file_name
        # Diretório dos arquivos sobre a irradiância
        path_files = os.path.abspath(self.config['curt_directory'])

        try:
            with self.engine.connect() as conn:
                try:
                    # Verifica se o diretório principal existe
                    if not os.path.exists(path_files):
                        raise FileNotFoundError(f"A pasta '{path_files}' não existe.")
                    print(f'Insert {table_name_sql}')
                    for chunk in pd.read_csv(os.path.join(path_files, file_name), chunksize=50000, sep=self.sep, low_memory=False):
                        #for col in chunk.select_dtypes(include='object').columns:
                        #    chunk[col] = chunk[col].astype(str)
                        chunk.drop_duplicates(inplace=True)

                        # Specify columns to exclude replace - Deixar coluna como nula quando sem dados
                        excluded_columns = ['dat_fimrelacionamento']
                        # Select all columns except the excluded ones
                        columns_to_replace = [col for col in chunk.columns if col not in excluded_columns]
                        # Apply replace(np.nan, 0) only to the selected columns
                        chunk[columns_to_replace] = chunk[columns_to_replace].replace(np.nan, 0)

                        chunk.to_sql(table_name_sql, self.engine, schema=self.schema, if_exists='append', index=False,
                                     chunksize=1000, method=None)
                        print('Insert 50000 lines...')
                except Exception as e:
                    print(f"Erro ao processar o arquivo '{path_files}': {e}")

        except Exception as e:
            print(f"Erro ao conectar no banco de dados: {e}")


if __name__ == '__main__':
    separador = ';'
    table_name_sql = 'USINA_CONJUNTO'
    file_name = 'RELACIONAMENTO_USINA_CONJUNTO.csv'
    #separador = ','
    #table_name_sql = 'wind_CURTAILMENT'
    #file_name = 'Curtailment_Total_Processed.csv'
    #separador = ','
    #table_name_sql = 'solar_CURTAILMENT'
    #file_name = 'Curtailment_Solar_Total_Processed.csv'

    impdata = InportDataONS(table_name_sql, file_name, sep=separador)
    impdata.del_table(table_name_sql)
    impdata.run_import_data()

