# -*- coding: utf-8 -*-
# @Author  : Guilherme Broslavschi
# @Email   : guibroslavschi@usp.br
# @File    : Hosting_Capacity_antigo.py
# @Software: PyCharm

import py_dss_interface
import pandas as pd
import pathlib
import numpy as np
import os
import string
import yaml
import json
import multiprocessing

# TODO - EXPLICAR O FUNCIONAMENTO HORÁRIO DO ESTUDO
""" 
O código apresentado tem como objetivo calcular a Capacidade de Hospedagem (Hosting Capacity) de geração distribuída em 
cada barra dos alimentadores do sistema de distribuição, utilizando o software OpenDSS.
É realizado uma avaliação para cada barra, determinando  qual é a máxima potência ativa (em kW) que pode ser inserida na
rede sem ultrapassar o limite de sobretensão definido, e os resultados são armazenados em arquivos .csv e .json.
"""


class HCSteps:
    def __init__(self, dss: py_dss_interface.DSS(), dss_file, max_kw: float, step_kw: float, ov_threshold: float, loadmult: float):
        self._dss = dss
        self._dss_file = dss_file
        self._max_kw = max_kw
        self._step_kw = step_kw
        self._ov_threshold = ov_threshold
        self._loadmult = loadmult

    def hosting_capacity(self):
        data_hc = list()
        error_log = list()
        buses_selected = list()

        self._dss.text(f"compile [{self._dss_file}]")
        self._dss.lines.first()

        # TODO - TESTE DO ARQUIVO .CSV E .JSON
        # TODO - COMENTAR O "for _ in range(self._dss.lines.count):" SE UTILIZAR O TESTE
        # count = 0
        # buses_chosen = 10
        # for _ in range(self._dss.lines.count):
        #     if count < buses_chosen:
        #         bus1 = self._dss.cktelement.bus_names[0].split(".")[0]
        #         buses_selected.append(bus1)
        #         count += 1
        #         self._dss.lines.next()
        #     else:
        #         break

        for _ in range(self._dss.lines.count):
            self._dss.circuit.set_active_element(f"line[{self._dss.lines.name}]")
            line = self._dss.lines.name

            bus1 = self._dss.cktelement.bus_names[0].split(".")[0]
            #if bus1 == 'mt3821739439859544cs02': # TODO PARA TESTE
            self._dss.circuit.set_active_bus(bus1)
            kv_base_bus1 = self._dss.bus.kv_base * 1000

            if kv_base_bus1 >= 1000 and bus1 not in buses_selected:
                buses_selected.append(bus1)
            if kv_base_bus1 <= 1000:
                print(f"{line} no bus1: {bus1}; {kv_base_bus1}V")

            bus2 = self._dss.cktelement.bus_names[1].split(".")[0]
            #if bus2 == 'mt3821739439859544cs02':  # TODO PARA TESTE
            self._dss.circuit.set_active_bus(bus2)
            kv_base_bus2 = self._dss.bus.kv_base * 1000

            if kv_base_bus2 >= 1000 and bus2 not in buses_selected:
                buses_selected.append(bus2)
            if kv_base_bus2 <= 1000:
                print(f"{line} no bus2: {bus2}; {kv_base_bus2}V")

            self._dss.lines.next()

        print(f"Quantidade de barras: {len(buses_selected)}; Processador: {multiprocessing.current_process().name}.") # TODO PARA TESTE
        bus_number = 0 # TODO PARA TESTE
        for bus in buses_selected:
            bus_number += 1 # TODO PARA TESTE
            print(f"Analisando barra de número: {bus_number} de {len(buses_selected)}; Processador: {multiprocessing.current_process().name}.")  # TODO PARA TESTE

            with open(self._dss_file, 'r') as file:
                for line_dss in file:
                    if not (line_dss.startswith('!') or line_dss.startswith('\n')):
                        self._dss.text(line_dss.strip('\n'))
                    if 'calcv' in line_dss:
                        break

            self._dss.text(f"set loadmult={self._loadmult}")

            self._dss.circuit.set_active_bus(bus)
            kv_1ph = self._dss.bus.kv_base
            kv_3ph = self._dss.bus.kv_base * np.sqrt(3)
            phases = len(self._dss.bus.nodes)
            node = self.__extract_nodes(bus)

            gen_bus = {"gen": self._dss.bus.name}
            gen_kv = {"gen": kv_3ph}
            gen_phases = {"gen": phases}
            gen_node = {"gen": node}

            if phases == 1:
                gen_kv = {"gen": kv_1ph}

            self.__add_gen(gen_bus, gen_kv, gen_phases, gen_node)

            i_kw = 0
            while i_kw < self._max_kw:
                if i_kw < 10:
                    i_kw += 1

                elif i_kw >= 10 and i_kw < 50:
                    if self._step_kw == 1:
                        i_kw += 1
                    elif self._step_kw > 1 and self._step_kw <= 5:
                        i_kw += self._step_kw
                    else:
                        i_kw += 5

                elif i_kw >= 50 and i_kw < 100:
                    if self._step_kw <= 5:
                        i_kw += self._step_kw
                    elif self._step_kw > 5 and self._step_kw <= 10:
                        i_kw += self._step_kw
                    else:
                        i_kw += 10

                elif i_kw >= 100 and i_kw < 500:
                    if self._step_kw <= 10:
                        i_kw += self._step_kw
                    elif self._step_kw > 10 and self._step_kw <= 50:
                        i_kw += self._step_kw
                    else:
                        i_kw += 50

                elif i_kw >= 500 and i_kw < 1000:
                    if self._step_kw <= 50:
                        i_kw += self._step_kw
                    elif self._step_kw > 50 and self._step_kw <= 100:
                        i_kw += self._step_kw
                    else:
                        i_kw += 100

                else:
                        i_kw += self._step_kw

                gen_kw = {"gen": i_kw}

                self.__increase_gen(gen_kw)
                converged = self.__solve_powerflow()

                if converged == 0 and i_kw == self._max_kw:
                    data_hc.append({
                        "Bus": bus,
                        "HC": self._max_kw,
                        "HC_violation": "",
                        "Bus_violation": "",
                        "V_a": "",
                        "V_b": "",
                        "V_c": ""
                    })

                if converged == 0:
                    error_log.append({
                        "Bus": bus,
                        "Power_kW": i_kw
                    })
                    continue

                violation, data_ov = self.__check_medium_overvoltage_violation()

                if not violation:
                    hc_value = i_kw

                if violation and i_kw == 1:
                    hc_value = 0

                if violation:
                    hosting_capacity_value = hc_value

                    for overvoltage in data_ov:
                        data_hc.append({
                            "Bus": bus,
                            "HC": hosting_capacity_value,
                            "HC_violation": i_kw,
                            "Bus_violation": overvoltage["Bus_violation"],
                            "V_a": overvoltage["V_a"],
                            "V_b": overvoltage["V_b"],
                            "V_c": overvoltage["V_c"]
                        })
                    break

                if i_kw == self._max_kw and not violation:
                    data_hc.append({
                        "Bus": bus,
                        "HC": self._max_kw,
                        "HC_violation": "",
                        "Bus_violation": "",
                        "V_a": "",
                        "V_b": "",
                        "V_c": ""
                    })
                    break

        return data_hc, error_log

    def __extract_nodes(self, bus):
        """
        Extrai as fases presentes na barra selecionada.
        """
        nodes = self._dss.bus.nodes
        phases = len(nodes)

        if phases == 1:
            node = [nodes[0]]
        elif phases == 2:
            node = nodes[:2]
        elif phases == 3:
            node = nodes[:3]
        else:
            return None

        return ".".join(str(n) for n in node)

    def __add_gen(self, gen_bus: dict, gen_kv: dict, gen_phases: dict, gen_node:dict):
        """
        Adiciona o gerador na barra escolhida.
        """
        for gen in gen_bus.keys():
            self._dss.text(f"new generator.{gen} "
                     f"phases={gen_phases[gen]} bus1={gen_bus[gen]}.{gen_node[gen]} kv={gen_kv[gen]} "
                     f"kw=0.0001 pf=1 Vminpu=0.7 Vmaxpu=1.2")

    def __increase_gen(self, gen_kw: dict):
        """
        Altera a potência do gerador.
        """
        for gen, kw in gen_kw.items():
            self._dss.text(f"Edit generator.{gen} kw={kw}")

    def __solve_powerflow(self):
        """
        Realiza o "Solve" no OpenDSS.
        Returna a resposta da convergência.
        """
        self._dss.text("solve")
        return self._dss.solution.converged

    def __check_overvoltage_violation(self) -> bool:
        """
        Realiza a checagem de sobretensão.
        """
        violation = False
        voltages = self._dss.circuit.buses_vmag_pu
        max_voltage = max(voltages)

        if max_voltage > self._ov_threshold:
            violation = True

        return violation

    def __check_medium_overvoltage_violation(self):
        """
        Realiza a checagem de sobretensão em alimentadores de média tensão.
        Retorna um dataframe das barras violadas e suas tensões de fase.
        """
        violation = False
        data_ov = list()

        for bus_name in self._dss.circuit.buses_names:
            self._dss.circuit.set_active_bus(bus_name)
            kv_base = self._dss.bus.kv_base * 1000

            if kv_base >= 1000:
                voltages = self._dss.bus.vmag_angle[::2]
                num_phases = len(voltages)
                max_voltage = max(voltages)
                medium_voltage_pu = max_voltage / kv_base

                if medium_voltage_pu > self._ov_threshold:

                    if num_phases == 1:
                        V_a = voltages[0] / kv_base
                        V_b = ""
                        V_c = ""
                    elif num_phases == 2:
                        V_a = voltages[0] / kv_base
                        V_b = voltages[1] / kv_base
                        V_c = ""
                    elif num_phases == 3:
                        V_a = voltages[0] / kv_base
                        V_b = voltages[1] / kv_base
                        V_c = voltages[2] / kv_base

                    violation = True
                    data_ov.append({
                        "Bus_violation": bus_name,
                        "V_a": V_a,
                        "V_b": V_b,
                        "V_c": V_c
                    })

        return violation, data_ov

    @staticmethod
    def _find_project_root(marker_folder="ui"):
        """
        Retorna o nome da raiz do projeto para mesclar com o caminho correto de gravação dos arquivos.
        """
        path = pathlib.Path(__file__).resolve()
        for parent in path.parents:
            if (parent / marker_folder).exists():
                return parent
        raise FileNotFoundError(f"Raiz do projeto não encontrada contendo a pasta '{marker_folder}'.")

    @staticmethod
    def list_drives():
        # """
        # Retorna todas as unidades disponíveis no sistema (ex: C:\\, D:\\, etc).
        # """
        # return [f"{d}:\\" for d in string.ascii_uppercase if pathlib.Path(f"{d}:\\").exists()]
        """
        Retorna apenas a unidade escolhida
        """
        return ["D:\\"]

    @staticmethod
    def find_file(filename: str, search_path: str) -> pathlib.Path | None:
        """
        Procura por um arquivo com nome exato a partir de `search_path`.
        Retorna o primeiro caminho encontrado ou None.
        """
        for root, dirs, files in os.walk(search_path):
            if filename in files:
                return pathlib.Path(root) / filename
        return None

