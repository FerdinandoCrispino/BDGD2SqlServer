import py_dss_interface
import os
import matplotlib.pyplot as plt
import matplotlib
import numpy as np
import pandas as pd
import glob
import calendar
import math
import json
import logging
import time
from Tools.tools import circuit_by_bus, load_config, create_connection
from core.electric_data import get_substations_list
from multiprocessing import Pool, cpu_count

matplotlib.use('TKAgg')
# Configuração do logger
logging.basicConfig(filename='base_case.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s', datefmt='%Y-%m-%d,%H:%M:%S')

# False para rodar o master com todos os circuitos e os transformadores de alta ou
# True para rodar um circuito de cada vez
exec_by_circuit = True
# set run multiprocess
run_multiprocess = False

database = "40_2022"
master_type_day = "DU"
master_month = "12"

config = load_config(database)
dist = config['dist']
master_data_base = config['data_base'].split('-')[0]
engine = create_connection(config)

master_folder = os.path.expanduser(config['dss_files_folder'])
# Lista com os códigos das subestações
list_sub = get_substations_list(engine)


def substations_losses(dist, tipo_dia, ano, mes, by_circ=None):
    """
    Reune as informações das simulações já realizadas para apresentar um resumo das perdas de energia das subestações.
    :param dist: Código da distribuidora.
    :param tipo_dia: Tipo de dia utilizado no cálculo do fluxo de potência.
    :param ano: Ano utilizado no cálculo do fluxo de potência.
    :param mes: Mês do ano utilizado no cálculo do fluxo de potência.
    :param by_circ:
    :return:
    """
    subs_losses = pd.DataFrame()
    file_result = f'{tipo_dia}_{ano}_{mes}_losses.xlsx'

    for root, dirs, files in os.walk(os.path.join(os.path.dirname(__file__), '../ui/static/scenarios/base', str(dist))):
        for file in files:
            if file.endswith(file_result) and 'SUB' not in file.upper():
                print(file)
                print(root)
                try:
                    df = pd.read_excel(os.path.join(root, file))
                    print(df)
                    df_filter = df[['SUB', 'circuit', 'losses']].copy()
                    subs_losses = pd.concat([subs_losses, df_filter])

                except FileNotFoundError:
                    print(f'Error with fife {root}/{file}')

    if subs_losses.empty:
        print(f'Arquivo {file_result} não encontado!')
        return

    subs_losses.reset_index(drop=True, inplace=True)
    print(subs_losses)

    plt_path = os.path.join(os.path.dirname(__file__), '../ui/static/scenarios/base', str(dist))
    subs_losses.to_excel(f"{plt_path}/{ano}_{tipo_dia}_{mes}_sub_losses.xlsx")

    x = np.arange(len(subs_losses['circuit']))
    multiplier = 0

    fig, ax = plt.subplots(figsize=(20, 6), layout='constrained')

    for attribute, mesasurements in subs_losses.items():
        if attribute in ('SUB', 'circuit'):
            continue
        offset = 0.25 * multiplier
        rects = ax.bar(x + offset, mesasurements, 0.25, label=attribute)
        # ax.bar_label(rects, padding=3)
        multiplier += 1

    ax.set_ylabel('Power Loss (kWh)')
    ax.set_title(f"{config['database'][16:]} Power transformer Losses - {tipo_dia} {ano} {mes}")

    ax.set_xticks(x + 0.1, subs_losses['SUB'])
    ax.tick_params(axis='x', labelsize=8, labelrotation=90)
    ax.legend(loc='upper left', ncols=3)

    plt.grid(axis='y')
    plt.savefig(f'{plt_path}/{tipo_dia}_{mes}_sub_losses_analysis.png', dpi=fig.dpi)
    plt.close()


