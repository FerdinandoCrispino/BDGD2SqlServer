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
from Tools.tools import create_connection, load_config

# Lê a configuração do arquivo yml
config = load_config('Irradiance')

# Diretório dos arquivos sobre a irradiância
caminho_principal = config['irrad_directory']

# Retorna o schema
schema = config['schema']

# Cria a conexão com o banco de dados
engine = create_connection(config)

try:
    engine.connect()

except Exception as e:
    print(f"Erro ao conectar no banco de dados: {e}")
    exit()

IRRAD_sql = 'IRRAD'
MUNICIPIO_sql = 'MUNICIPIO'

try:
    # Verifica se o diretório principal existe
    if not os.path.exists(caminho_principal):
        raise FileNotFoundError(f"A pasta '{caminho_principal}' não existe.")

    # Processar todos os arquivos sobre a irradiância e os códigos do município
    for raiz, subdirs, arquivos in os.walk(caminho_principal):
        try:
            if not arquivos and not subdirs: # Verifica se não há arquivos na subpasta
                raise ValueError(f"A subpasta '{raiz}' está vazia. Nenhum arquivo encontrado para processamento.")

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

                    if not colunas == ['COD_MUNICIPIO', 'Mes', 'Dia', 'Hora', 'Gt(i)_mean', 'Gt(i)_std', 'T2m_mean', 'T2m_std']:
                        raise ValueError(f"Arquivo {caminho_arquivo} difere do Banco de Dados.")

                    df = df[colunas]

                    # Se o df for igual a tabela do banco de dados então será preenchida
                    df.to_sql(IRRAD_sql, engine, schema=schema, index=False,
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

                    # Se o df for igual a tabela do banco de dados então será preenchida
                    df.to_sql(MUNICIPIO_sql, engine, schema=schema, index=False,
                              if_exists="replace", chunksize=None, method=None)

                    print(f"Arquivo processado: {caminho_arquivo}")

                except Exception as e:
                    print(f"Erro ao processar o arquivo '{caminho_arquivo}': {e}")

            else:  # Se a extensão não for .csv ou .xls
                caminho_arquivo = os.path.join(raiz, arquivo)

                try:
                    raise ValueError(f"Extensão do arquivo {caminho_arquivo} inválida. O arquivo deve ser '.csv' ou '.xls'.")
                except ValueError as e:
                    print(f"Erro: {e}")

except FileNotFoundError as e:
    print(f"Erro: {e}")