def run_multiprocess(args):
    feeder, config = args
    print(f"🚀 Iniciando processamento do alimentador: {feeder}; Processador: {multiprocessing.current_process().name}.\n")
    filename = f"{config['type_day']}_{config['month']}_Master_{config['utility']}_{config['substation']}_{feeder}.dss"
    dss = py_dss_interface.DSS()

    all_errors = list()
    try:
        # Directory path to Master.dss script
        available_drives = HCSteps.list_drives()
        dss_file = None
        for drive in available_drives:
            result = HCSteps.find_file(filename, search_path=drive)
            if result:
                dss_file = result
                break
        if dss_file is None:
            raise FileNotFoundError

        # Directory to save the .csv file
        project_root = HCSteps._find_project_root()
        relative_path = pathlib.Path(
            f"ui/static/scenarios/Hosting Capacity/{config['utility']}/{config['substation']}/{feeder}/{config['type_day']}/{config['year']}/{config['month']}")
        base_path = project_root / relative_path
        base_path.mkdir(parents=True, exist_ok=True)
        csv_path = base_path / f"HC_{feeder}_{config['month']}_{config['type_day']}.csv"

        # Execute Hosting Capacity
        data_hc, error_log = HCSteps(dss, dss_file, config["max_kw"], config["step_kw"], config["ov_threshold"], config["loadmult"]).hosting_capacity()

        if error_log:
            all_errors.extend(error_log)
            df_errors = pd.DataFrame(all_errors)
            errors_path = base_path / f"errors_convergence_{feeder}_{config['month']}_{config['type_day']}.csv"
            df_errors.to_csv(errors_path, index=False)
            #print(f"⛔ ERRO: De convergência no alimentador {feeder}. E salvos em: {errors_path}.")

        # To save the dataframe in .csv file
        df = pd.DataFrame(data_hc)
        df = df[["Bus", "HC", "HC_violation", "Bus_violation", "V_a", "V_b", "V_c"]]
        df.to_csv(csv_path, index=False)

        # Directory to save the .json file
        hc_summary = df[["Bus", "HC"]].drop_duplicates(subset="Bus")
        hc_dict = {row["Bus"]: row["HC"] for _, row in hc_summary.iterrows()}
        json_path = base_path / f"{feeder}.json"

        with open(json_path, "w", encoding="utf-8") as f:
            json.dump([hc_dict], f, indent=4)

        print(f"✅ Alimentador {feeder} processado com sucesso.")

    except FileNotFoundError:
        print(f"❌ Alimentador '{feeder}'; Arquivo '{filename}' não encontrado.")


