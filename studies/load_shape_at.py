import pandas as pd
import numpy as np
from Tools.tools import create_connection, load_config, calc_du_sa_do_mes, irrad_by_municipio, fator_autoconsumo
import calendar


def curvas_carga_normal(curvas_carga):
    curvas_carga_dss = {}
    # Transforma 96 pontos da curva de carga em 24 pontos em kW
    for index in range(curvas_carga.shape[0]):
        for x in range(0, 24):
            col_name_new_crv = f'POT_{x:02}'
            curvas_carga_dss[col_name_new_crv] = (curvas_carga.iloc[index, 4 + 4 * x] +
                                                  curvas_carga.iloc[index, 1 + 4 + 4 * x] +
                                                  curvas_carga.iloc[index, 2 + 4 + 4 * x] +
                                                  curvas_carga.iloc[index, 3 + 4 + 4 * x]) / 4

        # Normaliza os pontos em relação ao máximo valor
        kw_max = max(curvas_carga_dss.values())
        curvas_carga_dss = {k: round(v / kw_max, 6) for k, v in curvas_carga_dss.items()}
    return curvas_carga_dss


def query_crvcrg(engine, dist):
    try:
        with engine.connect() as con:
            query = f'''SELECT * FROM SDE.CRVCRG WHERE dist='{dist}'
                ;
            '''
            curvas_cargas = pd.read_sql_query(sql=query, con=con)
            return curvas_cargas

    except Exception as e:
        print(f"Erro ao conectar no banco de dados: {e}")
        return


def query_fator_de_carga(engine):
    try:
        with engine.connect() as con:
            query = f'''
                select s.COD_ID, s.TIP_DIA, (s.DEM_MED/s.DEN_MAX) as FC
                from (
                SELECT COD_ID, TIP_DIA, GREATEST(
                ([POT_01] + [POT_02] + [POT_03] + [POT_04])/4 ,([POT_05] + [POT_06] + [POT_07] + [POT_08])/4 ,
                ([POT_09] + [POT_10] + [POT_11] + [POT_12])/4 ,([POT_13] + [POT_14] + [POT_15] + [POT_16])/4 ,
                ([POT_17] + [POT_18] + [POT_19] + [POT_20])/4 ,([POT_21] + [POT_22] + [POT_23] + [POT_24])/4 ,
                ([POT_25] + [POT_26] + [POT_27] + [POT_28])/4 ,([POT_29] + [POT_30] + [POT_31] + [POT_32])/4 ,
                ([POT_33] + [POT_34] + [POT_35] + [POT_36])/4 ,([POT_37] + [POT_38] + [POT_39] + [POT_40])/4 ,
                ([POT_41] + [POT_42] + [POT_43] + [POT_44])/4 ,([POT_45] + [POT_46] + [POT_47] + [POT_48])/4 ,
                ([POT_49] + [POT_50] + [POT_51] + [POT_52])/4 ,([POT_53] + [POT_54] + [POT_55] + [POT_56])/4 ,
                ([POT_57] + [POT_58] + [POT_59] + [POT_60])/4 ,([POT_61] + [POT_62] + [POT_63] + [POT_64])/4 ,
                ([POT_65] + [POT_66] + [POT_67] + [POT_68])/4 ,([POT_69] + [POT_70] + [POT_71] + [POT_72])/4 ,
                ([POT_73] + [POT_74] + [POT_75] + [POT_76])/4 ,([POT_77] + [POT_78] + [POT_79] + [POT_80])/4 ,
                ([POT_81] + [POT_82] + [POT_83] + [POT_84])/4 ,([POT_85] + [POT_86] + [POT_87] + [POT_88])/4 , 
                ([POT_89] + [POT_90] + [POT_91] + [POT_92])/4 ,([POT_93] + [POT_94] + [POT_95] + [POT_96])/4
                ) as DEN_MAX
                ,([POT_01] +[POT_02] +[POT_03] +[POT_04] +[POT_05] +[POT_06] +[POT_07] +[POT_08] +[POT_09] +[POT_10]
                 +[POT_11] +[POT_12] +[POT_13] +[POT_14] +[POT_15] +[POT_16] +[POT_17] +[POT_18] +[POT_19] +[POT_20]
                 +[POT_21] +[POT_22] +[POT_23] +[POT_24] +[POT_25] +[POT_26] +[POT_27] +[POT_28] +[POT_29] +[POT_30]
                 +[POT_31] +[POT_32] +[POT_33] +[POT_34] +[POT_35] +[POT_36] +[POT_37] +[POT_38] +[POT_39] +[POT_40]
                 +[POT_41] +[POT_42] +[POT_43] +[POT_44] +[POT_45] +[POT_46] +[POT_47] +[POT_48] +[POT_49] +[POT_50]
                 +[POT_51] +[POT_52] +[POT_53] +[POT_54] +[POT_55] +[POT_56] +[POT_57] +[POT_58] +[POT_59] +[POT_60]
                 +[POT_61] +[POT_62] +[POT_63] +[POT_64] +[POT_65] +[POT_66] +[POT_67] +[POT_68] +[POT_69] +[POT_70]
                 +[POT_71] +[POT_72] +[POT_73] +[POT_74] +[POT_75] +[POT_76] +[POT_77] +[POT_78] +[POT_79] +[POT_80]
                 +[POT_81] +[POT_82] +[POT_83] +[POT_84] +[POT_85] +[POT_86] +[POT_87] +[POT_88] +[POT_89] +[POT_90]
                 +[POT_91] +[POT_92] +[POT_93] +[POT_94]+ [POT_95] +[POT_96])/(4*24) as DEM_MED
                  FROM [sde].[CRVCRG]
                  ) as s
                ;
            '''
            carga_fc = pd.read_sql_query(sql=query, con=con)
            return carga_fc
    except Exception as e:
        print(f"Erro ao conectar no banco de dados: {e}")
        return


