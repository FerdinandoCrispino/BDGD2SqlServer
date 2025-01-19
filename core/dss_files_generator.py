# -*- encoding: utf-8 -*-
import math

import numpy as np
from Tools.tools import *
import connected_segments as cs
import calendar

"""
# @Date    : 20/06/2024
# @Author  : Ferdinano Crispino
# @Email   : ferdinando.crispino@usp.br
Implemeta funcionalidades de preparação dos dados para escrita dos arquivos do openDSS
"""


class DssFilesGenerator:
    def __init__(self, dist=None, substation=None):
        self.dist = dist
        self.sub = substation

    def get_lines_substation(self, transfomers, circuits, linhas_substation_dss, mes, tipo_dia, voltagebases):
        mes = mes
        tipo_dia = tipo_dia

        linhas_substation_dss.clear()

        nome_arquivo_crv = f'{tipo_dia}_{mes}_CurvaCarga_{self.dist}_{self.sub}'
        nome_arquivo_cnd = f'{tipo_dia}_{mes}_CodCondutores_{self.dist}_{self.sub}'
        nome_arquivo_chv_mt = f'{tipo_dia}_{mes}_ChavesMT_{self.dist}_{self.sub}'
        nome_arquivo_re_mt = f'{tipo_dia}_{mes}_ReatoresMT_{self.dist}_{self.sub}'
        nome_arquivo_tr_mt = f'{tipo_dia}_{mes}_TrafosMT_{self.dist}_{self.sub}'
        nome_arquivo_seg_mt = f'{tipo_dia}_{mes}_TrechoMT_{self.dist}_{self.sub}'
        nome_arquivo_crg_mt = f'{tipo_dia}_{mes}_CargasMT_{self.dist}_{self.sub}'
        nome_arquivo_monitors = f'{tipo_dia}_{mes}_Monitors_{self.dist}_{self.sub}'
        nome_arquivo_capacitors = f'{tipo_dia}_{mes}_Capacitors_{self.dist}_{self.sub}'
        nome_arquivo_crg_bt = f'{tipo_dia}_{mes}_CargasBT_{self.dist}_{self.sub}'
        nome_arquivo_generators_mt_dss = f'{tipo_dia}_{mes}_GeradoresMT_{self.dist}_{self.sub}'
        nome_arquivo_generators_bt_dss = f'{tipo_dia}_{mes}_GeradoresBT_{self.dist}_{self.sub}'

        list_files_dss = [nome_arquivo_crv, nome_arquivo_cnd, nome_arquivo_chv_mt, nome_arquivo_re_mt,
                          nome_arquivo_tr_mt, nome_arquivo_seg_mt, nome_arquivo_crg_mt, nome_arquivo_monitors,
                          nome_arquivo_capacitors, nome_arquivo_crg_bt, nome_arquivo_generators_mt_dss,
                          nome_arquivo_generators_bt_dss]

        substation = circuits.merge(transfomers, how='inner', left_on='UNI_TR_AT', right_on='COD_ID')

        base_kv = round(transfomers['TEN_PRI'] / 1000, 2)
        voltagebases.loc[len(voltagebases.index)] = [base_kv[0]]

        # Add Source
        linhas_substation_dss.clear()
        linhas_substation_dss.append('clear')
        linhas_substation_dss.append('')
        linhas_substation_dss.append(f'New Circuit.Sub_{self.sub} bus1=Sourcebus basekv={base_kv[0]} '
                                     f'phases=3 pu=1.0 r1=0.0 x1=0.0001')

        # Create dummy switch and transformer
        for index in range(transfomers.shape[0]):
            tr_name = transfomers.loc[index]['COD_ID']
            tr_pac_1 = transfomers.loc[index]['PAC_1']
            tr_pac_2 = transfomers.loc[index]['PAC_2']
            tr_pac_3 = transfomers.loc[index]['PAC_3']
            lig_fas_p = transfomers.loc[index]['FAS_CON_P']
            lig_fas_s = transfomers.loc[index]['FAS_CON_S']
            lig_fas_t = transfomers.loc[index]['FAS_CON_T']
            tr_lig = transfomers.loc[index]['LIG']
            ten_lin_pri = transfomers.loc[index]['TEN_PRI'] / 1000
            ten_lin_sec = transfomers.loc[index]['TEN_SEC'] / 1000
            kva_nom = transfomers.loc[index]['POT_NOM'] * 1000
            PerdaTotalTrafo = transfomers.loc[index]['PER_TOT']
            PerdaFerroTrafo = transfomers.loc[index]['PER_FER']

            voltagebases.loc[len(voltagebases.index)] = [ten_lin_pri]
            voltagebases.loc[len(voltagebases.index)] = [ten_lin_sec]

            # Create dummy switch Transformer
            linhas_substation_dss.append(f'New Line.DJ_{tr_name} phases=3 bus1=SourceBus bus2={tr_pac_1} '
                                         f'r1=0.001 r0=0.001 x1=0 x0=0 c1=0 c0=0 length=0.001 units=km switch=T')
            # Add transformer AT
            PerdaFerroTrafo_per = PerdaFerroTrafo
            PerdaCobreTrafo_per = PerdaTotalTrafo - PerdaFerroTrafo
            # todos os circuits de um transformador AT deveriam ter a mesma tensão de operação!!!!
            # NA BDGD foram obtidos valores diferentes para cada circuito assim será adota o menor valor de operação.
            # Pode existir um TR_AT sem circuitos associados (TR RESERVA) adotar ten_ope_pu = 1.0
            if tr_name in set(circuits['UNI_TR_AT']):
                ten_ope_pu = min(circuits[circuits['UNI_TR_AT'] == tr_name]['TEN_OPE'])
            else:
                ten_ope_pu = '1.0'

            # com acrescimo do regulador a tensão de operação do transformador AT deve ser 1.0 pu
            linhas_substation_dss.append(f'New Transformer.{tr_name} phases={numero_fases_transformador(lig_fas_p)} '
                                         f'windings={quantidade_enrolamentos(lig_fas_t, lig_fas_s)} '
                                         f'buses=[{nos_com_neutro_trafo(lig_fas_p, lig_fas_s, lig_fas_t, ten_lin_sec, tr_pac_1, tr_pac_2)}] '
                                         f'conns=[Wye {lig_trafo(tr_lig)}] kvs=({ten_lin_pri} {ten_lin_sec} ) '
                                         f'kvas=({kvas_trafo(lig_fas_s, lig_fas_t, float(kva_nom))}) '
                                         #f'taps=[1.0 {ten_ope_pu}] '
                                         f'taps=[1.0 1.0] '
                                         f'%loadloss={PerdaCobreTrafo_per} %noloadloss={PerdaFerroTrafo_per}')

            # Add monitor to transformer AT
            linhas_substation_dss.append(f'New monitor.{tr_name}_m1  element=Transformer.{tr_name} '
                                         f'terminal=2 mode=1 ppolar=no')

        # Create dummy switch for each circuit
        for index in range(substation.shape[0]):
            cir_name = substation.loc[index]['COD_ID_x']
            tr_pac_2 = substation.loc[index]['PAC_2']
            cir_pac_ini = substation.loc[index]['PAC_INI']
            tensao_operacao = substation.loc[index]['TEN_OPE']
            kv_sec = substation.loc[index]['TEN_SEC']/1000
            pot_nom = substation.loc[index]['POT']

            # Create dummy regulator
            # Add regulator to control operation voltage
            linhas_substation_dss.append(f'New "Transformer.REG_busA_{cir_name}" phases=3 windings=2 '
                                         f'buses=[{tr_pac_2} "busa_{cir_name}"] '
                                         f'conns=[Wye Wye] kvs=[{kv_sec} {kv_sec}] '
                                         f'kvas=[{pot_nom:.1f} {pot_nom:.1f}] '
                                         f'%loadloss=0.0001 %noloadloss=0.0001 \n'
                                         f'New "Regcontrol.CREG_busA_{cir_name}" '
                                         f'transformer="REG_busA_{cir_name}" winding=2 '
                                         f'vreg={(100 * tensao_operacao):.0f} band=2 '
                                         f'ptratio={(10 * kv_sec / np.sqrt(3)):.2f} \n')

            # Create dummy switch Transformer
            linhas_substation_dss.append(f'New Line.SW_{cir_name} phases=3 bus1="busa_{cir_name}" bus2={cir_pac_ini} '
                                         f'r1=0.001 r0=0.001 x1=0 x0=0 c1=0 c0=0 length=0.001 units=km switch=T')

            # Add monitor in start of circuit
            # Não é necessario, pois esta sendo criado no arquivo monitor.dss de cada circuito
            # linhas_substation_dss.append(f'New monitor.{cir_name}_m1  element=Line.SW_{cir_name} '
            #                             f'terminal=2 mode=1 ppolar=no')

            # Create redirect files
            linhas_substation_dss.append('')
            for nome_arquivo in list_files_dss:
                nome_arquivo += '_' + cir_name
                linhas_substation_dss.append(f"redirect {cir_name}\{nome_arquivo}.dss")
            linhas_substation_dss.append('')

        # Inclui tensões nominais
        # remove duplicates
        voltagebases.drop_duplicates(subset=None, keep='first', inplace=True, ignore_index=False)
        voltagebases_str = ", ".join(str(element) for element in voltagebases['TEN_LIN_SE'])
        linhas_substation_dss.append(f"set voltagebases=({voltagebases_str})")
        linhas_substation_dss.append('calcv')
        # Inclui outros comandos
        # linhas_master.append(f"buscoords coords.dss")
        linhas_substation_dss.append(f"set mode=daily")
        linhas_substation_dss.append(f"set tolerance=0.0001")
        linhas_substation_dss.append(f"set maxcontroliter=100")
        linhas_substation_dss.append(f"set maxiterations=100")
        linhas_substation_dss.append(f"set stepsize=1h")
        linhas_substation_dss.append(f"set number=24")
        linhas_substation_dss.append(f"solve")
        linhas_substation_dss.append('')

    def get_lines_suprimento_circuito(self, se, circuito, linhas_suprimento_dss) -> None:
        """Função para determinar o suprimento de um determinado circuito"""
        linhas_suprimento_dss.clear()

        codigo = circuito['COD_ID']
        cod_barra_ini = circuito['PAC_INI']
        base_kv = round(circuito['TEN'] / 1000, 2)
        tensao_operacao = circuito['TEN_OPE']
        pot_trafo_at = circuito['POT']

        if pot_trafo_at is None:
            pot_trafo_at = 20000
        if tensao_operacao is None:
            tensao_operacao = '1.00'

        # sem controle de tensão no inicio do circuito, não converge em alguns casos
        if f'{tensao_operacao:.2f}' == '1.00':
            comando = f'new "circuit.{codigo}" pu={tensao_operacao} basekv={str(base_kv)} bus1="{cod_barra_ini}"'
            # comando = comando + f" mvasc3=600 mvasc1=400"
            comando = comando + f' r1=0 x1=0.0001'
        else:
            # Add regulator to control operation voltage insted of using in circuit definition
            comando = f'New "circuit.{codigo}" basekv={str(base_kv)} bus1="busA" r1=0 x1=0.0001 \n'
            comando = comando + f'New "Transformer.REG_busA" phases=3 windings=2 buses=["busA" "{cod_barra_ini}"] ' \
                                f'conns=[Wye Wye] kvs=[{str(base_kv)} {base_kv}] ' \
                                f'kvas=[{pot_trafo_at:.1f} {pot_trafo_at:.1f}] ' \
                                f'%loadloss=0.0001 %noloadloss=0.0001 \n' \
                                f'New "Regcontrol.CREG_busA" transformer="REG_busA" winding=2 ' \
                                f'vreg={(100 * tensao_operacao):.0f} band=2 ptratio={(10 * base_kv / np.sqrt(3)):.2f}\n'

        linhas_suprimento_dss.append(comando)

    def get_lines_chaves_mt(self, chaves, linhas_chaves_dss) -> None:
        """ Função para gerar as linhas (DSS) referentes às chaves de um determinado circuito """
        linhas_chaves_dss.clear()
        switch = ''
        for index in range(chaves.shape[0]):
            sw = chaves.loc[index]['P_N_OPE']
            if sw == 'F':  # chave fechada
                switch = 'T'
            elif sw == 'A':  # chave aberta
                switch = 'F'

            linha = 'New "Line.CMT_' + chaves.loc[index]['COD_ID'] + '"' + " phases=" + \
                    numero_fases_segmento(chaves.loc[index]['FAS_CON']) + \
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
            strTipRegul = reatores.loc[index]['TIP_REGU']
            intBanc = reatores.loc[index]['BANC']
            intCodBnc = reatores.loc[index]['CODBNC']
            strCodFasPrim = reatores.loc[index]['LIG_FAS_P']
            strCodFasSecu = reatores.loc[index]['LIG_FAS_S']
            dblTensaoPrimTrafo_kV = reatores.loc[index]['REL_TP']
            ctmt_vll = reatores.loc[index]['TEN']/1000
            PotNom_kVA = reatores.loc[index]['POT']
            dblTenRgl_pu = reatores.loc[index]['TEN_REG']
            ReatHL_per = reatores.loc[index]['XHL']
            dblPerdVz_per = reatores.loc[index]['PER_FER']
            dblPerdTtl_per = reatores.loc[index]['PER_TOT']

            # obtido da relação do tp -> será sempre tensão de fase
            dblkvREG = round(tens_regulador(dblTensaoPrimTrafo_kV), 4)
            if dblkvREG != round(ctmt_vll/np.sqrt(3), 4):
                dblkvREG = round(ctmt_vll/np.sqrt(3), 4)

            if strTipRegul == 'T' and numero_fases_transformador(strCodFasPrim) == 3:
                dblkvREG = vll = round(tens_regulador(dblTensaoPrimTrafo_kV) * np.sqrt(3), 4)  # 'tensão de linha'

            # análise de dados conflitantes
            if strTipRegul in ('DF', 'DA') and intBanc == 1:  # considera indormação do DF ou DA sobre a codFas
                # Usar tensão de linha
                dblkvREG = ctmt_vll

                if strCodFasPrim in ('AN', 'A'):
                    strCodFasPrim = 'AB'
                if strCodFasPrim in ('BN', 'B'):
                    strCodFasPrim = 'BC'
                if strCodFasPrim in ('CN', 'C'):
                    strCodFasPrim = 'CA'
                if strCodFasSecu in ('AN', 'A'):
                    strCodFasSecu = 'AB'
                if strCodFasSecu in ('BN', 'B'):
                    strCodFasSecu = 'BC'
                if strCodFasSecu in ('CN', 'C'):
                    strCodFasSecu = 'CA'

            PerdaFerroTrafo_per = (dblPerdVz_per / (float(PotNom_kVA) * 1000)) * 100
            PerdaCobreTrafo_per = ((dblPerdTtl_per - dblPerdVz_per) / (float(PotNom_kVA) * 1000)) * 100

            linhas_reguladores_dss.append('New "Transformer.REG_' + strNome + nome_banco(intCodBnc) + '"' +
                                          " phases=" + str(numero_fases(strCodFasPrim)) +
                                          " windings=2 buses=[" + '"' + strBus1 + nos(strCodFasPrim) + '"' + ' "' +
                                          strBus2 + nos(strCodFasSecu) + '"' + "] conns=[" +
                                          ligacao_trafo(strCodFasPrim) + " " + ligacao_trafo(strCodFasSecu) +
                                          "] kvs=[" + str(dblkvREG) + " " + str(dblkvREG) + "] kvas=[" +
                                          str(PotNom_kVA) + " " + str(PotNom_kVA) + "] xhl=" + str(ReatHL_per) +
                                          " %loadloss=" + f"{PerdaCobreTrafo_per:.6f}" +
                                          " %noloadloss=" + f"{PerdaFerroTrafo_per:.6f}")
            linhas_reguladores_dss.append(
                'New "Regcontrol.CREG_' + strNome + nome_banco(intCodBnc) + '"' + ' transformer="REG_' +
                strNome + nome_banco(intCodBnc) + '"' + " winding=2 vreg=" +
                f"{dblTenRgl_pu * 100:.0f}" + " band=2 ptratio=" + f"{dblkvREG * 10:.2f}")

    def get_lines_trafos(self, trafos, linhas_trafos_dss) -> None:

        linhas_trafos_dss.clear()

        # Remoção de transformadores duplicados.
        # ctrafos.drop_duplicates(subset='COD_ID', keep='first', inplace=True)
        # ctrafos.reset_index(drop=True, inplace=True)

        if trafos.empty:
            return
        # Add index trafo for Banc
        add_id_banc_to_dataframe(trafos, 'COD_ID')
        trafos.sort_values(by=['COD_ID', 'ID_BANC'], ascending=True, inplace=True)
        trafos.reset_index(drop=True, inplace=True)

        for index in range(trafos.shape[0]):
            mrt = trafos.loc[index]['MRT']  # 1 indica transformador monofasico com retorno por terra
            circ = trafos.loc[index]['CTMT']
            codigo = trafos.loc[index]['COD_ID']
            lig_fas_eq = trafos.loc[index]['FAS_CON']
            lig_fas_eq_p = trafos.loc[index]['LIG_FAS_P']
            lig_fas_eq_s = trafos.loc[index]['LIG_FAS_S']
            lig_fas_eq_t = trafos.loc[index]['LIG_FAS_T']
            lig_fas_p = trafos.loc[index]['FAS_CON_P']
            lig_fas_s = trafos.loc[index]['FAS_CON_S']
            lig_fas_t = trafos.loc[index]['FAS_CON_T']
            ten_lin_sec = trafos.loc[index]['TEN_LIN_SE']
            eq_ten_lin_sec = trafos.loc[index]['TEN_SEC']
            pac1 = trafos.loc[index]['PAC_1']
            pac2 = trafos.loc[index]['PAC_2']
            codi_tipo_trafo = trafos.loc[index]['TIP_TRAFO']
            kv1 = trafos.loc[index]['TEN_PRI'] / 1000
            kva_nom = trafos.loc[index]['POT_NOM']
            tap = trafos.loc[index]['TAP']
            PerdaTotalTrafo = trafos.loc[index]['PER_TOT']
            PerdaFerroTrafo = trafos.loc[index]['PER_FER']
            index_banc = trafos.loc[index]['ID_BANC']
            banc = trafos.loc[index]['BANC']
            lig_eq = trafos.loc[index]['LIG']
            pot_eq = trafos.loc[index]['POT_NOM_EQ']

            PerdaFerroTrafo_per = (PerdaFerroTrafo / (kva_nom * 1000)) * 100
            PerdaCobreTrafo_per = ((PerdaTotalTrafo - PerdaFerroTrafo) / (kva_nom * 1000)) * 100

            tipo_trafo = get_tipo_trafo(codi_tipo_trafo)

            if ten_lin_sec == 0:
                ten_lin_sec = eq_ten_lin_sec

            # Considera-se que tap maiores que 1.5 é um erro de cadastro. Ex.: 1.6 será convertido para 1.06
            if tap > 1.5:
                tap = ((tap - 1) / 10) + 1

            if tipo_trafo == 1 or tipo_trafo == 2:  # monofasico ou MT
                if round(kv1, 2) == 7.96:
                    kv1 = 13.8
                if ten_lin_sec == 0.127:
                    ten_lin_sec = 0.254
                if ten_lin_sec == 0.120:
                    ten_lin_sec = 0.240
                if ten_lin_sec == 0.110:
                    ten_lin_sec = 0.220

            if lig_fas_p != lig_fas_eq:
                lig_fas_p = lig_fas_eq

            if int(lig_eq) == 6 and int(banc) == 1 and int(mrt) == 0:
                mrt = 1

            if kva_nom != pot_eq and pot_eq != 0:
                kva_nom = pot_eq

            if int(banc) == 1:
                lig_fas_s = lig_fas_eq_s
                if lig_fas_eq_t != '0' and lig_fas_eq_t != '':
                    mrt = 1
                    lig_fas_t = lig_fas_eq_t

            if codi_tipo_trafo == 'DA':
                if round(kv1, 2) == 7.96:
                    kv1 = 13.8
                lig_fas_s = lig_fas_eq_s
                if lig_fas_eq_t != '0':
                    if mrt == 1:
                        lig_fas_t = lig_fas_eq_t
                    else:
                        lig_fas_s = lig_fas_eq_s + lig_fas_eq_t
                        lig_fas_s = lig_fas_s.replace('N', '')
                        lig_fas_t = '0'

            if codi_tipo_trafo == 'DF':
                if round(kv1, 2) == 7.96:
                    kv1 = round(kv1 * math.sqrt(3), 1)

            if codi_tipo_trafo == 'T' and lig_fas_eq == 'ABC' and index_banc > 1:
                continue

            if mrt == 1:
                linha = 'new transformer.TRF_MRT_' + codigo + nome_banco(index_banc) + \
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
                    tipo_trafo, lig_fas_p, lig_fas_s, lig_fas_t, float(kv1),
                    float(ten_lin_sec)) + ')' \
                                          ' kvas=(' + kvas_trafo(lig_fas_s, lig_fas_t, float(kva_nom)) + ')' \
                                                                                                         ' %loadloss=' + f'{PerdaCobreTrafo_per:.6f}' + \
                        ' %noloadloss=' + f'{PerdaFerroTrafo_per:.6f}'

                linhas_trafos_dss.append(linha)
                if ligacao_trafo(lig_fas_s) != 'Delta':
                    linha = 'New "Reactor.TRF_' + codigo + nome_banco(index_banc) + "_R" + '"' + \
                            ' phases=1 bus1=' + pac2 + '.4' + ' R=15 X=0 basefreq=60 '
                    linhas_trafos_dss.append(linha)

            else:
                linha = 'New "Transformer.TRF_' + codigo + nome_banco(index_banc) + '"' + \
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
                    tipo_trafo, lig_fas_p, lig_fas_s, lig_fas_t, float(kv1),
                    float(ten_lin_sec)) + ']' \
                                          ' taps=[' + tap_trafo(lig_fas_t, str(tap), codi_tipo_trafo) + ']' \
                                                                                                        ' kvas=[' + kvas_trafo(
                    lig_fas_s, lig_fas_t, float(kva_nom)) + ']' \
                                                            ' %loadloss=' + f"{PerdaCobreTrafo_per:.6f}" + \
                        ' %noloadloss=' + f"{PerdaFerroTrafo_per:.6f}"
                linhas_trafos_dss.append(linha)

                if ligacao_trafo(lig_fas_s) != 'Delta':
                    linha = 'New "Reactor.TRF_' + codigo + nome_banco(index_banc) + '_R' + '"' + \
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

    @classmethod
    def get_prop_curva_carga(cls, curvas_carga, tipo_dia, tipo_curva):
        """
        Utilizado para a caracterização das cargas de baixa e media tensão.
        Calcula a proporção de energia para um tipo de dia (DU, DO ou SA) e um tipo de curva de carga
        esse valor é utilizado para calcular o valor de potencia da carga a partir da sua energia.
        :param curvas_carga:
        :param tipo_dia:
        :param tipo_curva:
        :return:
        """

        crv_tipo_dia = curvas_carga[(curvas_carga['TIP_DIA'].str.upper() == tipo_dia) &
                                    (curvas_carga['COD_ID'].str.upper() == tipo_curva)]
        crv_all_tipo_dia = curvas_carga[curvas_carga['COD_ID'].str.upper() == tipo_curva]

        energia = crv_tipo_dia.filter(like="POT").sum(axis=1)

        # crv_all_tipo_dia['ener_class'] = crv_all_tipo_dia.filter(like="POT").sum(axis=1)
        crv_all_tipo_dia = crv_all_tipo_dia.copy()  # Create a copy to avoid the SettingWithCopyWarning
        crv_all_tipo_dia.loc[:, 'ener_class'] = crv_all_tipo_dia.filter(like="POT").sum(axis=1)

        return energia.iloc[0] / crv_all_tipo_dia['ener_class'].sum()

    def get_lines_curvas_carga(self, curvas_carga, multi_ger, linhas_curvas_carga_dss) -> None:
        """
        Transforma os 96 pontos das curvas de carga em 24 pontos e normaliza pelo seu valor máximo.
        :param multi_ger:
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

            linha = f'New "Loadshape.{curvas_carga.iloc[index][1].upper()}_' \
                    f'{curvas_carga.iloc[index][3].upper()}" 24 1.0 mult=({multi})'
            # print(linha)
            linhas_curvas_carga_dss.append(linha)

            # Curva de carga do consumidor com GD (curva de carga sem GD zerando para os horarios de geração)
            # Essa curva não sera utilizada no novo modelo de carga + geração independente.
            # Assim a curva do consumidor se mantem a mesma sendo a demanda acrecida do autoconsumo
            multi_list = multi.split(",")
            for idx, item in enumerate(multi_list):
                if 8 <= idx < 17:
                    multi_list[idx] = '0'
            multi_GD = ', '.join(multi_list)

            linha = f'New "Loadshape.{curvas_carga.iloc[index][1].upper()}_' \
                    f'{curvas_carga.iloc[index][3].upper()}_GD" 24 1.0 mult=({multi_GD})'
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
        linha = ''
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
        cargas_fc['COD_ID'] = cargas_fc['COD_ID'].str.upper()
        cargas['TIP_CC'] = cargas['TIP_CC'].str.upper()

        # Deve-se implementar para 12 meses e os 3 tipos de dia DO DU SA
        mes = 1
        tipo_dia = 'DU'

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
            trafo_kva = cargas.loc[index]['POT_NOM']

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

                    trafo_kva = float(trafo_kva)
                    if dblDemMax_kW > trafo_kva > 0:
                        dblDemMax_kW = trafo_kva * 0.98  # fator de potência médio

                    linhas_cargas_dss.append('New "Load.MT_' + strName + '_M1" bus1="' + strBus + nos(
                        strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                        strCodFas) + " model=2" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.7f}" +
                                             " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')
                    linhas_cargas_dss.append('New "Load.MT_' + strName + '_M2" bus1="' + strBus + nos(
                        strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                        strCodFas) + " model=3" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.7f}" +
                                             " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')

    def get_lines_cargas_mt_ssdmt(self, curvas_carga, cargas, cargas_fc, linhas_cargas_dss, mes, tipo_dia):

        linhas_cargas_dss.clear()

        mes = mes
        tipo_dia = tipo_dia
        strmes = f'{mes:02}'

        # Remoção de cargas duplicados. Ordernar pelo maior valor de energia e selecionar o primeirio
        cargas.sort_values(by=f'ENE_{strmes}', ascending=False)
        cargas.drop_duplicates(subset='COD_ID', keep='first', inplace=True)
        cargas.reset_index(drop=True, inplace=True)

        cargas_fc['COD_ID'] = cargas_fc['COD_ID'].str.upper()
        cargas['TIP_CC'] = cargas['TIP_CC'].str.upper()

        for index in range(cargas.shape[0]):
            strName = cargas.loc[index]['COD_ID']
            strCodCrvCrg = cargas.loc[index]['TIP_CC'] + '_' + tipo_dia
            strCodFas = cargas.loc[index]['FAS_CON']
            dblTensao_kV = cargas.loc[index]['KV_NOM']
            kv_ctmt = cargas.loc[index]['KV_CTMT']
            strBus = cargas.loc[index]['PAC']
            energy_mes = cargas.loc[index]['ENE_' + str(strmes)]
            demand_mes = cargas.loc[index]['DEM_' + str(strmes)]
            ano_base = cargas.loc[index]['ANO_BASE']
            strCodFasSSDMT = cargas.loc[index]['FAS_CON_SSDMT']

            # verifica a tensão do circuito em relação a tensão da carga MT
            if kv_ctmt != dblTensao_kV:
                dblTensao_kV = kv_ctmt
            if numero_fases_carga(strCodFas) == '1':  # fase da carga
                if numero_fases_carga(strCodFasSSDMT) == '3':  # Fases da linha
                    dblTensao_kV = f'{kv_ctmt / math.sqrt(3):.4f}'

            str_coments = ""
            if energy_mes == 0:
                str_coments = "!"
                dblDemMax_kW = 0
                # if demand_mes == 0:
                #     str_coments = "!"
                #     dblDemMax_kW = 0
                # else:
                #     dblDemMax_kW = demand_mes
            else:
                # numero de dias do mes
                num_dias = calendar.monthrange(ano_base, mes)[1]
                # Fator de carga calculado a partir do tipo de curva de carga
                fc = cargas_fc.loc[(cargas_fc['COD_ID'] == cargas.loc[index]['TIP_CC']) &
                                   (cargas_fc['TIP_DIA'] == tipo_dia)]
                dblDemMax_kW = (energy_mes / (num_dias * 24)) / fc.iloc[0]['FC']

                # Metodologia ANEEL: proporção de dias e tipo de curva de carga
                propor = DssFilesGenerator.get_prop_curva_carga(curvas_carga, tipo_dia,
                                                                cargas.loc[index]['TIP_CC'])
                proporDU = DssFilesGenerator.get_prop_curva_carga(curvas_carga, 'DU',
                                                                  cargas.loc[index]['TIP_CC'])
                proporDO = DssFilesGenerator.get_prop_curva_carga(curvas_carga, 'DO',
                                                                  cargas.loc[index]['TIP_CC'])
                proporSA = DssFilesGenerator.get_prop_curva_carga(curvas_carga, 'SA',
                                                                  cargas.loc[index]['TIP_CC'])
                tipo_dias_mes = calc_du_sa_do_mes(ano_base, mes)
                num_dias_tipo_dia = tipo_dias_mes[tipo_dia]
                prop_mes = propor * num_dias_tipo_dia
                prop_mes_ene = prop_mes / (proporDU * tipo_dias_mes['DU'] +
                                           proporDO * tipo_dias_mes['DO'] +
                                           proporSA * tipo_dias_mes['SA'])

                dblDemMax_kW = ((energy_mes * prop_mes_ene) / (num_dias_tipo_dia * 24)) / fc.iloc[0]['FC']

            linhas_cargas_dss.append(str_coments + 'New "Load.MT_' + strName + '_M1" bus1="' + strBus + nos(
                strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                strCodFas) + " model=2" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.7f}" +
                                     " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')
            linhas_cargas_dss.append(str_coments + 'New "Load.MT_' + strName + '_M2" bus1="' + strBus + nos(
                strCodFas) + '"' + " phases=" + numero_fases_carga(strCodFas) + " conn=" + ligacao_carga(
                strCodFas) + " model=3" + " kv=" + str(dblTensao_kV) + " kw=" + f"{(dblDemMax_kW / 2):.7f}" +
                                     " pf=0.92" + ' daily="' + strCodCrvCrg + '" status=variable vmaxpu=1.5 vminpu=0.93')

    def get_lines_cargas_bt(self, curvas_carga, cargas_bt, cargas_fc, cargas_pip, linhas_cargas_bt_dss, mes, tipo_dia):

        linhas_cargas_bt_dss.clear()

        cargas_bt['TIP_CC'] = cargas_bt['TIP_CC'].str.upper()
        cargas_fc['COD_ID'] = cargas_fc['COD_ID'].str.upper()
        cargas_pip['TIP_CC'] = cargas_pip['TIP_CC'].str.upper()

        mes = mes
        tipo_dia = tipo_dia
        if mes < 10:
            strmes = '0' + str(mes)
        else:
            strmes = str(mes)

        # Remoção de cargas duplicados.
        cargas_bt = cargas_bt.sort_values(by='ENE_' + str(strmes), ascending=False)
        cargas_bt.drop_duplicates(subset='COD_ID', keep='first', inplace=True)
        cargas_bt.reset_index(drop=True, inplace=True)

        for index in range(cargas_bt.shape[0]):
            strName = cargas_bt.loc[index]['COD_ID']
            strCodCrvCrg = cargas_bt.loc[index]['TIP_CC'] + '_' + tipo_dia
            strCodFas = cargas_bt.loc[index]['FAS_CON']
            strCodFas_medidor = cargas_bt.loc[index]['M_FAS_CON']
            # strBus = cargas_bt.loc[index]['PAC']
            strBus = cargas_bt.loc[index]['PAC_2']  # ligar as cargas BT no secundario do transformador
            energy_mes = cargas_bt.loc[index]['ENE_' + str(strmes)]
            dblTenSecu_kV = cargas_bt.loc[index]['TEN_LIN_SE']
            dblTen_carga = cargas_bt.loc[index]['TEN']  # tensão da carga
            codi_tipo_trafo = cargas_bt.loc[index]['TIP_TRAFO']
            dblDemMaxTrafo_kW = cargas_bt.loc[index]['POT_NOM'] * 0.92  # kVA
            ano_base = cargas_bt.loc[index]['ANO_BASE']

            ceg_gd = ''
            # Caso a carga possua geração alterar a curva típica para a curva com final _GD ?
            # if cargas_bt.loc[index]['CEG_GD'].strip() != '':
            #    ceg_gd = "_GD"

            # No OpenDSS cargas nonofasicas ligadas a transformador em Delta Aberto dever ser a dois fios
            if codi_tipo_trafo == "DA":
                if strCodFas == "AN" or strCodFas == "BN":
                    strCodFas = "ABN"
                if strCodFas == "CN":
                    strCodFas = "CAN"

            # if ligacao_carga(strCodFas) == 'Delta':
            # remover neutro da carga (.4)
            #    strCodFas = strCodFas.replace("N", "")

            # Acrescentar Neutro a todas as cargas bt. Verificar o resultado para outras subestações
            if (strCodFas == 'A' or strCodFas == 'B' or strCodFas == 'C' or
                    strCodFas == 'AB' or strCodFas == 'BC' or strCodFas == 'CA' or
                    strCodFas == 'ABC'):
                strCodFas += 'N'

            # comparação entre a fase de conecção do medidor e da carga, (melhora o desequilibrio)
            # check_meter_phases = True, será adotado as fases declaradas no medidor de energia
            check_meter_phases = True
            if check_meter_phases:
                if strCodFas != strCodFas_medidor and strCodFas_medidor is not None:
                    if len(strCodFas) == len(strCodFas_medidor):  # mesmo numero de fases
                        strCodFas = strCodFas_medidor

            # casos onde a tensão do secundario vem zerada, então utilizar a tensão da carga
            if dblTenSecu_kV == 0:
                if strCodFas == 'AN' or strCodFas == 'BN' or strCodFas == 'CN':
                    dblTenSecu_kV = dblTen_carga * math.sqrt(3)
                else:
                    dblTenSecu_kV = dblTen_carga

            intTipTrafo = get_tipo_trafo(codi_tipo_trafo)

            # num_dias = calendar.monthrange(ano_base, mes)[1]
            # número de dias para o tipo de dia analisado (DU, SA, DO)

            # Metodologia ANEEL: proporção de dias e tipo de curva de carga
            propor = DssFilesGenerator.get_prop_curva_carga(curvas_carga, tipo_dia, cargas_bt.loc[index]['TIP_CC'])
            proporDU = DssFilesGenerator.get_prop_curva_carga(curvas_carga, 'DU', cargas_bt.loc[index]['TIP_CC'])
            proporDO = DssFilesGenerator.get_prop_curva_carga(curvas_carga, 'DO', cargas_bt.loc[index]['TIP_CC'])
            proporSA = DssFilesGenerator.get_prop_curva_carga(curvas_carga, 'SA', cargas_bt.loc[index]['TIP_CC'])
            tipo_dias_mes = calc_du_sa_do_mes(ano_base, mes)
            num_dias_tipo_dia = tipo_dias_mes[tipo_dia]
            prop_mes = propor * num_dias_tipo_dia
            prop_mes_ene = prop_mes / (proporDU * tipo_dias_mes['DU'] +
                                       proporDO * tipo_dias_mes['DO'] +
                                       proporSA * tipo_dias_mes['SA'])
            # Fator de carregamento
            fc = cargas_fc.loc[(cargas_fc['COD_ID'] == cargas_bt.loc[index]['TIP_CC']) &
                               (cargas_fc['TIP_DIA'] == tipo_dia)]

            # metodologia 1
            # dblDemMax_kW = (energy_mes / (num_dias * 24)) / fc.iloc[0]['FC']
            # print(dblDemMax_kW)

            # metodologia ANEEL
            dblDemMax_kW = ((energy_mes * prop_mes_ene) / (num_dias_tipo_dia * 24)) / fc.iloc[0]['FC']
            # print(dblDemMax_kW)
            # print('---------')

            if dblDemMax_kW > dblDemMaxTrafo_kW:
                dblDemMaxCorrigida_kW = dblDemMaxTrafo_kW
            else:
                dblDemMaxCorrigida_kW = dblDemMax_kW

            srt_comment_dss = ''
            if dblDemMaxCorrigida_kW == 0:
                srt_comment_dss = '!'
            """
            determinação da tensão da carga
            " kv=" + kv_carga(strCodFas, dblTenSecu_kV, intTipTrafo) 
            or 
            " kv=" + f"{dblTenSecu_kV:.3f}" + 
            """

            linhas_cargas_bt_dss.append(srt_comment_dss +
                                        'New "Load.BT_' + strName +
                                        '_M1" bus1="' + strBus + nos_com_neutro(strCodFas) + '"' +
                                        " phases=" + numero_fases_carga_dss(strCodFas) +
                                        " conn=" + ligacao_carga(strCodFas) +
                                        " model=2" + " kv=" + kv_carga(strCodFas, dblTenSecu_kV, intTipTrafo) +
                                        " kw=" + f"{(dblDemMaxCorrigida_kW / 2):.5f}" + " pf=0.92" +
                                        ' daily="' + strCodCrvCrg + ceg_gd +
                                        '" status=variable vmaxpu=1.5 vminpu=0.92')

            linhas_cargas_bt_dss.append(srt_comment_dss +
                                        'New "Load.BT_' + strName +
                                        '_M2" bus1="' + strBus + nos_com_neutro(strCodFas) + '"' +
                                        " phases=" + numero_fases_carga_dss(strCodFas) +
                                        " conn=" + ligacao_carga(strCodFas) +
                                        " model=3" + " kv=" + kv_carga(strCodFas, dblTenSecu_kV, intTipTrafo) +
                                        " kw=" + f"{(dblDemMaxCorrigida_kW / 2):.5f}" + " pf=0.92" +
                                        ' daily="' + strCodCrvCrg + ceg_gd +
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
            strCodCrvCrg = cargas_pip.loc[index]['TIP_CC'].upper() + '_' + tipo_dia
            strCodFas = cargas_pip.loc[index]['FAS_CON']
            strBus = cargas_pip.loc[index]['PAC']
            strBus = cargas_pip.loc[index]['PAC_2']  # ligar as cargas PIP no secundario do transformador
            energy_mes = cargas_pip.loc[index]['ENE_' + str(strmes)]
            dblTenSecu_kV = cargas_pip.loc[index]['TEN_LIN_SE']
            pip_dblTen = cargas_pip.loc[index]['TEN']
            codi_tipo_trafo = cargas_pip.loc[index]['TIP_TRAFO']
            dblDemMaxTrafo_kW = cargas_pip.loc[index]['POT_NOM'] * 0.92  # kVA
            ano_base = cargas_pip.loc[index]['ANO_BASE']

            # Verificação do tipo de curva de carga associada a carga de iluminação pública
            # verificar o motivo para strName == '124825844'
            # if 'IP-TIPO' not in strCodCrvCrg:
            #    strCodCrvCrg = 'IP-TIPO1' + '_' + tipo_dia

            intTipTrafo = get_tipo_trafo(codi_tipo_trafo)

            # casos onde a tensão do secundario vem zerada, então utilizar a tensão da carga
            if dblTenSecu_kV == 0:
                if intTipTrafo == 1:  # transformador Monofasico
                    dblTenSecu_kV = pip_dblTen
                if intTipTrafo == 2:  # Transformador MRT
                    if strCodFas == 'AN' or strCodFas == 'BN' or strCodFas == 'CN':
                        dblTenSecu_kV = pip_dblTen * 2
                    else:
                        dblTenSecu_kV = pip_dblTen
                if intTipTrafo == 3:  # transformador bifasico
                    dblTenSecu_kV = pip_dblTen
                if intTipTrafo == 4:  # transformador trifasico
                    if strCodFas == 'AN' or strCodFas == 'BN' or strCodFas == 'CN':
                        dblTenSecu_kV = pip_dblTen * math.sqrt(3)
                    else:
                        dblTenSecu_kV = pip_dblTen
                if intTipTrafo == 5:  # transformador Monofasico
                    dblTenSecu_kV = pip_dblTen
                if intTipTrafo == 6:  # transformador delta aberto
                    if strCodFas == 'AN':
                        strCodFas = 'AB'
                    if strCodFas == 'BN':
                        strCodFas = 'AB'
                    if strCodFas == 'CN':
                        strCodFas = 'CA'
                    dblTenSecu_kV = pip_dblTen  # possivel problema

            num_dias = calendar.monthrange(ano_base, mes)[1]

            fc = cargas_fc.loc[(cargas_fc['COD_ID'] == cargas_pip.loc[index]['TIP_CC']) &
                               (cargas_fc['TIP_DIA'].str.upper() == tipo_dia)]
            dblDemMax_kW = (energy_mes / (num_dias * 24)) / fc.iloc[0]['FC']

            if dblDemMax_kW > dblDemMaxTrafo_kW:
                dblDemMaxCorrigida_kW = dblDemMaxTrafo_kW
            else:
                dblDemMaxCorrigida_kW = dblDemMax_kW

            if dblDemMaxCorrigida_kW > 0:
                linhas_cargas_bt_dss.append(
                    'New "Load.PIP_' + strName + '_M1" bus1="' + strBus + nos_com_neutro(strCodFas) + '"' +
                    " phases=" + numero_fases_carga_dss(strCodFas) + " conn=" + ligacao_carga(strCodFas) +
                    " model=2" + " kv=" + kv_carga(strCodFas, dblTenSecu_kV, intTipTrafo) + " kw=" +
                    f"{(dblDemMaxCorrigida_kW / 2):.6f}" + " pf=0.92" + ' daily="' + strCodCrvCrg +
                    '" status=variable vmaxpu=1.5 vminpu=0.92')
                linhas_cargas_bt_dss.append(
                    'New "Load.PIP_' + strName + '_M2" bus1="' + strBus + nos_com_neutro(strCodFas) + '"' +
                    " phases=" + numero_fases_carga_dss(strCodFas) + " conn=" + ligacao_carga(strCodFas) +
                    " model=3" + " kv=" + kv_carga(strCodFas, dblTenSecu_kV, intTipTrafo) + " kw=" +
                    f"{(dblDemMaxCorrigida_kW / 2):.6f}" + " pf=0.92" + ' daily="' + strCodCrvCrg +
                    '" status=variable vmaxpu=1.5 vminpu=0.92')

    def get_lines_generators_bt(self, generators, crv_ger, linha_generators_bt_dss, mes, model_pv_system):
        """
        Implementa a conversão do modelo de geradores de baixa tensão da BDGD para o
        modelo de gerador do openDSS.
        :param model_pv_system: Modelo a ser utilizado no openDss — pv_system == True ou Generator == False
        :param generators: Dados da BDGD dos geradores de baixa tensão.
        :param crv_ger: Curvas de carga da BDGD
        :param linha_generators_bt_dss: lista com o modelo de dados do openDSS.
        :param mes: mes de referência para as curvas de carga.
        :return:
        """
        linha_generators_bt_dss.clear()
        model_pv_system = model_pv_system
        set_pv_system = False
        # O gerador terá a mesma curva de carga para os 12 meses
        mes = mes
        # tipo_dia = self.tipo_dia
        if mes < 10:
            strmes = '0' + str(mes)
        else:
            strmes = str(mes)

        for index in range(generators.shape[0]):
            strName = generators.loc[index]['COD_ID']
            circuit = generators.loc[index]['CTMT']
            cod_mun = generators.loc[index]['MUN']
            cod_gd = generators.loc[index]['CEG_GD']
            # strCodCrvCrg = generators.loc[index]['TIP_CC'] + '_' + tipo_dia
            strCodFas = generators.loc[index]['FAS_CON']

            ten_lin_se_trafo = generators.loc[index]['TEN_LIN_SE']
            strBus = generators.loc[index]['PAC_TRAFO']
            energy_mes = generators.loc[index]['ENE_' + str(strmes)]
            ano_base = generators.loc[index]['ANO_BASE']
            codi_tipo_trafo = generators.loc[index]['TIP_TRAFO']

            intTipTrafo = get_tipo_trafo(codi_tipo_trafo)

            dblTensao_kV = ten_lin_se_trafo

            # Compara fases do gerador e fases do transformador, em caso de discordancia adota as fases do transformador
            fases_s_trafo = generators.loc[index]['FAS_CON_S']
            fases_t_trafo = generators.loc[index]['FAS_CON_T']
            for fase in strCodFas:
                if fase not in fases_s_trafo and fase not in fases_t_trafo:
                    if fases_t_trafo == '0':
                        strCodFas = fases_s_trafo
                    else:
                        strCodFas = fases_s_trafo.replace('N', '') + fases_t_trafo

            # Acrescentar Neutro a todas as fases.
            if (strCodFas == 'A' or strCodFas == 'B' or strCodFas == 'C' or
                    strCodFas == 'AB' or strCodFas == 'BC' or strCodFas == 'CA' or
                    strCodFas == 'ABC'):
                strCodFas += 'N'

            dbdaily = 'GeradorBT-Tipo1'
            # pv_daily = 'PVIrrad_diaria'     # definido no loadshape
            srt_comment_dss = ''

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

            dbconn = ligacao_gerador(strCodFas, codi_tipo_trafo)  # "Wye" ou "Delta"

            # considera-se que o valor obtido da BDGD se refere a potencia do inversor
            # irrad = 0.7  # deverá ser obtido do maximo valor da curva de irradiação / 1000
            rel_cc_ca = 1.15  # relação potência do painel pmpp e potência do inversor kva
            pf = 1.0
            kva = dblDemMax_kW / pf
            pmpp = dblDemMax_kW * rel_cc_ca

            # obtem a curva de temperatura ambiente da base de dados de irradiação
            temp_amb = temp_amb_by_municipio(cod_mun, mes, self.dist)

            # obtem curva de irradiação solar na base de dados de irradiação
            irradiacao = irrad_by_municipio(cod_mun, mes, self.dist)

            # converte temperatura ambiente e irradiação solar em temperatura do painel solar
            pv_temp_data = temp_amb_to_temp_pv(irradiacao, temp_amb)

            # máxima irradiação solar em relação a uma irradiação de 1000 W/m2
            irrad = round(max(pv_temp_data["crv_g"]) / 1000, 2)

            if model_pv_system == 1 and cod_gd[:2].upper() == 'GD':
                # No início do arquivo uma unica vez para todos os PV.
                # deverá ser substituido por dados de um banco de dados de irradiancia e temperatura
                # A curva de irradiancia normalizada é inserida no parametro Daily
                if not set_pv_system:
                    linha_generators_bt_dss.append(f'New XYCurve.MyPvsT npts=4 '
                                                   f'xarray=[0  25  75  100]  yarray=[1.2  1.0  0.8  0.6] ')
                    linha_generators_bt_dss.append(f'New XYCurve.MyEff npts=4 '
                                                   f'xarray=[0.1  0.2  0.4  1.0]  yarray=[0.86  0.9  0.93  0.97] ')
                    linha_generators_bt_dss.append(f'New Tshape.MyTemp npts=24 interval=1 '
                                                   f'temp={pv_temp_data["crv_t_pv_2"]}')
                    linha_generators_bt_dss.append(f'New Loadshape.PVIrrad_{circuit} 24 1.0 '
                                                   f'mult=({pv_temp_data["crv_g_norm"]})\n')
                    set_pv_system = True

                linha_generators_bt_dss.append(f'{srt_comment_dss}New PVsystem.BT_{strName}_M1 '
                                               f'phases={numero_fases_transformador(strCodFas)} '
                                               f'bus1={strBus + nos_com_neutro(strCodFas)} '
                                               f'conn={dbconn} '
                                               f'kv={kv_carga(strCodFas, dblTensao_kV, intTipTrafo)} '
                                               f'pf={pf} '
                                               f'pmpp={pmpp:.3f} '  # potencia do painel
                                               f'kva={kva:.3f} '  # potencia do inversor
                                               f'%pmpp=100 '
                                               f'irradiance={irrad} temperature=25 %cutin=0.1 %cutout=0.1 '
                                               f'effcurve=Myeff P-TCurve=MyPvsT Daily=PVIrrad_{circuit} TDaily=MyTemp')
            else:
                linha_generators_bt_dss.append(srt_comment_dss + 'New Generator.BT_' + strName +
                                               '_M1 bus1=' + strBus + nos_com_neutro(strCodFas) +
                                               ' phases=' + numero_fases_transformador(strCodFas) + ' conn=' + dbconn +
                                               ' kv=' + kv_carga(strCodFas, dblTensao_kV, intTipTrafo) +
                                               ' model=1 kw=' + f'{dblDemMax_kW:.4f}' +
                                               ' pf=0.95 daily="' + dbdaily +
                                               '" status=variable vmaxpu=1.5 vminpu=0.93')

    def get_lines_generators_mt_ssdmt(self, generators, crv_ger, linha_generators_mt_dss, mes, model_pv_system):
        """
        Escreve os arquivos DSS para os geradores MT
        :param model_pv_system:
        :param generators:
        :param crv_ger:
        :param linha_generators_mt_dss:
        :param mes:
        :return:
        """
        linha_generators_mt_dss.clear()
        set_pv_system = False
        model_pv_system = model_pv_system

        mes = mes
        dbdaily = 'GeradorMT-Tipo1'
        pv_daily = 'PVIrrad_diaria'

        if mes < 10:
            strmes = '0' + str(mes)
        else:
            strmes = str(mes)

        for index in range(generators.shape[0]):
            strName = generators.loc[index]['COD_ID']
            strCodFas = generators.loc[index]['FAS_CON']
            dblTensao_kV_form = generators.loc[index]['KV_FORM']
            dblTensao_kV_con = generators.loc[index]['KV_CON']
            strBus = generators.loc[index]['PAC']
            energy_mes = generators.loc[index]['ENE_' + str(strmes)]
            demand_mes = generators.loc[index]['DEM_' + str(strmes)]
            ano_base = generators.loc[index]['ANO_BASE']
            cod_ceg = generators.loc[index]['CEG_GD']

            dbconn = ligacao_gerador(strCodFas)  # "Wye" ou "Delta"

            dblTensao_kV = dblTensao_kV_form
            if dblTensao_kV_form is None:
                dblTensao_kV = dblTensao_kV_con

            if demand_mes == 0:
                for crv in crv_ger:
                    if crv[0] == dbdaily:
                        pt_crv = crv[1]
                        # media dos valores diferentes de zero
                        fc = np.apply_along_axis(lambda v: np.mean(v[np.nonzero(v)]), 0, pt_crv)

                num_dias = calendar.monthrange(ano_base, mes)[1]
                dblDemMax_kW = (energy_mes / (num_dias * 24)) / fc
            else:
                dblDemMax_kW = demand_mes

            # comenta geradores sem demanda
            srt_comment_dss = ''
            if dblDemMax_kW == 0:
                srt_comment_dss = '!'

            if model_pv_system == 1 and cod_ceg[:2].upper() == 'GD':
                # No início do arquivo uma unica vez para todos os PV.
                # deverá ser substituido por dados de um banco de dados de irradiancia e temperatura
                # A curva de irradiancia normalizada é inserida no parametro Daily
                # considera-se que o valor obtido da BDGD se refere a potência do inversor
                # irrad = 0.7  # deverá ser obtido do máximo valor da curva de irradiação / 1000
                rel_cc_ca = 1.15  # relação potência do painel pmpp e potência do inversor kva (1.15 residencial 1.25 para comercial)
                pf = 1.0
                kva = dblDemMax_kW / pf
                pmpp = dblDemMax_kW * rel_cc_ca
                pv_temp_data = temp_amb_to_temp_pv()  # converte temperatura ambiente em temperatura do painel solar
                irrad = round(max(pv_temp_data["crv_g"]) / 1000, 2)

                if not set_pv_system:
                    linha_generators_mt_dss.append(f'New XYCurve.MyPvsT npts=4 '
                                                   f'xarray=[0  25  75  100]  yarray=[1.2 1.0 0.8 0.6] ')
                    linha_generators_mt_dss.append(f'New XYCurve.MyEff npts=4 '
                                                   f'xarray=[0.1  0.2  0.4  1.0]  yarray=[0.86  0.9  0.93  0.97] ')
                    linha_generators_mt_dss.append(f'New Tshape.MyTemp npts=24 interval=1 '
                                                   f'temp={pv_temp_data["crv_t_pv_2"]} \n')
                    set_pv_system = True

                linha_generators_mt_dss.append(f'{srt_comment_dss}New PVsystem.MT_{strName}_M1 '
                                               f'phases={numero_fases_transformador(strCodFas)} '
                                               f'bus1={strBus}{nos(strCodFas)} '
                                               f'conn={dbconn} '
                                               f'kv={str(dblTensao_kV)} '
                                               f'pf={pf} '
                                               f'pmpp={pmpp:.3f} '  # potencia do painel
                                               f'kva={kva:.3f} '  # potencia do inversor
                                               f'%pmpp=100 '
                                               f'irradiance={irrad} temperature=25 %cutin=0.1 %cutout=0.1 '
                                               f'effcurve=Myeff P-TCurve=MyPvsT Daily={pv_daily} TDaily=MyTemp')
            else:
                linha_generators_mt_dss.append(f'{srt_comment_dss}New Generator.MT_{strName}_M1 '
                                               f'phases={numero_fases_carga(strCodFas)} '
                                               f'bus1={strBus}{nos(strCodFas)} '
                                               f'conn={dbconn} '
                                               f'kv={str(dblTensao_kV)} '
                                               f'model=1 kw={dblDemMax_kW:.4f} '
                                               f'pf=0.92 daily={dbdaily} '
                                               f'status=variable vmaxpu=1.5 vminpu=0.93')
            """                                   
            linha_generators_mt_dss.append(
                srt_comment_dss + 'New Generator.MT_' + strName + '_M1 bus1=' + strBus  + nos(strCodFas) +
                ' phases=' + numero_fases_carga(strCodFas) + ' conn=' + dbconn + ' kv=' +
                str(dblTensao_kV) + ' model=1 kw=' + f'{dblDemMax_kW:.4f}' + ' pf=0.92 daily="' +
                dbdaily + '" status=variable vmaxpu=1.5 vminpu=0.93')
            """

    def get_lines_generators_mt(self, generators, crv_ger, linha_generators_mt_dss):
        linha_generators_mt_dss.clear()
        # O gerador terá a mesma curva de carga para os 12 meses
        mes = 1
        # tipo_dia = self.tipo_dia
        if mes < 10:
            strmes = '0' + str(mes)
        else:
            strmes = str(mes)

        for index in range(generators.shape[0]):
            strName = generators.loc[index]['COD_ID']
            # strCodCrvCrg = generators.loc[index]['TIP_CC'] + '_' + tipo_dia
            strCodFas = generators.loc[index]['FAS_CON']
            dblTensao_kV = generators.loc[index]['KV_NOM']
            dbl_kv_trafo = generators.loc[index]['KV_TRAFO']
            strBus = generators.loc[index]['PAC']
            energy_mes = generators.loc[index]['ENE_' + str(strmes)]
            dblDemMax_kW = generators.loc[index]['DEM_' + str(strmes)]
            ano_base = generators.loc[index]['ANO_BASE']

            cod_kv_pri_trafo = generators.loc[index]['TEN_PRI']
            cod_kv_generator = generators.loc[index]['TEN_FORN']
            if cod_kv_pri_trafo != cod_kv_generator:
                # print(f"Erro: cod tensão do gerador diferente do transformador. Atualizar banco de dados")
                print(f"cod tensão do gerador: {cod_kv_generator} cod tensão trafo: {cod_kv_pri_trafo}")
                dblTensao_kV = dbl_kv_trafo

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

            linha_generators_mt_dss.append(
                srt_comment_dss + 'New Generator.MT_' + strName + '_M1 bus1=' + strBus + nos(strCodFas) +
                ' phases=' + numero_fases_carga(strCodFas) + ' conn=' + dbconn + ' kv=' +
                str(dblTensao_kV) + ' model=3 kw=' + f'{dblDemMax_kW:.4f}' + ' pf=0.92 daily="' +
                dbdaily + '" status=variable vmaxpu=1.5 vminpu=0.93')

    def get_line_capacitor(self, capacitores, trafos_mt_mt, trafos_mt_mt_seg, linha_capacitores_dss):
        """
        Montagem do arquivo DSS para capacitores de média tensão.
        :param capacitores:
        :param linha_capacitores_dss:
        :return:
        """

        # A lista de capacitores pode ter capacitores duplicados quando existe mais de um capacitor no mesmo PAC.
        capacitores.drop_duplicates(subset='COD_ID', keep='first', inplace=True)
        capacitores = capacitores.reset_index(drop=True)
        linha_capacitores_dss.clear()
        for index in range(capacitores.shape[0]):
            str_name = capacitores.loc[index]['COD_ID']
            str_pac = capacitores.loc[index]['PAC_1']
            strCodFas = capacitores.loc[index]['FAS_CON']
            dbl_pot = capacitores.loc[index]['POT']
            line_cod = capacitores.loc[index]['LINE_COD']
            kv_nom = capacitores.loc[index]['TEN'] / 1000
            ctmt = capacitores.loc[index]['CTMT']

            # A tensão do capacitor pode não ser a tensão do circuito (kv_nom) quando existir um
            # transformador MT-MT no circito. Neste caso deve-se verificar se o capacitor está
            # instalado a jusante ou a montante do transformador MT-MT.
            if trafos_mt_mt_seg:
                find_cap = list(filter(lambda x: str_pac in x, trafos_mt_mt_seg))
                if not find_cap:
                    # tensão do capacitor é o do secundario do trafo MTMT
                    tr_mt_mt = trafos_mt_mt.loc[trafos_mt_mt['ctmt'] == ctmt]
                    kv_nom = tr_mt_mt['TEN_SEC'].values[0] / 1000

            num_fases = numero_fases(strCodFas)

            # A referência do controle do capacitor é tensão de fase para capacitor em wye e tensão de linha para conn delta.
            if ligacao_trafo(strCodFas) == "Delta":
                v_ref = kv_nom * 1000
            else:
                v_ref = (kv_nom * 1000) / math.sqrt(3)

            ptratio = 60
            c_on = round((v_ref / ptratio * 0.95), 4)  # valor em volts - tensão de fase
            c_off = round((v_ref / ptratio), 4)

            linha_capacitores_dss.append(
                f'New "Capacitor.CAP_{str_name}" bus1="{str_pac}{nos(strCodFas)}" kvar={dbl_pot} kv={kv_nom} '
                f'phases={num_fases} conn={ligacao_trafo(strCodFas)}')
            linha_capacitores_dss.append(
                f'New "CapControl.C1ctrl_{str_name}" element="Line.SMT_{line_cod}" Capacitor=CAP_{str_name} '
                f'Type=voltage ptratio={ptratio} ON={c_on} OFF={c_off}')

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
            linha = 'New "monitor.' + tipo_elem + '_' + str(medidor['COD_ID']).replace('Line.', '') + \
                    '" element="' + medidor['COD_ID'] + '" terminal=1 mode=1 ppolar=no'
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

        # Inclui as tensões de linha nominais
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