def substations_transformer_loading(dist, tipo_dia, ano, mes):
    """
    Reune as informações das simulações já realizadas para apresentar um resumo do carregamento das subestações para um
    determinado tipo de dia, ano e mes.
    Cria um Dataframe com os resultados das potências máximas e mínimas de cada subestação.
    Exporta o dataframe num arquivo e gera um grafico de barras

    :param dist: Código da distribuidora.
    :param tipo_dia: Tipo de dia utilizado no cálculo do fluxo de potência.
    :param ano: Ano utilizado no cálculo do fluxo de potência.
    :param mes: Mês do ano utilizado no cálculo do fluxo de potência.
    :return:
    """
    subs_power = pd.DataFrame()
    for root, dirs, files in os.walk(os.path.join(os.path.dirname(__file__), '../ui/static/scenarios/base')):
        for file in files:
            if file.endswith(f'{dist}_{tipo_dia}_{ano}_{mes}_power.csv'):
                print(file)
                print(root)

                try:
                    df = pd.read_csv(os.path.join(root, file))
                    print(df)
                    df_filter = df[['sub', 'nome', 'P_max', 'P_min', 'P_time_max', 'P_time_min']].copy()
                    subs_power = pd.concat([subs_power, df_filter])

                except FileNotFoundError:
                    print(f'Error with fife {root}/{file}')

    subs_power.reset_index(drop=True, inplace=True)
    print(subs_power)

    plt_path = os.path.join(os.path.dirname(__file__), '../ui/static/scenarios/base', str(dist))
    subs_power.to_excel(f"{plt_path}/{ano}_{tipo_dia}_{mes}_sub_analysis.xlsx")

    if subs_power.empty:
        return
    # plot ---------------------------------------
    x = np.arange(len(subs_power['nome']))
    multiplier = 0

    fig, ax = plt.subplots(figsize=(20, 6), layout='constrained')

    for attribute, mesasurements in subs_power.items():
        if attribute in ('sub', 'nome', 'P_time_max', 'P_time_min'):
            continue
        offset = 0.25 * multiplier
        rects = ax.bar(x + offset, mesasurements, 0.25, label=attribute)
        # ax.bar_label(rects, padding=3)
        multiplier += 1

    ax.set_ylabel('Apparent Power (p.u)')
    ax.set_title(f"{config['database'][16:]} Power Transformer Loading - {tipo_dia} {ano} {mes}")
    ax.set_xticks(x + 0.25, subs_power['sub'])
    ax.tick_params(axis='x', labelsize=8, labelrotation=90)
    ax.legend(loc='upper left', ncols=3)

    plt.grid(axis='y')
    # plt.bar(subs_power['nome'], subs_power['P_max'], width=0.5, color='orange')
    plt.savefig(f'{plt_path}/{tipo_dia}_{mes}_sub_analysis.png', dpi=fig.dpi)
    plt.close()


def run_multi(subs):
    """
    Função para execução do fluxo de potência para as subestações de uma distribuidora.
    :param subs: Lista de subestações.
    :return:
    """
    list_sub = subs

    for nome_sub in list_sub:
        proc_time_ini = time.time()
        sub = nome_sub
        master_file = f"{master_type_day}_{master_month}_Master_substation_{dist}_{sub}.dss"

        config_opendss = {"master_folder": master_folder,
                          "master_dist": os.path.join(dist, sub),
                          "master_file": master_file,
                          "master_type_day": master_type_day,
                          "master_month": master_month,
                          "master_data_base": master_data_base,
                          "master_sub": sub}

        folder = os.path.join(config_opendss['master_folder'], config_opendss['master_dist'])
        master_file = glob.glob(folder + "/*.dss")
        # sub_folders = [name for name in os.listdir(folder) if os.path.isdir(os.path.join(folder, name))]
        # print(sub_folders)
        if not master_file:
            print(f'Arquivo DSS não encontrado em {folder}.')
            continue

        simul = SimuladorOpendss(config_opendss)

        if exec_by_circuit:
            for file_dss in (glob.glob(folder + f"/*/{master_type_day}_{master_month}*.dss")):
                if "Master" in file_dss:
                    simul.list_file_dss.append(file_dss)
                    simul.dss_file = file_dss
                    simul.executa_fluxo_potencia()
                    simul.plot_data_monitors()
        else:
            simul.executa_fluxo_potencia()
            simul.plot_data_monitors()

        print(f'Substation: {sub} process in {time.time() - proc_time_ini}.', flush=True)