def get_energy_sub(engine, sub, mes):
    try:
        with engine.connect() as con:
            query = f'''select 'SUB_TIPO' as TIP_CC, sum(u.ENES_01) as ENE_01, sum(u.ENES_02) as ENE_02, 
            sum(u.ENES_03) as ENE_03, sum(u.ENES_04) as ENE_04, sum(u.ENES_05) as ENE_05, sum(u.ENES_06) as ENE_06, 
            sum(u.ENES_07) as ENE_07, sum(u.ENES_08) as ENE_08, sum(u.ENES_09) as ENE_09, sum(u.ENES_10) as ENE_10, 
            sum(u.ENES_11) as ENE_11, sum(u.ENES_12) as ENE_12 
            from sde.untrat U  WHERE U.SUB = '{sub}'          
            '''
            result = pd.read_sql_query(sql=query, con=con)
            # result['ENE_' + f'{mes:02}'][0]
            return result
    except Exception as e:
        print(f"Erro ao conectar no banco de dados: {e}")
        return


def get_municipio_gd(engine, tabela, sub):
    try:
        with engine.connect() as con:
            query = f'''Select top 1 u.MUN From sde.{tabela} u Where sub = '{sub}'
            '''
            result = pd.read_sql_query(sql=query, con=con)
            return result.iloc[0]['MUN']
    except Exception as e:
        print(f"Erro ao conectar no banco de dados: {e}")
        return


def get_pot_inst_pv(engine, sub, tabela):
    try:
        with engine.connect() as con:
            query = f'''Select sum(CASE 
                            WHEN u.POT_INST >= 1000 THEN u.POT_INST/1000 
                            WHEN (u.POT_INST >= 250 and u.POT_INST < 1000) THEN u.POT_INST/100
                            ELSE u.POT_INST 
                        END) as POT_INST
                From sde.{tabela} u Where u.sub='{sub}' and sit_ativ = 'AT'
                '''
            result = pd.read_sql_query(sql=query, con=con)
            if result.iloc[0]['POT_INST'] is None:
                return 0.0
            return result.iloc[0]['POT_INST']
    except Exception as e:
        print(f"Erro ao conectar no banco de dados: {e}")
        return


