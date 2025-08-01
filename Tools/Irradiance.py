# -*- encoding: utf-8 -*-
"""
 * Project Name: BDGD2SqlServer
 * Created by Guilherme Broslavschi
 * Date: 08/01/2025
 * Time: 19:00
 *
 * Edited by:
 * Date:
 * Time:
"""
import os
import pandas as pd
from tools import create_connection, load_config


# Verifica se existe o município
def existe_municipio_banco_de_dados(con, municipio):
    query = f"SELECT COUNT (*) AS HOURS FROM sde.IRRAD WHERE COD_MUNICIPIO = '{municipio}'"
    try:
        df_municipio = pd.read_sql_query(sql=query, con=con)
        count_reg = df_municipio.iloc[0]['HOURS']

        if count_reg > 0:
            return True

        else:
            return False

    except ValueError as e:
        print(f"Erro: {e}")

        return False


""" Importa para o banco de dados do SQLSERVER os dados de irradiação e temperatura de cada município """


class ImportIrradiance:

    def run_import_irradiance(self):

        # Lê a configuração do arquivo yml
        config = load_config('Irradiance')

        # Diretório dos arquivos sobre a irradiância
        caminho_principal = config['irrad_directory']

        # Retorna o schema
        schema = config['schema']

        # Cria a conexão com o banco de dados
        engine = create_connection(config)

        IRRAD_sql = 'IRRAD'
        MUNICIPIO_sql = 'MUNICIPIO'

        try:
            with engine.connect() as con:

                try:
                    # Verifica se o diretório principal existe
                    if not os.path.exists(caminho_principal):
                        raise FileNotFoundError(f"A pasta '{caminho_principal}' não existe.")

                    # con.execution_options(autocommit=True).execute(f"TRUNCATE TABLE {schema}.{IRRAD_sql}")

                    # Processar todos os arquivos sobre a irradiância e os códigos do município
                    for raiz, subdirs, arquivos in os.walk(caminho_principal):
                        try:
                            if not arquivos and not subdirs:  # Verifica se não há arquivos na subpasta
                                raise ValueError(
                                    f"A subpasta '{raiz}' está vazia. Nenhum arquivo encontrado para processamento.")

                        except ValueError as e:
                            print(f"Erro: {e}")

                        for arquivo in arquivos:
                            if arquivo.endswith('.csv'):  # Verifica se é um arquivo Excel (.csv)
                                caminho_arquivo = os.path.join(raiz, arquivo)

                                try:
                                    # Lendo o arquivo Excel (.csv)
                                    df = pd.read_csv(caminho_arquivo)

                                    COD_MUNICIPIO_ComChaves = raiz.split('\\')[-2]
                                    df["COD_MUNICIPIO"] = int(COD_MUNICIPIO_ComChaves.strip("[]"))
                                    colunas = ['COD_MUNICIPIO'] + [col for col in df.columns if col != 'COD_MUNICIPIO']

                                    if not colunas == ['COD_MUNICIPIO', 'Mes', 'Dia', 'Hora', 'Gt(i)_mean', 'Gt(i)_std',
                                                       'T2m_mean', 'T2m_std']:
                                        raise ValueError(f"Arquivo {caminho_arquivo} difere do Banco de Dados.")

                                    if existe_municipio_banco_de_dados(con, df["COD_MUNICIPIO"][0]):
                                        print(f'O município {df["COD_MUNICIPIO"][0]} já existe.')
                                        break

                                    df = df[colunas]

                                    # Se o df for igual a tabela do banco de dados então será preenchida
                                    df.to_sql(IRRAD_sql, con, schema=schema, index=False,
                                              if_exists="append", chunksize=None, method=None)

                                    print(f"Arquivo processado: {caminho_arquivo}")

                                except ValueError as e:
                                    print(f"Erro: {e}")

                                except Exception as e:
                                    print(f"Erro ao processar o arquivo '{caminho_arquivo}': {e}")

                            elif arquivo.endswith('.xls'):  # Verifica se é um arquivo Excel antigo (.xls)
                                caminho_arquivo = os.path.join(raiz, arquivo)

                                try:
                                    # Lendo o arquivo Excel (.xls)
                                    df = pd.read_excel(caminho_arquivo, engine='xlrd', skiprows=6)
                                    # substituir aspas simples por duas aspas simples para inserir no sql
                                    df['NOME_MUNICIPIO'] = df['NOME_MUNICIPIO'].str.replace("'", "")

                                    # con.execution_options(autocommit=True).execute(
                                    #    f'ALTER TABLE {schema}.{IRRAD_sql} DROP CONSTRAINT FK_IRRAD_MUNICIPIO')

                                    con.execution_options(autocommit=True).execute(
                                        f"TRUNCATE TABLE {schema}.{MUNICIPIO_sql}")

                                    # con.execution_options(autocommit=True).execute(
                                    #    f'ALTER TABLE {schema}.{IRRAD_sql} ADD CONSTRAINT FK_IRRAD_MUNICIPIO FOREIGNKEY('
                                    #    f'COD_MUNICIPIO) REFERENCES {schema}.{MUNICIPIO_sql}(COD_MUNICIPIO)')

                                    # Se o df for igual a tabela do banco de dados então será preenchida
                                    #  if_exists="replace" altera a definição das colunas por isso, utilizar append
                                    df.to_sql(MUNICIPIO_sql, con, schema=schema, index=False,
                                              if_exists="append", chunksize=None, method=None)

                                    print(f"Arquivo processado: {caminho_arquivo}")

                                except Exception as e:
                                    print(f"Erro ao processar o arquivo '{caminho_arquivo}': {e}")

                            else:  # Se a extensão não for .csv ou .xls
                                caminho_arquivo = os.path.join(raiz, arquivo)

                                try:
                                    raise ValueError(
                                        f"Extensão do arquivo {caminho_arquivo} inválida. O arquivo deve ser '.csv' ou '.xls'.")
                                except ValueError as e:
                                    print(f"Erro: {e}")

                except FileNotFoundError as e:
                    print(f"Erro: {e}")

        except Exception as e:
            print(f"Erro ao conectar no banco de dados: {e}")
            exit()


if __name__ == '__main__':
    ImportIrradiance().run_import_irradiance()
    print("here")
