import py_dss_interface
import os
import matplotlib.pyplot as plt
import matplotlib
import numpy as np
import pandas as pd
import glob
import calendar

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

        print(self.dss_file)

    def executa_fluxo_potencia(self) -> None:
        """
        Função para solicitar execução do fluxo de potência ao OpenDSS.
        :return: None
        """

        """
        self.dss.text("clear")
        with open(os.path.join(self.dss_file), 'r') as file:
            for dss_line in file:
                if not (dss_line.startswith('!') or dss_line.lower().startswith('clear') or dss_line.startswith('\n')):
                    self.dss.text(dss_line.strip('\n'))
                if 'calcv' in dss_line:
                    break

        #self.dss.text("set DemandInterval=true")
        #self.dss.text("set overloadreport=true")
        #self.dss.text("set voltexceptionreport=true")
        #self.dss.text("set DIverbose=true")
        #self.dss.text("set controlmode = static")
        self.dss.text("set mode = daily")
        self.dss.text("Set stepsize = 1h")
        self.dss.text("set number = 24")

        self.dss.text("solve")
        #self.dss.text("closeDI")
        """
        monitor_mode = {0: "Voltages", 1: "Powers ", 2: "Tap Position"}

        # compila os arquivos DSS
        self.dss.text(f"compile [{self.dss_file}]")

        self.dss.transformers.first()
        print(f'Bus:{self.dss.transformers.name}')
        print(f'Pot:{self.dss.transformers.kva} kVA')

        monitor = self.dss.monitors.first()
        nun_monit = 1
        while monitor:
            xpoints = np.array([])
            """
            print(f"Monitor: {self.dss.monitors.name} - "
                  f"Element: {self.dss.monitors.element} - "
                  f"header: {self.dss.monitors.header} - "
                  f"num_channels: {self.dss.monitors.num_channels}")
            print(f"Monitor:{self.dss.monitors.channel(1)} ")
            print(f"Monitor:{self.dss.monitors.channel(2)} ")
            """

            # Get power from monitored transformer
            tr_kva = ''
            if self.dss.monitors.mode == 1:
                for tr_name in self.dss.transformers.names:
                    if 'transformer.' + tr_name == self.dss.monitors.element:
                        self.dss.transformers.name = tr_name
                        tr_kva = f' {self.dss.transformers.kva} kVA'
                        break

            max_p1 = max(self.dss.monitors.channel(1))
            min_p1 = min(self.dss.monitors.channel(1))
            max_index1 = pd.Series(self.dss.monitors.channel(1)).idxmax()
            max_index2 = self.dss.monitors.channel(1).index(max(self.dss.monitors.channel(1)))

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
            dirname = os.path.dirname(__file__)
            plt_path = os.path.join(dirname, "..\\ui\\static\\scenarios\\base\\",
                                    config_opendss['master_dist'], self.dss.circuit.name.upper())
            os.makedirs(plt_path, exist_ok=True)
            plt.savefig(f'{plt_path}\\{self.dss.circuit.name.upper()}_M{nun_monit}.png')
            plt.close()
            # mng = plt.get_current_fig_manager()
            # mng.window.state("zoomed")
            # mng.frame.Maximize(True)
            # mng.full_screen_toggle()
            # O comando show aguarda o usuario fechar o grafico para continuar
            # plt.show()

            monitor = self.dss.monitors.next()
            nun_monit += 1


if __name__ == '__main__':

    config_opendss = {"master_folder": os.path.expanduser('~\\dss'),
                      "master_dist": "391\\TAU",
                      "master_file": "DU_1_Master_substation_391_TAU.dss",
                      "master_type_day": "DU",
                      "master_month": "1",
                      "master_data_base": "2022"}

    folder = dist_path = os.path.join(config_opendss['master_folder'], config_opendss['master_dist'])
    master_file = glob.glob(folder + "/*.dss")
    # sub_folders = [name for name in os.listdir(folder) if os.path.isdir(os.path.join(folder, name))]
    # print(sub_folders)

    simul = SimuladorOpendss(config_opendss)

    # True para rodar o master com todos os circuitos e os transformadores de alta ou False para rodar um circuito de cada vez
    exec_by_substation = False
    if exec_by_substation:
        for file_dss in (glob.glob(folder + "/*/*.dss")):
            if "Master" in file_dss:
                simul.list_file_dss.append(file_dss)
                simul.dss_file = file_dss
                simul.executa_fluxo_potencia()
    else:
        simul.executa_fluxo_potencia()