def get_generation(engine, sub, tabela, ck_pot=None, classe=None):
    try:
        with engine.connect() as con:
            col = 'ENE'
            if tabela == 'UGAT':
                col = 'ENE_P'
            cond1 = cond2 = ''
            if classe == 1 and tabela == 'UGBT':
                cond1 = f"inner join sde.UCBT c on u.ceg_gd=c.ceg_gd "
                cond2 = f"and upper(SUBSTRING(c.TIP_CC, 1,2)) = 'RE'"
            elif classe == 2 and tabela == 'UGBT':
                cond1 = f"inner join sde.UCBT c on u.ceg_gd=c.ceg_gd "
                cond2 = f"and upper(SUBSTRING(c.TIP_CC, 1,2)) = 'CO'"
            elif classe == 0 and tabela == 'UGBT':
                cond1 = f"inner join sde.UCBT c on u.ceg_gd=c.ceg_gd "
                cond2 = f"and upper(SUBSTRING(c.TIP_CC, 1,2)) not in ('CO','RE')"
            elif classe == 3 and tabela == 'UGMT':
                cond1 = f"inner join sde.UCMT c on u.ceg_gd=c.ceg_gd "
                cond2 = f"and upper(SUBSTRING(c.TIP_CC, 1,2)) = 'CO'"
            elif classe == 4 and tabela == 'UGMT':
                cond1 = f"inner join sde.UCMT c on u.ceg_gd=c.ceg_gd "
                cond2 = f"and upper(SUBSTRING(c.TIP_CC, 1,2)) != 'CO'"

            if not ck_pot:
                query = f'''Select COALESCE(sum(u.{col}_01),0) as ENE_01, COALESCE(sum(u.{col}_02),0) as ENE_02, 
                COALESCE(sum(u.{col}_03),0) as ENE_03, COALESCE(sum(u.{col}_04),0) as ENE_04, 
                COALESCE(sum(u.{col}_05),0) as ENE_05, COALESCE(sum(u.{col}_06),0) as ENE_06, 
                COALESCE(sum(u.{col}_07),0) as ENE_07, COALESCE(sum(u.{col}_08),0) as ENE_08, 
                COALESCE(sum(u.{col}_09),0) as ENE_09, COALESCE(sum(u.{col}_10),0) as ENE_10, 
                COALESCE(sum(u.{col}_11),0) as ENE_11, COALESCE(sum(u.{col}_12),0) as ENE_12
                From sde.{tabela} u {cond1} 
                Where u.sub='{sub}' and SUBSTRING(u.CEG_GD,1,2) in ('GD','UF') {cond2}
                '''
                result = pd.read_sql_query(sql=query, con=con)
                return result
            else:
                query = f'''Select COALESCE(sum(u.{col}_01),0) as ENE_01, COALESCE(sum(u.{col}_02),0) as ENE_02, 
                COALESCE(sum(u.{col}_03),0) as ENE_03, COALESCE(sum(u.{col}_04),0) as ENE_04, 
                COALESCE(sum(u.{col}_05),0) as ENE_05, COALESCE(sum(u.{col}_06),0) as ENE_06, 
                COALESCE(sum(u.{col}_07),0) as ENE_07, COALESCE(sum(u.{col}_08),0) as ENE_08, 
                COALESCE(sum(u.{col}_09),0) as ENE_09, COALESCE(sum(u.{col}_10),0) as ENE_10, 
                COALESCE(sum(u.{col}_11),0) as ENE_11, COALESCE(sum(u.{col}_12),0) as ENE_12 
                From sde.{tabela} u {cond1} 
                Where u.sub='{sub}' and SUBSTRING(u.CEG_GD,1,2) in ('GD', 'UF') and POT_INST = 0 {cond2}
                '''
                result = pd.read_sql_query(sql=query, con=con)
                return result
    except Exception as e:
        print(f"Erro ao conectar no banco de dados: {e}")
        return


