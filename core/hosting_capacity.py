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

from Tools.tools import circuit_by_bus

matplotlib.use('TKAgg')


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
        self.dist = config_opendss['master_dist'].split('\\')[0]
        print(self.dss_file)

    def plot_data_monitors(self) -> None:

        self.dss.text(f"compile [{self.dss_file}]")

        monitor_mode = {0: "Voltages", 1: "Powers ", 2: "Tap Position"}
        nun_monit = 1
        monitor = self.dss.monitors.first()
        while monitor:

            xpoints = np.array([])

            print(f"Monitor: {self.dss.monitors.name} - "
                  f"Element: {self.dss.monitors.element} - "
                  f"header: {self.dss.monitors.header} - "
                  f"num_channels: {self.dss.monitors.num_channels}")
            print(f"Monitor:{self.dss.monitors.channel(1)} ")
            print(f"Monitor:{self.dss.monitors.channel(2)} ")
            print(f"Sample_count:{self.dss.monitors.sample_count} ")

            # Get power from monitored transformer
            tr_kva = ''
            if self.dss.monitors.mode == 1:
                for tr_name in self.dss.transformers.names:
                    if 'transformer.' + tr_name == self.dss.monitors.element:
                        self.dss.transformers.name = tr_name
                        tr_kva = f' {self.dss.transformers.kva} kVA'
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

            plt_path = os.path.join("C:\\_BDGD2SQL\\BDGD2SqlServer\\ui\\static\\scenarios\\base\\",
                                    config_opendss['master_dist'], self.dss.circuit.name.upper())
            os.makedirs(plt_path, exist_ok=True)
            plt.savefig(f'{plt_path}\\{self.dss.circuit.name.upper()}_Balance_M{nun_monit}.png')

            # mng = plt.get_current_fig_manager()
            # mng.window.state("zoomed")
            # mng.frame.Maximize(True)
            # mng.full_screen_toggle()
            # O comando show aguarda o usuario fechar o grafico para continuar
            # plt.show()

            monitor = self.dss.monitors.next()
            nun_monit += 1

    def executa_fluxo_potencia(self) -> None:
        """
        Função para solicitar execução do fluxo de potência ao OpenDSS.
        :return: None
        """
        #self.dss.text("clear")
        self.dss.dssinterface.clear_all()
        #self.dss.text(f"set datapath = '{os.path.join(config_opendss['master_folder'], config_opendss['master_dist'])}'")
        self.dss.text(f"set Datapath = '{os.path.dirname(self.dss_file)}'")
        with open(os.path.join(self.dss_file), 'r') as file:
            for dss_line in file:
                if not (dss_line.startswith('!') or dss_line.startswith('clear') or dss_line.startswith('\n')):
                    self.dss.text(dss_line.strip('\n'))
                if 'calcv' in dss_line:
                    break

        self.dss.text("set mode = daily")
        self.dss.text("Set stepsize = 1h")
        #self.dss.text("set number = 1")
        #self.dss.text("solve")

        #for meter_name in self.dss.meters.names:
        #    self.dss.meters.name = meter_name
        #    self.dss.meters.sample()

        #print(min(self.dss.circuit.buses_vmag_pu))

        total_number = 24
        voltage_bus_dict = dict()
        vuf_bus_dict = dict()
        voltage_bus_list = []
        voltage_bus_violation_list = []
        vuf_bus_list = []
        vuf_bus_violation_list = []

        for number in range(1, total_number + 1):
            self.dss.text(f"set number={number}")
            self.dss.monitors.reset_all()
            self.dss.solution.solve()
            # self.dss.meters.sample()
            # self.dss.monitors.save_all()
            # print(f"Sample_count:{self.dss.monitors.sample_count} ")

            status = self.dss.solution.converged
            if status == 0:
                print('OpenDSS not solved!!!!')
                exit()

            active_bus = ''
            voltage_bus_dict.clear()
            for bus_name in self.dss.circuit.nodes_names:
                if bus_name.split('.')[0] == active_bus:
                    continue
                active_bus = bus_name.split('.')[0]
                id = self.dss.circuit.set_active_bus(active_bus)
                #print(id)
                #print(bus_name)
                if bus_name.split('.')[1] == '4':  # desconsiderar tensão de neutro
                    continue
                if self.dss.bus.kv_base < 1:  # desconsiderar a baixa tensão
                    continue
                vll_pu = []
                vll = []
                for i in range(self.dss.bus.num_nodes):
                    vll_pu.append(round(math.sqrt(self.dss.bus.pu_vll[i*2] ** 2 + self.dss.bus.pu_vll[(i*2)+1] ** 2), 8))
                    vll.append(round(math.sqrt(self.dss.bus.vll[i] ** 2 + self.dss.bus.vll[i+1] ** 2), 5))
                    voltage_bus_dict[f"{bus_name.split('.')[0]}.{i+1}"] = vll_pu[i]

                if self.dss.bus.num_nodes == 3:
                    beta = (vll[0] ** 4 + vll[1] ** 4 + vll[2] ** 4) / (vll[0] ** 2 + vll[1] ** 2 + vll[2] ** 2) ** 2
                    vuf = round(math.sqrt((abs(1 - math.sqrt(3 - 6 * beta))) / (1 + math.sqrt(3 - 6 * beta))) * 100, 5)
                    vuf_bus_dict[f"{bus_name.split('.')[0]}"] = vuf

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

            vuf_bus_list.append(vuf_bus_dict.copy())
            voltage_bus_list.append(voltage_bus_dict.copy())

            voltage_bus_violation_dict = dict((k, v) for k, v in voltage_bus_dict.items() if (float(v) < 0.95 or
                                                                                              float(v) > 1.05))
            voltage_bus_violation_list.append(voltage_bus_violation_dict.copy())

            # fator de desbalanceamento de tensão
            vuf_bus_violation_dict = dict((k, v) for k, v in vuf_bus_dict.items() if float(v) > 2.0)
            vuf_bus_violation_list.append(vuf_bus_violation_dict)

            max_vol = max(voltage_bus_dict.items(), key=lambda x: x[1])
            min_vol = min(voltage_bus_dict.items(), key=lambda x: x[1])

            #max_vol = max(voltage_bus_dict.values())
            #min_vol = min(voltage_bus_dict.values())

            # print(len(voltage_bus_dict.values()))
            print(f'Tensão máxima na hora {number}: {max_vol}')
            print(f'Tensão mínima na hora {number}: {min_vol}')

            # desequilibrio na barra com menor tensão
            self.dss.circuit.set_active_bus(min_vol[0].split('.')[0])

            cir_nome = circuit_by_bus(min_vol[0].split('.')[0], self.dist)
            print(f"Circuito: {cir_nome['CTMT'][0]}")

            Vab = round(math.sqrt(self.dss.bus.vll[0] ** 2 + self.dss.bus.vll[1] ** 2), 4)
            Vbc = round(math.sqrt(self.dss.bus.vll[2] ** 2 + self.dss.bus.vll[3] ** 2), 4)
            Vca = round(math.sqrt(self.dss.bus.vll[4] ** 2 + self.dss.bus.vll[5] ** 2), 4)

            print(f' VAB: {Vab} V')
            print(f' VBC: {Vbc} V')
            print(f' VCA: {Vca} V')

            # Desequilibrio de tensão:
            # IEEE
            # vuf% = 3(Vmax-Vmin)/(VA+Vb+Vc)
            # Cigre / Prodist - limite 2%
            # Vuf = sqrt(1-sqrt(3-6*Beta)/(1+sqrt(3-6*Beta))) beta=(Vab**4+Vbc**4+Vca**4)/(Vab**2+Vbc**2+Vca**2)**2
            # IEC
            # FD% = (V2/V1)*100  (sequencia positiva por sequencia negativa)

            beta = (Vab ** 4 + Vbc ** 4 + Vca ** 4) / (Vab ** 2 + Vbc ** 2 + Vca ** 2) ** 2
            Vuf = round(math.sqrt((abs(1 - math.sqrt(3 - 6 * beta))) / (1 + math.sqrt(3 - 6 * beta))) * 100,5)
            print(f' Desequilibrio de Tensão: {Vuf}')

        df_vbus = pd.DataFrame.from_dict(voltage_bus_list)
        df_vbus.to_csv(f'{self.database}_{self.tipo_dia}_{self.mes}_voltage_bus_scenario.csv')
        df_violation = pd.DataFrame.from_dict(voltage_bus_violation_list)
        df_violation.to_csv(f'{self.database}_{self.tipo_dia}_{self.mes}_voltage_bus_violation_scenario.csv')
        df_vuf = pd.DataFrame.from_dict(vuf_bus_violation_list)
        df_vuf.to_csv(f'{self.database}_{self.tipo_dia}_{self.mes}_vuf_bus_violation_scenario.csv')

        # convert into json
        #result = json.dumps(voltage_bus_list, indent=2)
        dirname = os.path.dirname(__file__)
        json_path = os.path.abspath(os.path.join(dirname, "../ui/static/scenarios/base/", config_opendss['master_dist']))
        os.makedirs(json_path, exist_ok=True)
        with open(f"{json_path}\\{self.dss.circuit.name.upper()}.json", "w") as final:
            json.dump(voltage_bus_list, final, indent=2)


