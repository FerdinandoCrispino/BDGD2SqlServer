# -*- coding: utf-8 -*-
import py_dss_interface
import json
import os
import numpy as np
import pandas as pd
from Tools.tools import load_config, circuit_by_bus, temp_amb_by_municipio, irrad_by_municipio, \
    temp_amb_to_temp_pv, municipio_from_load, get_coord_load

"""
Classe implementa a insersão de geradores no caso base.
Localiza as cargas do caso base definidas no arquivo de entrada (json)
busca informações das cargas do caso base (tensão e tipo de conexão) e 
insere o gerador utilizando as informações de tensão e nós da carga.
"""


class CreateScenarios:
    def __init__(self, dist, sub, circuit, type_day, month, ano_base, scenarios_json, path_scenario):
        self.dss = py_dss_interface.DSS()
        self.dss_path = os.path.join(os.path.expanduser(load_config(dist)['dss_files_folder']), dist, sub, circuit)
        self.dist = dist
        self.sub = sub
        self.circuito = circuit
        self.tipo_dia = type_day
        self.mes = month
        self.database = ano_base
        self.data_scenarios = scenarios_json
        self.sc_path = os.path.dirname(os.path.abspath(path_scenario))
        self.dss_file = f"{type_day}_{month}_Master_{dist}_{sub}_{circuit}.dss"

    def __first_element(self):
        """ Retorna o primeiro bus do circuito
            Navega pela topologia da rede de um bus qualquer ate o início do circuito
        """
        self.dss.topology.first()
        self.dss.topology.forward_branch()
        while True:
            index_branch = self.dss.topology.backward_branch()
            if index_branch:  # chegou no inicio do alimentador (Vsource)
                self.dss.topology.forward_branch()  # avançar para obter o primeiro elemento
                print(self.dss.topology.branch_name)
                return self.dss.topology.branch_name

    def __get_parm_irrad(self, load):
        """
        Obtem os parametros de irradiação solar e temperatura do painel para inserir a nova geração PV.
        A partir da carga localiza-se o seu municipio
        Com o municipio busca as informações de irradiação e temeratura do município.
        :param load: codigo do consumidor adotante do gerador PV.
        :return: dict - dicionário com os parametros de irradiação e temperaturas do local de um determinado consumidor.
        """

        cod_mun = municipio_from_load(load.split("_")[1], self.dist)
        if not cod_mun:
            print(f"Load not found.")
        else:
            # obtem a curva de temperatura ambiente da base de dados de irradiação
            temp_amb = temp_amb_by_municipio(cod_mun, self.mes, self.dist)

            # obtem curva de irradiação solar na base de dados de irradiação
            irradiacao = irrad_by_municipio(cod_mun, self.mes, self.dist)

            # converte temperatura ambiente e irradiação solar em temperatura do painel solar
            pv_temp_data = temp_amb_to_temp_pv(irradiacao, temp_amb)

            return pv_temp_data

    def __edit_dss_pvsystem(self, load_param_list, pv_temp_data):
        """
        Cria o commando de edição no OpenDSS para inserir o cenário de geração PV no caso base
        :param load_param_list: lista de parametros obtidos do consumidor on o gerador será instalado.
        :param pv_temp_data: lista de parametros de irradiação solar, temperatura do painel, curvas de eficiencia.
        :return: lista de comandos do OpenDSS para inserir o novo gerador no caso base.
        """

        linha_generators_dss = []
        load = load_param_list['load'].split("_")[1]
        strBus = load_param_list['load_bus']
        strFase = load_param_list['load_ph']
        dbconn = load_param_list['conn']
        kv_carga = load_param_list['kv']
        dblDemMax_kW = load_param_list['kw']

        rel_cc_ca = 1.15  # relação potência do painel pmpp e potência do inversor kva
        pf = 1.0
        kva = dblDemMax_kW / pf
        pmpp = dblDemMax_kW * rel_cc_ca

        # máxima irradiação solar em relação a uma irradiação de 1000 W/m2
        irrad = round(max(pv_temp_data["crv_g"]) / 1000, 2)

        linha_generators_dss.append(f'New XYCurve.MyPvsT_{load} npts=4 '
                                    f'xarray=[0  25  75  100]  yarray=[1.2  1.0  0.8  0.6] ')
        linha_generators_dss.append(f'New XYCurve.MyEff_{load} npts=4 '
                                    f'xarray=[0.1  0.2  0.4  1.0]  yarray=[0.86  0.9  0.93  0.97] ')
        linha_generators_dss.append(f'New Tshape.MyTemp_{load} npts=24 interval=1 '
                                    f'temp={pv_temp_data["crv_t_pv_2"]}')
        linha_generators_dss.append(f'New Loadshape.PVIrrad_{load} 24 1.0 '
                                    f'mult={pv_temp_data["crv_g_norm"]}')

        linha_generators_dss.append(f'New PVsystem.{load}_SC '
                                    f'phases={strFase} '
                                    f'bus1={strBus} '
                                    f'conn={dbconn} '
                                    f'kv={kv_carga} '
                                    f'pf={pf} '
                                    f'pmpp={pmpp:.3f} '  # potencia do painel
                                    f'kva={kva:.3f} '  # potencia do inversor
                                    f'%pmpp=100 '
                                    f'irradiance={irrad} temperature=25 %cutin=0.1 %cutout=0.1 '
                                    f'effcurve=Myeff_{load} P-TCurve=MyPvsT_{load} '
                                    f'Daily=PVIrrad_{load} TDaily=MyTemp_{load}')
        return linha_generators_dss

    def __get_param_loads(self) -> list:
        """
        Obtem os parametros do ponto de conexão da carga onde será inserido o novo gerador.
        Adota-se que o novo gerador terá a mesma tensão e conexão de fases da carga.
        Os valores são retirados do modelo do OpenDSS apos a leitura dos arquivos DSS do caso base.
        :return: lista de parametros para inserção do novo gerador no circuito conforme definição do cenário.
        """
        load_param_list = []
        load_param_dict = dict()
        load_sc = self.data_scenarios[0]['cod_id']
        for data in self.data_scenarios:
            load_sc = data['cod_id']
            kw_sc = data['kw']
            self.dss.meters.first()
            # print(f"Meters: {self.dss.meters.count}")
            for _ in range(self.dss.meters.count):
                loads = self.dss.meters.all_pce_in_zone
                # print(f"Meter: {self._dss.meters.name}")
                # print(loads)
                conn = ''
                for load in loads:
                    if load.split(".")[0].lower() == "load":
                        if load_sc in load:
                            self.dss.circuit.set_active_element(load)
                            load_ph = self.dss.cktelement.num_phases
                            load_bus = self.dss.cktelement.bus_names[0]
                            self.dss.circuit.set_active_bus(load_bus)
                            load_nodes = self.dss.bus.nodes
                            load_kv = self.dss.loads.kv
                            load_kva = self.dss.loads.kva

                            # Gerador trifásico será adotado sempre conexão em estrela
                            bus = self.dss.cktelement.bus_names[0].split(".", 1)[1]
                            if bus in ("1.2.3.4", "1.2.3", "1.2.3.0", "1.4", "2.4", "3.4",
                                       "1.0", "2.0", "3.0", "1", "2", "3"):
                                conn = "WYE"
                            else:
                                conn = "DELTA"
                            load_param_dict['coords'] = get_coord_load(self.dist, load_sc)
                            load_param_dict['load'] = load
                            load_param_dict['load_bus'] = load_bus
                            load_param_dict['load_ph'] = load_ph
                            load_param_dict['conn'] = conn
                            load_param_dict['kv'] = load_kv
                            load_param_dict['kw'] = kw_sc
                            load_param_list.append(load_param_dict.copy())

                            break
                else:
                    continue
                break

        return load_param_list

    def __run_base_case(self):
        """
        Faz a leitura do caso base sem realizar o solve.
        Coloca na memória o modelo da rede para o caso base.
        :return: True or False
        """
        dss_file = os.path.join(self.dss_path, self.dss_file)
        self.dss.dssinterface.clear_all()
        # self.dss.text(f'compile [{dss_file}]')
        try:
            with open(os.path.join(dss_file), 'r') as file:
                for dss_line in file:
                    if not (dss_line.startswith('!') or dss_line.startswith('clear') or dss_line.startswith('\n')):
                        self.dss.text(dss_line.strip('\n'))
                    if 'calcv' in dss_line:
                        break

            # Remove meters if present in dss files
            # for name in self.dss.meters.names:
            #    self.dss.text(f"disable energymeter.{name}")

            # Add meter in the first element
            # first_elem = self.__first_element()
            # self.dss.text(f"new energymeter.{first_elem} element={first_elem} terminal=1")
            # self.dss.text(f"Enable energymeter.{first_elem}")
        except IOError as e:
            print("An error occurred:", e)
            return True
        finally:
            print("Closing the file now")
            file.close()
            return False

    def __voltage_study(self, month):
        """
        Executa o OpenDSS para o cenário de hora em hora e obtem os indices de desempenho do circuito.
        :return:
        """
        path_result = os.path.abspath(os.path.join(self.sc_path, self.tipo_dia, self.database, self.mes))
        os.makedirs(path_result, exist_ok=True)

        total_number = 24
        self.dss.text("set mode = daily")
        self.dss.text("set tolerance = 0.0001")
        self.dss.text("set maxcontroliter = 100")
        self.dss.text("set maxiterations = 100")
        self.dss.text("Set stepsize = 1h")
        self.dss.text("set number = 1")
        voltage_bus_list = []
        voltage_bus_dict = dict()
        voltage_bus_dict_1phase = dict()

        vuf_bus_list = []
        vuf_bus_dict = dict()

        voltage_bus_violation_list = []
        vuf_bus_violation_list = []

        for number in range(1, total_number + 1):
            #self.dss.text(f"set number={number}")
            self.dss.monitors.reset_all()
            self.dss.solution.solve()
            status = self.dss.solution.converged
            if status == 0:
                print(f'solution not converged: {status}')
                continue

            active_bus = ''
            voltage_bus_dict.clear()
            for bus_name in self.dss.circuit.nodes_names:
                if bus_name.split('.')[0] in (
                        active_bus, 'busa'):  # bus ficticio para o OLTC do início do circuito, Não será avaliado
                    continue
                active_bus = bus_name.split('.')[0]
                self.dss.circuit.set_active_bus(active_bus)

                if bus_name.split('.')[1] == '4':  # para desconsiderar tensão de neutro
                    continue
                if self.dss.bus.kv_base < 1:  # para desconsiderar a baixa tensão
                    continue

                vll_pu = []
                vln_pu = []
                vll = []
                # Não funciona! em alguns casos pode haver diferença entre o tamanho o vetor de pu_vll e do vmag_pu
                # for i in range(self.dss.bus.num_nodes):
                num_nodes = int(len(self.dss.bus.vll) / 2)
                # num_nodes = self.dss.bus.num_nodes
                # Não existe valores de tensão de linha para barras monofasicas
                if num_nodes > 1:
                    for i in range(num_nodes):
                        # print(active_bus)
                        # tensões de linha
                        vll_pu.append(
                            round(
                                np.sqrt(self.dss.bus.pu_vll[i * 2] ** 2 + self.dss.bus.pu_vll[(i * 2) + 1] ** 2),
                                8))
                        vll.append(
                            round(np.sqrt(self.dss.bus.vll[i * 2] ** 2 + self.dss.bus.vll[(i * 2) + 1] ** 2), 5))
                        voltage_bus_dict[f"{bus_name.split('.')[0]}.{i + 1}"] = vll_pu[i]

                        # tensões de fase
                        vln_pu.append(
                            round(np.sqrt(
                                self.dss.bus.pu_voltages[i * 2] ** 2 + self.dss.bus.pu_voltages[(i * 2) + 1] ** 2), 5))
                        voltage_bus_dict[f"{bus_name.split('.')[0]}.{i + 1}"] = vln_pu[i]

                    if num_nodes == 3 and vll[0] != 0:
                        beta = (vll[0] ** 4 + vll[1] ** 4 + vll[2] ** 4) / (
                                vll[0] ** 2 + vll[1] ** 2 + vll[2] ** 2) ** 2
                        vuf = round(np.sqrt((abs(1 - np.sqrt(3 - 6 * beta))) / (1 + np.sqrt(3 - 6 * beta))) * 100, 5)
                        vuf_bus_dict[f"{bus_name.split('.')[0]}"] = vuf

                elif num_nodes == 1:
                    voltage_bus_dict_1phase[bus_name] = \
                        round(np.sqrt(self.dss.bus.pu_voltages[0] ** 2 + self.dss.bus.pu_voltages[1] ** 2), 8)
                    # voltage_bus_dict_1phase[bus_name] = \
                    #    round(np.sqrt(self.dss.bus.voltages[0] ** 2 + self.dss.bus.voltages[1] ** 2) /
                    #          self.dss.bus.kv_base, 8 )

            max_vol = max(voltage_bus_dict.items(), key=lambda x: x[1])
            min_vol = min(voltage_bus_dict.items(), key=lambda x: x[1])

            # os valores de max e min poidem apresentar diferença nos caso onde existem valores iguais
            # max_vol = max(voltage_bus_dict.values())
            # min_vol = min(voltage_bus_dict.values())

            # print(len(voltage_bus_dict.values()))
            print(f'Tensão máxima na hora {number}: {max_vol}')
            print(f'Tensão mínima na hora {number}: {min_vol}')

            # desequilibrio na barra com menor tensão
            self.dss.circuit.set_active_bus(min_vol[0].split('.')[0])

            cir_nome = circuit_by_bus(min_vol[0].split('.')[0], self.dist)
            print(f"Circuito: {cir_nome['CTMT'][0]}")

            Vab = round(np.sqrt(self.dss.bus.vll[0] ** 2 + self.dss.bus.vll[1] ** 2), 4)
            Vbc = round(np.sqrt(self.dss.bus.vll[2] ** 2 + self.dss.bus.vll[3] ** 2), 4)
            Vca = round(np.sqrt(self.dss.bus.vll[4] ** 2 + self.dss.bus.vll[5] ** 2), 4)

            print(f' VAB: {Vab} V')
            print(f' VBC: {Vbc} V')
            print(f' VCA: {Vca} V')

            # Desequilibrio de tensão:
            # IEEE: -  vuf% = 3(Vmax-Vmin)/(VA+Vb+Vc)
            # Cigre / Prodist - limite 2%
            # Vuf = sqrt(1-sqrt(3-6*Beta)/(1+sqrt(3-6*Beta))) beta=(Vab**4+Vbc**4+Vca**4)/(Vab**2+Vbc**2+Vca**2)**2
            # IEC: - FD% = (V2/V1)*100  (sequencia positiva dividido pela sequencia negativa)

            if Vab != 0 and Vbc != 0 and Vca != 0:
                beta = (Vab ** 4 + Vbc ** 4 + Vca ** 4) / (Vab ** 2 + Vbc ** 2 + Vca ** 2) ** 2
                Vuf = round(np.sqrt((abs(1 - np.sqrt(3 - 6 * beta))) / (1 + np.sqrt(3 - 6 * beta))) * 100, 5)
                print(f' Desequilibrio de Tensão: {Vuf} %')

            # deve-se fazer a copia caso contrario a referencia é por ponteiro!!
            vuf_bus_list.append(vuf_bus_dict.copy())

            # acrescenta o dict das linhas monofasicas
            voltage_bus_dict.update(voltage_bus_dict_1phase)

            # create list of dict
            voltage_bus_list.append(voltage_bus_dict.copy())

            # buses com violação de tensão
            voltage_bus_violation_dict = dict((k, v) for k, v in voltage_bus_dict.items() if (float(v) < 0.95 or
                                                                                              float(v) > 1.05))
            voltage_bus_violation_list.append(voltage_bus_violation_dict.copy())

            # fator de desbalanceamento de tensão
            vuf_bus_violation_dict = dict((k, v) for k, v in vuf_bus_dict.items() if float(v) > 3.0)
            vuf_bus_violation_list.append(vuf_bus_violation_dict)

        df_vbus = pd.DataFrame.from_dict(voltage_bus_list)
        df_vbus.to_csv(f'{path_result}/{self.database}_{self.tipo_dia}_{self.mes}_voltage_bus_sc{month}.csv')
        df_violation = pd.DataFrame.from_dict(voltage_bus_violation_list)
        df_violation.to_csv(
            f'{path_result}/{self.database}_{self.tipo_dia}_{self.mes}_voltage_bus_violation_sc{month}.csv')
        df_vuf = pd.DataFrame.from_dict(vuf_bus_violation_list)
        # df_vuf.to_csv(f'{self.database}_{self.tipo_dia}_{self.mes}_vuf_bus_violation_scenario.csv')
        df_vuf = df_vuf.transpose()
        df_vuf.to_excel(f'{path_result}/{self.database}_{self.tipo_dia}_{self.mes}_vuf_bus_violation_sc{month}.xlsx')
        df_all_vuf = pd.DataFrame.from_dict(vuf_bus_list)
        df_all_vuf = df_all_vuf.transpose()
        df_all_vuf.to_excel(f'{path_result}/{self.database}_{self.tipo_dia}_{self.mes}_vuf_bus_sc{month}.xlsx')

        # convert into json
        self.__save_json('v_pu_bus', path_result, voltage_bus_list, month)

    def __save_json(self, json_type, path_result, dados, month_ref):
        """
        Salva o arquivo de resultados do fluxo de potência para o mes de referência do cenário.
        :param json_type: Não utilizado.
        :param path_result: Local de gravação do arquivo.
        :param dados: valores das tensões das barras do circuito analizado.
        :param month_ref: Mês de refeerncia de inserção de geração no cicrcuito conforme cenário.
        :return: None
        """

        # with open(f"{json_path}\\{self.dss.circuit.name.upper()}_{self.database}_{self.tipo_dia}_{self.mes}_"
        with open(f"{path_result}/{self.circuito}_sc{month_ref}.json".replace("\\", "/"), "w") as fj:
            json.dump(dados, fj, indent=2)

    def control_scenario_dss(self, month_sc):
        """
        Controla a inserção dos scenarios e execução do OpenDSS.
        :param month_sc: Mês de refeerncia de inserção de geração no cicrcuito conforme cenário.
        :return: None
        """

        # coloca na memoria o caso base
        erro = self.__run_base_case()
        if erro:
            exit()

        # busca no caso base os parametros das cargas declaradas no cenário
        parm_loads = self.__get_param_loads()

        # Acrescenta os geradores PV no caso base
        for load in parm_loads:
            pv_irrad = self.__get_parm_irrad(load['load'])
            edit_sc = (self.__edit_dss_pvsystem(load, pv_irrad))
            for write_sc in edit_sc:
                print(f"{write_sc}")
                self.dss.text(f"{write_sc}")

        # TODO inserir estudos de perdas e inversão de fluxo
        # Executa o estudo
        self.__voltage_study(month_sc)


if __name__ == '__main__':
    # configuração do estudo
    dist = '391'
    sub = 'APA'
    circ = 'RAPA1303'
    tipo_dia = 'DU'
    ano_base = '2022'
    mes_base = '1'
    file_scenario = 'sc1.json'
    script_dir = os.path.dirname(__file__)
    filepath = os.path.join(script_dir, '..', 'ui/static/scenarios/sc_type1', dist, sub, circ, file_scenario).replace(
        '\\', '/')

    # leitura do arquivo de cenarios
    try:
        with open(filepath) as fp:
            data_json = json.load(fp)
    except (ValueError, TypeError) as e:
        print("An error occurred:", e)
        exit()
    finally:
        print("Closing the file now")
        fp.close()

    # horizonte de analise anual
    for month in range(1, 13):
        # Monthly filter with list comprehensions
        scenario_study_month = [x for x in data_json if x['mes'] == month]
        if scenario_study_month:
            sc = CreateScenarios(dist, sub, circ, tipo_dia, mes_base, ano_base, scenario_study_month, filepath)
            sc.control_scenario_dss(month)
