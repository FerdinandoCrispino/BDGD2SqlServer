from py_dss_interface import DSS
import os
import numpy as np
import pandas as pd
import time
import cmath

import matplotlib

matplotlib.use('TKAgg')
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker


def convert2polar(real, imag):
    z = complex(real, imag)
    return cmath.polar(z)


class Condition:
    def __init__(self, circuit, dss_file):
        self.circuit = circuit
        self.dss_file = dss_file

        self.bt_undervoltage_prec = pd.DataFrame()
        self.bt_undervoltage_crit = pd.DataFrame()
        self.bt_overvoltage_prec = pd.DataFrame()
        self.bt_overvoltage_crit = pd.DataFrame()

        self.mt_undervoltage_prec = pd.DataFrame()
        self.mt_undervoltage_crit = pd.DataFrame()
        self.mt_overvoltage_prec = pd.DataFrame()
        self.mt_overvoltage_crit = pd.DataFrame()

        self.dss = self.__read_dss_file()
        self.__solve_circuit()

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
        # for name in dss.meters.names:
        #    dss.text(f"disable energymeter.{name}")

        dss.text("set mode = daily")
        dss.text("set tolerance = 0.0001")
        dss.text("set maxcontroliter = 100")
        dss.text("set maxiterations = 100")
        dss.text("Set stepsize = 10m")
        dss.text("set number = 1")

        """
        first_elem = self.__first_element(dss)
        # self.dss.text(f"new monitor.{first_elem}_P element={first_elem} terminal=1 mode=1 ppolar=no")
        dss.text(f"new 'monitor.{first_elem}_i' element='{first_elem}' terminal=1 mode=0 ppolar=no")
        self.current_monitor = f'{first_elem}_i'

        dss.text(f"new 'Energymeter.{first_elem}_m' element='{first_elem}' terminal=1")
        self.current_medidor = f'{first_elem}_m'
        """
        return dss

    def __solve_circuit(self):
        total_number = 144

        voltage_bus_list_all = []
        voltage_bus_list = []

        for number in range(1, total_number + 1):
            print(f"Patamar:{number}")
            self.dss.solution.solve()
            status = self.dss.solution.converged
            if status == 0:
                print(f'OpenDSS: File {self.dss_file} not solved to time {number}!')
                #return False
                continue
            else:
                vll_list = []
                for bus_name in self.dss.circuit.nodes_names:
                    active_bus = bus_name.split('.')[0]
                    bus_node = int(bus_name.split('.')[1])
                    self.dss.circuit.set_active_bus(active_bus)

                    # print(bus_name)
                    if bus_name.split('.')[1] == '4':  # para desconsiderar tensão de neutro
                        continue
                    # if self.dss.bus.kv_base < 1:  # para desconsiderar a baixa tensão

                    num_nodes = int(len(self.dss.bus.vll) / 2)
                    # num_nodes = self.dss.bus.num_nodes
                    # Não existe valores de tensão de linha para barras monofásicas
                    if num_nodes == 1:
                        pos = 0
                        vll_1 = 0
                        vll_pu_1 = 0
                    else:
                        pos = bus_node - 1
                        vll_1 = round(convert2polar(self.dss.bus.vll[pos * 2],
                                                    self.dss.bus.vll[(pos * 2) + 1])[0], 3)
                        vll_pu_1 = round(
                            convert2polar(self.dss.bus.pu_vll[pos * 2], self.dss.bus.pu_vll[(pos * 2) + 1])[0], 3)

                    # tensões de fase
                    vln_1 = round(convert2polar(self.dss.bus.voltages[pos * 2],
                                                self.dss.bus.voltages[(pos * 2) + 1])[0], 3)
                    vln_pu_1 = round(convert2polar(self.dss.bus.pu_voltages[pos * 2],
                                                   self.dss.bus.pu_voltages[(pos * 2) + 1])[0], 3)

                    vll_list.append([f"{bus_name.split('.')[0]}", pos + 1, vll_1, vll_pu_1, vln_1, vln_pu_1,
                                     self.dss.bus.kv_base])
                    # print(len(vll_list))

            for bus, nodes, vll, vll_pu, vln, vln_pu, kv_base in vll_list:
                voltage_bus_list_all.append({"patamar": number, "bus": bus, "nodes": nodes, "vll": vll, "vln": vln,
                                             "vll_pu": vll_pu, "vln_pu": vln_pu, "kv_base": kv_base})

        # proc_time_ini = time.time()
        df = pd.DataFrame(voltage_bus_list_all)
        # print(f"total: {round(time.time() - proc_time_ini, 4)}")

        self.bt_undervoltage_prec = df[(df['kv_base'] <= 1) & (df['vln_pu'] < 0.92) & (df['vln_pu'] > 0)]
        self.bt_undervoltage_crit = df[(df['kv_base'] <= 1) & (df['vln_pu'] < 0.92) & (df['vln_pu'] > 0.87)]
        self.bt_overvoltage_prec = df[(df['kv_base'] <= 1) & (df['vln_pu'] > 1.05) & (df['vln_pu'] <= 1.06)]
        self.bt_overvoltage_crit = df[(df['kv_base'] <= 1) & (df['vln_pu'] > 1.06)]

        self.mt_undervoltage_prec = df[(df['kv_base'] > 1) & (df['vln_pu'] < 0.93) & (df['vln_pu'] >= 0.90)]
        self.mt_undervoltage_crit = df[(df['kv_base'] > 1) & (df['vln_pu'] < 0.90) & (df['vln_pu'] > 0.2)]
        self.mt_overvoltage_crit = df[(df['kv_base'] > 1) & (df['vln_pu'] > 1.05)]

        self.plot_data_result()
        print("aqui")

    def plot_data_result(self, isblock=True):

        dirname = os.path.dirname(self.dss_file)
        path_dir = os.path.abspath(os.path.join(dirname, fr'output'))

        plt_path_base = os.path.join(rf"C:\pastaD\TSEA\Analises\base_case", self.circuit)
        os.makedirs(plt_path_base, exist_ok=True)

        counts_bt_under_prec = self.bt_undervoltage_prec['patamar'].value_counts()
        counts_bt_under_crit = self.bt_undervoltage_crit['patamar'].value_counts()
        counts_bt_over_prec = self.bt_overvoltage_prec['patamar'].value_counts()
        counts_bt_over_crit = self.bt_overvoltage_crit['patamar'].value_counts()
        bt_df = pd.DataFrame({'bt_undervoltage_prec': counts_bt_under_prec,
                              'bt_undervoltage_crit': counts_bt_under_crit,
                              'bt_overvoltage_prec': counts_bt_over_prec,
                              'bt_overvoltage_crit': counts_bt_over_crit})

        num_buses = len(self.dss.circuit.nodes_names)
        counts_bt_under_prec_perc = counts_bt_under_prec / num_buses * 100
        counts_bt_under_crit_perc = counts_bt_under_crit / num_buses * 100
        counts_bt_over_prec_perc = counts_bt_over_prec / num_buses * 100
        counts_bt_over_crit_perc = counts_bt_over_crit / num_buses * 100
        bt_df_perc = pd.DataFrame({'bt_undervoltage_prec': counts_bt_under_prec_perc,
                                   'bt_undervoltage_crit': counts_bt_under_crit_perc,
                                   'bt_overvoltage_prec': counts_bt_over_prec_perc,
                                   'bt_overvoltage_crit': counts_bt_over_crit_perc})

        counts_mt_under_prec = self.mt_undervoltage_prec['patamar'].value_counts()
        counts_mt_under_crit = self.mt_undervoltage_crit['patamar'].value_counts()

        counts_mt_over_crit = self.mt_overvoltage_crit['patamar'].value_counts()
        mt_df = pd.DataFrame({'mt_undervoltage_prec': counts_mt_under_prec,
                              'mt_undervoltage_crit': counts_mt_under_crit,
                              'mt_overvoltage_crit': counts_mt_over_crit})

        counts_mt_under_prec_perc = counts_mt_under_prec / num_buses * 100
        counts_mt_under_crit_perc = counts_mt_under_crit / num_buses * 100
        counts_mt_over_crit_perc = counts_mt_over_crit / num_buses * 100
        mt_df_perc = pd.DataFrame({'mt_undervoltage_prec': counts_mt_under_prec_perc,
                                   'mt_undervoltage_crit': counts_mt_under_crit_perc,
                                   'mt_overvoltage_crit': counts_mt_over_crit_perc})

        if not bt_df.empty:
            ax = bt_df.plot(kind='bar', stacked=True)
            plt.title(f"BUS Violation : {self.circuit}")
            plt.ylabel(f"Number")
            plt.xlabel(f"Time steps")
            ax.xaxis.set_major_locator(ticker.MultipleLocator(6))
            plt_path = os.path.join(plt_path_base, "bt_voltages.png")
            plt.savefig(plt_path, dpi=300, bbox_inches='tight', transparent=False)
            plt.show(block=False)

            ax = bt_df_perc.plot(kind='bar', stacked=True)
            plt.title(f"BUS Violation : {self.circuit}")
            plt.ylabel(f"Number (%)")
            plt.xlabel(f"Time steps")
            ax.xaxis.set_major_locator(ticker.MultipleLocator(6))
            plt_path = os.path.join(plt_path_base, "bt_voltages_perc.png")
            plt.savefig(plt_path, dpi=300, bbox_inches='tight', transparent=False)
            plt.show(block=True)

        else:
            print("Sem violação de tensão BT.")

        if not mt_df.empty:
            ax = mt_df.plot(kind='bar', stacked=True)
            plt.title(f"BUS Violation : {self.circuit}")
            plt.ylabel(f"Number")
            plt.xlabel(f"Time")
            ax.xaxis.set_major_locator(ticker.MultipleLocator(6))
            plt_path = os.path.join(plt_path_base, "mt_voltages.png")
            plt.savefig(plt_path, dpi=300, bbox_inches='tight', transparent=False)
            plt.show(block=False)

            ax = mt_df_perc.plot(kind='bar', stacked=True)
            plt.title(f"BUS Violation : {self.circuit}")
            plt.ylabel(f"Number (%)")
            plt.xlabel(f"Time")
            ax.xaxis.set_major_locator(ticker.MultipleLocator(6))
            plt_path = os.path.join(plt_path_base, "mt_voltages_perc.png")
            plt.savefig(plt_path, dpi=300, bbox_inches='tight', transparent=False)
            plt.show(block=isblock)
        else:
            print("Sem violação de tensão MT.")


if __name__ == '__main__':
    list_circuit = ['RAVP1303', 'RBOI1302', 'RBRR1301', 'RMTQ1302']

    #dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RAVP1303\output\master.dss'
    #dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RAVP1303\DU_7_Master_391_AVP_RAVP1303.dss'
    #circuito = 'RAVP1303'

    # dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RBOI1302\output\master.dss'
    #dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RBOI1302\DU_7_Master_391_BOI_RBOI1302.dss'
    #circuito = 'RBOI1302'

    # dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RBRR1301\output\master.dss'
    #dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RBRR1301\DU_7_Master_391_BRR_RBRR1301.dss'
    #circuito = 'RBRR1301'

    #dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RMTQ1302\output\master.dss'
    dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RMTQ1302\DU_7_Master_391_MTQ_RMTQ1302.dss'
    circuito = 'RMTQ1302'

    # dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RMTQ1306\output\master.dss'
    # circuito = 'RMTQ1306'

    simul = Condition(circuit=circuito, dss_file=dss_file)
