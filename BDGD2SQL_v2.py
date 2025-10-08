# -*- encoding: utf-8 -*-
from datetime import datetime
import time
import os
import logging
from multiprocessing import Pool, cpu_count
import fiona
from Tools.tools import load_config, create_connection, process_gdb_files, run_multi_process_gdb_file, set_coords, \
    exec_sp_atualiza_v10, update_coords_by_aneel

# Configuração do logger
logging.basicConfig(filename='processamento_dados.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s', datefmt='%Y-%m-%d,%H:%M:%S')

# Mapeamento de renomeação de colunas: {'nome_antigo': 'nome_novo'}
columns_rename = {'Shape_Leng': 'Shape_STLength__',
                  'Shape_Length': 'Shape_STLength__',
                  'Shape_Area': 'Shape_STArea__'}


if __name__ == "__main__":
    conf_bdgd = '39_2022'
    proc_time_ini = time.time()
    config_bdgd = load_config(conf_bdgd)
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

    run_multiprocess = False
    # Todo o processamento paralelo gera problema de indices no SQLServer para tabelas grandes. Rever a estrategia!!!!
    if run_multiprocess:
        # Processa o arquivo de dados da BDGD
        """Função para processar arquivos GeoDatabase"""
        with engine.connect() as conn, conn.begin():
            # gdf = gpd.read_file(gdb_file)
            layerlist = fiona.listlayers(gdb_file)

        arguments = []
        for table_name in layerlist:
            arguments.append([table_name, gdb_file, conf_bdgd, schema, data_base, data_carga, columns_rename])

        p = Pool(processes=(cpu_count() - 1))
        p.starmap(run_multi_process_gdb_file, arguments)
    else:
        process_gdb_files(gdb_file, engine, schema, data_base, data_carga, columns_rename)

    # engine.dispose() # type: ignore
    logging.info(f"Processo concluído em {time.time() - proc_time_ini} ")
    print(f"Processo concluído em {time.time() - proc_time_ini}")

    # Executa a stored procedure de atualização da versão 10
    print(f"Executando stored procedure de atualização da versão 1.0 da base de dados da BDGD: {config_bdgd['dist']}")
    exec_sp_atualiza_v10(config_bdgd['dist'], data_base, engine)
    print(f"Processo concluído!")

    # preenche as coordenadas para UGMT, UCMT, UGBT, UCBT
    print(f"Preenchendo coordenadas para UGMT, UCMT, UGBT, UCBT")
    set_coords(engine)
    print(f"Processo concluído!")
    print(f"Preenchendo coordenadas a partir da api ANEEL")
    update_coords_by_aneel(config_bdgd['dist'], engine)