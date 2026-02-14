# -*- coding: utf-8 -*-
# @Author  : Ferdinando Crispino
# @Email   : ferdinando.crispino@usp.br
# @File    : AjusteDemanda.py


import pandas as pd
import numpy as np
from py_dss_interface import DSS
import os
import cmath
import time
import logging

"""
Ajusta a demanda a partir de valores de medição de correntes

"""
logging.basicConfig(filename='AjusteDemandda.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s', datefmt='%Y-%m-%d,%H:%M:%S')


class AjustaDemanda:
    def __init__(self, circuit, dss_file, excel_file):
        self.circuit = circuit
        self.dss_file = dss_file
        self.current_monitor = ''
        self.current_medidor = ''
        self.dss_current = {'A': 0, 'B': 0, 'C': 0, 'N': 0}
        self.listloadmult = [1] * 144
        self.listloadmult_2phi = [1] * 144
        self.list_error = [0] * 144
        self.dss = self.__read_dss_file()
        self.excel_file = pd.read_excel(excel_file)
        self.load_class = pd.DataFrame()

    def run_ajuste(self):
        return self.__exec_ajuste_demanda()

    def run_ajust_demanda_by_phases(self):
        return self.__ajust_demanda_by_phases()

    def __get_corrent_3p(self, Ia, ang_Ia, Ib, ang_Ib, Ic, ang_Ic, In=0, ang_In=0):

        # 1. Converter polar para complexo (x + yi)
        c1 = cmath.rect(Ia, ang_Ia)
        c2 = cmath.rect(Ib, ang_Ib)
        c3 = cmath.rect(Ic, ang_Ic)
        c4 = cmath.rect(In, ang_In)
        # 2. Somar os números complexos
        soma_complexa = c1 + c2 + c3 + c4
        # 3. Converter de volta para polar (r, theta)
        soma_polar = cmath.polar(soma_complexa)

        return soma_polar

    def __get_table_currents(self, patamar, multi=10):
        """
        Acessa os dados do arquivo excel com as correntes diarias e
        obtem os valores das correntes para um determinado patamar
        O patamar multiplcado pelo multi indica o total registros
        :param patamar:
        :param multi:
        :return:
        """

        c = {'A': 0, 'B': 0, 'C': 0}
        total_minutos = (patamar - 1) * multi
        horas, minutos = divmod(total_minutos, 60)
        # Ensure the column is datetime type
        self.excel_file['data'] = pd.to_datetime(self.excel_file['data'])
        # Filter rows
        filtered_df = self.excel_file[
            (self.excel_file['data'].dt.hour == horas) & (self.excel_file['data'].dt.minute == minutos)]
        filtered_df = filtered_df.sort_values(by='name')

        return filtered_df

    def __read_dss_file(self) -> DSS:
        """
        Leitura do arquivo 'master' sem executar o 'solve' e com os medidores desabilitados.
        :return: DSS
        """
        dss = DSS()
        dss.dssinterface.clear_all()
        dss.text(f"set Datapath = '{os.path.dirname(self.dss_file)}'")
        with open(os.path.join(self.dss_file), 'r') as file:
            for line_dss in file:
                if not (line_dss.startswith('!') or line_dss.startswith('\n') or line_dss.lower().startswith('clear')):
                    dss.text(line_dss.strip('\n'))
                if 'calc' in line_dss:
                    break
        # remove meters if present in dss files
        for name in dss.meters.names:
            dss.text(f"disable energymeter.{name}")

        dss.text("set mode = daily")
        dss.text("set tolerance = 0.0001")
        dss.text("set maxcontroliter = 100")
        dss.text("set maxiterations = 100")
        dss.text("Set stepsize = 10m")
        dss.text("set number = 1")

        first_elem = self.__first_element(dss)
        # self.dss.text(f"new monitor.{first_elem}_P element={first_elem} terminal=1 mode=1 ppolar=no")
        dss.text(f"new 'monitor.{first_elem}_i' element='{first_elem}' terminal=1 mode=0 ppolar=no")
        self.current_monitor = f'{first_elem}_i'

        dss.text(f"new 'Energymeter.{first_elem}_m' element='{first_elem}' terminal=1")
        self.current_medidor = f'{first_elem}_m'

        return dss

    def __first_element(self, dss):
        """ Retorna o primeiro bus do circuito
            Navega pela topologia da rede de um bus qualquer ate o inicio do circuito
        """
        dss.topology.first()
        dss.topology.forward_branch()
        while True:
            index_branch = dss.topology.backward_branch()
            if index_branch:  # chegou no inicio do alimentador (Vsource)
                dss.topology.forward_branch()  # avançar para obter o primeiro elemento
                # print(self._dss.topology.branch_name)
                return dss.topology.branch_name

    def transformer_load_phases(self):
        loads_class = []
        loads_class_dict = {}
        fases = {"1", "2", "3"}

        self.dss.transformers.first()
        for _ in range(self.dss.transformers.count):
            if "reg" not in self.dss.transformers.name:
                self.dss.text(f"new energymeter.{self.dss.transformers.name} "
                              f"element=transformer.{self.dss.transformers.name} terminal=1")

            self.dss.transformers.next()

        self.dss.text("solve")
        self.dss.meters.first()
        for _ in range(self.dss.meters.count):
            self.dss.circuit.set_active_element(f"transformer.{self.dss.meters.name}")
            tr_ph = self.dss.cktelement.num_phases
            tr_bus = self.dss.cktelement.bus_names
            tr_nodes = self.dss.cktelement.bus_names[0].split(".")[1:]
            tr_wdg = len(self.dss.cktelement.bus_names)
            tr_name = self.dss.cktelement.name

            loads = self.dss.meters.all_pce_in_zone
            for load in loads:
                if load.split(".")[0].lower() == "load":
                    self.dss.circuit.set_active_element(load)
                    load_ph = self.dss.cktelement.num_phases
                    load_bus = tr_bus = self.dss.cktelement.bus_names
                    nodes = self.dss.cktelement.bus_names[0].split(".")[1:]
                    tipo = len(set(nodes) & fases)

                    loads_class_dict['name'] = load
                    loads_class_dict['type'] = tipo # 1, 2 ou 3
                    loads_class_dict['phase_mt'] = str(tr_nodes)
                    loads_class_dict['phase_bt'] = str(nodes)
                    loads_class_dict['loadshape'] = self.dss.loads.daily

                    loads_class.append(loads_class_dict.copy())
            self.dss.meters.next()
            self.load_class = pd.DataFrame(loads_class)
        return self.load_class

    def list_loads_type(self):
        fases = {"1", "2", "3"}
        cnt_tri = 0
        cnt_bi = 0
        cnt_mono = 0

        self.dss.text("solve")

        self.dss.meters.first()
        for _ in range(self.dss.meters.count):
            if self.dss.meters.name == self.current_medidor.lower():
                loads = self.dss.meters.all_pce_in_zone
                for load in loads:
                    if load.split(".")[0].lower() == "load":
                        self.dss.circuit.set_active_element(load)
                        nodes = self.dss.cktelement.bus_names[0].split(".")[1:]

                        fases_presentes = set(nodes) & fases
                        if len(fases_presentes) == 3:
                            cnt_tri += 1
                            classificacao = "trifasico"
                        elif len(fases_presentes) == 2:
                            cnt_bi += 1
                            classificacao = "bifasico"
                        elif len(fases_presentes) == 1:
                            classificacao = "monofasico"
                            cnt_mono += 1
                        else:
                            classificacao = "indefinido"
        print(f'Tri:{cnt_tri} Bi:: {cnt_bi}, Mono:{cnt_mono}   ')

    def solve_load_type(self, patamar, loads, tipo):
        correntes_list = []
        correntes_dict = {}
        if tipo == 3:
            load_multi = self.listloadmult
        elif tipo == 2:
            load_multi = self.listloadmult_2phi

        self.dss = self.__read_dss_file()

        for number in range(1, patamar + 1):
            self.dss.monitors.reset_all()

            # alterar o loadShape e não o kw
            for index, row in loads.iterrows():

                # create a new loadshape for each load
                self.dss.loadshapes.first()
                for _ in range(self.dss.loadshapes.count):
                    if self.dss.loadshapes.name == row['loadshape'].lower():
                        # curva de carga encontrada.
                        break
                    self.dss.loadshapes.next()

                ori_dmult = self.dss.loadshapes.p_mult
                # print(ori_dmult)
                # Create 144 points via interpolation
                ori_dmult_scale = np.interp(np.linspace(0, 24 - 1, 144), np.arange(24), ori_dmult)

                # Multiply corresponding elements and create a new list
                multiplied_list = [a * b for a, b in zip(ori_dmult_scale, load_multi)]

                name_loadshape = f"TIPO_{tipo}_{index}"
                row['loadshape'] = name_loadshape
                if number == 1:
                    self.dss.text(f"New 'Loadshape.{name_loadshape}' npts={len(multiplied_list)} interval=1 "
                                  f"mult=({str(multiplied_list)[1:-1]})")
                else:
                    # self.dss.loadshapes.npts = 144
                    self.dss.loadshapes.p_mult = multiplied_list

                # ativa a carga e associa a curva de carga
                x = self.dss.circuit.set_active_element(row['name'])
                self.dss.loads.daily = name_loadshape


            self.dss.solution.solve()

            status = self.dss.solution.converged
            if status == 0:
                print(f'OpenDSS: File {self.dss_file} not solved to time {number}!')
                return False
            else:
                monitor = self.dss.monitors.first()
                while monitor:
                    if self.dss.monitors.name == self.current_monitor.lower():
                        self.dss_current['A'] = self.dss.monitors.channel(9)
                        self.dss_current['A_ang'] = self.dss.monitors.channel(10)
                        self.dss_current['B'] = self.dss.monitors.channel(11)
                        self.dss_current['B_ang'] = self.dss.monitors.channel(12)
                        self.dss_current['C'] = self.dss.monitors.channel(13)
                        self.dss_current['C_ang'] = self.dss.monitors.channel(14)
                        self.dss_current['N'] = self.dss.monitors.channel(15)
                        self.dss_current['N_ang'] = self.dss.monitors.channel(16)
                    monitor = self.dss.monitors.next()

                correntes_dict['A'] = self.dss_current.get('A')[0]
                correntes_dict['A_ang'] = self.dss_current.get('A_ang')[0]
                correntes_dict['B'] = self.dss_current.get('B')[0]
                correntes_dict['B_ang'] = self.dss_current.get('B_ang')[0]
                correntes_dict['C'] = self.dss_current.get('C')[0]
                correntes_dict['C_ang'] = self.dss_current.get('C_ang')[0]
                correntes_dict['N'] = self.dss_current.get('N')[0]
                correntes_dict['N_ang'] = self.dss_current.get('N_ang')[0]

            correntes_list.append(correntes_dict.copy())

            if patamar == 144:
                p_adata = pd.DataFrame.from_dict(correntes_list)
                dirname = os.path.dirname(__file__)
                plt_path = os.path.abspath(os.path.join(dirname, 'ajusteDemanda'))
                os.makedirs(plt_path, exist_ok=True)
                if not p_adata.empty:
                    p_adata.to_csv(f'{plt_path}/{self.circuit}_currents_ajust_by_phases.csv')

            print(f'A:{self.dss_current["A"]} '
                  f'B:{self.dss_current["B"]} '
                  f'C:{self.dss_current["C"]} '
                  f'N:{self.dss_current["N"]}')

        return True

    def __ajust_demanda_by_phases(self):
        total_number = 144
        tolerancia = 0.05
        maxiterations = 100
        menor_dif_percent = 1
        loadMult_menor_erro = 0
        tipo = [3, 2]
        for tp in tipo:
            for number in range(1, total_number + 1):
                print(f'number:{number}')
                # obtem os valores das correntes de referencia no arquivo excel
                corrente_medida = self.__get_table_currents(patamar=number, multi=10)
                print(corrente_medida)

                dif_percent = 0
                iterations = 1
                while True:
                    self.list_error[number - 1] = dif_percent

                    if abs(dif_percent) > tolerancia * 4:
                        passo = dif_percent * 10
                    elif tolerancia * 1.5 < abs(dif_percent) <= tolerancia * 4:
                        passo = dif_percent
                    else:
                        passo = dif_percent / 2

                    if tp == 3:
                        self.listloadmult[number - 1] = round(self.listloadmult[number - 1] + passo, 5)
                        print(f'LoadMult: {self.listloadmult[number - 1]}')

                        result = simul.solve_load_type(number, load_class.loc[load_class['type'] == 3], tipo=3)

                        if not result:
                            # Para o caso que não convergir alterar o valor do loadmult e verificar se converge
                            if dif_percent < 0:
                                self.listloadmult[number - 1] = self.listloadmult[number - 1] * 0.95
                            else:
                                self.listloadmult[number - 1] = self.listloadmult[number - 1] * 1.05

                            continue

                        # Fase de referencia para o ajsute de demanda será a corrente da fase B
                        # Todo Analisar como selecionar a fase para o ajuste
                        corrente_ref = corrente_medida.loc[corrente_medida['name'].str.endswith('IB'), 'valor'].values[0]
                        # calcula a porcentagem de aumento ou diminuição das cargas em relação ao definido no DSS.
                        dif_percent = (corrente_ref - self.dss_current.get('B')[0]) / corrente_ref

                    elif tipo == 2:
                        self.listloadmult_2phi[number - 1] = round(self.listloadmult_2phi[number - 1] + passo, 5)
                        print(f'LoadMult: {self.listloadmult_2phi[number - 1]}')

                        result = simul.solve_load_type(number, load_class.loc[
                            (load_class['type'] == 2) & (load_class['phase_mt'] == "['3', '0']")], tipo=2)

                        if not result:
                            # Para o caso que não convergir alterar o valor do loadmult e verificar se converge
                            if dif_percent < 0:
                                self.listloadmult_2phi[number - 1] = self.listloadmult_2phi[number - 1] * 0.95
                            else:
                                self.listloadmult_2phi[number - 1] = self.listloadmult_2phi[number - 1] * 1.05

                            continue

                        corrente_ref = corrente_medida.loc[corrente_medida['name'].str.endswith('IV'), 'valor'].values[
                            0]
                        # calcula a porcentagem de aumento ou diminuição das cargas em relação ao definido no DSS.
                        dif_percent = (corrente_ref - self.dss_current.get('A')[0]) / corrente_ref

                    print(f'Diferença Percentual: {dif_percent}')

                    # guardar o loadmult com o menor erro para o caso de não atingir o valor de tolerancia definido.
                    if abs(dif_percent) < abs(menor_dif_percent):
                        menor_dif_percent = dif_percent
                        loadMult_menor_erro = self.listloadmult[number - 1]

                    iterations += 1

                    if abs(dif_percent) < tolerancia:
                        break

                    if iterations > maxiterations:
                        # Se sair pq atingiu o maximo numero de interação, utilizar o menor valor obtido na simulação
                        if tp == 3:
                            self.listloadmult[number - 1] = loadMult_menor_erro
                        elif tp == 2:
                            self.listloadmult_2phi[number - 1] = loadMult_menor_erro
                        break

                    # executa o solve novamente, agora com a alteração loadmulti e verifica a tolerancia.

        return self.listloadmult, self.listloadmult_2phi

    def __solve(self, patamar):
        correntes_list = []
        correntes_dict = {}
        # recarregar o arquivo DSS e avaliar a diferença
        self.dss = self.__read_dss_file()

        # solve ate o patamar definido alterando o loadmult para cada patamar
        for number in range(1, patamar + 1):
            self.dss.monitors.reset_all()
            self.dss.solution.load_mult = self.listloadmult[number - 1]
            self.dss.solution.solve()  # a cada solve para o proximo patamar, não é necessario set number!

            print(f"Patamar:{number}, loadmult:{self.dss.solution.load_mult}")
            logging.info(
                f"Patamar:{number}, loadmult:{self.dss.solution.load_mult}, erro:{self.list_error[number - 1]}")

            status = self.dss.solution.converged
            if status == 0:
                print(f'OpenDSS: File {self.dss_file} not solved to time {number}!')
                logging.info(f'OpenDSS: File {self.dss_file} not solved! Set number: {number} - event: '
                             f'{self.dss.solution.event_log}')
                return False
            else:
                monitor = self.dss.monitors.first()
                while monitor:
                    if self.dss.monitors.name == self.current_monitor.lower():
                        self.dss_current['A'] = self.dss.monitors.channel(9)
                        self.dss_current['A_ang'] = self.dss.monitors.channel(10)
                        self.dss_current['B'] = self.dss.monitors.channel(11)
                        self.dss_current['B_ang'] = self.dss.monitors.channel(12)
                        self.dss_current['C'] = self.dss.monitors.channel(13)
                        self.dss_current['C_ang'] = self.dss.monitors.channel(14)
                        self.dss_current['N'] = self.dss.monitors.channel(15)
                        self.dss_current['N_ang'] = self.dss.monitors.channel(16)
                    monitor = self.dss.monitors.next()

                """"
                self.dss.circuit.set_active_element("Vsource.Source")
                currents = self.dss.cktelement.currents_mag_ang
                # Correntes fase A,B,C,N
                self.dss_current['A'] = currents[0]
                self.dss_current['A_ang'] = currents[1]
                self.dss_current['B'] = currents[2]
                self.dss_current['B_ang'] = currents[3]
                self.dss_current['C'] = currents[4]
                self.dss_current['C_ang'] = currents[5]
                self.dss_current['N'] = currents[6]
                self.dss_current['N_ang'] = currents[7]
                """
                correntes_dict['A'] = self.dss_current.get('A')[0]
                correntes_dict['A_ang'] = self.dss_current.get('A_ang')[0]
                correntes_dict['B'] = self.dss_current.get('B')[0]
                correntes_dict['B_ang'] = self.dss_current.get('B_ang')[0]
                correntes_dict['C'] = self.dss_current.get('C')[0]
                correntes_dict['C_ang'] = self.dss_current.get('C_ang')[0]
                correntes_dict['N'] = self.dss_current.get('N')[0]
                correntes_dict['N_ang'] = self.dss_current.get('N_ang')[0]
            correntes_list.append(correntes_dict.copy())

        if patamar == 144:
            p_adata = pd.DataFrame.from_dict(correntes_list)
            dirname = os.path.dirname(__file__)
            plt_path = os.path.abspath(os.path.join(dirname, 'ajusteDemanda'))
            os.makedirs(plt_path, exist_ok=True)
            if not p_adata.empty:
                p_adata.to_csv(f'{plt_path}/{self.circuit}_currents_original.csv')

        print(f'A:{self.dss_current["A"]} '
              f'B:{self.dss_current["B"]} '
              f'C:{self.dss_current["C"]} '
              f'N:{self.dss_current["N"]}')

        return True

    def __exec_ajuste_demanda(self):
        total_number = 144
        tolerancia = 0.05
        maxiterations = 50
        menor_dif_percent = 1
        loadMult_menor_erro = 0

        for number in range(1, total_number + 1):

            print(f'number:{number}')
            # obtem os valores das correntes de referencia no arquivo excel
            corrente_medida = self.__get_table_currents(patamar=number, multi=10)
            print(corrente_medida)
            corrente_3f = self.__get_corrent_3p(
                corrente_medida.loc[corrente_medida['name'].str.endswith('IA'), 'valor'].values[0], 0,
                corrente_medida.loc[corrente_medida['name'].str.endswith('IB'), 'valor'].values[0], 120,
                corrente_medida.loc[corrente_medida['name'].str.endswith('IV'), 'valor'].values[0], 240)

            print(f'Corrente 3p:{corrente_3f}')

            dif_percent = 0
            iterations = 1
            while True:
                self.list_error[number - 1] = dif_percent

                if abs(dif_percent) > tolerancia * 3:
                    passo = dif_percent / 2
                else:
                    passo = dif_percent / 5

                self.listloadmult[number - 1] = round(self.listloadmult[number - 1] + passo, 5)
                print(f'LoadMult: {self.listloadmult[number - 1]}')

                # executa o fluxo de potencia iniciando do patamar 1 'hora 00:00' até o paramar 'number'
                result = self.__solve(number)

                if not result:
                    # Para o caso que não convergir alterar o valor do loadmult e verificar se converge
                    if dif_percent < 0:
                        self.listloadmult[number - 1] = self.listloadmult[number - 1] * 0.95
                    else:
                        self.listloadmult[number - 1] = self.listloadmult[number - 1] * 1.05

                    continue

                # Fase de referencia para o ajsute de demanda será a corrente da fase B
                # Todo Analisar como selecionar a fase para o ajuste
                corrente_ref = corrente_medida.loc[corrente_medida['name'].str.endswith('IB'), 'valor'].values[0]
                # calcula a porcentagem de aumento ou diminuição das cargas em relação ao definido no DSS.
                dif_percent = (corrente_ref - self.dss_current.get('B')[0]) / corrente_ref
                """
                # fase de referencia será o valor da corrente trifasico
                corrente_ref = corrente_3f
                # calcula a porcentagem de aumento ou diminuição das cargas em relação ao definido no DSS.

                # teste referencia a soma vetorial das correntes
                corrente_dss_3f = self.__get_corrent_3p(self.dss_current.get('A')[0], self.dss_current.get('A_ang')[0],
                                                        self.dss_current.get('B')[0], self.dss_current.get('B_ang')[0],
                                                        self.dss_current.get('C')[0], self.dss_current.get('C_ang')[0])

                # teste referencia a soma escalar das correntes
                corrente_dss_3f = self.__get_corrent_3p(self.dss_current.get('A')[0], 0,
                                                        self.dss_current.get('B')[0], 0,
                                                        self.dss_current.get('C')[0], 0)

                # teste referencia a soma das correntes mais o neutro
                corrente_dss_3f = self.__get_corrent_3p(self.dss_current.get('A')[0], 0,
                                                        self.dss_current.get('B')[0], 0,
                                                        self.dss_current.get('C')[0], 0,
                                                        self.dss_current.get('N')[0], 0)

                print(f'Corrente dss 3p:{corrente_dss_3f}')

                dif_percent = (corrente_ref[0] - corrente_dss_3f[0]) / corrente_ref[0]                
                """
                print(f'Diferença Percentual: {dif_percent}')

                # guardar o loadmult com o menor erro para o caso de não atingir o valor de tolerancia definido.
                if abs(dif_percent) < abs(menor_dif_percent):
                    menor_dif_percent = dif_percent
                    loadMult_menor_erro = self.listloadmult[number - 1]

                iterations += 1

                if abs(dif_percent) < tolerancia:
                    break

                if iterations > maxiterations:
                    # Se sair pq atingiu o maximo numero de interação, utilizar o menor valor obtido na simulação
                    self.listloadmult[number - 1] = loadMult_menor_erro
                    break

                # executa o solve novamente, agora com a alteração loadmulti e verifica a tolerancia.

        return self.listloadmult

    def update_loadshape(self, load_multi):
        self.dss.loadshapes.first()
        for _ in range(self.dss.loadshapes.count):
            ori_dmult = self.dss.loadshapes.p_mult
            print(ori_dmult)
            # Create 144 points via interpolation
            ori_dmult_scale = np.interp(np.linspace(0, 24 - 1, 144), np.arange(24), ori_dmult)
            print(len(ori_dmult_scale))  # Output: 144

            # Multiply corresponding elements and create a new list
            multiplied_list = [a * b for a, b in zip(ori_dmult_scale, load_multi)]

            self.dss.loadshapes.npts = 144
            self.dss.loadshapes.p_mult = multiplied_list

            self.dss.loadshapes.next()

        self.dss.solution.solve()
        status = self.dss.solution.converged
        if status == 0:
            print(f'OpenDSS: File {self.dss_file} with update_loadshape not solved!')
        else:
            path_dir = r"C:\pastaD\TSEA\dss\2024\Ajuste_demanda"
            self.dss.text(f"Save Circuit dir={path_dir}")

    def check_result(self):
        """
        Apresenta o rsultado do loadFlow aplicando so valores resultantes do ajsute de demanda
        :return:
        """
        result_loadMult = [2.35556, 2.36302, 2.36302, 2.64637, 2.64637, 2.64637, 2.48368, 2.50969, 2.32647, 2.32647,
                           2.32647, 2.32647, 2.32647, 2.16383, 2.16374, 2.17888, 2.17888, 2.17888, 2.17888, 2.17888,
                           2.24526, 2.24535, 2.24535, 2.24535, 2.24535, 2.40031, 2.24444, 1.57681, 1.66752, 1.66752,
                           1.66752, 1.78771, 1.78533, 1.78944, 1.58273, 1.75479, 1.75479, 1.75479, 1.88001, 1.77711,
                           1.66423, 1.77953, 1.66443, 1.56322, 1.1783, 1.28999, 1.19484, 1.10872, 1.10859, 1.14667,
                           1.16973, 1.08782, 1.10493, 1.027, 1.0, 1.0, 1.0, 1.0, 0.95769, 0.95851, 1.0, 0.96781, 1.0,
                           1.02703, 1.0, 0.96104, 0.92884, 1.0, 1.0, 1.05436, 1.06342, 1.0, 1.0, 1.0, 1.0624, 1.18195,
                           1.26908, 1.32051, 1.28072, 1.43289, 1.44477, 1.45675, 1.40978, 1.45851, 1.56687, 1.52567,
                           1.52567, 1.40538, 1.42418, 1.43866, 1.43764, 1.73881, 1.80675, 1.85842, 1.80416, 1.96,
                           1.90141, 1.79071, 1.84135, 1.91391, 1.80007, 1.83495, 1.75988, 1.83571, 2.12185, 2.1218,
                           2.18488, 2.24433, 2.03286, 2.1775, 2.1699, 2.35308, 2.6248, 2.63013, 2.69134, 2.60789,
                           2.61374, 2.6139, 2.542, 2.45918, 2.02509, 2.0288, 1.88041, 2.05506, 1.98977, 1.98575,
                           1.97906, 1.89432, 2.43128, 2.3999, 2.32277, 2.22101, 2.22068, 2.13639, 2.03515, 2.44037,
                           2.32913, 2.21541, 2.21483, 2.11088, 2.36005, 2.36005, 2.2366, 2.23655]
        # self.listloadmult = result_loadMult
        self.__solve(144)