def get_cargas(engine, sub, tabela, classe=None):
    try:
        with engine.connect() as con:
            col = 'ENE'
            campo = ', u.uni_tr_at'
            if tabela == 'UCAT':
                col = 'ENE_P'
                campo = ''
            cond = ''
            if classe == 1 and tabela == 'UCBT':
                cond = f"and upper(SUBSTRING(u.CLAS_SUB, 1,2)) = 'RE'"
            elif classe == 2 and tabela == 'UCBT':
                cond = f"and upper(SUBSTRING(u.CLAS_SUB, 1,2)) = 'CO'"
            elif classe == 0 and tabela == 'UCBT':
                cond = f"and upper(SUBSTRING(u.CLAS_SUB, 1,2)) not in ('RE','CO')"
            elif classe == 3 and tabela == 'UCMT':
                cond = f"and upper(SUBSTRING(u.CLAS_SUB, 1,2)) = 'CO'"
            elif classe == 4 and tabela == 'UCMT':
                cond = f"and upper(SUBSTRING(u.CLAS_SUB, 1,2)) != 'CO'"

            query = f'''Select u.TIP_CC {campo}, COALESCE(sum(u.{col}_01),0) as ENE_01, 
            COALESCE(sum(u.{col}_02),0) as ENE_02, COALESCE(sum(u.{col}_03),0) as ENE_03, 
            COALESCE(sum(u.{col}_04),0) as ENE_04, COALESCE(sum(u.{col}_05),0) as ENE_05, 
            COALESCE(sum(u.{col}_06),0) as ENE_06, COALESCE(sum(u.{col}_07),0) as ENE_07, 
            COALESCE(sum(u.{col}_08),0) as ENE_08, COALESCE(sum(u.{col}_09),0) as ENE_09, 
            COALESCE(sum(u.{col}_10),0) as ENE_10, COALESCE(sum(u.{col}_11),0) as ENE_11, 
            COALESCE(sum(u.{col}_12),0) as ENE_12 
            From sde.{tabela} u 
            Where u.sub='{sub}' {cond} group by u.TIP_CC {campo} order by TIP_CC 
            '''
            result = pd.read_sql_query(sql=query, con=con)
            return result
    except Exception as e:
        print(f"Erro ao conectar no banco de dados: {e}")
        return


def get_prop_curva_carga(curvas_carga, tipo_dia, tipo_curva):
    crv_tipo_dia = curvas_carga[(curvas_carga['TIP_DIA'].str.upper() == tipo_dia) &
                                (curvas_carga['COD_ID'].str.upper() == tipo_curva.upper())]

    crv_all_tipo_dia = curvas_carga[curvas_carga['COD_ID'].str.upper() == tipo_curva.upper()]

    energia = crv_tipo_dia.filter(like="POT").sum(axis=1)

    # crv_all_tipo_dia['ener_class'] = crv_all_tipo_dia.filter(like="POT").sum(axis=1)
    crv_all_tipo_dia = crv_all_tipo_dia.copy()  # Create a copy to avoid the SettingWithCopyWarning
    crv_all_tipo_dia.loc[:, 'ener_class'] = crv_all_tipo_dia.filter(like="POT").sum(axis=1)

    return energia.iloc[0] / crv_all_tipo_dia['ener_class'].sum()


