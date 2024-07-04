from Tools.tools import *

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
            linha = 'New "Line.CMT_' + chaves.loc[index]['COD_ID'] + '"' + " phases=" + numero_fases_segmento(
                chaves.loc[index]['FAS_CON']) + \
                    " bus1=" + '"' + chaves.loc[index]['PAC_1'] + nos_com_neutro(chaves.loc[index]['FAS_CON']) + '"' + \
                    " bus2=" + '"' + chaves.loc[index]['PAC_2'] + nos_com_neutro(chaves.loc[index]['FAS_CON']) + '"' + \
                    " r1=0.001 r0=0.001 x1=0 x0=0 c1=0 c0=0 length=0.001 switch=T"
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

            linhas_reguladores_dss.append('New "Transformer.REG_' + strNome + nome_banco(intCodBnc) + '"' + " phases=" +
                                          numero_fases_transformador(
                                              strCodFasPrim) + " windings=2 buses=[" + '"' + strBus1 +
                                          nos(strCodFasPrim) + '"' + ' "' + strBus2 + nos(
                strCodFasSecu) + '"' + "] conns=[" +
                                          ligacao_trafo(strCodFasPrim) + " " + ligacao_trafo(
                strCodFasSecu) + "] kvs=[" +
                                          str(dblkvREG) + " " + str(dblkvREG) + "] kvas=[" +
                                          str(PotNom_kVA) + " " + str(PotNom_kVA) + "] xhl=" + str(
                ReatHL_per) + " %loadloss=" +
                                          str((dblPerdTtl_per - dblPerdVz_per)) + " %noloadloss=" + str(dblPerdVz_per))
            linhas_reguladores_dss.append(
                'New "Regcontrol.REG_' + strNome + nome_banco(intCodBnc) + '"' + ' transformer="REG_' +
                strNome + nome_banco(intCodBnc) + '"' + " winding=2 vreg=" +
                str(float(dblTenRgl_pu) * 100) + " band=2 ptratio=" + str(float(dblkvREG) * 10))

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
            kv1 = trafos.loc[index]['TEN_PRI'][1]/1000
            kva_nom = trafos.loc[index]['POT_NOM']
            tap = trafos.loc[index]['TAP']
            PerdaTotalTrafo = trafos.loc[index]['PER_TOT']
            PerdaFerroTrafo = trafos.loc[index]['PER_FER']

            PerdaFerroTrafo_per = PerdaFerroTrafo / (kva_nom * 1000)
            PerdaCobreTrafo_per = (PerdaTotalTrafo - PerdaFerroTrafo) / (kva_nom * 1000)

            # Avalia o tipo do trafo
            if codi_tipo_trafo == 'M':
                tipo_trafo = 1
            elif codi_tipo_trafo == 'MT':
                tipo_trafo = 2
            elif codi_tipo_trafo == 'B':
                tipo_trafo = 3
            elif codi_tipo_trafo == 'T':
                tipo_trafo = 4
            elif codi_tipo_trafo == 'DF':
                tipo_trafo = 5
            elif codi_tipo_trafo == 'DA':
                tipo_trafo = 6
            else:
                tipo_trafo = 0

            # Se for trifásico ou bifásico, mantém a tensão do TEN_LIN_PRI, do contrário, multiplica por raiz de 3
            if numero_fases(lig_fas_p) == 1:
                trafo_kV_linha = kv1 * math.sqrt(3)

            if mrt == 1:
                linha = 'new transformer.TRF_' + codigo + nome_banco(1) + \
                        ' phases=' + numero_fases_transformador(lig_fas_p) + \
                        ' windings=' + quantidade_enrolamentos(lig_fas_t, lig_fas_s) + \
                        ' buses=[' + nos_com_neutro_trafo(lig_fas_p,
                                                          lig_fas_s,
                                                          lig_fas_t,
                                                          ten_lin_sec, 'MRT_' +
                                                          pac1 + 'TRF_' + codigo + nome_banco(1),
                                                          pac2) + ']' \
                        ' conns=[' + conexoes_trafo(lig_fas_p, lig_fas_s, lig_fas_t) + ']' \
                        ' kvs=(' + kvs_trafo(tipo_trafo, lig_fas_p, lig_fas_s, lig_fas_t, float(kv1), float(ten_lin_sec)) + ')' \
                        ' kvas=(' + kvas_trafo(lig_fas_s, lig_fas_t, float(kva_nom)) + ')' \
                        ' %loadloss=' + str(PerdaCobreTrafo_per) + ' %noloadloss=' + str(PerdaFerroTrafo_per)

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
                        ' conns=[' + conexoes_trafo(lig_fas_p, lig_fas_s, lig_fas_t) + ']' \
                        ' kvs=[' + kvs_trafo(tipo_trafo, lig_fas_p, lig_fas_s, lig_fas_t, float(kv1), float(ten_lin_sec)) + ']' \
                        ' taps=[' + tap_trafo(lig_fas_t, str(tap)) + ']' \
                        ' kvas=[' + kvas_trafo(lig_fas_s, lig_fas_t, float(kva_nom)) + '] ' \
                        '%loadloss=' + str(PerdaCobreTrafo_per) + ' %noloadloss=' + str(PerdaFerroTrafo_per)
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

    def get_lines_curvas_carga(self, curvas_carga, linhas_curvas_carga_dss) -> None:
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
        multi_ger = '0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.213170, 0.493614, 0.767539, 0.930065, 1.000000, ' \
                    '0.908147, 0.682011, 0.461154, 0.024685, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 '
        linha = f'New "Loadshape.GeradorMT-Tipo1" 24 1.0 mult=({multi_ger})'
        linhas_curvas_carga_dss.append(linha)

        # Add to dataframe
        # linhas_curvas_carga_dss_dictionary = pd.DataFrame(all_curvas_carga_dss)
        # curvas_carga = pd.concat([curvas_carga, linhas_curvas_carga_dss_dictionary], axis=1)

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
            compr = trechos.loc[index]['COMP']
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
                        " length=" + f'{compr:.4f}' + " units=km"

            elif propriedade != "PD" and neutralizar_redes_terceiros:
                linha = srt_comment_dss + 'New "Line.' + identif_mt_bt + codigo + '"' + " phases=" + num_fases + \
                        " bus1=" + '"' + pac1 + nos_com_neutro(fases_con) + '"' + \
                        " bus2=" + '"' + pac2 + nos_com_neutro(fases_con) + '"' + \
                        " r1=0.001 r0=0.001 x1=0 x0=0 c1=0 c0=0 length=" + f'{compr:.4f}' + " units=km switch=T"
            linhas_trechos_dss.append(linha)

    def get_lines_cargas_mt(self, cargas, cargas_fc, linhas_cargas_dss):

        linhas_cargas_dss.clear()
        mes = 1
        tipo_dia = "DU"

        if mes < 10:
            strmes = '0' + str(mes)
        else:
            strmes = str(mes)

        for index in range(cargas.shape[0]):
            strName = cargas.loc[index]['COD_ID']
            strCodCrvCrg = cargas.loc[index]['TIP_CC'] + '_' + tipo_dia
            strCodFas = cargas.loc[index]['FAS_CON']
            dblTensao_kV = cargas.loc[index]['KV_NOM']
            strBus = cargas.loc[index]['PAC']
            energy_mes = cargas.loc[index]['ENE_' + str(strmes)]
            dblDemMax_kW = cargas.loc[index]['DEM_' + str(strmes)]

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
                if energy_mes == 0:
                    linhas_cargas_dss.append('!New "Load.MT_' + strName + '_M1" bus1="' + strBus + nos(
                        strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                        strCodFas) + " model=2" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.7f}" +
                        " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')
                    linhas_cargas_dss.append('!New "Load.MT_' + strName + '_M2" bus1="' + strBus + nos(
                        strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                        strCodFas) + " model=3" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.7f}" +
                        " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')
                else:
                    fc = cargas_fc.loc[(cargas_fc['COD_ID'] == cargas.loc[index]['TIP_CC']) &
                                       (cargas_fc['TIP_DIA'] == tipo_dia)]
                    dblDemMax_kW = (energy_mes / 365) * fc.iloc[0]['FC']

                    linhas_cargas_dss.append('New "Load.MT_' + strName + '_M1" bus1="' + strBus + nos(
                        strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                        strCodFas) + " model=2" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.7f}" +
                        " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')
                    linhas_cargas_dss.append('New "Load.MT_' + strName + '_M2" bus1="' + strBus + nos(
                        strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                        strCodFas) + " model=3" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.7f}" +
                        " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')

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

    def get_lines_master(self, circuito, list_files_dss, linhas_dict, linhas_master) -> None:
        """ Função para gerar as linhas (DSS) referentes ao arquivo master.dss """
        linhas_master.clear()
        linhas_master.append('clear')
        linhas_master.append('')

        # Inclui redirecionamentos
        for nome_arquivo in list_files_dss:
            nome_arquivo += '_' + circuito
            linhas_master.append(f"redirect {nome_arquivo}.dss")
        linhas_master.append('')
        """
        # Inclui tensões nominais
        tensoes_nominais_sec = linhas_dict.TEN_LIN_SE.unique()
        tensoes_nominais_prim = linhas_dict.TEN_PRI[1]
        tensoes_nominais = tensoes_nominais_prim + tensoes_nominais_sec

        if len(tensoes_nominais) > 0:
            tensoes_str = ''
            for tensao in tensoes_nominais:
                tensoes_str += str(tensao) + ' '

            linhas_master.append(f"set voltagebases=({tensoes_str[0:len(tensoes_str) - 1]})")
        
            linhas_master.append('calcv')
        
        # Inclui outros comandos
        linhas_master.append(f"buscoords coords.dss")
        """
        linhas_master.append(f"set mode=daily")
        linhas_master.append(f"set tolerance=0.0001")
        linhas_master.append(f"set maxcontroliter=100")
        linhas_master.append(f"set maxiterations=100")
        linhas_master.append(f"set stepsize=1h ! duracao de cada step")
        linhas_master.append(f"set number=24 ! cada solve executa 24 steps")
        linhas_master.append(f"solve")

