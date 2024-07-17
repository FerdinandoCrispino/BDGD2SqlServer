import numpy as np

from Tools.tools import *
import calendar

"""
# @Date    : 20/06/2024
# @Author  : Ferdinano Crispino
Implemeta funcionalidades de preparação doos dados para escrita dos arquivos do openDSS
"""


class DssFilesGenerator:
    def __init__(self, dist=None, substation=None):
        self.dist = dist
        self.sub = substation

    def get_lines_suprimento_circuito(self, se, circuito, linhas_suprimento_dss) -> None:
        """Função para determinar o suprimento de um determinado circuito"""
        linhas_suprimento_dss.clear()

        codigo = circuito['COD_ID']
        cod_barra_ini = circuito['PAC_INI']
        base_kv = round(circuito['TEN'] / 1000, 2)
        tensao_operacao = circuito['TEN_OPE']

        if tensao_operacao is None:
            tensao_operacao = '1.00'

        comando = f'new "circuit.{codigo}" pu={tensao_operacao} basekv={str(base_kv)} bus1="{cod_barra_ini}"'
        # comando = comando + f" mvasc3=600 mvasc1=400"
        comando = comando + f' r1=0 x1=0.0001'
        linhas_suprimento_dss.append(comando)

    def get_lines_chaves_mt(self, chaves, linhas_chaves_dss) -> None:
        """ Função para gerar as linhas (DSS) referentes às chaves de um determinado circuito """
        linhas_chaves_dss.clear()
        for index in range(chaves.shape[0]):
            sw = chaves.loc[index]['P_N_OPE']
            if sw == 'F':      # chave fechada
                switch = 'T'
            elif sw == 'A':     # chave aberta
                switch = 'F'

            linha = 'New "Line.CMT_' + chaves.loc[index]['COD_ID'] + '"' + " phases=" + numero_fases_segmento(
                chaves.loc[index]['FAS_CON']) + \
                    " bus1=" + '"' + chaves.loc[index]['PAC_1'] + nos_com_neutro(chaves.loc[index]['FAS_CON']) + '"' + \
                    " bus2=" + '"' + chaves.loc[index]['PAC_2'] + nos_com_neutro(chaves.loc[index]['FAS_CON']) + '"' + \
                    " r1=0.001 r0=0.001 x1=0 x0=0 c1=0 c0=0 length=0.001 switch=" + switch
            linhas_chaves_dss.append(linha)

    def get_lines_reguladores(self, reatores, linhas_reguladores_dss):

        linhas_reguladores_dss.clear()
        for index in range(reatores.shape[0]):
            strNome = reatores.loc[index]['COD_ID']
            strBus1 = reatores.loc[index]['PAC_1']
            strBus2 = reatores.loc[index]['PAC_2']
            intTipRegul = reatores.loc[index]['TIP_REGU']
            intBanc = reatores.loc[index]['BANC']
            intCodBnc = reatores.loc[index]['CODBNC']
            strCodFasPrim = reatores.loc[index]['LIG_FAS_P']
            strCodFasSecu = reatores.loc[index]['LIG_FAS_S']
            dblTensaoPrimTrafo_kV = reatores.loc[index]['REL_TP']
            PotNom_kVA = reatores.loc[index]['POT_NOM']
            dblTenRgl_pu = reatores.loc[index]['TEN_REG']
            ReatHL_per = reatores.loc[index]['XHL']
            dblPerdVz_per = reatores.loc[index]['PER_FER']
            dblPerdTtl_per = reatores.loc[index]['PER_TOT']

            dblkvREG = round(tens_regulador(dblTensaoPrimTrafo_kV), 4)

            PerdaFerroTrafo_per = dblPerdVz_per / (float(PotNom_kVA) * 1000)
            PerdaCobreTrafo_per = (dblPerdTtl_per - dblPerdVz_per) / (float(PotNom_kVA) * 1000)

            linhas_reguladores_dss.append('New "Transformer.REG_' + strNome + nome_banco(intCodBnc) + '"' +
                                          " phases=" + numero_fases_transformador(strCodFasPrim) +
                                          " windings=2 buses=[" + '"' + strBus1 + nos(strCodFasPrim) + '"' + ' "' +
                                          strBus2 + nos(strCodFasSecu) + '"' + "] conns=[" +
                                          ligacao_trafo(strCodFasPrim) + " " + ligacao_trafo(strCodFasSecu) +
                                          "] kvs=[" + str(dblkvREG) + " " + str(dblkvREG) + "] kvas=[" +
                                          str(PotNom_kVA) + " " + str(PotNom_kVA) + "] xhl=" + str(ReatHL_per) +
                                          " %loadloss=" + f"{PerdaCobreTrafo_per:.6f}" +
                                          " %noloadloss=" + f"{PerdaFerroTrafo_per:.6f}")
            linhas_reguladores_dss.append(
                'New "Regcontrol.REG_' + strNome + nome_banco(intCodBnc) + '"' + ' transformer="REG_' +
                strNome + nome_banco(intCodBnc) + '"' + " winding=2 vreg=" +
                str(float(dblTenRgl_pu) * 100) + " band=2 ptratio=" + f"{(dblkvREG * 10):.4f}")

    def get_lines_trafos(self, trafos, linhas_trafos_dss) -> None:

        linhas_trafos_dss.clear()

        trafos.drop_duplicates(keep='first', inplace=True)
        trafos.reset_index(drop=True, inplace=True)

        for index in range(trafos.shape[0]):
            mrt = trafos.loc[index]['MRT']  # 1 indica transformador monofasico com retorno por terra
            circ = trafos.loc[index]['CTMT']
            codigo = trafos.loc[index]['COD_ID']
            lig_fas_p = trafos.loc[index]['FAS_CON_P']
            lig_fas_s = trafos.loc[index]['FAS_CON_S']
            lig_fas_t = trafos.loc[index]['FAS_CON_T']
            ten_lin_sec = trafos.loc[index]['TEN_LIN_SE']
            pac1 = trafos.loc[index]['PAC_1']
            pac2 = trafos.loc[index]['PAC_2']
            codi_tipo_trafo = trafos.loc[index]['TIP_TRAFO']
            kv1 = trafos.loc[index]['TEN_PRI'] / 1000
            kva_nom = trafos.loc[index]['POT_NOM']
            tap = trafos.loc[index]['TAP']
            PerdaTotalTrafo = trafos.loc[index]['PER_TOT']
            PerdaFerroTrafo = trafos.loc[index]['PER_FER']

            PerdaFerroTrafo_per = PerdaFerroTrafo / (kva_nom * 1000)
            PerdaCobreTrafo_per = (PerdaTotalTrafo - PerdaFerroTrafo) / (kva_nom * 1000)

            tipo_trafo = get_tipo_trafo(codi_tipo_trafo)

            # Se for trifásico ou bifásico, mantém a tensão do TEN_LIN_PRI, do contrário, multiplica por raiz de 3
            if numero_fases(lig_fas_p) == 1:
                trafo_kV_linha = kv1 * math.sqrt(3)

            if mrt == 1:
                linha = 'new transformer.TRF_MRT_' + codigo + nome_banco(1) + \
                        ' phases=' + numero_fases_transformador(lig_fas_p) + \
                        ' windings=' + quantidade_enrolamentos(lig_fas_t, lig_fas_s) + \
                        ' buses=[' + nos_com_neutro_trafo(lig_fas_p,
                                                          lig_fas_s,
                                                          lig_fas_t,
                                                          ten_lin_sec,
                                                          pac1,
                                                          pac2) + ']' \
                                                                  ' conns=[' + conexoes_trafo(lig_fas_p, lig_fas_s,
                                                                                              lig_fas_t) + ']' \
                                                                                                           ' kvs=(' + kvs_trafo(
                    tipo_trafo, lig_fas_p, lig_fas_s, lig_fas_t, float(kv1), float(ten_lin_sec)) + ')' \
                                                                                                   ' kvas=(' + kvas_trafo(
                    lig_fas_s, lig_fas_t, float(kva_nom)) + ')' \
                                                            ' %loadloss=' + str(
                    PerdaCobreTrafo_per) + ' %noloadloss=' + str(PerdaFerroTrafo_per)

                linhas_trafos_dss.append(linha)

                linha = 'New "Reactor.TRF_' + codigo + nome_banco(1) + "_R" + '"' + \
                        ' phases=1 bus1=' + pac2 + '.4' + ' R=15 X=0 basefreq=60'
                linhas_trafos_dss.append(linha)
            else:
                linha = 'New "Transformer.TRF_' + codigo + nome_banco(1) + '"' + \
                        ' phases=' + numero_fases_transformador(lig_fas_p) + \
                        ' windings=' + quantidade_enrolamentos(lig_fas_t, lig_fas_s) + \
                        ' buses=[' + nos_com_neutro_trafo(lig_fas_p,
                                                          lig_fas_s,
                                                          lig_fas_t,
                                                          ten_lin_sec,
                                                          pac1,
                                                          pac2) + ']' \
                                                                  ' conns=[' + conexoes_trafo(lig_fas_p, lig_fas_s,
                                                                                              lig_fas_t) + ']' \
                                                                                                           ' kvs=[' + kvs_trafo(
                    tipo_trafo, lig_fas_p, lig_fas_s, lig_fas_t, float(kv1), float(ten_lin_sec)) + ']' \
                                                                                                   ' taps=[' + tap_trafo(
                    lig_fas_t, str(tap)) + ']' \
                                           ' kvas=[' + kvas_trafo(lig_fas_s, lig_fas_t, float(kva_nom)) + '] ' \
                                                                                                          '%loadloss=' + str(
                    PerdaCobreTrafo_per) + ' %noloadloss=' + str(PerdaFerroTrafo_per)
                linhas_trafos_dss.append(linha)
                linha = 'New "Reactor.TRF_' + codigo + nome_banco(1) + '_R' + '"' + \
                        ' phases=1 bus1=' + pac2 + '.4' + ' R=15 X=0 basefreq=60'
                linhas_trafos_dss.append(linha)

    def get_lines_condutores(self, condutores, linhas_condutores_dss) -> None:
        """
        Escreve os comandos do openDSS para os LineCodes
        :param condutores: Dataframe com o dados da bdgd do condutores
        :param linhas_condutores_dss: Saida com lista dos comandos gerados para o openDSS
        :return:
        """
        linhas_condutores_dss.clear()
        for index in range(condutores.shape[0]):

            codigo = condutores.loc[index]['COD_ID']
            r1 = condutores.loc[index]['R1']
            x1 = condutores.loc[index]['X1']
            cmax = condutores.loc[index]['CNOM']

            for num_fase in range(1, 5):
                linha = f'New "Linecode.{codigo}_{num_fase}" nphases={num_fase} ' \
                        f'basefreq=60 r1={r1} x1={x1} units=km normamps={cmax}'
                # print(linha)
                linhas_condutores_dss.append(linha)

    def get_lines_curvas_carga(self, curvas_carga, multi_ger, linhas_curvas_carga_dss) -> None:
        """
        Transforma os 96 pontos das curvas de carga em 24 pontos e normaliza pelo seu valor máximo.
        :param curvas_carga: dados da BDGD
        :param linhas_curvas_carga_dss: Retorno com os dados transformados.
        :return:
        """
        linhas_curvas_carga_dss.clear()
        # pot_idx = 0
        # col_name_pot = 'POT_'
        # pot_idx += 1
        curvas_carga_dss = {}
        all_curvas_carga_dss = []
        # Transforma 96 pontos da curva de carga em 24 pontos em kW
        for index in range(curvas_carga.shape[0]):
            for x in range(0, 24):
                # pot_idx = x + 1
                col_name_new_crv = f'kw_pts_{x}'
                # curvas_carga[col_name_new_crv] = 0
                # col_name_pot_index = f"{col_name_pot}{pot_idx:02}"
                # linhas_curvas_carga_dss["COD_ID"] = curvas_carga.iloc[index][1]
                curvas_carga_dss[col_name_new_crv] = (curvas_carga.iloc[index][4 + 4 * x] +
                                                      curvas_carga.iloc[index][1 + 4 + 4 * x] +
                                                      curvas_carga.iloc[index][2 + 4 + 4 * x] +
                                                      curvas_carga.iloc[index][3 + 4 + 4 * x]) / 4

            # Normaliza os pontos em relação ao máximo valor
            kw_max = max(curvas_carga_dss.values())
            curvas_carga_dss = {k: round(v / kw_max, 6) for k, v in curvas_carga_dss.items()}
            # list(curvas_carga_dss.values())
            multi = ', '.join('{0}'.format(w) for w in curvas_carga_dss.values())

            # list contains a reference to the original dictionary, should do the trick copy().
            # all_curvas_carga_dss.append(curvas_carga_dss.copy())

            linha = 'New "Loadshape.' + curvas_carga.iloc[index][1] + '_' + curvas_carga.iloc[index][3] + '"' + \
                    " 24 1.0 mult=(" + multi + ")"
            # print(linha)
            linhas_curvas_carga_dss.append(linha)

        # Gerador curva tipica
        for crv_ger in multi_ger:
            crv = ', '.join(map(str, crv_ger[1]))
            linha = f'New "Loadshape.{str(crv_ger[0])}" 24 1.0 mult=({crv})'
            linhas_curvas_carga_dss.append(linha)

    def get_lines_trechos_mt(self, is_bt, trechos, linhas_trechos_dss) -> None:
        """ Função para obter as linhas (DSS) referentes aos trechos

        Caso seja de um terceiro, o programa da ANEEL transforma aquele trecho numa chave sem perdas no arquivo .DSS
        (caso tenha habilitado para “Neutralizar redes de terceiros”)

        O transformador é comentado no arquivo .DSS (caso habilite a opção “Eliminar transformadores a vazio”),
        e toda a rede BT a jusante dele também é comentada. (ainda nao implementadoa eliminação da rede a jusante!)
        """
        linhas_trechos_dss.clear()
        neutralizar_redes_terceiros = False
        eliminar_transformadores_vazio = False
        srt_comment_dss = ''
        if eliminar_transformadores_vazio or neutralizar_redes_terceiros:
            srt_comment_dss = '!'

        for index in range(trechos.shape[0]):
            codigo = trechos.loc[index]['COD_ID']
            pac1 = trechos.loc[index]['PAC_1']
            pac2 = trechos.loc[index]['PAC_2']
            compr = trechos.loc[index]['COMP'] / 1000
            arranjo = trechos.loc[index]['TIP_CND']
            fases_con = trechos.loc[index]['FAS_CON']
            propriedade = trechos.loc[index]['POS']

            if is_bt:
                num_fases = numero_fases_segmento_neutro(fases_con)
                identif_mt_bt = "SBT_"
                # if ramlig:
                #    identif_mt_bt = "RBT_"
            else:
                num_fases = numero_fases_segmento(fases_con)
                identif_mt_bt = "SMT_"

            if propriedade == "PD" or not neutralizar_redes_terceiros:
                linha = 'New "Line.' + identif_mt_bt + codigo + '"' + " phases=" + num_fases + \
                        " bus1=" + '"' + pac1 + nos_com_neutro(fases_con) + '"' + \
                        " bus2=" + '"' + pac2 + nos_com_neutro(fases_con) + '"' + \
                        " linecode=" + '"' + arranjo + "_" + num_fases + '"' + \
                        " length=" + f'{compr:.8f}' + " units=km"

            elif propriedade != "PD" and neutralizar_redes_terceiros:
                linha = srt_comment_dss + 'New "Line.' + identif_mt_bt + codigo + '"' + " phases=" + num_fases + \
                        " bus1=" + '"' + pac1 + nos_com_neutro(fases_con) + '"' + \
                        " bus2=" + '"' + pac2 + nos_com_neutro(fases_con) + '"' + \
                        " r1=0.001 r0=0.001 x1=0 x0=0 c1=0 c0=0 length=" + f'{compr:.8f}' + " units=km switch=T"
            linhas_trechos_dss.append(linha)

    def get_lines_cargas_mt(self, cargas, cargas_fc, linhas_cargas_dss):

        linhas_cargas_dss.clear()

        # Deve-se implementar para 12 meses e os 3 tipos de dia DO DU SA
        mes = 1
        tipo_dia = "DU"

        if mes < 10:
            strmes = '0' + str(mes)
        else:
            strmes = str(mes)

        # remove duplicate values in COD_ID column
        cargas.sort_values(by=['COD_ID', 'DEM_01'], ascending=[True, False], inplace=True)
        # duplicate_values = cargas['COD_ID'].duplicated()
        cargas.drop_duplicates(subset='COD_ID', keep='first', inplace=True)
        cargas.reset_index(drop=True, inplace=True)

        for index in range(cargas.shape[0]):
            strName = cargas.loc[index]['COD_ID']
            strCodCrvCrg = cargas.loc[index]['TIP_CC'] + '_' + tipo_dia
            strCodFas = cargas.loc[index]['FAS_CON']
            dblTensao_kV = cargas.loc[index]['KV_NOM']
            strBus = cargas.loc[index]['PAC']
            energy_mes = cargas.loc[index]['ENE_' + str(strmes)]
            dblDemMax_kW = cargas.loc[index]['DEM_' + str(strmes)]
            ano_base = cargas.loc[index]['ANO_BASE']
            trafo_kw = cargas.loc[index]['POT_NOM']

            if dblDemMax_kW > 0.0:
                linhas_cargas_dss.append('New "Load.MT_' + strName + '_M1" bus1="' + strBus + nos(
                    strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                    strCodFas) + " model=2" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.5f}" +
                                         " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')
                linhas_cargas_dss.append('New "Load.MT_' + strName + '_M2" bus1="' + strBus + nos(
                    strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                    strCodFas) + " model=3" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.5f}" +
                                         " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')
            else:
                if energy_mes == 0:
                    linhas_cargas_dss.append('!New "Load.MT_' + strName + '_M1" bus1="' + strBus + nos(
                        strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                        strCodFas) + " model=2" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.5f}" +
                                             " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')
                    linhas_cargas_dss.append('!New "Load.MT_' + strName + '_M2" bus1="' + strBus + nos(
                        strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                        strCodFas) + " model=3" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.5f}" +
                                             " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')
                else:
                    # colocar o numero de dias de cada mes
                    num_dias = calendar.monthrange(ano_base, mes)[1]

                    fc = cargas_fc.loc[(cargas_fc['COD_ID'] == cargas.loc[index]['TIP_CC']) &
                                       (cargas_fc['TIP_DIA'] == tipo_dia)]
                    dblDemMax_kW = (energy_mes / (num_dias * 24)) / fc.iloc[0]['FC']
                    if dblDemMax_kW > trafo_kw:
                        dblDemMax_kW = trafo_kw * 0.98  # valor arbitrario

                    linhas_cargas_dss.append('New "Load.MT_' + strName + '_M1" bus1="' + strBus + nos(
                        strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                        strCodFas) + " model=2" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.7f}" +
                                             " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')
                    linhas_cargas_dss.append('New "Load.MT_' + strName + '_M2" bus1="' + strBus + nos(
                        strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                        strCodFas) + " model=3" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.7f}" +
                                             " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')

    def get_lines_cargas_bt(self, cargas_bt, cargas_fc, cargas_pip, linhas_cargas_bt_dss):

        linhas_cargas_bt_dss.clear()
        # Deve-se implementar para 12 meses e os 3 tipos de dia DO DU SA
        mes = 1
        tipo_dia = "DU"
        if mes < 10:
            strmes = '0' + str(mes)
        else:
            strmes = str(mes)

        for index in range(cargas_bt.shape[0]):
            strName = cargas_bt.loc[index]['COD_ID']
            strCodCrvCrg = cargas_bt.loc[index]['TIP_CC'] + '_' + tipo_dia
            strCodFas = cargas_bt.loc[index]['FAS_CON']
            strBus = cargas_bt.loc[index]['PAC']
            strBus = cargas_bt.loc[index]['PAC_2']  # ligar as cargas BT no secundario do transformador
            energy_mes = cargas_bt.loc[index]['ENE_' + str(strmes)]
            dblTenSecu_kV = cargas_bt.loc[index]['TEN_LIN_SE']
            codi_tipo_trafo = cargas_bt.loc[index]['TIP_TRAFO']
            dblDemMaxTrafo_kW = cargas_bt.loc[index]['POT_NOM'] * 0.92   #kVA
            ano_base = cargas_bt.loc[index]['ANO_BASE']

            intTipTrafo = get_tipo_trafo(codi_tipo_trafo)

            num_dias = calendar.monthrange(ano_base, mes)[1]
            fc = cargas_fc.loc[(cargas_fc['COD_ID'] == cargas_bt.loc[index]['TIP_CC']) &
                               (cargas_fc['TIP_DIA'] == tipo_dia)]
            dblDemMax_kW = (energy_mes / (num_dias * 24)) / fc.iloc[0]['FC']

            if dblDemMax_kW > dblDemMaxTrafo_kW:
                dblDemMaxCorrigida_kW = dblDemMaxTrafo_kW
            else:
                dblDemMaxCorrigida_kW = dblDemMax_kW

            if dblDemMaxCorrigida_kW > 0:
                """
                determinação da tensão da carga
                " kv=" + kv_carga(strCodFas, dblTenSecu_kV, intTipTrafo) 
                or 
                " kv=" + f"{dblTenSecu_kV:.3f}" + 
                """

                linhas_cargas_bt_dss.append(
                    'New "Load.BT_' + strName + '_M1" bus1="' + strBus + nos_com_neutro(strCodFas) + '"' +
                    " phases=" + numero_fases_carga_dss(strCodFas) + " conn=" + ligacao_carga(strCodFas) +
                    " model=2" + " kw=" +
                    f"{(dblDemMaxCorrigida_kW / 2):.5f}" + " pf=0.92" + ' daily="' + strCodCrvCrg +
                    '" status=variable vmaxpu=1.5 vminpu=0.92')
                linhas_cargas_bt_dss.append(
                    'New "Load.BT_' + strName + '_M2" bus1="' + strBus + nos_com_neutro(strCodFas) + '"' +
                    " phases=" + numero_fases_carga_dss(strCodFas) + " conn=" + ligacao_carga(strCodFas) +
                    " model=3" + " kw=" +
                    f"{(dblDemMaxCorrigida_kW / 2):.5f}" + " pf=0.92" + ' daily="' + strCodCrvCrg +
                    '" status=variable vmaxpu=1.5 vminpu=0.92')

                """# O valor de KV deve ser o seguinte: # Nominal rated (1.0 per unit) voltage, kV, for load. For 2- 
                and 3-phase loads, specify phase-phase kV. Otherwise, specify actual kV across each branch of the 
                load. If wye (star), specify phase-neutral kV. If delta or phase-phase connected, specify phase-phase 
                kV. 
                
                linhas_cargas_bt_dss.append( 
                    'New "Load.BT_' + strName + '_M1" bus1="' + strBus + nos_com_neutro(
                strCodFas) + '"' + " phases=" + numero_fases_carga_dss(strCodFas) + " conn=" + ligacao_carga(
                strCodFas) + " model=2" + " kv=" + kv_carga(strCodFas, dblTenSecu_kV, intTipTrafo) + " kw=" + f"{(
                dblDemMaxCorrigida_kW / 2):.7f}" + " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable 
                vmaxpu=1.5 vminpu=0.92') linhas_cargas_bt_dss.append( 'New "Load.BT_' + strName + '_M2" bus1="' + 
                strBus + nos_com_neutro(strCodFas) + '"' + " phases=" + numero_fases_carga_dss(strCodFas) + " conn=" 
                + ligacao_carga(strCodFas) + " model=3" + " kv=" + kv_carga(strCodFas, dblTenSecu_kV, intTipTrafo) + 
                " kw=" + f"{(dblDemMaxCorrigida_kW / 2):.7f}" + " pf=0.92" + ' daily="' + strCodCrvCrg + '" 
                status=variable vmaxpu=1.5 vminpu=0.92') """
        for index in range(cargas_pip.shape[0]):
            strName = cargas_pip.loc[index]['COD_ID']
            strCodCrvCrg = cargas_pip.loc[index]['TIP_CC'] + '_' + tipo_dia
            strCodFas = cargas_pip.loc[index]['FAS_CON']
            strBus = cargas_pip.loc[index]['PAC']
            strBus = cargas_pip.loc[index]['PAC_2']  # ligar as cargas PIP no secundario do transformador
            energy_mes = cargas_pip.loc[index]['ENE_' + str(strmes)]
            dblTenSecu_kV = cargas_pip.loc[index]['TEN_LIN_SE']
            codi_tipo_trafo = cargas_pip.loc[index]['TIP_TRAFO']
            dblDemMaxTrafo_kW = cargas_pip.loc[index]['POT_NOM'] * 0.92  # kVA
            ano_base = cargas_pip.loc[index]['ANO_BASE']

            intTipTrafo = get_tipo_trafo(codi_tipo_trafo)
            num_dias = calendar.monthrange(ano_base, mes)[1]
            fc = cargas_fc.loc[(cargas_fc['COD_ID'] == cargas_pip.loc[index]['TIP_CC']) &
                               (cargas_fc['TIP_DIA'] == tipo_dia)]
            dblDemMax_kW = (energy_mes / (num_dias * 24)) / fc.iloc[0]['FC']

            if dblDemMax_kW > dblDemMaxTrafo_kW:
                dblDemMaxCorrigida_kW = dblDemMaxTrafo_kW
            else:
                dblDemMaxCorrigida_kW = dblDemMax_kW

            if dblDemMaxCorrigida_kW > 0:
                linhas_cargas_bt_dss.append(
                    'New "Load.PIP_' + strName + '_M1" bus1="' + strBus + nos_com_neutro(strCodFas) + '"' +
                    " phases=" + numero_fases_carga_dss(strCodFas) + " conn=" + ligacao_carga(strCodFas) +
                    " model=2" + " kw=" +
                    f"{dblDemMaxCorrigida_kW:.7f}" + " pf=0.92" + ' daily="' + strCodCrvCrg +
                    '" status=variable vmaxpu=1.5 vminpu=0.92')

    def get_lines_generators_mt(self, generators, crv_ger, linha_generators_mt_dss):
        linha_generators_mt_dss.clear()
        # O gerador terá a mesma curva de carga para os 12 meses
        mes = 1
        tipo_dia = "DU"
        if mes < 10:
            strmes = '0' + str(mes)
        else:
            strmes = str(mes)

        for index in range(generators.shape[0]):
            strName = generators.loc[index]['COD_ID']
            # strCodCrvCrg = generators.loc[index]['TIP_CC'] + '_' + tipo_dia
            strCodFas = generators.loc[index]['FAS_CON']
            dblTensao_kV = generators.loc[index]['KV_NOM']
            strBus = generators.loc[index]['PAC']
            energy_mes = generators.loc[index]['ENE_' + str(strmes)]
            dblDemMax_kW = generators.loc[index]['DEM_' + str(strmes)]
            ano_base = generators.loc[index]['ANO_BASE']

            cod_kv_pri_trafo = generators.loc[index]['TEN_PRI']
            cod_kv_gererator = generators.loc[index]['TEN_FORN']
            if cod_kv_pri_trafo != cod_kv_gererator:
                print(f"Erro: cod tensão do gerador diferente do transformador. Atualizar banco de dados")
                print(f"cod tensão do gerador: {cod_kv_gererator} cod tensão trafo: {cod_kv_pri_trafo}")

            dbdaily = 'GeradorMT-Tipo1'
            srt_comment_dss = ''

            if dblDemMax_kW == 0:
                for crv in crv_ger:
                    if crv[0] == dbdaily:
                        pt_crv = crv[1]
                        # media dos valores diferentes de zero
                        fc = np.apply_along_axis(lambda v: np.mean(v[np.nonzero(v)]), 0, pt_crv)

                num_dias = calendar.monthrange(ano_base, mes)[1]
                dblDemMax_kW = (energy_mes / (num_dias * 24)) / fc

            # elimina geradores sem demanda
            if dblDemMax_kW == 0:
                srt_comment_dss = '!'

            dbconn = ligacao_gerador(strCodFas)  # "wye" ou "Delta"

            linha_generators_mt_dss.append(srt_comment_dss + 'New Generator.MT_' + strName + '_M1 bus1=' + strBus + nos(strCodFas) +
                                           ' phases=' + numero_fases_carga(strCodFas) + ' conn=' + dbconn + ' kv=' +
                                           str(dblTensao_kV) + ' model=1 kw=' + f'{dblDemMax_kW:.4f}' + ' pf=0.92 daily="' +
                                           dbdaily + '" status=variable vmaxpu=1.5 vminpu=0.93')

    def get_line_capacitor(self, capacitores, linha_capacitores_dss):
        linha_capacitores_dss.clear()
        for index in range(capacitores.shape[0]):
            str_name = capacitores.loc[index]['COD_ID']
            str_pac = capacitores.loc[index]['PAC_1']
            strCodFas = capacitores.loc[index]['FAS_CON']
            dbl_pot = capacitores.loc[index]['POT']
            line_cod = capacitores.loc[index]['LiNE_COD']
            kv_nom = capacitores.loc[index]['TEN']
            c_on = kv_nom / 60 * 0.95
            c_off = kv_nom / 60

            linha_capacitores_dss.append(
                f'New "Capacitor.CAP_{str_name}" bus1="{str_pac}{nos(strCodFas)}" kvar={dbl_pot} kv={kv_nom} '
                f'phases={numero_fases(strCodFas)} conn={ligacao_trafo(strCodFas)}')
            linha_capacitores_dss.append(
                f'New "CapControl.C1ctrl_{str_name}" element="Line.SMT_{line_cod}" Capacitor=CAP_{str_name} '
                f'Type=voltage ptratio=60 ON={c_on} OFF={c_off}')

    def get_lines_medidores(self, monitors, linha_medidores_dss):
        """ Função para gerar os Medidores do arquivo MEDIDORES>DSS """
        linha_medidores_dss.clear()
        momitors_dict = monitors.to_dict('records')
        for medidor in momitors_dict:
            if medidor['ELEM'] == 'SSDMT':
                tipo_elem = 'SEGMMT'
            else:
                tipo_elem = 'CHVMT'

            linha = 'New "Energymeter.Medidor_' + tipo_elem + '_' + str(medidor['COD_ID']).replace('Line.', '') + \
                    '" element="' + medidor['COD_ID'] + '" terminal=1'
            linha_medidores_dss.append(linha)

    def get_lines_master(self, circuito, voltagebases, list_files_dss, linhas_dict, linhas_master) -> None:
        """ Função para gerar as linhas (DSS) referentes ao arquivo master.dss """
        linhas_master.clear()
        linhas_master.append('clear')
        linhas_master.append('')

        # Inclui redirecionamentos
        for nome_arquivo in list_files_dss:
            nome_arquivo += '_' + circuito
            linhas_master.append(f"redirect {nome_arquivo}.dss")
        linhas_master.append('')

        # Inclui tensões nominais
        voltagebases_str = ",".join(str(element) for element in voltagebases)
        linhas_master.append(f"set voltagebases=({voltagebases_str})")
        linhas_master.append('calcv')

        # Inclui outros comandos
        # linhas_master.append(f"buscoords coords.dss")

        linhas_master.append(f"set mode=daily")
        linhas_master.append(f"set tolerance=0.0001")
        linhas_master.append(f"set maxcontroliter=100")
        linhas_master.append(f"set maxiterations=100")
        linhas_master.append(f"set stepsize=1h ! duracao de cada step")
        linhas_master.append(f"set number=24 ! cada solve executa 24 steps")
        linhas_master.append(f"solve")