if __name__ == '__main__':
    excel_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\AVP1303 - Correntes.xlsx'
    dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RAVP1303\DU_7_Master_391_AVP_RAVP1303.dss'
    circuito = 'RAVP1303'
    proc_time_ini = time.time()

    simul = AjustaDemanda(circuit=circuito, dss_file=dss_file, excel_file=excel_file)
    # simul.list_loads_type()

    result_loadMult = [2.35556, 2.36302, 2.36302, 2.64637, 2.64637, 2.64637, 2.48368, 2.50969, 2.32647, 2.32647,
                       2.32647, 2.32647, 2.32647, 2.16383, 2.16374, 2.17888, 2.17888, 2.17888, 2.17888, 2.17888,
                       2.24526, 2.24535, 2.24535, 2.24535, 2.24535, 2.40031, 2.24444, 1.57681, 1.66752, 1.66752,
                       1.66752, 1.78771, 1.78533, 1.78944, 1.58273, 1.75479, 1.75479, 1.75479, 1.88001, 1.77711,
                       1.66423, 1.77953, 1.66443, 1.56322, 1.1783, 1.28999, 1.19484, 1.10872, 1.10859, 1.14667,
                       1.16973, 1.08782, 1.10493, 1.027, 1.0, 1.0, 1.0, 1.0, 0.95769, 0.95851, 1.0, 0.96781, 1.0,
                       1.02703, 1.0, 0.96104, 0.92884, 1.0, 1.0, 1.05436, 1.06342, 1.0, 1.0, 1.0, 1.0624, 1.18195,
                       1.26908, 1.32051, 1.28072, 1.43289, 1.44477, 1.45675, 1.40978, 1.45851, 1.56687, 1.52567,
                       1.52567, 1.40538, 1.42418, 1.43866, 1.43764, 1.73881, 1.80675, 1.85842, 1.80416, 1.96,
                       1.90141, 1.79071, 1.84135, 1.91391, 1.80007, 1.83495, 1.75988, 1.83571, 2.12185, 2.1218,
                       2.18488, 2.24433, 2.03286, 2.1775, 2.1699, 2.35308, 2.6248, 2.63013, 2.69134, 2.60789,
                       2.61374, 2.6139, 2.542, 2.45918, 2.02509, 2.0288, 1.88041, 2.05506, 1.98977, 1.98575,
                       1.97906, 1.89432, 2.43128, 2.3999, 2.32277, 2.22101, 2.22068, 2.13639, 2.03515, 2.44037,
                       2.32913, 2.21541, 2.21483, 2.11088, 2.36005, 2.36005, 2.2366, 2.23655]

    #simul.update_loadshape(load_multi=result_loadMult)

    load_class = simul.transformer_load_phases()

    simul.run_ajust_demanda_by_phases()


    simul.run_ajuste()

    print(simul.listloadmult)
    print(simul.list_error)

    # simul.check_result()

    total_segundos = round(time.time() - proc_time_ini, 4)
    horas = total_segundos // 3600
    minutos = (total_segundos % 3600) // 60
    segundos = round(total_segundos % 60, 2)
    print(f"Process time: {horas}h {minutos}m {segundos}s")