class SimuladorOpendss:
    def __init__(self, config_opendss: dict, by_substation=None):
        self.dss = py_dss_interface.DSS()
        self.by_substation = by_substation
        self.list_file_dss = []
        self.dss_file = os.path.join(config_opendss['master_folder'], config_opendss['master_dist'],
                                     config_opendss['master_file'])
        self.mes = config_opendss['master_month']
        self.mes_abr = calendar.month_abbr[int(self.mes)]
        self.tipo_dia = config_opendss['master_type_day']
        self.database = config_opendss['master_data_base']
        self.dist = config_opendss['master_dist'].replace('\\', '/').split('/')[0]
        self.sub = config_opendss['master_sub']
        # print(self.dss_file)

    def _save_json(self, json_type, dados):
        """
        Função para salvar os dados num arquivo json.
        :param json_type:
        :param dados: Dados a serem salvos.
        :return:
        """
        dirname = os.path.dirname(__file__)
        json_path = os.path.abspath(os.path.join(dirname, "../ui/static/scenarios/base", self.dist, self.sub,
                                                 self.dss.circuit.name.upper(), self.tipo_dia, self.database, self.mes))
        os.makedirs(json_path, exist_ok=True)

        # with open(f"{json_path}\\{self.dss.circuit.name.upper()}_{self.database}_{self.tipo_dia}_{self.mes}_"
        with open(f"{json_path}/{self.dss.circuit.name.upper()}.json".replace("\\", "/"), "w") as file_json:
            json.dump(dados, file_json, indent=2)

    def _calc_kva(self, channel):
        if channel == 1:
            return [round(math.sqrt((p1 ** 2) + (q1 ** 2)), 4) for p1, q1 in
                    zip(self.dss.monitors.channel(1), self.dss.monitors.channel(2))]
        if channel == 2:
            return [round(math.sqrt((p1 ** 2) + (q1 ** 2)), 4) for p1, q1 in
                    zip(self.dss.monitors.channel(3), self.dss.monitors.channel(4))]
        if channel == 3:
            return [round(math.sqrt((p1 ** 2) + (q1 ** 2)), 4) for p1, q1 in
                    zip(self.dss.monitors.channel(4), self.dss.monitors.channel(5))]

    def plot_data_monitors(self) -> None:

        self.dss.dssinterface.clear_all()
        self.dss.text(f"compile [{self.dss_file}]")

        plt_path = os.path.join("C:\\_BDGD2SQL\\BDGD2SqlServer\\ui\\static\\scenarios\\base\\",
                                self.dist, self.sub, self.dss.circuit.name.upper(),
                                self.tipo_dia, self.database, self.mes).replace('\\', '/')
        os.makedirs(plt_path, exist_ok=True)

        if self.dss.solution.converged == 0:
            print(f'OpenDSS: File {self.dss_file} not solved!!!!')
            return

        # TODO: Organizar o código e separar métodos
        # Perdas totais
        total_losses_df = pd.DataFrame()
        meter = self.dss.meters.first()
        while meter:
            # self.dss.meters.sample() if snap mode

            meter_reg_index = [i for i, x in enumerate(self.dss.meters.register_names) if x == 'Zone Losses kWh'][0]
            total_losses = self.dss.meters.register_values[meter_reg_index]
            load_losses = self.dss.meters.register_values[16]  # Load Losses kWh
            noload_losses = self.dss.meters.register_values[18]  # No Load Losses kWh
            line_losses = self.dss.meters.register_values[22]  # Line Losses
            trafo_losses = self.dss.meters.register_values[23]  # Transformer Losses
            print(f'load_losses:{load_losses}  line_losses:{line_losses}  noload_losses:{noload_losses} trafo_losses:{trafo_losses}')
            print(f'Total: {total_losses}')
            print(f'{line_losses + trafo_losses}')

            total_losses_dict = {'SUB': self.sub, 'circuit': self.dss.circuit.name.upper(),
                                 'meter': self.dss.meters.name, 'losses': total_losses}

            # Descartar valores próximo de zero - Meter conectado a elemento sem carga. ver arquivo monitors.dss
            if total_losses > 1:
                total_losses_df = pd.concat([total_losses_df, pd.DataFrame([total_losses_dict])],
                                            ignore_index=True, sort=False)
            meter = self.dss.meters.next()
            # print(f'OpenDSS:  {self.dist} - {self.sub} - {self.tipo_dia} - {self.mes} - {self.dss.meters.name} - {total_losses}')

        monitor_mode = {0: "Voltages", 1: "Powers ", 2: "Tap Position"}
        nun_monit = 1
        p_data_list = []
        p_data_dict = dict()
        all_power = pd.DataFrame()

        monitor = self.dss.monitors.first()
        while monitor:
            xpoints = np.array([])
            """
            print(f"Monitor: {self.dss.monitors.name} - "
                  f"Element: {self.dss.monitors.element} - "
                  f"header: {self.dss.monitors.header} - "
                  f"num_channels: {self.dss.monitors.num_channels}")
            print(f"Monitor:{self.dss.monitors.channel(1)} ")
            print(f"Monitor:{self.dss.monitors.channel(3)} ")
            print(f"Monitor:{self.dss.monitors.channel(5)} ")
            print(f"Sample_count:{self.dss.monitors.sample_count} ")
            """

            # Get power from monitored transformer when DSS run for all substation circuits
            tr_kva = ''
            if self.dss.monitors.mode == 1:
                for tr_name in self.dss.transformers.names:
                    if 'transformer.' + tr_name == self.dss.monitors.element:
                        self.dss.transformers.name = tr_name
                        tr_kva = f' {self.dss.transformers.kva} kVA'

                        p_data_dict.clear()
                        p1_kva = self._calc_kva(1)
                        p2_kva = self._calc_kva(2)
                        p3_kva = self._calc_kva(3)

                        # potencia trifásico
                        p_kva = [p1 + p2 + p3 for p1, p2, p3 in zip(p1_kva, p2_kva, p3_kva)]

                        max_p1 = max(p1_kva)
                        max_p2 = max(p2_kva)
                        max_p3 = max(p3_kva)
                        max_p = max(p_kva)

                        min_p1 = min(p1_kva)
                        min_p2 = min(p2_kva)
                        min_p3 = min(p3_kva)
                        min_p = min(p_kva)

                        # max_index1 = pd.Series(self.dss.monitors.channel(1)).idxmax()
                        # max_index2 = self.dss.monitors.channel(1).index(max_p1)
                        # min_index2 = self.dss.monitors.channel(1).index(min_p1)
                        p_data_dict[f"sub"] = self.sub
                        p_data_dict[f"nome"] = self.dss.monitors.name

                        p_data_dict[f"P1_max"] = max_p1 / self.dss.transformers.kva
                        p_data_dict[f"P2_max"] = max_p2 / self.dss.transformers.kva
                        p_data_dict[f"P3_max"] = max_p3 / self.dss.transformers.kva
                        p_data_dict[f"P_max"] = max_p / self.dss.transformers.kva

                        p_data_dict[f"P1_time_max"] = p1_kva.index(max_p1)
                        p_data_dict[f"P2_time_max"] = p2_kva.index(max_p2)
                        p_data_dict[f"P3_time_max"] = p3_kva.index(max_p3)
                        p_data_dict[f"P_time_max"] = p_kva.index(max_p)

                        p_data_dict[f"P1_min"] = min_p1 / self.dss.transformers.kva
                        p_data_dict[f"P2_min"] = min_p2 / self.dss.transformers.kva
                        p_data_dict[f"P3_min"] = min_p3 / self.dss.transformers.kva
                        p_data_dict[f"P_min"] = min_p / self.dss.transformers.kva

                        p_data_dict[f"P1_time_min"] = p1_kva.index(min_p1)
                        p_data_dict[f"P2_time_min"] = p2_kva.index(min_p2)
                        p_data_dict[f"P3_time_min"] = p3_kva.index(min_p3)
                        p_data_dict[f"P_time_min"] = p_kva.index(min_p)

                        p_data_list.append(p_data_dict.copy())

                        break

            xpoints = np.append(xpoints, np.arange(self.dss.monitors.sample_count))
            ypoints1 = self.dss.monitors.channel(1)
            ypoints3 = self.dss.monitors.channel(3)
            ypoints5 = self.dss.monitors.channel(5)
            ypoints_ang2 = self.dss.monitors.channel(2)
            ypoints_ang4 = self.dss.monitors.channel(4)
            ypoints_ang6 = self.dss.monitors.channel(6)

            # plt.scatter(xpoints, ypoints)
            plt.figure(figsize=(15, 6))
            plt.subplot(1, 2, 1)
            plt.plot(xpoints, ypoints1, label=self.dss.monitors.header[0])
            plt.plot(xpoints, ypoints3, label=self.dss.monitors.header[2])
            plt.plot(xpoints, ypoints5, label=self.dss.monitors.header[4])
            plt.title(f'{self.dss.circuit.name.upper()} {self.tipo_dia} {self.mes_abr}/{self.database} \n'
                      f'{self.dss.monitors.element} {tr_kva}')
            # plt.title(f'{self.dss.circuit.name.upper()} {self.tipo_dia} {self.database} {self.mes}')

            plt.ylabel(monitor_mode[self.dss.monitors.mode])
            plt.xlabel("Hours")
            plt.grid(color='green', linestyle='--', linewidth=0.5)
            plt.legend()

            plt.subplot(1, 2, 2)
            plt.plot(xpoints, ypoints_ang2, label=self.dss.monitors.header[1])
            plt.plot(xpoints, ypoints_ang4, label=self.dss.monitors.header[3])
            plt.plot(xpoints, ypoints_ang6, label=self.dss.monitors.header[5])
            plt.title(f'{self.dss.circuit.name.upper()} {self.tipo_dia} {self.mes_abr}/{self.database}  \n'
                      f'{self.dss.monitors.element} {tr_kva}')
            plt.ylabel(monitor_mode[self.dss.monitors.mode])
            plt.xlabel("Hours")
            plt.grid(color='green', linestyle='--', linewidth=0.5)
            plt.legend()

            # plt.suptitle("Demanda máxima e Limite corrente")

            plt.savefig(f'{plt_path}/{self.dss.circuit.name.upper()}_Balance_M{nun_monit}.png')

            all_power_dict = {'SUB': self.sub, 'circuit': self.dss.circuit.name.upper(),
                              'monitor': self.dss.monitors.element,
                              'P1': ypoints1, 'P2': ypoints3, 'P3': ypoints5,
                              'Q1': ypoints_ang2, 'Q2': ypoints_ang4, 'Q3': ypoints_ang6}

            # descarta se os valores estão próximos de zero
            if sum(ypoints1) > 1:
                all_power = pd.concat([all_power, pd.DataFrame.from_dict(all_power_dict)], ignore_index=True,
                                      sort=False)

            # mng = plt.get_current_fig_manager()
            # mng.window.state("zoomed")
            # mng.frame.Maximize(True)
            # mng.full_screen_toggle()
            # O comando show aguarda o usuário fechar o grafico para continuar
            # plt.show()
            plt.close()

            monitor = self.dss.monitors.next()
            nun_monit += 1

        p_adata = pd.DataFrame.from_dict(p_data_list)
        if not p_adata.empty:
            p_adata.to_csv(f'{plt_path}/{self.dist}_{self.tipo_dia}_{self.database}_{self.mes}_power.csv')
        if not all_power.empty:
            all_power.to_excel(f'{plt_path}/{self.dist}_{self.dss.circuit.name.upper()}_{self.tipo_dia}_'
                               f'{self.database}_{self.mes}_all_power.xlsx')
        if not total_losses_df.empty:
            total_losses_df.to_excel(f'{plt_path}/{self.dist}_{self.dss.circuit.name.upper()}_{self.tipo_dia}_'
                                     f'{self.database}_{self.mes}_losses.xlsx')

    def executa_fluxo_potencia(self) -> None:
        """
        Função para solicitar execução do fluxo de potência no OpenDSS.
        :return: None
        """
        erros = []
        # self.dss.text("clear")
        self.dss.dssinterface.allow_forms = False
        self.dss.dssinterface.clear_all()
        # self.dss.text(f"set datapath = '{os.path.join(config_opendss['master_folder'], config_opendss['master_dist'])}'")
        self.dss.text(f"set Datapath = '{os.path.dirname(self.dss_file)}'")
        print(self.dss_file)
        with open(os.path.join(self.dss_file), 'r') as file:
            for dss_line in file:
                if not (dss_line.startswith('!') or dss_line.startswith('clear') or dss_line.startswith('\n')):
                    self.dss.text(dss_line.strip('\n'))
                if 'calcv' in dss_line:
                    break

        self.dss.text("set mode = daily")
        self.dss.text("set tolerance = 0.0001")
        self.dss.text("set maxcontroliter = 100")
        self.dss.text("set maxiterations = 100")
        self.dss.text("Set stepsize = 1h")
        self.dss.text("set number = 1")
        # self.dss.text("solve")

        # for meter_name in self.dss.meters.names:
        #    self.dss.meters.name = meter_name
        #    self.dss.meters.sample()

        # print(min(self.dss.circuit.buses_vmag_pu))

        total_number = 24
        voltage_bus_dict = dict()
        voltage_bus_dict_1phase = dict()
        vuf_bus_dict = dict()
        voltage_bus_list = []
        voltage_vln_bus_dict = dict()
        voltage_vln_bus_list = []
        voltage_bus_violation_list = []
        vuf_bus_list = []
        vuf_bus_violation_list = []

        for number in range(1, total_number + 1):
            #self.dss.text(f"set number={number}")
            self.dss.monitors.reset_all()
            self.dss.solution.solve()
            # self.dss.meters.sample()
            # self.dss.monitors.save_all()
            # print(f"Sample_count:{self.dss.monitors.sample_count} ")

            status = self.dss.solution.converged
            if status == 0:
                print(f'OpenDSS: File {self.dss_file} not solved to time {number}!')
                print(f"{self.dss.solution.event_log}\n")
                logging.info(
                    f'OpenDSS: File {self.dss_file} not solved! Set number: {number} - event: {self.dss.solution.event_log}')
                # Add null dict. indicates the time at which the program did not converge
                voltage_bus_list.append(dict.fromkeys(voltage_bus_dict.copy(), None))
                continue

            active_bus = ''
            voltage_bus_dict.clear()
            for bus_name in self.dss.circuit.nodes_names:
                if bus_name.split('.')[0] in (
                        active_bus, 'busa'):  # bus fictício para o OLTC do início do circuito, Não será avaliado
                    continue
                active_bus = bus_name.split('.')[0]
                id = self.dss.circuit.set_active_bus(active_bus)
                # print(id)
                # print(bus_name)
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
                # Não existe valores de tensão de linha para barras monofásicas
                if num_nodes > 1:
                    for i in range(num_nodes):
                        # print(active_bus)
                        # tensões de linha
                        vll_pu.append(
                            round(math.sqrt(self.dss.bus.pu_vll[i * 2] ** 2 + self.dss.bus.pu_vll[(i * 2) + 1] ** 2),
                                  8))
                        vll.append(
                            round(math.sqrt(self.dss.bus.vll[i * 2] ** 2 + self.dss.bus.vll[(i * 2) + 1] ** 2), 5))
                        voltage_bus_dict[f"{bus_name.split('.')[0]}.{i + 1}"] = vll_pu[i]

                        # tensões de fase
                        vln_pu.append(
                            round(math.sqrt(
                                self.dss.bus.pu_voltages[i * 2] ** 2 + self.dss.bus.pu_voltages[(i * 2) + 1] ** 2), 5))
                        voltage_bus_dict[f"{bus_name.split('.')[0]}.{i + 1}"] = vln_pu[i]

                    if num_nodes == 3 and vll[0] != 0:
                        beta = (vll[0] ** 4 + vll[1] ** 4 + vll[2] ** 4) / (
                                vll[0] ** 2 + vll[1] ** 2 + vll[2] ** 2) ** 2
                        vuf = round(math.sqrt((abs(1 - math.sqrt(3 - 6 * beta))) / (1 + math.sqrt(3 - 6 * beta))) * 100,
                                    5)
                        vuf_bus_dict[f"{bus_name.split('.')[0]}"] = vuf

                elif num_nodes == 1:
                    voltage_bus_dict_1phase[bus_name] = \
                        round(math.sqrt(self.dss.bus.pu_voltages[0] ** 2 + self.dss.bus.pu_voltages[1] ** 2), 8)
                    # voltage_bus_dict_1phase[bus_name] = \
                    #    round(math.sqrt(self.dss.bus.voltages[0] ** 2 + self.dss.bus.voltages[1] ** 2) /
                    #          self.dss.bus.kv_base, 8 )

                """
                vab_pu = round(math.sqrt(self.dss.bus.pu_vll[0] ** 2 + self.dss.bus.pu_vll[1] ** 2), 6)
                vbc_pu = round(math.sqrt(self.dss.bus.pu_vll[2] ** 2 + self.dss.bus.pu_vll[3] ** 2), 6)
                vca_pu = round(math.sqrt(self.dss.bus.pu_vll[4] ** 2 + self.dss.bus.pu_vll[5] ** 2), 6)

                vab = round(math.sqrt(self.dss.bus.vll[0] ** 2 + self.dss.bus.vll[1] ** 2), 4)
                vbc = round(math.sqrt(self.dss.bus.vll[2] ** 2 + self.dss.bus.vll[3] ** 2), 4)
                vca = round(math.sqrt(self.dss.bus.vll[4] ** 2 + self.dss.bus.vll[5] ** 2), 4)

                beta = (vab ** 4 + vbc ** 4 + vca ** 4) / (vab ** 2 + vbc ** 2 + vca ** 2) ** 2
                vuf = round(math.sqrt((abs(1 - math.sqrt(3 - 6 * beta))) / (1 + math.sqrt(3 - 6 * beta))) * 100, 5)

                voltage_bus_dict[f"{bus_name.split('.')[0]}.1"] = vab_pu
                voltage_bus_dict[f"{bus_name.split('.')[0]}.2"] = vbc_pu
                voltage_bus_dict[f"{bus_name.split('.')[0]}.3"] = vca_pu

                vuf_bus_dict[f"{bus_name.split('.')[0]}"] = vuf
                """

            max_vol = max(voltage_bus_dict.items(), key=lambda x: x[1])
            min_vol = min(voltage_bus_dict.items(), key=lambda x: x[1])

            # os valores de max e min poidem apresentar diferença nos caso onde existem valores iguais
            # max_vol = max(voltage_bus_dict.values())
            # min_vol = min(voltage_bus_dict.values())

            # print(len(voltage_bus_dict.values()))
            print(f'Tensão máxima na hora {number}: {max_vol}')
            print(f'Tensão mínima na hora {number}: {min_vol}')

            # desequilíbrio na barra com menor tensão
            self.dss.circuit.set_active_bus(min_vol[0].split('.')[0])

            cir_nome = circuit_by_bus(min_vol[0].split('.')[0], self.dist)
            print(f"Circuito: {cir_nome['CTMT'][0]}")

            Vab = round(math.sqrt(self.dss.bus.vll[0] ** 2 + self.dss.bus.vll[1] ** 2), 4)
            Vbc = round(math.sqrt(self.dss.bus.vll[2] ** 2 + self.dss.bus.vll[3] ** 2), 4)
            Vca = round(math.sqrt(self.dss.bus.vll[4] ** 2 + self.dss.bus.vll[5] ** 2), 4)

            print(f' VAB: {Vab} V')
            print(f' VBC: {Vbc} V')
            print(f' VCA: {Vca} V')

            # Desequilíbrio de tensão:
            # IEEE
            # vuf% = 3(Vmax-Vmin)/(VA+Vb+Vc)
            # Cigre / Prodist - limite 2%
            # Vuf = sqrt(1-sqrt(3-6*Beta)/(1+sqrt(3-6*Beta))) beta=(Vab**4+Vbc**4+Vca**4)/(Vab**2+Vbc**2+Vca**2)**2
            # IEC
            # FD% = (V2/V1)*100  (sequencia positiva por sequencia negativa)
            if Vab != 0 and Vbc != 0 and Vca != 0:
                beta = (Vab ** 4 + Vbc ** 4 + Vca ** 4) / (Vab ** 2 + Vbc ** 2 + Vca ** 2) ** 2
                Vuf = round(math.sqrt((abs(1 - math.sqrt(3 - 6 * beta))) / (1 + math.sqrt(3 - 6 * beta))) * 100, 5)
                print(f' Desequilíbrio de Tensão: {Vuf} %')

            # deve-se fazer a copia caso contrario a referencia é por ponteiro!!
            vuf_bus_list.append(vuf_bus_dict.copy())

            # acrescenta o dict das linhas monofásicas
            voltage_bus_dict.update(voltage_bus_dict_1phase)

            # create list of dict
            voltage_bus_list.append(voltage_bus_dict.copy())

            # buses com violação de tensão
            voltage_bus_violation_dict = dict((k, v) for k, v in voltage_bus_dict.items() if (float(v) < 0.95 or
                                                                                              float(v) > 1.05))
            voltage_bus_violation_list.append(voltage_bus_violation_dict.copy())

            # fator de Desequilíbrio de tensão
            vuf_bus_violation_dict = dict((k, v) for k, v in vuf_bus_dict.items() if float(v) > 3.0)
            vuf_bus_violation_list.append(vuf_bus_violation_dict)

        result_path = os.path.join("C:\\_BDGD2SQL\\BDGD2SqlServer\\ui\\static\\scenarios\\base\\",
                                   self.dist, self.sub, self.dss.circuit.name.upper(),
                                   self.tipo_dia, self.database, self.mes).replace('\\', '/')
        os.makedirs(result_path, exist_ok=True)

        df_vbus = pd.DataFrame.from_dict(voltage_bus_list)
        df_vbus.to_csv(f'{result_path}/{self.database}_{self.tipo_dia}_{self.mes}_voltage_bus_scenario.csv')
        df_violation = pd.DataFrame.from_dict(voltage_bus_violation_list)
        df_violation.to_csv(
            f'{result_path}/{self.database}_{self.tipo_dia}_{self.mes}_voltage_bus_violation_scenario.csv')
        df_vuf = pd.DataFrame.from_dict(vuf_bus_violation_list)
        # df_vuf.to_csv(f'{self.database}_{self.tipo_dia}_{self.mes}_vuf_bus_violation_scenario.csv')
        df_vuf = df_vuf.transpose()
        df_vuf.to_excel(f'{result_path}/{self.database}_{self.tipo_dia}_{self.mes}_vuf_bus_violation_scenario.xlsx')
        df_all_vuf = pd.DataFrame.from_dict(vuf_bus_list)
        df_all_vuf = df_all_vuf.transpose()
        df_all_vuf.to_excel(f'{result_path}/{self.database}_{self.tipo_dia}_{self.mes}_vuf_bus_scenario.xlsx')

        # convert into json
        self._save_json('v_pu_bus', voltage_bus_list)