if __name__ == '__main__':

    # Absolute path to config_hc_antigo.yml
    base_dir = os.path.dirname(os.path.abspath(__file__))
    config_path = os.path.join(base_dir, "config_hc_antigo.yml")

    with open(config_path, "r") as file:
        config = yaml.safe_load(file)["databases"]

    feeders = config["feeder"] if isinstance(config["feeder"], list) else [config["feeder"]]

    # To use multiprocess write TRUE
    multiprocess = True

    if multiprocess:
        cpu_cores = multiprocessing.cpu_count() - 1
        print(f"Utilizando {cpu_cores} processadores.")

        with multiprocessing.Pool(processes=cpu_cores) as pool:
            pool.map(run_multiprocess, [(feeder, config) for feeder in feeders])

    else:
        for feeder in feeders:
            print(f"🚀 Iniciando processamento do alimentador: {feeder}; Processador: {multiprocessing.current_process().name}.\n")
            filename = f"{config['type_day']}_{config['month']}_Master_{config['utility']}_{config['substation']}_{feeder}.dss"
            dss = py_dss_interface.DSS()

            all_errors = list()
            try:
                # Directory path to Master.dss script
                available_drives = HCSteps.list_drives()
                dss_file = None
                for drive in available_drives:
                    result = HCSteps.find_file(filename, search_path=drive)
                    if result:
                        dss_file = result
                        break
                if dss_file is None:
                    raise FileNotFoundError

                # Directory to save the .csv file
                project_root = HCSteps._find_project_root()
                relative_path = pathlib.Path(
                    f"ui/static/scenarios/Hosting Capacity/{config['utility']}/{config['substation']}/{feeder}/{config['type_day']}/{config['year']}/{config['month']}")
                base_path = project_root / relative_path
                base_path.mkdir(parents=True, exist_ok=True)
                csv_path = base_path / f"HC_{feeder}_{config['month']}_{config['type_day']}.csv"

                # Execute Hosting Capacity
                data_hc, error_log = HCSteps(dss, dss_file, config["max_kw"], config["step_kw"], config["ov_threshold"], config["loadmult"]).hosting_capacity()

                if error_log:
                    all_errors.extend(error_log)
                    df_errors = pd.DataFrame(all_errors)
                    errors_path = base_path / f"errors_convergence_{feeder}_{config['month']}_{config['type_day']}.csv"
                    df_errors.to_csv(errors_path, index=False)
                    #print(f"⛔ ERRO: De convergência no alimentador {feeder}. E salvos em: {errors_path}.")

                # To save the dataframe in .csv file
                df = pd.DataFrame(data_hc)
                df = df[["Bus", "HC", "HC_violation", "Bus_violation", "V_a", "V_b", "V_c"]]
                df.to_csv(csv_path, index=False)

                # Directory to save the .json file
                hc_summary = df[["Bus", "HC"]].drop_duplicates(subset="Bus")
                hc_dict = {row["Bus"]: row["HC"] for _, row in hc_summary.iterrows()}
                json_path = base_path / f"{feeder}.json"

                with open(json_path, "w", encoding="utf-8") as f:
                    json.dump([hc_dict], f, indent=4)

                print(f"✅ Alimentador {feeder} processado com sucesso.")

            except FileNotFoundError:
                print(f"❌ Alimentador '{feeder}'; Arquivo '{filename}' não encontrado.")
                continue

    print(f"here")