def get_curvas_agregadas(cargas, cargas_fc, curvas_carga_tipicas, tipo_dia, mes, cargas_list):
    for index in range(cargas.shape[0]):
        energy_mes = cargas.loc[index]['ENE_' + str(mes)]

        # Fator de carga calculado a partir do tipo de curva de carga
        fc = cargas_fc.loc[(cargas_fc['COD_ID'] == cargas.loc[index]['TIP_CC']) &
                           (cargas_fc['TIP_DIA'] == tipo_dia)]

        # Metodologia ANEEL: proporção de dias e tipo de curva de carga
        propor = get_prop_curva_carga(curvas_carga_tipicas, tipo_dia, cargas.loc[index]['TIP_CC'])
        proporDU = get_prop_curva_carga(curvas_carga_tipicas, 'DU', cargas.loc[index]['TIP_CC'])
        proporDO = get_prop_curva_carga(curvas_carga_tipicas, 'DO', cargas.loc[index]['TIP_CC'])
        proporSA = get_prop_curva_carga(curvas_carga_tipicas, 'SA', cargas.loc[index]['TIP_CC'])

        num_dias_tipo_dia = tipo_dias_mes[tipo_dia]
        prop_mes = propor * num_dias_tipo_dia
        prop_mes_ene = prop_mes / (proporDU * tipo_dias_mes['DU'] +
                                   proporDO * tipo_dias_mes['DO'] +
                                   proporSA * tipo_dias_mes['SA'])

        dblDemMax_kW = ((energy_mes * prop_mes_ene) / (num_dias_tipo_dia * 24)) / fc.iloc[0]['FC']

        crv_tipo_dia = curvas_carga_tipicas[(curvas_carga_tipicas['TIP_DIA'].str.upper() == tipo_dia) &
                                            (curvas_carga_tipicas['COD_ID'].str.upper() == cargas.loc[index][
                                                'TIP_CC'])]

        if len(crv_tipo_dia.columns) > 96:
            dict1 = curvas_carga_normal(crv_tipo_dia)
        else:
            pot_cols = crv_tipo_dia.filter(like="POT_").reset_index(drop=True)
            dict1 = pot_cols.div(pot_cols.max(axis=1), axis=0).to_dict('records')[0]

        for key in dict1:
            dict1[key] = dict1.get(key) * dblDemMax_kW
        # Add new key-value pairs using update() with an iterable
        dict1.update([('TIP_DIA', tipo_dia)])
        # lista de dicionarios
        cargas_list.append(dict1)

    curva_carga_agregada = pd.DataFrame(cargas_list)
    curva_carga_agregada = curva_carga_agregada.groupby(['TIP_DIA']).sum()
    return curva_carga_agregada