if __name__ == '__main__':

    proc_time_ini = time.time()
    if run_multiprocess:
        """
        list_sub = [['APA'], ['ARA'], ['ASP'], ['AVP'], ['BCU'], ['BIR'], ['BON'], ['CAC'], ['CAR'], ['CMB'], ['COL'],
                    ['CPA'], ['CRU'], ['CSO'], ['DBE'],
                    ['DUT'], ['FER'], ['GOP'], ['GUE'], ['GUL'], ['GUR'], ['INP'], ['IPO'], ['ITQ'], ['JAC'], ['JNO'],
                    ['JAM'], ['JAR'], ['JCE'], ['JUQ'],
                    ['KMA'], ['LOR'], ['MAP'], ['MAS'], ['MCI'], ['MRE'], ['MTQ'], ['OLR'], ['PED'], ['PID'], ['PIL'],
                    ['PME'], ['PNO'], ['POA'], ['PRT'],
                    ['PTE'], ['ROS'], ['SAT'], ['SBR'], ['SJC'], ['SKO'], ['SLU'], ['SLZ'], ['SSC'], ['SUZ'], ['TAU'],
                    ['UNA'], ['URB'], ['USS'], ['VGA'], ['VHE'], ['VJS'], ['VSL']]
        """
        print(cpu_count())

        # utilizando map (multi-args=no order result=yes)
        with Pool(processes=(cpu_count() - 1)) as p:
            # print(p.map(run_multi, [['AVP'], ['GUE'], ]))
            p.map(run_multi, list_sub, )
        p.close()
        p.join()
        p.terminate()
        """
        # utilizando apply_async
        p = Pool(processes=(cpu_count() - 1))
        for sub in list_sub:
            print(sub)
            print(p.apply_async(run_multi, args=(sub,)))
        p.close()
        p.join()
        """
    else:
        list_sub = list(map(lambda sl: sl[0], list_sub))
        """
        list_sub = ['APA', 'ARA', 'ASP', 'AVP', 'BCU', 'BIR', 'BON', 'CAC', 'CAR', 'CMB', 'COL', 'CPA', 'CRU', 'CSO',
                    'DBE', 'DUT', 'FER', 'GOP', 'GUE', 'GUL', 'GUR', 'INP', 'IPO', 'ITQ', 'JAC', 'JNO', 'JAM', 'JAR',
                    'JCE', 'JUQ', 'KMA', 'LOR', 'MAP', 'MAS', 'MCI', 'MRE', 'MTQ', 'OLR', 'PED', 'PID', 'PIL', 'PME',
                    'PNO', 'POA', 'PRT', 'PTE', 'ROS', 'SAT', 'SBR', 'SJC', 'SKO', 'SLU', 'SLZ', 'SSC', 'SUZ', 'TAU',
                    'UNA', 'URB', 'USS', 'VGA', 'VHE', 'VJS', 'VSL']
        list_sub = ['USS']
        """
        list_sub = ['TPU']
        for nome_sub in list_sub:
            sub = nome_sub
            master_file = f"{master_type_day}_{master_month}_Master_substation_{dist}_{sub}.dss"

            config_opendss = {"master_folder": master_folder,
                              "master_dist": os.path.join(dist, sub),
                              "master_file": master_file,
                              "master_type_day": master_type_day,
                              "master_month": master_month,
                              "master_data_base": master_data_base,
                              "master_sub": sub}

            folder = os.path.join(config_opendss['master_folder'], config_opendss['master_dist'])
            master_file = glob.glob(folder + "/*.dss")
            # sub_folders = [name for name in os.listdir(folder) if os.path.isdir(os.path.join(folder, name))]
            # print(sub_folders)
            if not master_file:
                print(f'Arquivo DSS não encontrado em {folder}.')
                continue

            simul = SimuladorOpendss(config_opendss)

            if exec_by_circuit:
                for file_dss in (glob.glob(folder + f"/*/{master_type_day}_{master_month}_Master_*.dss")):
                    if "Master" in file_dss:
                        simul.list_file_dss.append(file_dss)
                        simul.dss_file = file_dss
                        simul.executa_fluxo_potencia()
                        simul.plot_data_monitors()
            else:
                simul.executa_fluxo_potencia()
                simul.plot_data_monitors()
    
    control_sub_loading = True
    if control_sub_loading:
        substations_losses(dist, 'DO', '2022', master_month)
        substations_losses(dist, 'DU', '2022', master_month)
        # teste: análise de carregamento das subestações
        substations_transformer_loading(dist, 'DU', '2022', master_month)
        substations_transformer_loading(dist, 'DO', '2022', master_month)

    print(f'Substation: process completed in {time.time() - proc_time_ini}.', flush=True)

