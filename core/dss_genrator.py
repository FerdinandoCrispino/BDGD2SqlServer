import numpy as np
import pandas as pd

"""
# @Date    : 20/062024
# @Author  : Ferdinano Crispino
Implemeta funcionalidades de escrita dos arquivos do openDSS
"""


class DssFilesGenerator:
    def __init__(self, dist, substation):
        self.dist = dist
        self.sub = substation

    def get_dss_files_lines(self, cod_ses_selecionadas: list, cod_circuitos_selecionados: list) -> list:
        """
        Função que gera o conteúdo dos arquivos DSS (OpenDSS) representativos dos objetos de rede da memória interna.
        :param cod_ses_selecionadas: lista com os códigos das subestações selecionadas.
        :param cod_circuitos_selecionados: lista com os códigos dos circuitos selecionados.
        :return: lista com o conteúdo a ser persistido nos arquivos DSS
        """
        print('get_dss_files_lines')
        linhas_list = []
        linhas_curvas_carga = []
        linhas_arranjos_trechos = []

        # lista_curvas_carga = self._get_lines_curvas_carga_simplif(linhas_curvas_carga)
        lista_curvas_carga, df_lista_curvas_carga = self._get_lines_curvas_carga(linhas_curvas_carga)

        self._write_to_dss_arranjos(linhas_arranjos_trechos)  # arranjos referentes aos trechos das redes

        for se in self.memoria_interna.ses_importadas:
            if se.codigo not in cod_ses_selecionadas:
                continue
            for circuito in se.circuitos:
                if circuito.codigo not in cod_circuitos_selecionados:
                    continue
                print('circuito: {}'.format(circuito.codigo))
                arquivos_dict = {'suprimento': [], 'curvas_carga': [], 'arranjos': [], 'trechos': [], 'cargas': [],
                                 'trafos': [], 'chaves': [], 'reguladores': [], 'geradores': [], 'coords': [],
                                 'geradoresBT': [], 'medidores': [], 'master': []}
                linhas_dict = {'circuito': circuito.codigo, 'arquivos': arquivos_dict}
                linhas_list.append(linhas_dict)
                linhas_dict['arquivos']['arranjos'].extend(linhas_arranjos_trechos)

                arquivos_dict['curvas_carga'].extend([linha for linha in linhas_curvas_carga])
                tensoes_nominais = self._determina_tensoes_nominais_circuito(se, circuito)
                self._get_lines_suprimento_circuito(se, circuito, arquivos_dict['suprimento'])  # suprimento
                self._get_lines_coordenadas_circuito(circuito, arquivos_dict['coords'])  # coordenadas

                print("Blocos MT")
                for bloco in circuito.blocos:
                    self._write_to_dss_arranjos_trafos(bloco.trafos, arquivos_dict['arranjos'])  # arranjos trafos
                    self._get_lines_trechos(bloco.trechos, False, arquivos_dict['trechos'])  # trechos MT
                    # self._get_lines_cargas_mt_simplif(bloco.cargas, lista_curvas_carga, arquivos_dict['cargas'])  # cargas MT
                    self._get_lines_cargas_mt(bloco.cargas, df_lista_curvas_carga, arquivos_dict['cargas'])
                    self._get_lines_trafos(bloco.trafos, circuito, arquivos_dict['trafos'])  # trafos
                    self._get_lines_reguladores(bloco, arquivos_dict['reguladores'])  # reguladores
                    self._get_lines_geradores(bloco.geradores, arquivos_dict['geradores'])  # geradores
                print("Ets BT")
                for et_bt in circuito.ets:
                    self._get_lines_trechos(et_bt.trechos_bt, True, arquivos_dict['trechos'])  # trechos BT
                    # self._get_lines_cargas_bt_simplif(et_bt, lista_curvas_carga, arquivos_dict['cargas'])  # cargas BT
                    self._get_lines_cargas_bt(et_bt, df_lista_curvas_carga, arquivos_dict['cargas'])

                if len(circuito.ets) > 0:
                    if circuito.ets[0].geradores_bt is not None:
                        self._get_lines_geradores_bt(circuito.ets[0].geradores_bt, arquivos_dict['geradoresBT'],
                                             df_lista_curvas_carga)
                if circuito.monitores is not None:
                    self._get_lines_medidores(circuito.monitores, arquivos_dict['medidores'])

                self._get_lines_chaves(circuito, arquivos_dict['chaves'])  # chaves

                self._get_lines_master(linhas_dict, tensoes_nominais)  # master
        print("Finalizou geração dos arquivos DSS.")
        return linhas_list

    def _get_lines_medidores(self, medidores, linha_medidores_dss):
        """ Função para gerar os Medidores do arquivo MEDIDORES>DSS """

        for medidor in medidores:
            if medidor['element_tipo'] == 'SSDMT':
                tipo_elem = 'SEGMMT'
            else:
                tipo_elem = 'CHVMT'

            linha = 'New "Energymeter.medidor_' + tipo_elem + '_' + str(medidor['element']).replace('.', '_') + \
                    '" element="' + medidor['element'] + '" terminal=1'
            linha_medidores_dss.append(linha)

    def _get_lines_master(self, linhas_dict, tensoes_nominais) -> None:
        """ Função para gerar as linhas (DSS) referentes ao arquivo master.dss """
        linhas_master = linhas_dict['arquivos']['master']
        linhas_master.append('clear')
        linhas_master.append('')

        # Inclui redirecionamentos
        for nome_arquivo in linhas_dict['arquivos'].keys():
            if nome_arquivo == 'master' or nome_arquivo == 'coords':
                continue
            linhas_master.append(f"redirect {nome_arquivo}.dss")
        linhas_master.append('')

        # Inclui tensões nominais
        if len(tensoes_nominais) > 0:
            tensoes_str = ''
            for tensao in tensoes_nominais:
                tensoes_str += str(tensao) + ' '
            linhas_master.append(f"set voltagebases=({tensoes_str[0:len(tensoes_str) - 1]})")
            linhas_master.append('calcv')

        # Inclui outros comandos
        linhas_master.append(f"buscoords coords.dss")
        linhas_master.append(f"set mode=daily")
        linhas_master.append(f"set tolerance=0.0001")
        linhas_master.append(f"set maxcontroliter=100")
        linhas_master.append(f"set maxiterations=100")
        linhas_master.append(f"set stepsize=1h ! duracao de cada step")
        linhas_master.append(f"set number=24 ! cada solve executa 24 steps")

    def _get_lines_chaves(self, circuito, linhas_chaves_dss) -> None:
        """ Função para gerar as linhas (DSS) referentes às chaves de um determinado circuito """
        for chave in circuito.chaves:
            linha = 'New "Line.CMT_' + chave.codigo + '"' + " phases=" + numero_fases_segmento(chave.fases_conexao) + \
                    " bus1=" + '"' + chave.barra1.codigo + nos_com_neutro(chave.fases_conexao) + '"' + \
                    " bus2=" + '"' + chave.barra2.codigo + nos_com_neutro(chave.fases_conexao) + '"' + \
                    " r1=0.001 r0=0.001 x1=0 x0=0 c1=0 c0=0 length=0.001 switch=T"
            linhas_chaves_dss.append(linha)

    def _get_lines_cargas_bt_simplif(self, et_bt, lista_curvas_carga, linhas_cargas_dss) -> None:
        """ Função para gerar as linhas (DSS) referentes às cargas BT """
        for carga in et_bt.cargas_bt:
            trafo = et_bt.et
            if trafo is None:
                continue

            # Determina a curva de carga simplificada
            curva_carga_dict = None
            for curva_carga_dict in lista_curvas_carga:
                if curva_carga_dict['codigo'] == carga.curva:
                    break
                else:
                    curva_carga_dict = None
            if curva_carga_dict is None:
                continue

            # Determina a demanda máxima em kw
            ene_anual = carga.ene_01 + carga.ene_02 + carga.ene_03 + carga.ene_04 + carga.ene_05 + carga.ene_06 + \
                        carga.ene_07 + carga.ene_08 + carga.ene_09 + carga.ene_10 + carga.ene_11 + carga.ene_12
            kw_max = ene_anual / (365 * 24 * curva_carga_dict['fc'])
            kw_max_trafo = carga.kw_nom * 0.92
            if kw_max > kw_max_trafo:
                kw_max_corrigida = kw_max_trafo
            else:
                kw_max_corrigida = kw_max

            # converte tipo de trafo
            if trafo.tipo_trafo == 'M':
                cod_tipo_trafo = 1
            elif trafo.tipo_trafo == 'MT':
                cod_tipo_trafo = 2
            elif trafo.tipo_trafo == 'B':
                cod_tipo_trafo = 3
            elif trafo.tipo_trafo == 'T':
                cod_tipo_trafo = 4
            elif trafo.tipo_trafo == 'DF':
                cod_tipo_trafo = 5
            elif trafo.tipo_trafo == 'DA':
                cod_tipo_trafo = 6
            else:
                cod_tipo_trafo = 0

            kva_max_corrigida = kw_max_corrigida / 0.92
            if kw_max_corrigida > 0.0:
                linhas_cargas_dss.append(
                    'New "Load.BT_' + carga.codigo + '_M1" bus1="' + carga.barra.codigo + nos_com_neutro(
                        carga.lig_fas) + '"' +
                    " phases=" + numero_fases_carga(carga.lig_fas) + " conn=" + ligacao_carga(carga.lig_fas) +
                    " model=2" + " kv=" + kv_carga(carga.lig_fas, carga.kv_sec_et, cod_tipo_trafo) + " xfkva=" +
                    str(kva_max_corrigida) + " allocationfactor=0.5 pf=0.92" + ' daily="' + carga.curva +
                    '" status=variable vmaxpu=1.5 vminpu=0.92')
                linhas_cargas_dss.append(
                    'New "Load.BT_' + carga.codigo + '_M2" bus1="' + carga.barra.codigo + nos_com_neutro(
                        carga.lig_fas) + '"' +
                    " phases=" + numero_fases_carga(carga.lig_fas) + " conn=" + ligacao_carga(carga.lig_fas) +
                    " model=3" + " kv=" + kv_carga(carga.lig_fas, carga.kv_sec_et, cod_tipo_trafo) + " xfkva=" +
                    str(kva_max_corrigida) + " allocationfactor=0.5 pf=0.92" + ' daily="' + carga.curva +
                    '" status=variable vmaxpu=1.5 vminpu=0.92')
            else:
                linhas_cargas_dss.append(
                    '!New "Load.BT_' + carga.codigo + '_M1" bus1="' + carga.barra.codigo + nos_com_neutro(
                        carga.lig_fas) + '"' +
                    " phases=" + numero_fases_carga(carga.lig_fas) + " conn=" + ligacao_carga(carga.lig_fas) +
                    " model=2" + " kv=" + kv_carga(carga.lig_fas, carga.kv_sec_et, cod_tipo_trafo) + " xfkva=" +
                    str(kva_max_corrigida) + " allocationfactor=0.5 pf=0.92" + ' daily="' + carga.curva +
                    '" status=variable vmaxpu=1.5 vminpu=0.92')
                linhas_cargas_dss.append(
                    '!New "Load.BT_' + carga.codigo + '_M2" bus1="' + carga.barra.codigo + nos_com_neutro(
                        carga.lig_fas) + '"' +
                    " phases=" + numero_fases_carga(carga.lig_fas) + " conn=" + ligacao_carga(carga.lig_fas) +
                    " model=3" + " kv=" + kv_carga(carga.lig_fas, carga.kv_sec_et, cod_tipo_trafo) + " xfkva=" +
                    str(kva_max_corrigida) + " allocationfactor=0.5 pf=0.92" + ' daily="' + carga.curva +
                    '" status=variable vmaxpu=1.5 vminpu=0.92')

    def _get_lines_cargas_bt(self, et_bt, df_curva_carga, linhas_cargas_dss) -> bool:
        # Monta o dataframe das cargas BT e IP
        dfcargasbt = self._monta_dataframe_carga_bt(et_bt)
        dfcargasbt = self._incrementa_dataframe_carga(dfcargasbt, df_curva_carga)
        # Aplica função que gera as linhas de cargas BT do arquivo final de cargas
        i, j = 8, 1
        dfcargasbt.apply(self._write_to_dss_cargas_bt_from_dataframe, axis=1, args=(i, j, linhas_cargas_dss))

        return False

    def _write_to_dss_cargas_bt_from_dataframe(self, x, i, j, linhas_cargas_dss):
        strName = x.loc['COD_ID']
        strCodCrvCrg = x.loc['TIP_CC'] + '_' + tipo_dia(j)
        strCodFas = x.loc['FAS_CON']
        dblDemMaxTrafo_kW = x.loc['DemMaxTrafo_kW']
        strBus = x.loc['PAC']
        dblDemMax_kW = x.loc['DemMax' + tipo_dia(j) + str(i) + '_kW']
        dblTenSecu_kV = x.loc['TEN_LIN_SE']
        intTipTrafo = x.loc['TIP_TRAFO']

        if dblDemMax_kW > dblDemMaxTrafo_kW:
            dblDemMaxCorrigida_kW = dblDemMaxTrafo_kW
        else:
            dblDemMaxCorrigida_kW = dblDemMax_kW

        # if dblDemMax_kW == 0.0:
        #   print('DemMax' + tipo_dia(j) + str(i) + '_kW')
        #   print('dblDemMax_kW:{}  dblDemMaxTrafo_kW:{}'.format(dblDemMax_kW, dblDemMaxTrafo_kW))

        if dblDemMaxCorrigida_kW > 0.0:
            linhas_cargas_dss.append(
                'New "Load.BT_' + strName + '_M1" bus1="' + strBus + nos_com_neutro(strCodFas) + '"' +
                " phases=" + numero_fases_carga_dss(strCodFas) + " conn=" + ligacao_carga(strCodFas) +
                " model=2" + " kv=" + kv_carga(strCodFas, dblTenSecu_kV, intTipTrafo) + " kw=" +
                f"{(dblDemMaxCorrigida_kW / 2):.7f}" + " pf=0.92" + ' daily="' + strCodCrvCrg +
                '" status=variable vmaxpu=1.5 vminpu=0.92')
            linhas_cargas_dss.append(
                'New "Load.BT_' + strName + '_M2" bus1="' + strBus + nos_com_neutro(strCodFas) + '"' +
                " phases=" + numero_fases_carga_dss(strCodFas) + " conn=" + ligacao_carga(strCodFas) +
                " model=3" + " kv=" + kv_carga(strCodFas, dblTenSecu_kV, intTipTrafo) + " kw=" +
                f"{(dblDemMaxCorrigida_kW / 2):.7f}" + " pf=0.92" + ' daily="' + strCodCrvCrg +
                '" status=variable vmaxpu=1.5 vminpu=0.92')
        else:
            linhas_cargas_dss.append(
                'New "Load.BT_' + strName + '_M1" bus1="' + strBus + nos_com_neutro(strCodFas) + '"' +
                " phases=" + numero_fases_carga_dss(strCodFas) + " conn=" + ligacao_carga(strCodFas) +
                " model=2" + " kv=" + kv_carga(strCodFas, dblTenSecu_kV, intTipTrafo) + " kw=" +
                f"{(dblDemMaxCorrigida_kW / 2):.7f}" + " pf=0.92" + ' daily="' + strCodCrvCrg +
                '" status=variable vmaxpu=1.5 vminpu=0.92')
            linhas_cargas_dss.append(
                'New "Load.BT_' + strName + '_M2" bus1="' + strBus + nos_com_neutro(strCodFas) + '"' +
                " phases=" + numero_fases_carga_dss(strCodFas) + " conn=" + ligacao_carga(strCodFas) +
                " model=3" + " kv=" + kv_carga(strCodFas, dblTenSecu_kV, intTipTrafo) + " kw=" +
                f"{(dblDemMaxCorrigida_kW / 2):.7f}" + " pf=0.92" + ' daily="' + strCodCrvCrg +
                '" status=variable vmaxpu=1.5 vminpu=0.92')

    def _monta_dataframe_carga_bt(self, et_bt):
        lista_linhas_df = []

        for carga in et_bt.cargas_bt:
            trafo = et_bt.et
            if trafo is None:
                continue

            # converte tipo de trafo
            if trafo.tipo_trafo == 'M':
                cod_tipo_trafo = 1
            elif trafo.tipo_trafo == 'MT':
                cod_tipo_trafo = 2
            elif trafo.tipo_trafo == 'B':
                cod_tipo_trafo = 3
            elif trafo.tipo_trafo == 'T':
                cod_tipo_trafo = 4
            elif trafo.tipo_trafo == 'DF':
                cod_tipo_trafo = 5
            elif trafo.tipo_trafo == 'DA':
                cod_tipo_trafo = 6
            else:
                cod_tipo_trafo = 0

            lista_linha_df = []
            lista_linha_df.append(carga.codigo)  # COD_ID
            lista_linha_df.append(carga.codigo_trafo)  # UNI_TR_D
            lista_linha_df.append('circuito')  # CTMT
            lista_linha_df.append(carga.curva)  # TIP_CC
            lista_linha_df.append(carga.lig_fas)  # FAS_CON
            lista_linha_df.append(carga.kv_nom)  # TEN
            lista_linha_df.append(carga.kw_nom * 0.92)  # DemMaxTrafo_kW
            lista_linha_df.append(carga.kv_sec_et)  # TEN_LIN_SE
            lista_linha_df.append(cod_tipo_trafo)  # TIP_TRAFO (aplicar conversão)
            lista_linha_df.append(carga.barra.codigo)  # PAC
            lista_linha_df.append(carga.ene_01)  # ENE_01
            lista_linha_df.append(carga.ene_02)  # ENE_02
            lista_linha_df.append(carga.ene_03)  # ENE_03
            lista_linha_df.append(carga.ene_04)  # ENE_04
            lista_linha_df.append(carga.ene_05)  # ENE_05
            lista_linha_df.append(carga.ene_06)  # ENE_06
            lista_linha_df.append(carga.ene_07)  # ENE_07
            lista_linha_df.append(carga.ene_08)  # ENE_08
            lista_linha_df.append(carga.ene_09)  # ENE_09
            lista_linha_df.append(carga.ene_10)  # ENE_10
            lista_linha_df.append(carga.ene_11)  # ENE_11
            lista_linha_df.append(carga.ene_12)  # ENE_12

            lista_linhas_df.append(lista_linha_df)
        dfcargasbt = pd.DataFrame(lista_linhas_df, columns=['COD_ID', 'UNI_TR_D', 'CTMT', 'TIP_CC', 'FAS_CON', 'TEN',
                                                            'DemMaxTrafo_kW', 'TEN_LIN_SE', 'TIP_TRAFO', 'PAC',
                                                            'ENE_01',
                                                            'ENE_02', 'ENE_03', 'ENE_04', 'ENE_05', 'ENE_06', 'ENE_07',
                                                            'ENE_08', 'ENE_09', 'ENE_10', 'ENE_11', 'ENE_12'])

        return dfcargasbt

    def _get_lines_geradores_bt(self, geradores_bt, linhas_geradores_bt_dss, df_lista_curvas_carga) -> None:
        """ Função para gerar as linhas (DSS) referentes aos geradores de baixa tensão"""
        mes, t_dia = 8, 1
        # Monta o dataframe dos geradores BT
        dfgeradorbt = self._monta_dataframe_gerador_bt(geradores_bt, mes, t_dia, df_lista_curvas_carga)
        # Aplica função que gera as linhas de geradores BT do arquivo final de geradores
        dfgeradorbt.apply(self._write_to_dss_geradores_bt_from_dataframe, axis=1,
                          args=(mes, t_dia, linhas_geradores_bt_dss,))

    def _monta_dataframe_gerador_bt(self, geradores, mes, t_dia, df_lista_curvas_carga):

        # strtipo_dia = 'DU'
        strtipo_dia = tipo_dia(t_dia)
        cod_curva = 'GeradorBT-Tipo1'  # como definido na tabela storedCrvCgrBT

        dfgeradorbt = pd.DataFrame(geradores)
        index_lista = df_lista_curvas_carga.loc[(df_lista_curvas_carga['CodCrvCrg'] == cod_curva) &
                                                (df_lista_curvas_carga['TipoDia'] == strtipo_dia)].index.tolist()[0]
        # print('index Lista:{}'.format(index_lista))
        c_add = {'fc': df_lista_curvas_carga['fc'][index_lista],
                 'PropEnerMens' + str(mes): df_lista_curvas_carga['PropEnerMens' + str(mes)][index_lista],
                 'DiasMes' + str(mes): df_lista_curvas_carga['DiasMes' + str(mes)][index_lista]}
        dfgeradorbt = dfgeradorbt.assign(**c_add)

        return dfgeradorbt

    def _write_to_dss_geradores_bt_from_dataframe(self, x, mes, t_dia, linhas_geradores_bt_dss):

        # strtipo_dia = 'DU'
        strNome = x.loc['codigo']
        strCodAlim = x.loc['circuito_codigo']
        strCodFas = x.loc['lig_fas']
        strBus1 = x.loc['barra_codigo']
        dblTensaoKv = x.loc['ten_lin']
        dblPotInst = x.loc['kw_inst']
        dbdaily = 'GeradorBT-Tipo1' + '_' + tipo_dia(t_dia)  # 1: DU, 2: SA, 3: DO
        dbconn = ligacao_gerador(strCodFas)  # "wye" ou "Delta"
        fc = x.loc['fc']
        pf = 1.0
        EnerMedid_kWh = x.loc['kwhs'][mes-1]        # mes 1 indice 0
        PropEnerMens = x.loc['PropEnerMens' + str(mes)]
        DiasMes = x.loc['DiasMes' + str(mes)]
        PotNom_kw = x.loc['pot_nom'] * 0.92
        # print('PotNom:{} - fc:{} - PropEnerMens:{} - DiasMes:{}'.format(PotNom_kw, fc, PropEnerMens, DiasMes))
        DemMax_kW = (EnerMedid_kWh * PropEnerMens) / (DiasMes * 24 * fc)

        if DemMax_kW > PotNom_kw > 0:
            DemMax_kW = PotNom_kw
        if DemMax_kW == 0:
            DemMax_kW = 0.000005  # valor pequeno para evitar divisão por zero no cálculo do fluxo de potência

        fases, seq_fases = determina_faseamento_opendss(strCodFas)

        linhas_geradores_bt_dss.append('New "Generator.BT_' + strNome + '_M1" bus1="' + strBus1 + str(seq_fases) +
                                       '" phases=' + str(fases) + ' conn=' + dbconn + ' model=1 kv=' +
                                       str(dblTensaoKv) + ' kw=' + '{:.6f}'.format(DemMax_kW) + ' pf={}'.format(pf) +
                                       ' daily="' + dbdaily + '" status=variable vmaxpu=1.5 vminpu=0.93')

    def _get_lines_geradores(self, geradores, linhas_geradores_dss) -> None:
        """ Função para gerar as linhas (DSS) referentes aos geradores """
        # Monta o dataframe dos geradores MT
        mes, t_dia = 8, 1
        dfgeradormt = self._monta_dataframe_gerador_mt(geradores)
        # Aplica função que gera as linhas de geradores MT do arquivo final de geradores
        dfgeradormt.apply(self._write_to_dss_geradores_from_dataframe, axis=1, args=(mes, t_dia, linhas_geradores_dss,))

    def _write_to_dss_geradores_from_dataframe(self, x, mes, t_dia, linhas_geradores_dss):
        strNome = x.loc['COD_ID']
        strCodAlim = x.loc['CTMT']
        strCodFas = x.loc['FAS_CON']
        strBus1 = x.loc['PAC']
        dblTensaoKv = x.loc['TEN']
        dblPotInst = x.loc['POT_INST']
        # dbdaily = "GeradorMT-Tipo1_DU"
        dbdaily = 'GeradorMT-Tipo1' + '_' + tipo_dia(t_dia)  # 1: DU, 2: SA, 3: DO
        dbconn = ligacao_gerador(strCodFas)  # "wye" ou "Delta"

        linhas_geradores_dss.append('New Generator.MT_' + strNome + '_M1 bus1=' + strBus1 + nos(strCodFas) +
                                    ' phases=' + numero_fases_carga(strCodFas) + ' conn=' + dbconn + ' kv=' +
                                    str(dblTensaoKv) + ' model=1 kw=' + str(dblPotInst) + " pf=0.92" + ' daily="' +
                                    dbdaily + '" status=variable vmaxpu=1.5 vminpu=0.93')

    def _monta_dataframe_gerador_mt(self, geradores):
        lista_linhas_df = []
        for gerador in geradores:
            barra = gerador.barra
            if barra is None:
                continue

            # determina o faseamento do gerador
            if gerador.lig_fas == 'AX':
                fas_con = 'AN'
            elif gerador.lig_fas == 'BX':
                fas_con = 'BN'
            elif gerador.lig_fas == 'CX':
                fas_con = 'CN'
            else:
                fas_con = gerador.lig_fas

            lista_linha_df = []
            lista_linha_df.append(gerador.codigo)  # COD_ID
            lista_linha_df.append('circuito')  # CTMT
            lista_linha_df.append(barra.codigo)  # PAC
            lista_linha_df.append(fas_con)  # FAS_CON
            lista_linha_df.append(gerador.kv_nom)  # TEN
            lista_linha_df.append(gerador.kw_inst)  # POT_INST
            # insere energias (ENE_01, ENE_02, ..., ENE_12)
            for ene in gerador.kwhs:
                lista_linha_df.append(ene)
            lista_linhas_df.append(lista_linha_df)
        dfgeradormt = pd.DataFrame(lista_linhas_df, columns=['COD_ID', 'CTMT', 'PAC', 'FAS_CON', 'TEN', 'POT_INST',
                                                             'ENE_01', 'ENE_02', 'ENE_03', 'ENE_04', 'ENE_05', 'ENE_06',
                                                             'ENE_07', 'ENE_08', 'ENE_09', 'ENE_10', 'ENE_11',
                                                             'ENE_12'])
        return dfgeradormt

    def _get_lines_reguladores(self, bloco, linhas_reguladores_dss) -> None:
        """ Função para determinar as linhas (DSS) referentes aos reguladores MT """
        # Monta dataframe de reguladores
        dfreg = self._monta_dataframe_reguladores(bloco)
        dfreg2 = dfreg.copy()
        dfreg['FasesCoinc'] = ''
        A = dfreg[(dfreg.CODBNC == 1) & (dfreg.TIP_REGU == 2)].merge(
            dfreg2[(dfreg2.CODBNC == 2) & (dfreg.TIP_REGU == 2)], on='COD_ID_UN')[[
            'COD_ID_UN', 'LIG_FAS_P_EQ_x', 'LIG_FAS_S_EQ_x', 'LIG_FAS_P_EQ_y', 'LIG_FAS_S_EQ_y']]
        if not A.empty:
            A['FasesCoinc'] = A.apply(fases_coincidentes_reguladores, axis=1)
            dfreg.loc[:, 'FasesCoinc'] = dfreg.COD_ID_UN.map(A.set_index('COD_ID_UN')['FasesCoinc'])

        # Aplica função que gera as linhas do arquivo final de reguladores
        dfreg.apply(self._write_to_dss_reguladores_from_dataframe, axis=1, args=(linhas_reguladores_dss,))

    def _write_to_dss_reguladores_from_dataframe(self, x, linhas_reguladores_dss):
        strNome = x.loc['COD_ID_UN']
        strBus1 = x.loc['PAC_1']
        strBus2 = x.loc['PAC_2']
        intTipRegul = x.loc['TIP_REGU']
        intCodBnc = x.loc['CODBNC']
        strCodFasPrim = x.loc['LIG_FAS_P_EQ']
        strCodFasSecu = x.loc['LIG_FAS_S_EQ']
        dblTensaoPrimTrafo_kV = x.loc['TEN_PRI_EQ']
        PotNom_kVA = x.loc['POT_EQ']
        dblTenRgl_pu = x.loc['TEN_REG']
        ReatHL_per = x.loc['XHL']
        dblPerdVz_per = x.loc['PER_FER']
        dblPerdTtl_per = x.loc['PER_TOT']
        strCodCoinc = x.loc['FasesCoinc']

        dblkvREG = tensao_enrolamento(strCodFasPrim, dblTensaoPrimTrafo_kV)

        linhas_reguladores_dss.append('New "Transformer.REG_' + strNome + nome_banco(intCodBnc) + '"' + " phases=" +
                                      numero_fases_transformador(
                                          strCodFasPrim) + " windings=2 buses=[" + '"' + strBus1 +
                                      nos(strCodFasPrim) + '"' + ' "' + strBus2 + nos(
            strCodFasSecu) + '"' + "] conns=[" +
                                      ligacao_trafo(strCodFasPrim) + " " + ligacao_trafo(strCodFasSecu) + "] kvs=[" +
                                      str(dblkvREG) + " " + str(dblkvREG) + "] kvas=[" +
                                      str(PotNom_kVA) + " " + str(PotNom_kVA) + "] xhl=" + str(
            ReatHL_per) + " %loadloss=" +
                                      str((dblPerdTtl_per - dblPerdVz_per)) + " %noloadloss=" + str(dblPerdVz_per))
        linhas_reguladores_dss.append(
            'New "Regcontrol.REG_' + strNome + nome_banco(intCodBnc) + '"' + ' transformer="REG_' +
            strNome + nome_banco(intCodBnc) + '"' + " winding=2 vreg=" +
            str(float(dblTenRgl_pu) * 100) + " band=2 ptratio=" + str(float(dblkvREG) * 10))
        if intTipRegul == 2 and intCodBnc == 2:
            linhas_reguladores_dss.append(
                'New "Line.REG' + strNome + '_J" phases=' + numero_fases_transformador(strCodCoinc) +
                ' bus1="' + strBus1 + nos(strCodCoinc) + '"' + ' bus2="' + strBus2 + nos(strCodCoinc) +
                '"' + " r0=1e-3  r1=1e-3  x0=0  x1=0  c0=0 c1=0" + '\n')

    def _monta_dataframe_reguladores(self, bloco):
        lista_linhas_df = []
        erros_barras, total_reguladores = 0, 0
        for regulador in bloco.reguladores:
            total_reguladores += 1

            barra1 = regulador.barra1
            barra2 = regulador.barra2
            if barra1 is None or barra2 is None:
                erros_barras += 1
                continue

            if regulador.propriedade == 'PD':
                per_fer = regulador.per_fer / (10 * regulador.kva_nom)
                per_tot = regulador.per_tot / (10 * regulador.kva_nom)
            else:
                per_fer = 0.0
                per_tot = 0.0

            # print('regulador {} - rel_tp_id: {} - tip_regu {}'.format(regulador.codigo, regulador.rel_tp_id,
            #                                                       regulador.tipo_regulador))
            if int(regulador.rel_tp_id) == 3:
                ten_pri_eq = 34.5 / math.sqrt(3)
            elif int(regulador.rel_tp_id) == 4:
                ten_pri_eq = 25 / math.sqrt(3)
            elif int(regulador.rel_tp_id) == 6:
                ten_pri_eq = 23 / math.sqrt(3)
            elif int(regulador.rel_tp_id) == 10:
                ten_pri_eq = 14.4 / math.sqrt(3)
            elif int(regulador.rel_tp_id) == 15:
                ten_pri_eq = 13.8 / math.sqrt(3)
            elif int(regulador.rel_tp_id) == 17:
                ten_pri_eq = 7.6 / math.sqrt(3)
            elif int(regulador.rel_tp_id) == 19:
                ten_pri_eq = 34.5
            elif int(regulador.rel_tp_id) == 20:
                ten_pri_eq = 25
            elif int(regulador.rel_tp_id) == 21:
                ten_pri_eq = 23
            elif int(regulador.rel_tp_id) == 22:
                ten_pri_eq = 14.4
            elif int(regulador.rel_tp_id) == 23:
                ten_pri_eq = 13.8
            elif int(regulador.rel_tp_id) == 24:
                ten_pri_eq = 7.6
            else:
                ten_pri_eq = 0.0

            if regulador.tipo_regulador == 'M':
                tip_regu = 1
            elif regulador.tipo_regulador == 'T':
                tip_regu = 3
            elif regulador.tipo_regulador == 'DA':
                tip_regu = 2
            elif regulador.tipo_regulador == 'DF':
                tip_regu = 4
            else:
                tip_regu = 0

            lista_linha_df = []
            lista_linha_df.append(regulador.codigo)  # COD_ID_UN
            lista_linha_df.append(barra1.codigo)  # PAC_1
            lista_linha_df.append(barra2.codigo)  # PAC_2
            lista_linha_df.append(tip_regu)  # TIP_REGU
            lista_linha_df.append(regulador.cod_bnc)  # CODBNC
            lista_linha_df.append(regulador.lig_fas_p)  # LIG_FAS_P_EQ
            lista_linha_df.append(regulador.lig_fas_s)  # LIG_FAS_S_EQ
            lista_linha_df.append(ten_pri_eq)  # TEN_PRI_EQ
            lista_linha_df.append(regulador.kva_nom)  # POT_EQ
            lista_linha_df.append('circuito')  # CTMT
            lista_linha_df.append(regulador.ten_reg_pu)  # TEN_REG
            lista_linha_df.append(regulador.r)  # R
            lista_linha_df.append(regulador.xhl)  # XHL
            lista_linha_df.append(regulador.propriedade)  # POS
            lista_linha_df.append(per_fer)  # PER_FER
            lista_linha_df.append(per_tot)  # PER_TOT
            lista_linhas_df.append(lista_linha_df)

        df_reguladores = pd.DataFrame(lista_linhas_df, columns=['COD_ID_UN', 'PAC_1', 'PAC_2', 'TIP_REGU', 'CODBNC',
                                                                'LIG_FAS_P_EQ', 'LIG_FAS_S_EQ', 'TEN_PRI_EQ', 'POT_EQ',
                                                                'CTMT', 'TEN_REG', 'R', 'XHL', 'POS', 'PER_FER',
                                                                'PER_TOT'])

        return df_reguladores

    def _get_lines_trafos(self, trafos, circuito, linhas_trafos_dss) -> None:
        """ Função para determinar as linhas (DSS) referentes aos trafos MT/BT

            Perda do trafo (loadloss e noloadloss) é zerada no arquivo .DSS para a opção
            “Neutralizar transformadores de terceiros
            Para transformadores a vazio, o transformador é comentado no arquivo.DSS para a opção “Eliminar
            transformadores a vazio”, e toda a rede BT a jusante também é comentada.
        """
        neutralizar_transformadores_terceiros = False
        eliminar_transformadores_vazio = False
        srt_comment_dss = ''

        for trafo in trafos:
            # verifica se está operando em vazio
            ene_total, vazio, cargas_bt = 0, True, None
            for et_bt in circuito.ets:
                if et_bt.codigo == trafo.codigo:
                    cargas_bt = et_bt.cargas_bt
                    break
            if cargas_bt is not None:
                for carga in cargas_bt:
                    ene_total += carga.ene_01 + carga.ene_02 + carga.ene_03 + carga.ene_04 + carga.ene_05
                    ene_total += carga.ene_06 + carga.ene_07 + carga.ene_08 + carga.ene_09 + carga.ene_10
                    ene_total += carga.ene_11 + carga.ene_12
                    if ene_total > 0:
                        break
                if ene_total > 0:
                    vazio = False

            # Avalia o tipo do trafo
            if trafo.tipo_trafo == 'M':
                tipo_trafo = 1
            elif trafo.tipo_trafo == 'MT':
                tipo_trafo = 2
            elif trafo.tipo_trafo == 'B':
                tipo_trafo = 3
            elif trafo.tipo_trafo == 'T':
                tipo_trafo = 4
            elif trafo.tipo_trafo == 'DF':
                tipo_trafo = 5
            elif trafo.tipo_trafo == 'DA':
                tipo_trafo = 6
            else:
                tipo_trafo = 0

            # Cálculo das perdas do trafo
            if trafo.propriedade == 'PD':
                perda_ferro = trafo.perda_ferro / (10 * trafo.kva_nom)
                perda_total = trafo.perda_total / (10 * trafo.kva_nom)
            else:
                perda_ferro = 0.0
                perda_total = 0.0
            if trafo.propriedade != 'PD' and neutralizar_transformadores_terceiros:
                PerdaCobreTrafo_per = 0
                PerdaFerroTrafo_per = 0
            else:
                trafo_kV_linha = trafo.kv1
                # Se for trifásico ou bifásico, mantém a tensão do TEN_LIN_PRI, do contrário, multiplica por raiz de 3
                if numero_fases(trafo.lig_fas_p) == 1:
                    trafo_kV_linha = trafo.kv1 * math.sqrt(3)

                PerdaTotalTrafo_per = perda_total_trafo(trafo.lig_fas_p, float(trafo.kva_nom),
                                                        trafo_kV_linha, float(perda_total))
                PerdaFerroTrafo_per = perda_vazio_trafo(trafo.lig_fas_p, float(trafo.kva_nom),
                                                        trafo_kV_linha, float(perda_ferro))
                PerdaCobreTrafo_per = PerdaTotalTrafo_per - PerdaFerroTrafo_per

            mrt = trafo.mrt
            if not vazio:
                if mrt == 1:
                    linha = 'new transformer.TRF_' + trafo.codigo + nome_banco(1) + \
                            ' phases=' + numero_fases_transformador(trafo.lig_fas_p) + \
                            ' windings=' + quantidade_enrolamentos(trafo.lig_fas_t, trafo.lig_fas_s) + \
                            ' buses=[' + nos_com_neutro_trafo(trafo.lig_fas_p,
                                                              trafo.lig_fas_s,
                                                              trafo.lig_fas_t,
                                                              trafo.ten_lin_sec, 'MRT_' +
                                                              trafo.barra1.codigo + 'TRF_' +
                                                              trafo.codigo + nome_banco(1),
                                                              trafo.barra2.codigo) + ']' \
                                                                                     ' conns=[' + conexoes_trafo(
                        trafo.lig_fas_p, trafo.lig_fas_s, trafo.lig_fas_t) + ']' \
                                                                             ' kvs=(' + kvs_trafo(tipo_trafo,
                                                                                                  trafo.lig_fas_p,
                                                                                                  trafo.lig_fas_s,
                                                                                                  trafo.lig_fas_t,
                                                                                                  float(trafo.kv1),
                                                                                                  float(
                                                                                                      trafo.ten_lin_sec)) + ')' \
                                                                                                                            ' taps=[' + tap_trafo(
                        trafo.lig_fas_t, str(trafo.tap)) + ']' \
                                                           ' kvas=(' + kvas_trafo(trafo.lig_fas_s, trafo.lig_fas_t,
                                                                                  float(trafo.kva_nom)) + ')' \
                                                                                                          ' %loadloss=' + str(
                        PerdaCobreTrafo_per) + ' %noloadloss=' + str(PerdaFerroTrafo_per)
                    linhas_trafos_dss.append(linha)
                    linha = retorna_dss_segmento_mt('Resist_MTR_TRF_' + trafo.codigo + nome_banco(1),
                                                    trafo.lig_fas_p, trafo.barra1.codigo, 'MRT_' +
                                                    trafo.barra1.codigo + 'TRF_' + trafo.codigo +
                                                    nome_banco(1), 'LC_MRT_TRF_' + trafo.codigo +
                                                    nome_banco(1), 0.001, 'PD')
                    linhas_trafos_dss.append(linha)
                    linha = 'New "Reactor.TRF_' + trafo.codigo + nome_banco(1) + "_R" + '"' + \
                            ' phases=1 bus1=' + trafo.barra2.codigo + '.4' + ' R=15 X=0 basefreq=60'
                    linhas_trafos_dss.append(linha)

                else:
                    linha = 'New "Transformer.TRF_' + trafo.codigo + nome_banco(1) + '"' + \
                            ' phases=' + numero_fases_transformador(trafo.lig_fas_p) + \
                            ' windings=' + quantidade_enrolamentos(trafo.lig_fas_t, trafo.lig_fas_s) + \
                            ' buses=[' + nos_com_neutro_trafo(trafo.lig_fas_p, trafo.lig_fas_s, trafo.lig_fas_t,
                                                              trafo.ten_lin_sec, trafo.barra1.codigo,
                                                              trafo.barra2.codigo) + ']' \
                                                                                     ' conns=[' + conexoes_trafo(
                        trafo.lig_fas_p, trafo.lig_fas_s, trafo.lig_fas_t) + ']' \
                                                                             ' kvs=[' + kvs_trafo(tipo_trafo,
                                                                                                  trafo.lig_fas_p,
                                                                                                  trafo.lig_fas_s,
                                                                                                  trafo.lig_fas_t,
                                                                                                  float(trafo.kv1),
                                                                                                  float(
                                                                                                      trafo.ten_lin_sec)) + ']' \
                                                                                                                            ' taps=[' + tap_trafo(
                        trafo.lig_fas_t, str(trafo.tap)) + ']' \
                                                           ' kvas=[' + kvas_trafo(trafo.lig_fas_s, trafo.lig_fas_t,
                                                                                  float(trafo.kva_nom)) + '] ' \
                                                                                                          '%loadloss=' + str(
                        PerdaCobreTrafo_per) + ' %noloadloss=' + str(PerdaFerroTrafo_per)
                    linhas_trafos_dss.append(linha)
                    linha = 'New "Reactor.TRF_' + trafo.codigo + nome_banco(1) + '_R' + '"' + \
                            ' phases=1 bus1=' + trafo.barra2.codigo + '.4' + ' R=15 X=0 basefreq=60'
                    linhas_trafos_dss.append(linha)
            else:
                if eliminar_transformadores_vazio:
                    srt_comment_dss = '!'
                if mrt == 1:
                    linha = srt_comment_dss + 'New "Transformer.TRF_' + trafo.codigo + nome_banco(1) + '"' + \
                            ' phases=' + numero_fases_transformador(trafo.lig_fas_p) + \
                            ' windings=' + quantidade_enrolamentos(trafo.lig_fas_t, trafo.lig_fas_s) + \
                            ' buses=[' + nos_com_neutro_trafo(trafo.lig_fas_p, trafo.lig_fas_s, trafo.lig_fas_t,
                                                              trafo.ten_lin_sec, 'MRT_' + trafo.barra1.codigo +
                                                              'TRF_' + trafo.codigo + nome_banco(1),
                                                              trafo.barra2.codigo) + ']' \
                                                                                     ' conns=[' + conexoes_trafo(
                        trafo.lig_fas_p, trafo.lig_fas_s, trafo.lig_fas_t) + ']' \
                                                                             ' kvs=[' + kvs_trafo(tipo_trafo,
                                                                                                  trafo.lig_fas_p,
                                                                                                  trafo.lig_fas_s,
                                                                                                  trafo.lig_fas_t,
                                                                                                  float(trafo.kv1),
                                                                                                  float(
                                                                                                      trafo.ten_lin_sec)) + ']' \
                                                                                                                            ' taps=[' + tap_trafo(
                        trafo.lig_fas_t, str(trafo.tap)) + ']' \
                                                           ' kvas=[' + kvas_trafo(trafo.lig_fas_s, trafo.lig_fas_t,
                                                                                  float(trafo.kva_nom)) + ']' \
                                                                                                          ' %loadloss=' + str(
                        PerdaCobreTrafo_per) + " %noloadloss=" + str(PerdaFerroTrafo_per)
                    linhas_trafos_dss.append(linha)
                    linha = '!' + retorna_dss_segmento_mt('Resist_MTR_TRF_' + trafo.codigo + nome_banco(1),
                                                          trafo.lig_fas_p, trafo.barra1.codigo, 'MRT_' +
                                                          trafo.barra1.codigo + 'TRF_' + trafo.codigo + nome_banco(1),
                                                          'LC_MRT_TRF_' + trafo.codigo + nome_banco(1), 0.001, 'PD')
                    linhas_trafos_dss.append(linha)

                    linha = srt_comment_dss + 'New "Reactor.TRF_' + trafo.codigo + nome_banco(1) + '_R' + '"' + \
                            ' phases=1 bus1=' + '"' + trafo.barra2.codigo + '.4' + '"' + \
                            ' R=15 X=0 basefreq=60'
                    linhas_trafos_dss.append(linha)
                else:
                    linha = srt_comment_dss + 'New "Transformer.TRF_' + trafo.codigo + nome_banco(1) + '"' + \
                            ' phases=' + numero_fases_transformador(trafo.lig_fas_p) + \
                            ' windings=' + quantidade_enrolamentos(trafo.lig_fas_t, trafo.lig_fas_s) + \
                            ' buses=[' + nos_com_neutro_trafo(trafo.lig_fas_p, trafo.lig_fas_s, trafo.lig_fas_t,
                                                              trafo.ten_lin_sec, trafo.barra1.codigo,
                                                              trafo.barra2.codigo) + ']' \
                                                                                     ' conns=[' + conexoes_trafo(
                        trafo.lig_fas_p, trafo.lig_fas_s, trafo.lig_fas_t) + ']' \
                                                                             ' kvs=[' + kvs_trafo(tipo_trafo,
                                                                                                  trafo.lig_fas_p,
                                                                                                  trafo.lig_fas_s,
                                                                                                  trafo.lig_fas_t,
                                                                                                  float(trafo.kv1),
                                                                                                  float(
                                                                                                      trafo.ten_lin_sec)) + ']' \
                                                                                                                            ' taps=[' + tap_trafo(
                        trafo.lig_fas_t, str(trafo.tap)) + ']' \
                                                           ' kvas=[' + kvas_trafo(trafo.lig_fas_s, trafo.lig_fas_t,
                                                                                  float(trafo.kva_nom)) + ']' \
                                                                                                          ' %loadloss=' + str(
                        PerdaCobreTrafo_per) + ' %noloadloss=' + str(PerdaFerroTrafo_per)
                    linhas_trafos_dss.append(linha)
                    linha = srt_comment_dss + 'New "Reactor.TRF_' + trafo.codigo + nome_banco(1) + '_R' + '"' + \
                            ' phases=1 bus1=' + trafo.barra2.codigo + '.4' + ' R=15 X=0 basefreq=60'
                    linhas_trafos_dss.append(linha)

    def _get_lines_cargas_mt_simplif(self, cargas, lista_curvas_carga, linhas_cargas_dss) -> None:
        """ Função para determinar as linhas (DSS) referentes às cargas do ciruito """
        for carga in cargas:
            # Determina a curva de carga simplificada
            curva_carga_dict = None
            for curva_carga_dict in lista_curvas_carga:
                print("Localizando Curva de carga:{}".format(curva_carga_dict['codigo']))
                if curva_carga_dict['codigo'] == carga.curva:
                    break
                else:
                    curva_carga_dict = None
            if curva_carga_dict is None:
                continue

            # Determina a demanda máxima em kw
            ene_anual = carga.ene_01 + carga.ene_02 + carga.ene_03 + carga.ene_04 + carga.ene_05 + carga.ene_06 + \
                        carga.ene_07 + carga.ene_08 + carga.ene_09 + carga.ene_10 + carga.ene_11 + carga.ene_12
            kw_max = ene_anual / (365 * 24 * curva_carga_dict['fc'])
            kva_max = kw_max / 0.92
            if kw_max > 0.0:
                linhas_cargas_dss.append('New "Load.MT_' + carga.codigo + '_M1" bus1="' + carga.barra.codigo + nos(
                    carga.lig_fas) + '"' + " phases=" + numero_fases_carga(carga.lig_fas) + " conn=" + ligacao_carga(
                    carga.lig_fas) + " model=2" + " kv=" + str(carga.kv_nom) + " allocationfactor=0.5 xfkva=" + str(
                    kva_max) + " pf=0.92" + ' daily="' + carga.curva + '" status=variable vmaxpu=1.5 vminpu=0.93')
                linhas_cargas_dss.append('New "Load.MT_' + carga.codigo + '_M2" bus1="' + carga.barra.codigo + nos(
                    carga.lig_fas) + '"' + " phases=" + numero_fases_carga(carga.lig_fas) + " conn=" + ligacao_carga(
                    carga.lig_fas) + " model=3" + " kv=" + str(carga.kv_nom) + " allocationfactor=0.5 xfkva=" + str(
                    kva_max) + " pf=0.92" + ' daily="' + carga.curva + '" status=variable vmaxpu=1.5 vminpu=0.93')
            else:
                linhas_cargas_dss.append('!New "Load.MT_' + carga.codigo + '_M1" bus1="' + carga.barra.codigo + nos(
                    carga.lig_fas) + '"' + " phases=" + numero_fases_carga(carga.lig_fas) + " conn=" + ligacao_carga(
                    carga.lig_fas) + " model=2" + " kv=" + str(carga.kv_nom) + " allocationfactor=0.5 xfkva=" + str(
                    kva_max) + " pf=0.92" + ' daily="' + carga.curva + '" status=variable vmaxpu=1.5 vminpu=0.93')
                linhas_cargas_dss.append('!New "Load.MT_' + carga.codigo + '_M2" bus1="' + carga.barra.codigo + nos(
                    carga.lig_fas) + '"' + " phases=" + numero_fases_carga(carga.lig_fas) + " conn=" + ligacao_carga(
                    carga.lig_fas) + " model=3" + " kv=" + str(carga.kv_nom) + " allocationfactor=0.5 xfkva=" + str(
                    kva_max) + " pf=0.92" + ' daily="' + carga.curva + '" status=variable vmaxpu=1.5 vminpu=0.93')

    def _get_lines_cargas_mt(self, cargas, df_curva_carga, linhas_cargas_dss) -> bool:
        # Monta o dataframe das cargas MT
        dfcargasmt = self._monta_dataframe_carga_mt(cargas)
        dfcargasmt = self._incrementa_dataframe_carga(dfcargasmt, df_curva_carga)
        # Aplica função que gera as linhas de cargas MT do arquivo final de cargas
        i, j = 8, 1
        dfcargasmt.apply(self._write_to_dss_cargas_mt_from_dataframe, axis=1, args=(i, j, linhas_cargas_dss))
        return False

    def _incrementa_dataframe_carga(self, dfcargasmt, df_curva_carga):
        dfcargasmt['fcDU'] = dfcargasmt.TIP_CC.map(
            df_curva_carga.loc[df_curva_carga['TipoDia'] == 'DU'].set_index('CodCrvCrg')['fc'])
        dfcargasmt['fcSA'] = dfcargasmt.TIP_CC.map(
            df_curva_carga.loc[df_curva_carga['TipoDia'] == 'SA'].set_index('CodCrvCrg')['fc'])
        dfcargasmt['fcDO'] = dfcargasmt.TIP_CC.map(
            df_curva_carga.loc[df_curva_carga['TipoDia'] == 'DO'].set_index('CodCrvCrg')['fc'])
        dfcargasmt['ENE_TOTAL'] = dfcargasmt.loc[:, 'ENE_01':'ENE_12'].sum(axis=1)

        for x in range(0, 12):
            xaux = str(x + 1)
            if (x + 1) < 10:
                xaux = '0' + str(x + 1)

            A = dfcargasmt.TIP_CC.map(df_curva_carga.loc[df_curva_carga['TipoDia'] == 'DU'].set_index('CodCrvCrg')[
                                          'PropEnerMens' + str(x + 1)]).astype(float)
            B = dfcargasmt['ENE_' + xaux]
            C = dfcargasmt.TIP_CC.map(
                df_curva_carga.loc[df_curva_carga['TipoDia'] == 'DU'].set_index('CodCrvCrg')['fc'])
            D = dfcargasmt.TIP_CC.map(
                df_curva_carga.loc[df_curva_carga['TipoDia'] == 'DU'].set_index('CodCrvCrg')['DiasMes' + str(x + 1)])
            dfcargasmt['DemMaxDU' + str(x + 1) + '_kW'] = A * B / (C * 24 * D)

            A = dfcargasmt.TIP_CC.map(df_curva_carga.loc[df_curva_carga['TipoDia'] == 'SA'].set_index('CodCrvCrg')[
                                          'PropEnerMens' + str(x + 1)]).astype(float)
            B = dfcargasmt['ENE_' + xaux]
            C = dfcargasmt.TIP_CC.map(
                df_curva_carga.loc[df_curva_carga['TipoDia'] == 'SA'].set_index('CodCrvCrg')['fc'])
            D = dfcargasmt.TIP_CC.map(
                df_curva_carga.loc[df_curva_carga['TipoDia'] == 'SA'].set_index('CodCrvCrg')['DiasMes' + str(x + 1)])
            dfcargasmt['DemMaxSA' + str(x + 1) + '_kW'] = A * B / (C * 24 * D)

            A = dfcargasmt.TIP_CC.map(df_curva_carga.loc[df_curva_carga['TipoDia'] == 'DO'].set_index('CodCrvCrg')[
                                          'PropEnerMens' + str(x + 1)]).astype(float)
            B = dfcargasmt['ENE_' + xaux]
            C = dfcargasmt.TIP_CC.map(
                df_curva_carga.loc[df_curva_carga['TipoDia'] == 'DO'].set_index('CodCrvCrg')['fc'])
            D = dfcargasmt.TIP_CC.map(
                df_curva_carga.loc[df_curva_carga['TipoDia'] == 'DO'].set_index('CodCrvCrg')['DiasMes' + str(x + 1)])
            dfcargasmt['DemMaxDO' + str(x + 1) + '_kW'] = A * B / (C * 24 * D)
        return dfcargasmt

    def _monta_dataframe_carga_mt(self, cargas):
        lista_linhas_df = []
        for carga in cargas:
            if carga.tipo_carga != 'mt':
                continue
            if carga.barra is None:
                continue
            lista_linha_df = []
            lista_linha_df.append(carga.codigo)
            lista_linha_df.append('circuito')
            lista_linha_df.append(carga.curva)
            lista_linha_df.append(carga.lig_fas)
            lista_linha_df.append(carga.kv_nom)
            lista_linha_df.append(carga.barra.codigo)
            lista_linha_df.append(carga.ene_01)
            lista_linha_df.append(carga.ene_02)
            lista_linha_df.append(carga.ene_03)
            lista_linha_df.append(carga.ene_04)
            lista_linha_df.append(carga.ene_05)
            lista_linha_df.append(carga.ene_06)
            lista_linha_df.append(carga.ene_07)
            lista_linha_df.append(carga.ene_08)
            lista_linha_df.append(carga.ene_09)
            lista_linha_df.append(carga.ene_10)
            lista_linha_df.append(carga.ene_11)
            lista_linha_df.append(carga.ene_12)
            lista_linhas_df.append(lista_linha_df)
        dfcargasmt = pd.DataFrame(lista_linhas_df,
                                  columns=['COD_ID', 'CTMT', 'TIP_CC', 'FAS_CON', 'TEN', 'PAC', 'ENE_01',
                                           'ENE_02', 'ENE_03', 'ENE_04', 'ENE_05', 'ENE_06', 'ENE_07',
                                           'ENE_08', 'ENE_09', 'ENE_10', 'ENE_11', 'ENE_12'])
        return dfcargasmt

    def _write_to_dss_cargas_mt_from_dataframe(self, x, i, j, linhas_cargas_dss):
        strName = x.loc['COD_ID']
        strCodCrvCrg = x.loc['TIP_CC'] + '_' + tipo_dia(j)
        strCodFas = x.loc['FAS_CON']
        dblTensao_kV = x.loc['TEN']
        strBus = x.loc['PAC']
        dblDemMax_kW = x.loc['DemMax' + tipo_dia(j) + str(i) + '_kW']

        if dblDemMax_kW > 0.0:
            linhas_cargas_dss.append('New "Load.MT_' + strName + '_M1" bus1="' + strBus + nos(
                strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                strCodFas) + " model=2" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.7f}" +
                                     " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')
            linhas_cargas_dss.append('New "Load.MT_' + strName + '_M2" bus1="' + strBus + nos(
                strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                strCodFas) + " model=3" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.7f}" +
                                     " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')
        else:
            linhas_cargas_dss.append('!New "Load.MT_' + strName + '_M1" bus1="' + strBus + nos(
                strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                strCodFas) + " model=2" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.7f}" +
                                     " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')
            linhas_cargas_dss.append('!New "Load.MT_' + strName + '_M2" bus1="' + strBus + nos(
                strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                strCodFas) + " model=3" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.7f}" +
                                     " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')

    def _get_lines_trechos(self, trechos, is_bt, linhas_trechos_dss) -> None:
        """ Função para obter as linhas (DSS) referentes aos trechos

        Caso seja de um terceiro, o programa da ANEEL transforma aquele trecho numa chave sem perdas no arquivo .DSS
        (caso tenha habilitado para “Neutralizar redes de terceiros”)

        O transformador é comentado no arquivo .DSS (caso habilite a opção “Eliminar transformadores a vazio”),
        e toda a rede BT a jusante dele também é comentada. (ainda nao implementadoa eliminação da rede a jusante!)
        """
        neutralizar_redes_terceiros = False
        eliminar_transformadores_vazio = False
        srt_comment_dss = ''
        if eliminar_transformadores_vazio or neutralizar_redes_terceiros:
            srt_comment_dss = '!'

        for trecho in trechos:
            if is_bt:
                num_fases = numero_fases_segmento_neutro(trecho.fases_conexao)
                identif_mt_bt = "SBT_"
                if trecho.ramlig:
                    identif_mt_bt = "RBT_"
            else:
                num_fases = numero_fases_segmento(trecho.fases_conexao)
                identif_mt_bt = "SMT_"

            if trecho.propriedade == "PD" or not neutralizar_redes_terceiros:
                linha = 'New "Line.' + identif_mt_bt + trecho.codigo + '"' + " phases=" + num_fases + \
                        " bus1=" + '"' + trecho.barra1.codigo + nos_com_neutro(trecho.fases_conexao) + '"' + \
                        " bus2=" + '"' + trecho.barra2.codigo + nos_com_neutro(trecho.fases_conexao) + '"' + \
                        " linecode=" + '"' + trecho.arranjo.codigo + "_" + num_fases + '"' + \
                        " length=" + f'{trecho.compr:.8f}' + " units=km"
            elif trecho.propriedade != "PD" and neutralizar_redes_terceiros:
                linha = srt_comment_dss + 'New "Line.' + identif_mt_bt + trecho.codigo + '"' + " phases=" + num_fases + \
                        " bus1=" + '"' + trecho.barra1.codigo + nos_com_neutro(trecho.fases_conexao) + '"' + \
                        " bus2=" + '"' + trecho.barra2.codigo + nos_com_neutro(trecho.fases_conexao) + '"' + \
                        " r1=0.001 r0=0.001 x1=0 x0=0 c1=0 c0=0 length=" + f'{trecho.compr:.8f}' + " units=km switch=T"
            linhas_trechos_dss.append(linha)

    def _write_to_dss_arranjos_trafos(self, trafos, linhas_arranjos_dss) -> None:
        """ Função para escrever os arranjos referentes a MRT dos transformadores """
        for trafo in trafos:
            if trafo.mrt == 1:
                nome = 'LC_MRT_TRF_' + trafo.codigo + nome_banco(1)
                linha = 'New "Linecode.' + nome + "_1" + '"' + " nphases=1 basefreq=60 r1=15000 x1=0 units=km normamps=0"
                linhas_arranjos_dss.append(linha)
                linha = 'New "Linecode.' + nome + "_2" + '"' + " nphases=2 basefreq=60 r1=15000 x1=0 units=km normamps=0"
                linhas_arranjos_dss.append(linha)
                linha = 'New "Linecode.' + nome + "_3" + '"' + " nphases=3 basefreq=60 r1=15000 x1=0 units=km normamps=0"
                linhas_arranjos_dss.append(linha)
                linha = 'New "Linecode.' + nome + "_4" + '"' + " nphases=4 basefreq=60 r1=15000 x1=0 units=km normamps=0"
                linhas_arranjos_dss.append(linha)

    def _write_to_dss_arranjos(self, linhas_arranjos_dss) -> None:
        """ Função para obter as linhas (DSS) referentes aos arranjos dos trechos MT """
        # Escreve os arranjos referentes aos trechos MT
        for cabo in self.memoria_interna.cabos:
            linha = 'New "Linecode.' + cabo.codigo + "_1" + '"' + ' nphases=1 basefreq=60 r1=' + str(cabo.r1) + \
                    " x1=" + str(cabo.x1) + " units=km normamps=" + str(cabo.iadm)
            linhas_arranjos_dss.append(linha)
            linha = 'New "Linecode.' + cabo.codigo + "_2" + '"' + ' nphases=2 basefreq=60 r1=' + str(cabo.r1) + \
                    " x1=" + str(cabo.x1) + " units=km normamps=" + str(cabo.iadm)
            linhas_arranjos_dss.append(linha)
            linha = 'New "Linecode.' + cabo.codigo + "_3" + '"' + ' nphases=3 basefreq=60 r1=' + str(cabo.r1) + \
                    " x1=" + str(cabo.x1) + " units=km normamps=" + str(cabo.iadm)
            linhas_arranjos_dss.append(linha)
            linha = 'New "Linecode.' + cabo.codigo + "_4" + '"' + ' nphases=4 basefreq=60 r1=' + str(cabo.r1) + \
                    " x1=" + str(cabo.x1) + " units=km normamps=" + str(cabo.iadm)
            linhas_arranjos_dss.append(linha)

    def _get_lines_coordenadas_circuito(self, circuito, linhas_coordenadas) -> None:
        """Função para obter as lista de barras MT e BT e suas coordenadas (UTM)"""
        for bloco in circuito.blocos:
            for barra in bloco.barras:
                coordenadas_barra = f"{barra.codigo}, {str(barra.x)}, {str(barra.y)}"
                linhas_coordenadas.append(coordenadas_barra)
        for et_bt in circuito.ets:
            for barra in et_bt.barras_bt:
                coordenadas_barra = f"{barra.codigo}, {str(barra.x)}, {str(barra.y)}"
                linhas_coordenadas.append(coordenadas_barra)

    def _get_lines_suprimento_circuito(self, se, circuito, linhas_suprimento_dss) -> None:
        """Função para determinar o suprimento de um determinado circuito"""
        cod_barra_ini = circuito.barra_inicial.codigo
        base_kv = 0.0
        for trafo_se in se.trafos_se:
            if trafo_se.codigo == circuito.trafo_se_codigo:
                base_kv = trafo_se.kv2
                break
        tensao_operacao = '1.00'
        if circuito.tensao_oper is not None:
            tensao_operacao = circuito.tensao_oper

        comando = f"new circuit.{circuito.codigo} pu={tensao_operacao} basekv={str(base_kv)} bus1={cod_barra_ini}"
        #comando = comando + f" mvasc3=600 mvasc1=400"
        comando = comando + f" r1=0 x1=0.0001"
        linhas_suprimento_dss.append(comando + '\n')

    def _determina_tensoes_nominais_circuito(self, se, circuito) -> list:
        """Função para determinar todas as tensões nominais (de linha) observadas"""
        tensoes_nominais = []
        if circuito.tensao not in tensoes_nominais and circuito.tensao > 0.0:
            tensoes_nominais.append(circuito.tensao)
        for bloco in circuito.blocos:
            for trafo in bloco.trafos:
                if trafo.ten_lin_sec not in tensoes_nominais and trafo.ten_lin_sec > 0.0:
                    tensoes_nominais.append(trafo.ten_lin_sec)
        return tensoes_nominais

    def _get_lines_curvas_carga_simplif(self, linhas_curvas_carga_dss) -> list:
        curvas_carga = self.memoria_interna.curvas_carga
        # Determina o ano-base
        if len(self.memoria_interna.bases_bdgd) > 0:
            ano = int(self.memoria_interna.bases_bdgd[0].data_base[:4])
        else:
            dt = datetime.datetime.now()
            ano = int(dt.year)

        # Simplifica os pontos da curva de carga, em kW
        for curva in curvas_carga:
            for x in range(0, 24):
                a = [curva.kw_pts[4 * x], curva.kw_pts[1 + 4 * x], curva.kw_pts[2 + 4 * x], curva.kw_pts[3 + 4 * x]]
                b = np.mean(a)
                curva.kw_pts[x] = b
            curva.kw_pts = curva.kw_pts[0:24]

        # Ordena curvas de carga com base no seu código
        curvas_carga.sort(key=lambda obj_curva: obj_curva.codigo)

        # Junta curvas de carga de diferentes dias típicos e normaliza os pontos em relação ao máximo valor
        curva_codigo_ref = ""
        num_tipos_dias = 0
        lista_kws: list
        curvas_carga_equiv_dicts = []
        for curva in curvas_carga:
            if curva.codigo != curva_codigo_ref:
                if num_tipos_dias == 0:
                    num_tipos_dias = 1
                    curva_codigo_ref = curva.codigo
                    lista_kws = [kw for kw in curva.kw_pts]
                    if curvas_carga.index(curva) == len(curvas_carga) - 1:
                        kw_max = kw_med = fc = 0
                        for i in range(24):
                            lista_kws[i] /= num_tipos_dias
                            if lista_kws[i] > kw_max:
                                kw_max = lista_kws[i]
                            kw_med += lista_kws[i]
                        kw_med /= 24
                        if kw_max > 0:
                            fc = kw_med / kw_max
                        # Normaliza os pontos da curva em relação à potência máxima
                        if kw_max > 0:
                            for i in range(24):
                                lista_kws[i] /= kw_max
                        curvas_carga_equiv_dicts.append({'codigo': curva_codigo_ref, 'pts_norm': lista_kws,
                                                         'fc': fc, 'tipo_dia': curva.tipo_dia})
                else:
                    kw_max = kw_med = fc = 0
                    for i in range(24):
                        lista_kws[i] /= num_tipos_dias
                        if lista_kws[i] > kw_max:
                            kw_max = lista_kws[i]
                        kw_med += lista_kws[i]
                    kw_med /= 24
                    if kw_max > 0:
                        fc = kw_med / kw_max
                    # Normaliza os pontos da curva em relação à potência máxima
                    if kw_max > 0:
                        for i in range(24):
                            lista_kws[i] /= kw_max
                    curvas_carga_equiv_dicts.append({'codigo': curva_codigo_ref, 'pts_norm': lista_kws,
                                                     'fc': fc, 'tipo_dia': curva.tipo_dia})

                    num_tipos_dias = 1
                    curva_codigo_ref = curva.codigo
                    lista_kws = [kw for kw in curva.kw_pts]
            else:
                num_tipos_dias += 1
                for i in range(24):
                    lista_kws[i] += curva.kw_pts[i]
                # Verifica se a curva é o último item da lista
                if curvas_carga.index(curva) == len(curvas_carga) - 1:
                    kw_max = kw_med = fc = 0
                    for i in range(24):
                        lista_kws[i] /= num_tipos_dias
                        if lista_kws[i] > kw_max:
                            kw_max = lista_kws[i]
                        kw_med += lista_kws[i]
                    kw_med /= 24
                    if kw_max > 0:
                        fc = kw_med / kw_max
                    # Normaliza os pontos da curva em relação à potência máxima
                    if kw_max > 0:
                        for i in range(24):
                            lista_kws[i] /= kw_max
                    curvas_carga_equiv_dicts.append({'codigo': curva_codigo_ref, 'pts_norm': lista_kws,
                                                     'fc': fc, 'tipo_dia': curva.tipo_dia})

        for curva_dict in curvas_carga_equiv_dicts:
            multiplicadores = ""
            for mult in curva_dict['pts_norm']:
                multiplicadores += f"{mult:.6f}"
                if curva_dict['pts_norm'].index(mult) < len(curva_dict['pts_norm']) - 1:
                    multiplicadores += " "
            linha = 'New "Loadshape.' + curva_dict['codigo'] + '_' + curva_dict['tipo_dia'] + '"' + \
                    " 24 1.0 mult=(" + multiplicadores + ")"
            linhas_curvas_carga_dss.append(linha)

        return curvas_carga_equiv_dicts

    def _calc_curvas_carga_equiv(self) -> dict:
        curvas_carga = self.memoria_interna.curvas_carga
        # Ordena curvas de carga com base no seu código
        curvas_carga.sort(key=lambda obj_curva: obj_curva.codigo)

        # Junta curvas de carga de diferentes dias típicos e normaliza os pontos em relação ao máximo valor
        curva_codigo_ref = ""
        num_tipos_dias = 0
        lista_kws: list
        curvas_carga_equiv_dicts = []
        for curva in curvas_carga:
            if curva.codigo != curva_codigo_ref:
                if num_tipos_dias == 0:
                    num_tipos_dias = 1
                    curva_codigo_ref = curva.codigo
                    lista_kws = [kw for kw in curva.kw_pts]
                    if curvas_carga.index(curva) == len(curvas_carga) - 1:
                        kw_max = kw_med = fc = 0
                        for i in range(24):
                            lista_kws[i] /= num_tipos_dias
                            if lista_kws[i] > kw_max:
                                kw_max = lista_kws[i]
                            kw_med += lista_kws[i]
                        kw_med /= 24
                        if kw_max > 0:
                            fc = kw_med / kw_max
                        # Normaliza os pontos da curva em relação à potência máxima
                        if kw_max > 0:
                            for i in range(24):
                                lista_kws[i] /= kw_max
                        curvas_carga_equiv_dicts.append({'codigo': curva_codigo_ref, 'pts_norm': lista_kws,
                                                         'fc': fc, 'tipo_dia': curva.tipo_dia})
                else:
                    kw_max = kw_med = fc = 0
                    for i in range(24):
                        lista_kws[i] /= num_tipos_dias
                        if lista_kws[i] > kw_max:
                            kw_max = lista_kws[i]
                        kw_med += lista_kws[i]
                    kw_med /= 24
                    if kw_max > 0:
                        fc = kw_med / kw_max
                    # Normaliza os pontos da curva em relação à potência máxima
                    if kw_max > 0:
                        for i in range(24):
                            lista_kws[i] /= kw_max
                    curvas_carga_equiv_dicts.append({'codigo': curva_codigo_ref, 'pts_norm': lista_kws,
                                                     'fc': fc, 'tipo_dia': curva.tipo_dia})

                    num_tipos_dias = 1
                    curva_codigo_ref = curva.codigo
                    lista_kws = [kw for kw in curva.kw_pts]
            else:
                num_tipos_dias += 1
                for i in range(24):
                    lista_kws[i] += curva.kw_pts[i]
                # Verifica se a curva é o último item da lista
                if curvas_carga.index(curva) == len(curvas_carga) - 1:
                    kw_max = kw_med = fc = 0
                    for i in range(24):
                        lista_kws[i] /= num_tipos_dias
                        if lista_kws[i] > kw_max:
                            kw_max = lista_kws[i]
                        kw_med += lista_kws[i]
                    kw_med /= 24
                    if kw_max > 0:
                        fc = kw_med / kw_max
                    # Normaliza os pontos da curva em relação à potência máxima
                    if kw_max > 0:
                        for i in range(24):
                            lista_kws[i] /= kw_max
                    curvas_carga_equiv_dicts.append({'codigo': curva_codigo_ref, 'pts_norm': lista_kws,
                                                     'fc': fc, 'tipo_dia': curva.tipo_dia})
        return curvas_carga_equiv_dicts

    def _get_lines_curvas_carga(self, linhas_curvas_carga_dss) -> list:
        curvas_carga = self.memoria_interna.curvas_carga
        # Determina o ano-base
        if len(self.memoria_interna.bases_bdgd) > 0:
            ano = int(self.memoria_interna.bases_bdgd[0].data_base[:4])
        else:
            dt = datetime.datetime.now()
            ano = int(dt.year)

        # Escreve as linhas referentes às curvas de carga
        todas_curvas = []
        print("Curvas de carga:{}".format(len(curvas_carga)))
        for curva in curvas_carga:
            for x in range(0, 24):
                a = [curva.kw_pts[4 * x], curva.kw_pts[1 + 4 * x], curva.kw_pts[2 + 4 * x], curva.kw_pts[3 + 4 * x]]
                b = np.mean(a)
                curva.kw_pts[x] = b
            curva.kw_pts = curva.kw_pts[0:24]
            soma = sum(curva.kw_pts[0:24])

            curvas_lista = list(curva.kw_pts)
            curvas_lista.append(soma)
            curva.kw_pts = curvas_lista

            info_adicionais = [curva.codigo, curva.tipo_dia]
            curvas_lista = info_adicionais + curvas_lista
            todas_curvas.append(curvas_lista)

        curvas_carga_equiv_dicts = self._calc_curvas_carga_equiv()

        dfcurvas = pd.DataFrame(todas_curvas, columns=['CodCrvCrg', 'TipoDia',
                                                       'PotAtv01_kW', 'PotAtv02_kW', 'PotAtv03_kW', 'PotAtv04_kW',
                                                       'PotAtv05_kW', 'PotAtv06_kW', 'PotAtv07_kW', 'PotAtv08_kW',
                                                       'PotAtv09_kW', 'PotAtv10_kW', 'PotAtv11_kW', 'PotAtv12_kW',
                                                       'PotAtv13_kW', 'PotAtv14_kW', 'PotAtv15_kW', 'PotAtv16_kW',
                                                       'PotAtv17_kW', 'PotAtv18_kW', 'PotAtv19_kW', 'PotAtv20_kW',
                                                       'PotAtv21_kW', 'PotAtv22_kW', 'PotAtv23_kW', 'PotAtv24_kW',
                                                       'Ener_kWh'])
        dfcurvas['EnerClss_kWh'] = dfcurvas.groupby('CodCrvCrg')['Ener_kWh'].transform('sum')
        dfcurvas['prop'] = dfcurvas['Ener_kWh'] / dfcurvas['EnerClss_kWh']
        dfcurvas['PotAtvMedia_kW'] = dfcurvas['Ener_kWh'] / 24
        dfcurvas['PotAtvMax_kW'] = dfcurvas.iloc[:, 2:26].max(axis=1)

        for x in range(0, 24):
            dfcurvas["PotAtvNorm" + str(x + 1)] = dfcurvas.iloc[:, 2 + x].astype(float) / dfcurvas['PotAtvMax_kW']
        dfcurvas['fc'] = dfcurvas['PotAtvMedia_kW'].astype(float) / dfcurvas['PotAtvMax_kW']
        for x in range(0, 12):
            dfcurvas['DiasMes' + str(x + 1)] = 0
            dfcurvas.loc[dfcurvas['TipoDia'] == 'DU', 'DiasMes' + str(x + 1)] = quantidade_dias(x + 1, ano, 'DU')
            dfcurvas.loc[dfcurvas['TipoDia'] == 'SA', 'DiasMes' + str(x + 1)] = quantidade_dias(x + 1, ano, 'SA')
            dfcurvas.loc[dfcurvas['TipoDia'] == 'DO', 'DiasMes' + str(x + 1)] = quantidade_dias(x + 1, ano, 'DO')
            dfcurvas['PropEner' + str(x + 1)] = dfcurvas['prop'] * dfcurvas['DiasMes' + str(x + 1)]
            dfcurvas['PropEnerMens' + str(x + 1)] = dfcurvas['PropEner' + str(x + 1)] / dfcurvas.groupby('CodCrvCrg')[
                'PropEner' + str(x + 1)].transform('sum')

        df_list = dfcurvas.values.tolist()
        for linha_list in df_list:
            multiplicadores = ''
            for i in range(31, 55):
                multiplicadores += str(linha_list[i])
                if i < 54:
                    multiplicadores += ' '

            nome_curva = str(linha_list[0]) + '_' + str(linha_list[1])
            linha = 'New "Loadshape.' + nome_curva + '"' + " 24 1.0 mult=(" + multiplicadores + ")"
            linhas_curvas_carga_dss.append(linha)

        return curvas_carga_equiv_dicts, dfcurvas