if __name__ == '__main__':
    tipo_de_dias = ['DU', 'DO', 'SA']  # tipo de dia para referência para as curvas típicas de carga e geração
    list_subs = ['ACR', 'CCO', 'CRU', 'ICC', 'JPR', 'JSR', 'PLH']
    dist = '40'

    mes = 12
    ano_base = 2022
    rendimento = 0.75  # rendimento painel solar
    curva_carga_agregada_total = pd.DataFrame()
    curva_geracao_agregada_total = pd.DataFrame()
    cargas_all_mounth = []

    # Lê configuração do arquivo yml
    config = load_config('40_2022')
    engine = create_connection(config)

    # leitura de dados de curvas de carga da bdgd
    curvas_carga_tipicas = query_crvcrg(engine, dist)

    # Fator de carga
    cargas_fc = query_fator_de_carga(engine)
    cargas_fc['COD_ID'] = cargas_fc['COD_ID'].str.upper()

    # numero de dias do mes
    num_dias = calendar.monthrange(ano_base, mes)[1]
    tipo_dias_mes = calc_du_sa_do_mes(ano_base, mes)
    with pd.ExcelWriter(f'sub_loading.xlsx') as writer:

        for sub in list_subs:
            print(f'subestação: {sub}')
            """
            Caracterização das curvas de geração:
            Para a geração utiliza-se o fator de autoconsumo definido pela EPE: Eg = Ei*(1/(1-fi))
            """
            cod_mun = get_municipio_gd(engine, 'UGMT', sub)
            # obtem curva de irradiação solar na base de dados de irradiação
            irradiacao = irrad_by_municipio(cod_mun, mes, dist)

            # get BT Generation PV - residencial
            generation_bt_res_class = get_generation(engine, sub, 'UGBT', classe=1)
            factor_auto = fator_autoconsumo(classe=1)
            generation_bt_res = generation_bt_res_class * (1 / (1 - factor_auto))

            # get MT Generation PV - comercial bt
            generation_bt_com_class = get_generation(engine, sub, 'UGBT', classe=2)
            factor_auto = fator_autoconsumo(classe=2)
            generation_bt_com = generation_bt_com_class * (1 / (1 - factor_auto))

            # get MT Generation PV - demais classes bt
            generation_bt_demais = get_generation(engine, sub, 'UGBT', classe=0)

            # get MT Generation PV - comercial mt
            generation_mt_com_class = get_generation(engine, sub, 'UGMT', classe=3)
            factor_auto = fator_autoconsumo(classe=3)
            generation_mt_com = generation_mt_com_class * (1 / (1 - factor_auto))

            # get MT Generation PV - não comercial mt
            generation_mt_demais = get_generation(engine, sub, 'UGMT', classe=4)

            # get AT Generation PV
            generation_at = get_generation(engine, sub, 'UGAT')

            # soma toda a geração
            pv_generation = pd.concat([generation_bt_res, generation_bt_com, generation_bt_demais,
                                       generation_mt_com, generation_mt_demais, generation_at]).sum()
            pv_generation_mes = pv_generation[f'ENE_{mes}']

            # fator de geração media dos valores diferentes de zero
            fg = np.apply_along_axis(lambda v: np.mean(v[np.nonzero(v)]), 0, irradiacao)
            pot_generation_pv_mes = (pv_generation_mes / (num_dias * 24)) / fg
            curva_geracao_pv_total_mes = np.multiply(np.array(irradiacao), (-1 * pot_generation_pv_mes * rendimento))
            df_curva_geracao_pv_total_mes = pd.DataFrame(curva_geracao_pv_total_mes).transpose()

            curva_geracao_agregada_total = pd.concat([df_curva_geracao_pv_total_mes, curva_geracao_agregada_total])

            """
            Cálculo da geração atraves dos valores de potência instalada.            
            """
            # potencia instalada de geração na baixa tensão
            pot_inst_pv_bt = get_pot_inst_pv(engine, sub, 'UGBT')
            # potencia instalada de geração na média tensão
            pot_inst_pv_mt = get_pot_inst_pv(engine, sub, 'UGMT')
            # potencia instalada de geração na alta tensão
            pot_inst_pv_at = get_pot_inst_pv(engine, sub, 'UGAT')

            pot_inst_pv = pot_inst_pv_bt + pot_inst_pv_mt + pot_inst_pv_at

            # energia medida para os casos em que a potência instalada é zero, mas existe energia medida
            generation_pv_bt = get_generation(engine, sub, 'UGBT', ck_pot=1).iloc[0][f'ENE_{mes:02}']
            generation_pv_mt = get_generation(engine, sub, 'UGMT', ck_pot=1).iloc[0][f'ENE_{mes:02}']
            generation_pv_at = get_generation(engine, sub, 'UGAT', ck_pot=1).iloc[0][f'ENE_{mes:02}']
            generation_pv = generation_pv_bt + generation_pv_mt + generation_pv_at
            if generation_pv > 0:
                factor_auto = fator_autoconsumo(classe=2)
                generation_pv_total = generation_pv * (1 / (1 - factor_auto))
                # média dos valores diferentes de zero
                fc = np.apply_along_axis(lambda v: np.mean(v[np.nonzero(v)]), 0, irradiacao)
                pot_generation_pv = (generation_pv_total / (num_dias * 24)) / fc

            # soma da potência instalada com a demanda maxima obtida da energia injetada quando não temos a potência instalada
            pot_inst_pv_total = pot_inst_pv + pot_generation_pv

            curva_geracao_pv_total = np.multiply(np.array(irradiacao), (-1 * pot_inst_pv_total * rendimento))
            df_curva_geracao_pv_total = pd.DataFrame(curva_geracao_pv_total).transpose()

            """
            Caracterização das da curvas de carga
            Para os consumidores que possuem GD o valor de energia é liquido e deve-se considerar a geração 
            Ec = Ef + Eg - Ei
            Ef = energia faturada (BDGD: UCs)
            Eg = energia gerada (energia gerada pela GD)
            Ei = energia injetada (BDGD (UGs)
            """

            # get demand of subestation by mounth
            energy_sub = get_energy_sub(engine, sub, mes)

            # cargas da subestação agrupadas por TIP_CC
            cargas_at = get_cargas(engine, sub, 'UCAT')
            cargas_at['TIP_CC'] = cargas_at['TIP_CC'].str.upper()

            cargas_pip = get_cargas(engine, sub, 'PIP')
            cargas_pip['TIP_CC'] = cargas_pip['TIP_CC'].str.upper()
            """
            cargas_bt = get_cargas(engine, sub, 'UCBT')
            cargas_bt['TIP_CC'] = cargas_bt['TIP_CC'].str.upper()

            cargas_mt = get_cargas(engine, sub, 'UCMT')
            cargas_mt['TIP_CC'] = cargas_mt['TIP_CC'].str.upper()
            """
            cargas_bt_res = get_cargas(engine, sub, 'UCBT', classe=1)
            cargas_bt_res['TIP_CC'] = cargas_bt_res['TIP_CC'].str.upper()
            num_rows = len(cargas_bt_res)
            factor_auto = fator_autoconsumo(classe=1)
            generation_to_add = generation_bt_res_class * ((1 / (1 - factor_auto)) - 1)
            generation_by_rows = generation_to_add/num_rows
            for i in range(1, 13):
                cargas_bt_res[f'ENE_{i:02}'] = cargas_bt_res[f'ENE_{i:02}'].apply(
                    lambda x: x + generation_by_rows[f'ENE_{i:02}'])

            cargas_bt_com = get_cargas(engine, sub, 'UCBT', classe=2)
            cargas_bt_com['TIP_CC'] = cargas_bt_com['TIP_CC'].str.upper()
            num_rows = len(cargas_bt_com)
            factor_auto = fator_autoconsumo(classe=2)
            generation_to_add = generation_bt_res_class * ((1 / (1 - factor_auto)) - 1)
            generation_by_rows = generation_to_add / num_rows
            for i in range(1, 13):
                cargas_bt_com[f'ENE_{i:02}'] = cargas_bt_com[f'ENE_{i:02}'].apply(
                    lambda x: x + generation_by_rows[f'ENE_{i:02}'])

            cargas_bt_demais = get_cargas(engine, sub, 'UCBT', classe=0)
            cargas_bt_demais['TIP_CC'] = cargas_bt_demais['TIP_CC'].str.upper()

            cargas_bt = pd.concat([cargas_bt_res, cargas_bt_com, cargas_bt_demais]).reset_index()

            cargas_mt_com = get_cargas(engine, sub, 'UCMT', classe=3)
            cargas_mt_com['TIP_CC'] = cargas_mt_com['TIP_CC'].str.upper()
            num_rows = len(cargas_mt_com)
            factor_auto = fator_autoconsumo(classe=3)
            generation_to_add = generation_mt_com_class * round(((1 / (1 - factor_auto)) - 1), 3)
            generation_by_rows = generation_to_add / num_rows
            for i in range(1, 13):
                cargas_mt_com[f'ENE_{i:02}'] = cargas_mt_com[f'ENE_{i:02}'].apply(
                    lambda x: x + generation_by_rows[f'ENE_{i:02}'])

            cargas_mt_demais = get_cargas(engine, sub, 'UCMT', classe=4)
            cargas_mt_demais['TIP_CC'] = cargas_mt_demais['TIP_CC'].str.upper()

            cargas_mt = pd.concat([cargas_mt_com, cargas_mt_demais]).reset_index()

            x = pd.concat([cargas_at, cargas_mt, cargas_bt, cargas_pip]).sum()

            cargas_all_mounth.append(x)

            # list results
            cargas_list_at = []
            cargas_list_mt = []
            cargas_list_bt = []
            cargas_list_pip = []
            curva_carga_agregada_at = curva_carga_agregada_mt = curva_carga_agregada_bt = \
                curva_carga_agregada_pip = curva_carga_agregada_sub = pd.DataFrame()

            for tipo_dia in tipo_de_dias:
                if not cargas_at.empty:
                    curva_carga_agregada_at = get_curvas_agregadas(cargas_at, cargas_fc, curvas_carga_tipicas, tipo_dia,
                                                                   mes, cargas_list_at)
                if not cargas_mt.empty:
                    curva_carga_agregada_mt = get_curvas_agregadas(cargas_mt, cargas_fc, curvas_carga_tipicas, tipo_dia,
                                                                   mes, cargas_list_mt)
                if not cargas_bt.empty:
                    curva_carga_agregada_bt = get_curvas_agregadas(cargas_bt, cargas_fc, curvas_carga_tipicas, tipo_dia,
                                                                   mes, cargas_list_bt)
                if not cargas_pip.empty:
                    curva_carga_agregada_pip = get_curvas_agregadas(cargas_pip, cargas_fc, curvas_carga_tipicas,
                                                                    tipo_dia, mes, cargas_list_pip)
                curva_carga_agregada_sub = pd.concat([curva_carga_agregada_at, curva_carga_agregada_mt,
                                                      curva_carga_agregada_bt, curva_carga_agregada_pip]).groupby(
                    ['TIP_DIA']).sum()

            # Escreve arquivo excel
            curva_carga_agregada_mt.to_excel(writer, sheet_name=sub + '_MT')
            curva_carga_agregada_bt.to_excel(writer, sheet_name=sub + '_BT')
            curva_carga_agregada_pip.to_excel(writer, sheet_name=sub + '_pip')
            curva_carga_agregada_sub.to_excel(writer, sheet_name=sub + '_Total')

            curva_carga_agregada_total = pd.concat([curva_carga_agregada_sub, curva_carga_agregada_total]).groupby(
                ['TIP_DIA']).sum()

            df_fc_sub = pd.DataFrame(
                curva_carga_agregada_sub.mean(axis=1) / curva_carga_agregada_sub.max(axis=1)).reset_index()

            df_fc_sub['COD_ID'] = 'SUB_TIPO'
            df_fc_sub.columns = ['TIP_DIA', 'FC', 'COD_ID']
            # print(df_fc_sub)
            curva_carga_agregada_sub['COD_ID'] = 'SUB_TIPO'
            curva_carga_agregada_sub = curva_carga_agregada_sub.reset_index()
            cargas_list_sub = []
            df_cargas_list_sub = pd.DataFrame()
            for tipo_dia in tipo_de_dias:
                df_cargas_list_sub = get_curvas_agregadas(energy_sub, df_fc_sub, curva_carga_agregada_sub, tipo_dia,
                                                          mes, cargas_list_sub)

            df_cargas_list_sub.to_excel(writer, sheet_name=sub + '_Total_SUB')
            df_curva_geracao_pv_total.to_excel(writer, sheet_name=sub + '_Geracao')
            df_curva_geracao_pv_total_mes.to_excel(writer, sheet_name=sub + '_Geracao_by_energy')

        curva_carga_agregada_total.to_excel(writer, sheet_name='ALL_SUB')
        curva_geracao_agregada_total.loc['Total'] = pd.Series(curva_geracao_agregada_total.sum())
        curva_geracao_agregada_total.to_excel(writer, sheet_name='ALL_SUB_geracao')

        cargas_total_mes = pd.DataFrame(cargas_all_mounth)
        cargas_total_mes.drop(['TIP_CC', 'uni_tr_at', 'index'], axis=1, inplace=True)
        cargas_total_mes.to_excel(writer, sheet_name='ALL_cargas_mes')
    print('Fim!')
