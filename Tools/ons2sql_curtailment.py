# -*- encoding: utf-8 -*-
"""
 * Project Name: BDGD2SqlServer
 * Created by Ferdinando Crispino
 * Date: 12/07/2025
 * Resume: Implementa a importação dos dados do ONS em formato CSV para o banco de dados SQLServer
"""
import os
import pandas as pd
from Tools.tools import create_connection, load_config


class InportDataONS:
    def __init__(self, table_name_sql, file_name, sep=','):
        self.table_name_sql = table_name_sql
        self.file_name = file_name
        self.sep = sep

    def run_import_data(self):
        table_name_sql = self.table_name_sql
        file_name = self.file_name

        # Lê a configuração do arquivo yml
        config = load_config('curtailment')
        # Diretório dos arquivos sobre a irradiância
        path_files = os.path.abspath(config['curt_directory'])

        # Retorna o schema
        schema = config['schema']
        # Cria a conexão com o banco de dados
        engine = create_connection(config)

        try:
            with engine.connect() as conn:
                try:
                    # Verifica se o diretório principal existe
                    if not os.path.exists(path_files):
                        raise FileNotFoundError(f"A pasta '{path_files}' não existe.")

                    for chunk in pd.read_csv(os.path.join(path_files, file_name), chunksize=5000, sep=self.sep):
                        #for col in chunk.select_dtypes(include='object').columns:
                        #    chunk[col] = chunk[col].astype(str)

                        chunk.to_sql(table_name_sql, engine, schema=schema, if_exists='append', index=False,
                                     chunksize=1000, method=None)
                except Exception as e:
                    print(f"Erro ao processar o arquivo '{path_files}': {e}")

        except Exception as e:
            print(f"Erro ao conectar no banco de dados: {e}")


if __name__ == '__main__':
    #table_name_sql = 'CURTAILMENT'
    #file_name = 'Curtailment_Total_Processed.csv'
    table_name_sql = 'USINA_CONJUNTO'
    file_name = 'RELACIONAMENTO_USINA_CONJUNTO.csv'

    impdata = InportDataONS(table_name_sql, file_name, ';')
    impdata.run_import_data()

