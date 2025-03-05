# -*- encoding: utf-8 -*-
from datetime import datetime
import time
import os
import logging
from Tools.tools import load_config, create_connection, process_gdb_files, set_coords, exec_sp_atualiza_v10

# Configuração do logger
logging.basicConfig(filename='processamento_dados.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s', datefmt='%Y-%m-%d,%H:%M:%S')

# Mapeamento de renomeação de colunas: {'nome_antigo': 'nome_novo'}
columns_rename = {'Shape_Leng': 'Shape_STLength__',
                  'Shape_Length': 'Shape_STLength__',
                  'Shape_Area': 'Shape_STArea__'}


if __name__ == "__main__":
    proc_time_ini = time.time()
    config_bdgd = load_config('391')
    schema = config_bdgd['schema']
    # Conectando ao banco de dados sqlserver using sqlalchemy
    try:
        engine = create_connection(config_bdgd)
    except Exception as e:
        logging.error(f"Erro ao conectar ao banco de dados: {e}")
        exit(1)

    # Valores dos campos adicionais
    data_base = config_bdgd['data_base']
    data_carga = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    # localização do arquivo do BDGD
    gdb_file = os.path.join(config_bdgd['gdb_directory'], config_bdgd['gdb_file'])

    # Processa o arquivo de dados da BDGD
    process_gdb_files(gdb_file, engine, schema, data_base, data_carga, columns_rename)

    engine.dispose() # type: ignore
    logging.info(f"Processo concluído em {time.time() - proc_time_ini} ")
    print(f"Processo concluído em {time.time() - proc_time_ini}")

    # preenche as coordenadas para UGMT, UCMT, UGBT, UCBT
    print(f"Preenchendo coordenadas para UGMT, UCMT, UGBT, UCBT")
    set_coords(config_bdgd['dist'])
    print(f"Processo concluído!")

    # Executa a stored procedure de atualização da versão 10
    print(f"Executando stored procedure de atualização da versão 1.0 da base de dados da BDGD {config_bdgd['dist']}")
    exec_sp_atualiza_v10(config_bdgd['dist'], data_base, engine)
    print(f"Processo concluído!")
