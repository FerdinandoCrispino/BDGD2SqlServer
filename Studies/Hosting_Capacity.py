# -*- coding: utf-8 -*-
# @Author  : Guilherme Broslavschi
# @Email   : guibroslavschi@usp.br
# @File    : Hosting_Capacity.py
# @Software: PyCharm

import py_dss_interface
import pandas as pd
import numpy as np
import pathlib
import os
import sys
import yaml
import json
import time
import multiprocessing
from dataclasses import dataclass
from typing import List, Dict, Tuple
from unify_json import All


""" 
O código apresentado tem como objetivo calcular a Capacidade de Hospedagem (Hosting Capacity), pela métrica de sobretensão, para geração distribuída de duas maneiras: 
    
    1. A primeira calcula a Hosting Capacity em cada barra do alimentador, sendo necessário apenas escrever "False" em "buses_selected" no arquivo "config_hc.yml".
    2. A segunda calcula a Hosting Capacity em barras selecionadas pela distância, no qual a distância é definida em "distance_goal" em km e "buses_selected" deve ser True, ambos estão no arquivo "config_hc.yml".

Os parâmetros utilizados estão em um arquivo de configuração nomeado como "config_hc.yml", e os parâmetros são:
    utility_path: Endereço dos arquivos .dss para a concessionária que será avaliada.
    utility: O número da concessionária.
    substation: Uma ou mais siglas de subestações.
    feeder: Este parâmetro serve apenas para avaliar os alimentadores escritos para as subestações correspondentes do item "substations", caso seja necessário avaliar todos os alimentadores, este parâmetro deve permanecer em branco.  
    year: Ano correspondente da BDGD dos arquivos .dss.
    month: Número do mês ou dos meses de 1 à 12. Por exemplo, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].
    type_day: Tipos de dias. Por exemplo, ['DU', 'DO', 'SA'].
    max_kw: Potência máxima para análise de Hosting Capacity.
    step_kw: Potência de passo para avaliar Hosting Capacity.
    ov_threshold: Limite de sobretensão em pu.
    loadmult: Fator de multiplicação da potência nominal das cargas.
    distance_goal: Distância mínima para seleção das barras que serão avaliadas.
    buses_selected: Determina o modo de seleção de barras para análise de Hosting Capacity.
"""