if __name__ == '__main__':
    master_folder = os.path.expanduser('~\\dss')
    dist = "391"
    circ = "ITQ"
    master_type_day = "DU"
    master_month = "1"
    master_data_base = "2022"
    master_file = f"{master_type_day}_{master_month}_Master_substation_{dist}_{circ}.dss"

    config_opendss = {"master_folder": master_folder,
                      "master_dist": os.path.join(dist, circ),
                      "master_file": master_file,
                      "master_type_day": master_type_day,
                      "master_month": master_month,
                      "master_data_base": master_data_base}
    """
    config_opendss = {"master_folder": os.path.expanduser('~\\dss'),
                      "master_dist": "391\\ITQ\\RITQ1312",
                      "master_file": "DU_1_Master_391_ITQ_RITQ1312.dss",
                      "master_type_day": "DU",
                      "master_month": "1",
                      "master_data_base": "2022"}
    """
    folder = os.path.join(config_opendss['master_folder'], config_opendss['master_dist'])
    master_file = glob.glob(folder + "/*.dss")
    # sub_folders = [name for name in os.listdir(folder) if os.path.isdir(os.path.join(folder, name))]
    # print(sub_folders)

    simul = SimuladorOpendss(config_opendss)

    # True para rodar o master com todos os circuitos e os transformadores de alta ou
    # False para rodar um circuito de cada vez
    exec_by_substation = True
    if exec_by_substation:
        for file_dss in (glob.glob(folder + f"/*/{master_type_day}_{master_month}*.dss")):
            if "Master" in file_dss:
                simul.list_file_dss.append(file_dss)
                simul.dss_file = file_dss
                simul.executa_fluxo_potencia()
                simul.plot_data_monitors()
    else:
        simul.executa_fluxo_potencia()
        simul.plot_data_monitors()
