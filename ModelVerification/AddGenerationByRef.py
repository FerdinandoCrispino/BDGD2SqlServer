# -*- encoding: utf-8 -*-
import os
import time
import pandas as pd
from sqlalchemy import create_engine
import json
from Tools.tools import nos_com_neutro, create_connection, return_query_as_dataframe, \
    numero_fases_carga_dss, temp_amb_by_municipio, temp_amb_to_temp_pv, irrad_by_municipio


def conn_generator(strFas):
    if strFas == 'AN' or strFas == 'BN' or strFas == 'CN':
        return 'Wye'
    else:
        return 'Delta'


def find_nearest(engine, point_x, point_y, table, circuit):
    # Forma de Haversine para calculo de distancia
    query = f"""SELECT TOP 1 *,
                       6371000 * ACOS(
                           COS(RADIANS({point_y})) * COS(RADIANS(POINT_Y2)) *
                           COS(RADIANS(POINT_X2) - RADIANS({point_x})) +
                           SIN(RADIANS({point_y})) * SIN(RADIANS(POINT_Y2))
                       ) AS DistanciaMetros
                FROM sde.SSD{table}
                WHERE CTMT = '{circuit}' and
                    6371000 * ACOS(
                        COS(RADIANS({point_y})) * COS(RADIANS(POINT_Y2)) *
                        COS(RADIANS(POINT_X2) - RADIANS({point_x})) +
                        SIN(RADIANS({point_y})) * SIN(RADIANS(POINT_Y2))
                    ) <= 5000
                ORDER BY DistanciaMetros;
            """
    return return_query_as_dataframe(query, engine)


if __name__ == '__main__':
    circuito = 'RGER1302'
    sub = circuito[1:4]
    mes = 7
    cod_mun = '3549904'
    redes = ['BT', 'MT']

    # Busca os geradores de um circuito e tipo de rede na planilha
    excel_file = r'C:\pastaD\TSEA\INSTALACAO_GERADOR_202601162101.csv'

    for tipo_rede in redes:
        filename = f'AddGenerator_{tipo_rede}_{mes}_{sub}_{circuito}.dss'

        df = pd.read_csv(excel_file, sep=';', low_memory=False)
        filtered_df = df.loc[(df['ALIMENTADOR_1'].str.replace(" ", "") == f'{circuito}') & (df['TIPO_REDE'] == f'{tipo_rede}'),
                             ['CODIGO_CEG', 'TIPO_REDE', 'TENSAO_OPERACAO', 'POTENCIA', 'FASE', 'ALIMENTADOR_2',
                              'COORDENADA_X_LATLONG', 'COORDENADA_Y_LATLONG']]

        # ceg_atual = filtered_df[['CODIGO_CEG']].copy()
        # list_ceg = filtered_df['CODIGO_CEG'].tolist()

        config_bdgd = {'username': 'usr_GeoPerdas', 'password': '123456', 'server': 'DaimonEng',
                       'database': 'GEO_SIGR_PERDAS_EDP_SP_2024'}
        engine = create_connection(config_bdgd)

        if tipo_rede == 'MT':
            for index, row in filtered_df.iterrows():
                # Encontrar o PAC do consumidor do gerador
                query = f"Select PAC, CEG_GD from SDE.UC{tipo_rede} where CEG_GD='{row['CODIGO_CEG']}'"
                pac_consumidor = return_query_as_dataframe(query, engine)
                if not pac_consumidor.empty:
                    filtered_df.loc[index, 'PAC_2'] = pac_consumidor['PAC'].values[0]
                else:
                    # Localizar o PAC do segmento mais proximo a coordenada do gerador
                    ssdmt = find_nearest(engine=engine, point_x=row['COORDENADA_X_LATLONG'],
                                         point_y=row['COORDENADA_Y_LATLONG'], table=tipo_rede, circuit=circuito)
                    if not ssdmt.empty:
                        filtered_df.loc[index, 'PAC_2'] = ssdmt['PAC_2'].values[0]

        # Busca os geradores do circuito
        query = f"Select CEG_GD as CODIGO_CEG from SDE.UG{tipo_rede} where CTMT = '{circuito}'"
        ceg_bdgd = return_query_as_dataframe(query, engine)

        # seleciona a diferença entre os geradores do circuito e da lista do excel
        merged_df = pd.merge(ceg_bdgd, filtered_df, on=['CODIGO_CEG'], how='outer', indicator=True)
        unique_rows = merged_df[merged_df['_merge'] == 'right_only']
        unique_rows = unique_rows.reset_index(drop=True)

        with open(filename, 'w', encoding='utf-8') as f:
            f.write(f'! Add_Geradores_{tipo_rede}_{mes}_{sub}_{circuito}' + "\n")
            list_tr = unique_rows['ALIMENTADOR_2'].tolist()

            if list_tr:

                if tipo_rede == 'BT':
                    # busca o PAC do transformador para conectar o gerador bt que não tem consumidor
                    query = f"Select COD_ID as ALIMENTADOR_2, PAC_2 from SDE.UNTRMT where CTMT = '{circuito}' and " \
                            f"COD_ID in ({str(list_tr)[1:-1]})"
                    pac_bdgd = return_query_as_dataframe(query, engine)
                    unique_rows = pd.merge(unique_rows, pac_bdgd, on=['ALIMENTADOR_2'], how='inner')

                for index, row in unique_rows.iterrows():
                    kva = round(row["POTENCIA"] / 1000, 2)
                    pmpp = round(kva * 1.15, 3)
                    kv = round(row["TENSAO_OPERACAO"] / 1000, 3)

                    # obtem a curva de temperatura ambiente da base de dados de irradiação
                    temp_amb = temp_amb_by_municipio(cod_mun, mes, database="Irradiance")
                    # obtem curva de irradiação solar na base de dados de irradiação
                    irradiacao = irrad_by_municipio(cod_mun, mes, database="Irradiance")
                    # converte temperatura ambiente e irradiação solar em temperatura do painel solar
                    pv_temp_data = temp_amb_to_temp_pv(irradiacao, temp_amb)
                    # máxima irradiação solar em relação a uma irradiação de 1000 W/m2
                    irrad = round(max(pv_temp_data["crv_g"]) / 1000, 2)

                    new_pv = f'New "PVsystem.{tipo_rede}_PV{index}" phases={numero_fases_carga_dss(row["FASE"])} ' \
                             f'bus1="{row["PAC_2"]}{nos_com_neutro(row["FASE"])}" ' \
                             f'conn={conn_generator(row["FASE"])} kv={kv} pf=1.0 ' \
                             f'pmpp={pmpp} kva={kva} %pmpp=100 ' \
                             f'irradiance=0.59 temperature=25 ' \
                             f'%cutin=0.1 %cutout=0.1 effcurve=Myeff P-TCurve=MyPvsT ' \
                             f'Daily=PVIrrad_{circuito} TDaily=MyTemp'

                    print(new_pv)
                    f.write(new_pv + "\n")
                print(f'Saved to {filename}')
