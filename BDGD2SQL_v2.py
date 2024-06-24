# -*- encoding: utf-8 -*-

import os
import time
from datetime import datetime

import pandas as pd
# import geopandas as gpd
# import fiona
# import yaml
import logging
# import sqlalchemy

from simpledbf import Dbf5
from datetime import datetime

import logging
import yaml

from Tools.tools import *


# # Leitura do arquivo de configuração
# application_path = os.path.dirname(os.path.abspath(__file__))
# with open(os.path.join(application_path, r'config_database.yml'), 'r') as file:
#     config_bdgd = yaml.load(file, Loader=yaml.BaseLoader)

# Configuração do logger
logging.basicConfig(filename='processamento_dados.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')

# Mapeamento de renomeação de colunas: {'nome_antigo': 'nome_novo'}
columns_rename = {'Shape_Leng': 'Shape_STLength__',
                  'Shape_Length': 'Shape_STLength__',
                  'Shape_Area': 'Shape_STArea__'}


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

    # schema = config_bdgd['bancos']['schema']
    # Processa o arquivo de dados da BDGD
    process_gdb_files(gdb_file, engine, data_base, data_carga, columns_rename)

    engine.dispose() # type: ignore
    logging.info(f"Processo concluído em {time.time() - proc_time_ini} ")
    print(f"Processo concluído em {time.time() - proc_time_ini}")