# ==========================
# Núcleo do cálculo de HC
# ==========================
class HCSteps:
    def __init__(self, dss: py_dss_interface.DSS(), dss_file, max_kw: float, step_kw: float, ov_threshold: float, loadmult: float, distance_goal:float):
        self._dss = dss
        self._dss_file = dss_file
        self._max_kw = max_kw
        self._step_kw = step_kw
        self._ov_threshold = ov_threshold
        self._loadmult = loadmult
        self._distance_goal = distance_goal

    def hosting_capacity_completed(self):
        buses_selected_LINES = self.__get_buses_with_lines()
        buses_selected_METERS, buses_groups = self.__get_all_buses_with_meters()
        selection_buses = False

        missing_buses = sorted(set(buses_selected_LINES) - set(buses_selected_METERS))

        data_hc_incompleted, error_log = self.__hosting_capacity(buses_selected_METERS, selection_buses)
        data_hc = self.__filling_data_hc(data_hc_incompleted, buses_groups, missing_buses)

        return data_hc, error_log

    def hosting_capacity_distance(self):
        buses_selected_LINES = self.__get_buses_with_lines()
        buses_selected_METERS, buses_groups = self.__get_buses_with_meters()
        selection_buses = True

        missing_buses = sorted(set(buses_selected_LINES) - set(buses_selected_METERS))

        data_hc_incompleted, error_log = self.__hosting_capacity(buses_selected_METERS, selection_buses)
        data_hc = self.__filling_data_hc(data_hc_incompleted, buses_groups, missing_buses)

        return data_hc, error_log

    def __hosting_capacity(self, buses_selected, selection_buses):
        """
        Processo de cálculo para Hosting Capacity
        Retorna resultados do nível de hosting capacity por barra e possíveis erros de convergência.
        """

        data_hc = list()
        error_log = list()

        print(f"Quantidade de barras: {len(buses_selected)}; Processador: {multiprocessing.current_process().name}.")
        hc_previous = self._max_kw
        bus_number = 0
        for bus in buses_selected:
            bus_number += 1
            print(
                f"Analisando barra de número: {bus_number} de {len(buses_selected)}; Processador: {multiprocessing.current_process().name}.")

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

            hc_value = 0
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
                self.__set_maxcontroliter()
                self.__set_maxiterations()
                converged = self.__solve_powerflow()
                # Control_Iterations = self._dss.solution.control_iterations

                if converged == 0 and i_kw == self._max_kw:
                    data_hc.append({
                        "Bus": bus,
                        "HC": hc_previous,
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

                if violation:
                    if selection_buses:
                        hosting_capacity_value = hc_value if abs(i_kw - hc_value) < abs(i_kw - hc_previous) else hc_previous

                    else:
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

                    hc_previous = hosting_capacity_value
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

                    hc_previous = self._max_kw
                    break

        return data_hc, error_log

    def __get_buses_with_lines(self):
        """
        Retorna uma lista de barramentos conectados por linhas
        cuja tensão base é maior ou igual a 1 kV.
        """

        buses_selected = list()

        self._dss.text(f"compile [{self._dss_file}]")
        self._dss.lines.first()

        for _ in range(self._dss.lines.count):
            self._dss.circuit.set_active_element(f"line[{self._dss.lines.name}]")

            bus1 = self._dss.cktelement.bus_names[0].split(".")[0]
            self._dss.circuit.set_active_bus(bus1)
            kv_base_bus1 = self._dss.bus.kv_base * 1000
            if kv_base_bus1 >= 1000 and bus1 not in buses_selected:
                buses_selected.append(bus1)

            bus2 = self._dss.cktelement.bus_names[1].split(".")[0]
            self._dss.circuit.set_active_bus(bus2)
            kv_base_bus2 = self._dss.bus.kv_base * 1000
            if kv_base_bus2 >= 1000 and bus2 not in buses_selected:
                buses_selected.append(bus2)

            self._dss.lines.next()

        return buses_selected

    def __get_all_buses_with_meters(self):
        buses_selected = list()
        buses_groups = dict()

        self._dss.text(f"compile [{self._dss_file}]")
        self.__solve_powerflow()
        self._dss.meters.first()

        for _ in range(self._dss.meters.count):
            end_elements_pd = self._dss.meters.all_end_elements

            for end_element in end_elements_pd:

                self._dss.circuit.set_active_element(end_element)

                bus1 = self._dss.cktelement.bus_names[0].split(".")[0]
                self._dss.circuit.set_active_bus(bus1)
                kv_base_bus1 = self._dss.bus.kv_base * 1000
                if kv_base_bus1 >= 1000 and bus1 not in buses_selected:
                    buses_selected.append(bus1)

                bus2 = self._dss.cktelement.bus_names[1].split(".")[0]
                self._dss.circuit.set_active_bus(bus2)
                kv_base_bus2 = self._dss.bus.kv_base * 1000
                if kv_base_bus2 >= 1000 and bus2 not in buses_selected:
                    buses_selected.append(bus2)

                count_parent = 0
                while self._dss.circuit.parent_pd_element:
                    count_parent = count_parent + 1
                    parent_line = self._dss.cktelement.name
                    self._dss.circuit.set_active_element(parent_line)

                    parent_bus1 = self._dss.cktelement.bus_names[0].split(".")[0]
                    self._dss.circuit.set_active_bus(parent_bus1)
                    kv_base_parent_bus1 = self._dss.bus.kv_base * 1000
                    if kv_base_parent_bus1 >= 1000 and parent_bus1 not in buses_selected:
                        buses_selected.append(parent_bus1)

                    parent_bus2 = self._dss.cktelement.bus_names[1].split(".")[0]
                    self._dss.circuit.set_active_bus(parent_bus2)
                    kv_base_parent_bus2 = self._dss.bus.kv_base * 1000
                    if kv_base_parent_bus2 >= 1000 and parent_bus2 not in buses_selected:
                        buses_selected.append(parent_bus2)

            self._dss.meters.next()

        return buses_selected, buses_groups

    def __get_buses_with_meters(self):
        buses_selected = list()
        buses_groups = dict()
        buses_intermediate = list()
        first_bus = list()
        last_bus = list()
        distance_accumulated = 0

        self._dss.text(f"compile [{self._dss_file}]")
        self.__solve_powerflow()
        self._dss.meters.first()

        for _ in range(self._dss.meters.count):
            end_elements_pd = self._dss.meters.all_end_elements

            for end_element in end_elements_pd:

                self._dss.circuit.set_active_element(end_element)

                bus1 = self._dss.cktelement.bus_names[0].split(".")[0]
                bus2 = self._dss.cktelement.bus_names[1].split(".")[0]

                if not last_bus:
                    self._dss.circuit.set_active_bus(bus2)
                    kv_base_bus2 = self._dss.bus.kv_base * 1000

                    if kv_base_bus2 >= 1000 and bus2 not in buses_selected and bus2 not in buses_intermediate and not any(
                            bus2 in g for g in buses_groups.values()):
                        buses_intermediate.append(bus2)
                        last_bus.append(bus2)

                if end_element.lower().startswith("transformer"):
                    length_km = 0

                if not end_element.lower().startswith("transformer"):
                    length_km = self._dss.lines.length

                distance_accumulated = distance_accumulated + length_km

                if distance_accumulated >= self._distance_goal:
                    self._dss.circuit.set_active_bus(bus1)
                    kv_base_bus1 = self._dss.bus.kv_base * 1000

                    if kv_base_bus1 >= 1000:
                        if bus1 not in buses_selected and not any(bus1 in g for g in buses_groups.values()):
                            buses_selected.append(bus1)
                            distance_accumulated = 0

                count_parent = 0
                while self._dss.circuit.parent_pd_element:
                    count_parent = count_parent + 1
                    parent_line = self._dss.cktelement.name
                    self._dss.circuit.set_active_element(parent_line)

                    parent_bus1 = self._dss.cktelement.bus_names[0].split(".")[0]
                    parent_bus2 = self._dss.cktelement.bus_names[1].split(".")[0]

                    if parent_line.lower().startswith("transformer"):
                        length_km = 0

                    if not parent_line.lower().startswith("transformer"):
                        length_km = self._dss.lines.length

                    distance_accumulated = distance_accumulated + length_km

                    if distance_accumulated >= self._distance_goal:
                        self._dss.circuit.set_active_bus(parent_bus1)
                        kv_base_parent_bus1 = self._dss.bus.kv_base * 1000

                        if kv_base_parent_bus1 >= 1000:
                            if parent_bus1 not in buses_selected and not any(
                                    parent_bus1 in g for g in buses_groups.values()):
                                buses_selected.append(parent_bus1)

                                if buses_intermediate:
                                    previous_bus = buses_selected[-1]
                                    buses_groups[previous_bus] = list(set(buses_intermediate.copy()))
                                    buses_intermediate.clear()
                                    distance_accumulated = 0

                            elif parent_bus1 in buses_selected:
                                if parent_bus1 in buses_groups:
                                    existing_group = set(buses_groups[parent_bus1])
                                    new_group = set(buses_intermediate)
                                    buses_groups[parent_bus1] = list(existing_group.union(new_group))

                                else:
                                    buses_groups[parent_bus1] = list(set(buses_intermediate.copy()))

                                buses_intermediate.clear()
                                distance_accumulated = 0

                    elif parent_bus1 in buses_selected:
                        if parent_bus1 in buses_groups:
                            existing_group = set(buses_groups[parent_bus1])
                            new_group = set(buses_intermediate)
                            buses_groups[parent_bus1] = list(existing_group.union(new_group))

                        else:
                            buses_groups[parent_bus1] = list(set(buses_intermediate.copy()))

                        buses_intermediate.clear()
                        distance_accumulated = 0

                    else:
                        self._dss.circuit.set_active_bus(parent_bus1)
                        kv_base_parent_bus1 = self._dss.bus.kv_base * 1000
                        if kv_base_parent_bus1 >= 1000:
                            if parent_bus1 not in buses_selected and parent_bus1 not in buses_intermediate and not any(
                                    parent_bus1 in g for g in buses_groups.values()):
                                buses_intermediate.append(parent_bus1)

                        self._dss.circuit.set_active_bus(parent_bus2)
                        kv_base_parent_bus2 = self._dss.bus.kv_base * 1000
                        if kv_base_parent_bus2 >= 1000:
                            if parent_bus2 not in buses_selected and parent_bus2 not in buses_intermediate and not any(
                                    parent_bus2 in g for g in buses_groups.values()):
                                buses_intermediate.append(parent_bus2)

                if not first_bus and count_parent == 0:
                    self._dss.circuit.set_active_bus(bus1)
                    kv_base_bus1 = self._dss.bus.kv_base * 1000

                    if kv_base_bus1 >= 1000:
                        if bus1 not in buses_selected and not any(bus1 in g for g in buses_groups.values()):
                            buses_selected.append(bus1)
                            first_bus.append(bus1)

                elif not first_bus and count_parent != 0 and distance_accumulated <= self._distance_goal:
                    self._dss.circuit.set_active_bus(parent_bus1)
                    kv_base_parent_bus1 = self._dss.bus.kv_base * 1000

                    if kv_base_parent_bus1 >= 1000:
                        if not any(parent_bus1 in g for g in buses_groups.values()):
                            buses_intermediate = [b for b in buses_intermediate if b != parent_bus1]

                            if parent_bus1 not in buses_selected:
                                buses_selected.append(parent_bus1)
                                first_bus.append(parent_bus1)
                                previous_bus = buses_selected[-1]
                                buses_groups[previous_bus] = list(set(buses_intermediate.copy()))

                            else:
                                if parent_bus1 in buses_groups:
                                    existing_group = set(buses_groups[parent_bus1])
                                    new_group = set(buses_intermediate)
                                    buses_groups[parent_bus1] = list(existing_group.union(new_group))

                                else:
                                    buses_groups[parent_bus1] = list(set(buses_intermediate.copy()))

                distance_accumulated = 0
                buses_intermediate.clear()
                first_bus.clear()
                last_bus.clear()

            self._dss.meters.next()

        return buses_selected, buses_groups

    def __filling_data_hc(self, data_hc_incompleted, buses_groups, missing_buses):
        hc_dict = {entry["Bus"]: entry["HC"] for entry in data_hc_incompleted}

        for main_bus, group_buses in buses_groups.items():
            if main_bus in hc_dict:
                hc_value = hc_dict[main_bus]

                for child_bus in group_buses:
                    if child_bus not in hc_dict:
                        data_hc_incompleted.append({
                            "Bus": child_bus,
                            "HC": hc_value,
                            "HC_violation": "",
                            "Bus_violation": "",
                            "V_a": "",
                            "V_b": "",
                            "V_c": ""
                        })

        for bus in missing_buses:
            if not any(entry["Bus"] == bus for entry in data_hc_incompleted):
                data_hc_incompleted.append({
                    "Bus": bus,
                    "HC": 0,
                    "HC_violation": "",
                    "Bus_violation": "",
                    "V_a": "",
                    "V_b": "",
                    "V_c": ""
                })

        return data_hc_incompleted

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

    def __set_maxcontroliter(self):
        """
        Determina o controle máximo de iterações
        """
        self._dss.text("set maxcontroliter=100")

    def __set_maxiterations(self):
        """
        Determina o máximo de iterações
        """
        self._dss.text("set maxiterations=100")

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

    def find_project_root(marker_folder="ui"):
        """
        Retorna o nome da raiz do projeto para mesclar com o caminho correto de gravação dos arquivos.
        """
        path = pathlib.Path(__file__).resolve()
        for parent in path.parents:
            if (parent / marker_folder).exists():
                return parent
        raise FileNotFoundError(f"Raiz do projeto não encontrada contendo a pasta '{marker_folder}'.")

    def discover_feeders_for_substation(utility_path: str, substation: str) -> List[str]:
        """
        Espera que os feeders sejam subpastas dentro de:
        <project_root>/dss/<utility>/<substation>/
        Cada subpasta encontrada é considerada um feeder (ex: RAPA1301).
        """
        feeders = []
        utility_path = pathlib.Path(utility_path)
        substation_path = utility_path / substation
        if substation_path.exists():
            for entry in substation_path.iterdir():
                if entry.is_dir():
                    feeders.append(entry.name)
        return feeders

# ==========================
# Infra de execução
# ==========================
@dataclass
class Task:
    feeder: str
    substation: str
    month: int
    type_day: str
    config: Dict

def find_file(filename: str, search_path: str):
    """
    Procura por um arquivo com nome exato a partir de `search_path`.
    Retorna o primeiro caminho encontrado ou None.
    """
    for root, dirs, files in os.walk(search_path):
        if filename in files:
            return pathlib.Path(root) / filename
    return None

def make_output_paths(task: Task) -> Tuple[pathlib.Path, pathlib.Path, pathlib.Path]:
    project_root = HCSteps.find_project_root()
    relative_path = pathlib.Path(
        f"ui/static/scenarios/Hosting Capacity/{task.config['utility']}/{task.substation}/{task.feeder}/{task.type_day}/{task.config['year']}/{task.month}"
    )
    base_path = project_root / relative_path
    base_path.mkdir(parents=True, exist_ok=True)
    csv_path = base_path / f"HC_{task.feeder}_{task.month}_{task.type_day}.csv"
    json_path = base_path / f"{task.feeder}.json"
    return base_path, csv_path, json_path

def run_feeder_mode(utility, substation, feeder, year, months, type_days, config):
    # Verifica se já existe resultado
    temp_task = Task(feeder, substation, months[0], type_days[0], config)
    _, _, json_path = make_output_paths(temp_task)
    if json_path.exists():
        print(f"⏩ Resultado já existe para {feeder}/{type_days[0]}/{year}/{months[0]}. Pulando...")
        return

    # Localiza o Master.dss
    master_filename = f"{type_days[0]}_{months[0]}_Master_{utility}_{substation}_{feeder}.dss"
    utility_path = pathlib.Path(config['utility_path']).resolve()
    master_path = find_file(master_filename, search_path=utility_path)
    if master_path is None:
        print(f"❌ Master file não encontrado: {master_filename}")
        return

    # Cria interface DSS
    dss = py_dss_interface.DSS()
    hc = HCSteps(
        dss=dss,
        dss_file=str(master_path),
        max_kw=config["max_kw"],
        step_kw=config["step_kw"],
        ov_threshold=config["ov_threshold"],
        loadmult=config["loadmult"],
        distance_goal = config["distance_goal"]
    )

    print(f"🚀 Processando o Master: {master_filename} | {multiprocessing.current_process().name}")

    if config["buses_selected"] is True:
        data_hc, error_log = hc.hosting_capacity_distance()

    else:
        data_hc, error_log = hc.hosting_capacity_completed()

    # Salva resultados .json e .csv
    base_path, csv_path, json_path = make_output_paths(Task(feeder, substation, months[0], type_days[0], config))
    pd.DataFrame(data_hc).to_csv(csv_path, index=False)
    hc_dict = {item["Bus"]: item["HC"] for item in data_hc}
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump([hc_dict], f, ensure_ascii=False, indent=4)

    # Salva erros (se houver)
    if error_log:
        all_errors = []
        all_errors.extend(error_log)
        df_errors = pd.DataFrame(all_errors)
        errors_path = base_path / f"errors_convergence_{feeder}_{months[0]}_{type_days[0]}.csv"
        df_errors.to_csv(errors_path, index=False)

    print(f"✅ Alimentador {master_filename} processado com sucesso.")

def process_task(task: Task):
    utility = task.config.get("utility")
    substations = task.substation
    feeders = task.feeder
    year = str(task.config.get("year"))
    months = task.month
    type_days = task.type_day

    # Normalização para listas
    if isinstance(substations, str):
        substations = [substations]
    if isinstance(feeders, str):
        feeders = [feeders]
    if isinstance(months, (str, int)):
        months = [months]
    if isinstance(type_days, str):
        type_days = [type_days]

    # Loop principal
    for sub in substations:
        if feeders:
            for feeder in feeders:
                run_feeder_mode(
                    utility=utility,
                    substation=sub,
                    feeder=feeder,
                    year=year,
                    months=months,
                    type_days=type_days,
                    config=task.config
                )

def to_list(x):
    if x is None:
        return []
    if isinstance(x, list):
        return x
    return [x]

def build_tasks_from_config(config: Dict) -> List[Task]:
    utility = config["utility"]
    utility_path = os.path.join(config["utility_path"], utility)
    subs = to_list(config.get("substation", []))
    feeders = to_list(config.get("feeder", []))
    months = to_list(config.get("month", []))
    type_days = to_list(config.get("type_day", []))

    tasks: List[Task] = []

    # Descoberta de feeders por subestação
    for sub in subs:
        feeders_found = HCSteps.discover_feeders_for_substation(utility_path, sub)

        if feeders:
            feeders_to_process = [f for f in feeders_found if f in feeders]
        else:
            feeders_to_process = feeders_found

        if not feeders_found:
            print(f"⚠️ Nenhum feeder encontrado para subestação {sub}.")
            continue

        for feeder in feeders_to_process:
            for m in months:
                for td in type_days:
                    tasks.append(Task(feeder=feeder, substation=sub, month=int(m), type_day=str(td), config=config))
    return tasks


if __name__ == '__main__':
    inicio = time.time()
    base_dir = os.path.dirname(os.path.abspath(__file__))
    config_path = os.path.join(base_dir, "config_hc.yml")

    with open(config_path, "r", encoding="utf-8") as file:
        config = yaml.safe_load(file)["data_HC"]

    tasks = build_tasks_from_config(config)
    if not tasks:
        print("Nenhuma tarefa criada. Verifique o config_hc.yml e pastas de feeders.")
        sys.exit(1)

    cpu_cores = max(multiprocessing.cpu_count() - 6, 1)
    print(f"⚡ Utilizando {cpu_cores} processadores.")

    with multiprocessing.Pool(processes=cpu_cores) as pool:
        pool.map(process_task, tasks)

    pool.close()
    pool.join()
    del pool

    All.run_all_unifications(config)

    fim = time.time()
    tempo_total = fim - inicio

    horas = int(tempo_total // 3600)
    minutos = int((tempo_total % 3600) // 60)
    segundos = int(tempo_total % 60)

    print(f"Tempo total de execução: {horas:02d}h{minutos:02d}min{segundos:02d}seg")
    print("\n✅ Execution completed")