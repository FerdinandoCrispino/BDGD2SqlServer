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
import json
from Tools.tools import get_trafo_from_load, get_demand_from_load, nome_banco, nos
from dataclasses import dataclass, asdict
from typing import Optional, List

# config yaml - acess to database
database = '391_2024'


@dataclass
class DRP:
    load: str = ""
    tipo: str = ""
    num_leituras: int = 0
    value: float = 0
    bus: Optional[str] = ""
    drp_l: float = 0.03  # limites para os indicadores individuais DRP
    tusd: float = 0.45667
    demanda: float = 0.1
    drp_comp: float = 0.0

    def __post_init__(self):
        k = 0
        if self.value > self.drp_l:
            k = 3
        self.drp_comp = ((self.value - self.drp_l) / 100) * k * self.tusd * self.demanda


@dataclass
class DRC:
    load: str = ""
    tipo: str = ""
    num_leituras: int = 0
    value: float = 0
    bus: Optional[str] = ""
    drc_l: float = 0.005  # limites para os indicadores individuais DRC
    tusd: float = 0.45667
    demanda: float = 0.1    # kWh
    drc_comp: float = 0.0

    def __post_init__(self):
        k = 0
        if self.value > self.drc_l:
            if self.tipo == 'bt':
                k = 7
            else:
                k = 3
        self.drc_comp = ((self.value - self.drc_l) / 100) * k * self.tusd * self.demanda

@dataclass
class Indicadores:
    drc: List[DRC]
    drp: List[DRP]
    data_ref: str               # mês de referencia do indicador
    circuito: str
    nl: int                     # total de unidades consumidoras objeto de medição;
    nc: int = 0                 # total de unidades consumidoras com indicador individual DRC diferente de 0 (zero);
    icc: Optional[float] = 0    # Índice de Unidades Consumidoras com Tensão Crítica
    drp_e: float = 0            # Duração Relativa da Transgressão de Tensão Precária Equivalente
    drc_e: float = 0            # Duração Relativa da Transgressão de Tensão Crítica Equivalente

    def __post_init__(self):
        self.nc = len(self.drc)
        self.icc = round((self.nc / self.nl) * 100, 3)
        self.drp_e = round(sum([x.value / self.nl for x in self.drp]), 3)
        self.drc_e = round(sum([x.value / self.nl for x in self.drc]), 3)


def convert2polar(real, imag):
    z = complex(real, imag)
    return cmath.polar(z)


def safe_divide(numerator, denominator):
    return numerator / denominator if denominator != 0 else 0


def plot_indic(circuit):
    with open(rf'C:\pastaD\TSEA\Analises\base_case\{circuit}indicadores.json', 'r') as f:
        p_dict = json.load(f)

        # Plotting
    drc = p_dict["drc"]
    drp = p_dict["drp"]

    # Criar dicionários: load -> value
    drc_dict = {item["load"]: item["value"] for item in drc}
    drp_dict = {item["load"]: item["value"] for item in drp}

    # União dos loads
    todos_loads = list(set(drc_dict.keys()) | set(drp_dict.keys()))

    # Criar lista combinada: (load, drc, drp)
    dados_combinados = [
        (l, drc_dict.get(l, 0), drp_dict.get(l, 0))
        for l in todos_loads
    ]

    # 🔥 Ordenar pelo DRP (índice 2), do maior para o menor
    dados_ordenados = sorted(dados_combinados, key=lambda x: x[2], reverse=True)

    # Separar novamente
    labels = [item[0][:10] + "..." for item in dados_ordenados]
    drc_values = [item[1] for item in dados_ordenados]
    drp_values = [item[2] for item in dados_ordenados]

    # Posição das barras
    x = range(len(labels))
    width = 0.4

    # Criar gráfico
    plt.figure(figsize=(14, 6))

    plt.bar([i - width / 2 for i in x], drc_values, width=width, label="DRC")
    plt.bar([i + width / 2 for i in x], drp_values, width=width, label="DRP")

    plt.xticks(list(x), labels, rotation=45)
    plt.xlabel('Cargas')
    plt.ylabel('Duração Relativa da Transgressão de Tensão %')
    plt.title(f'{circuit} - Indicadores individuais de tensão')
    plt.legend()
    plt.tight_layout()
    plt.show()


class Condition:
    def __init__(self, circuit, dss_file, total_patamar):

        self.circuit = circuit
        self.dss_file = dss_file
        self.total_patamar = total_patamar

        self.bt_undervoltage_prec = pd.DataFrame()
        self.bt_undervoltage_crit = pd.DataFrame()
        self.bt_overvoltage_prec = pd.DataFrame()
        self.bt_overvoltage_crit = pd.DataFrame()

        self.mt_undervoltage_prec = pd.DataFrame()
        self.mt_undervoltage_crit = pd.DataFrame()
        self.mt_overvoltage_prec = pd.DataFrame()
        self.mt_overvoltage_crit = pd.DataFrame()

        self.bt_undervoltage_prec_2 = pd.DataFrame()
        self.bt_undervoltage_crit_2 = pd.DataFrame()
        self.bt_overvoltage_prec_2 = pd.DataFrame()
        self.bt_overvoltage_crit_2 = pd.DataFrame()

        self.mt_undervoltage_prec_2 = pd.DataFrame()
        self.mt_undervoltage_crit_2 = pd.DataFrame()
        self.mt_overvoltage_prec_2 = pd.DataFrame()
        self.mt_overvoltage_crit_2 = pd.DataFrame()

        self._transformer_kv_map = None

        self.dss = self.__read_dss_file()

        # Check kv_base
        self.__check_kv_base()

        # rodar novamente para verificar que as alerações foram realizadas
        # self.__check_kv_base()

        # insere energymeter em cada transformador para obter as suas cargas
        # self.__add_energymeters()
        self.__get_num_buses()

        self.__solve_circuit()

        self.__get_load_class()

        self.plot_data_result()
        self.plot_data_result_2()

        self.__indic_DRP_DRC()

    def __check_kv_base(self):
        """
        Verifica a tensão de base definida pelo openDSS para as todas as barras conectadas
        no secundario dos transformadores.
        São obtidas as tensões de fase para a barra do secundario do TR e comparada com a informada pelo openDSS
        Em caso de diferença são localizadas todas barras conectadas no secundario do transformador e set o kv_base
        de todas as barras com o valor obtido da avaliação das conecções do transformador.
        :return:
        """
        # identifica a tensão de linha e de fase para cada transformador
        dss = self.dss
        tr_map = {}
        dss.transformers.first()
        vln = vll = None
        for _ in range(dss.transformers.count):
            dss.circuit.set_active_element(f"transformer.{dss.transformers.name}")
            tr_ph = dss.cktelement.num_phases
            if tr_ph == 3:
                dss.transformers.wdg = 2
                vll = dss.transformers.kv
                vln = dss.transformers.kv / np.sqrt(3)
            elif tr_ph == 1:
                num_wdg = dss.transformers.num_windings
                if num_wdg == 2:
                    dss.transformers.wdg = 2
                    if dss.transformers.is_delta:
                        vll = dss.transformers.kv
                        vln = vll / 2
                    else:
                        vln = dss.transformers.kv
                        vll = vln * 2
                elif num_wdg == 3:
                    dss.transformers.wdg = 2
                    vln = dss.transformers.kv
                    vll = 2 * vln

            tr_map[dss.transformers.name] = (round(vll, 3), round(vln, 3))

            bus_name = dss.cktelement.bus_names
            element_name = dss.cktelement.name
            dss.circuit.set_active_bus(bus_name[1])
            bus_name1 = dss.bus.name
            kv_base = dss.bus.kv_base
            # Verifica se ha diferença entre o calculado e o descrito pelo opnDSS
            if round(vln, 3) != round(kv_base, 3):
                print(f'{element_name}: {bus_name1}: {kv_base}: {vln}')
                # todo testar para ver se setar a tensão de linha e a tensão de fase fazem diferença !!!!
                dss.text(f'SetkVBase Bus={bus_name1} kVLL={vll}')
                dss.text(f'SetkVBase Bus={bus_name1} kVLN={vln}')
                print(f'Valor alterado: {dss.cktelement.bus_names[1]} - kvbase:{dss.bus.kv_base}')

                # Localozar o transformador que foi alterado o valor de kvbase atraves da topologia
                dss.topology.first()
                while True:
                    indx = dss.topology.active_branch
                    indx_level = dss.topology.active_level
                    branch_name = dss.topology.branch_name
                    if branch_name == element_name:
                        dss.circuit.set_active_element(element_name)
                        dss.circuit.set_active_bus(dss.cktelement.bus_names[1])
                        # encontrou o transformador que foi alterado com setkvbase
                        break
                    index_branch = dss.topology.forward_branch()

                # busca os ramais conectados neste transformador
                while True:
                    index_branch_2 = dss.topology.next()
                    indx_level_2 = dss.topology.active_level
                    branch_name_2 = dss.topology.branch_name
                    if not dss.topology.branch_name.startswith(('Line.sbt', 'Line.rbt')):
                        print('\n Proximo transformador !!! \n')
                        break
                    # sekvbase aqui
                    dss.circuit.set_active_element(branch_name_2)
                    dss.circuit.set_active_bus(dss.cktelement.bus_names[1])
                    kv_base_2 = dss.bus.kv_base
                    print(f'{branch_name_2}: {dss.cktelement.bus_names}: {kv_base_2}')
                    dss.text(f'SetkVBase Bus={bus_name1} kVLL={vll}')
                    dss.text(f'SetkVBase Bus={bus_name1} kVLN={vln}')
                    print(f'Valor alterado: {dss.cktelement.bus_names[1]} - kvbase:{dss.bus.kv_base}')
            dss.transformers.next()

        self._transformer_kv_map = tr_map

    def __indic_DRP_DRC(self):
        """
        # Indicadores individuais de tensão em regime permanente
        nlp = maior valor entre as fases do número de leituras situadas na faixa precária; e
        nlc = maior valor entre as fases do número de leituras situadas na faixa crítica.
        :return:
        """
        indic_data_ref = '20260301'
        nun_leituras = self.total_patamar    # int(1008 / 7)  # amostras 10 min, 7 dias = 168 horas
        drc_list = []
        drp_list = []
        demand_load_bt = get_demand_from_load(self.circuit, 'UCBT', database)
        demand_load_bt['cod_id'] = "bt_" + demand_load_bt['cod_id'] + "_m1"
        demand_load_mt = get_demand_from_load(self.circuit, 'UCMT', database)
        demand_load_mt['cod_id'] = "mt_" + demand_load_mt['cod_id'] + "_m1"

        #bus_carga.merge(demand_load_bt[['cod_id', 'avg_demand']], left_on='load', right_on='cod_id', how='left')

        # load_violation = self.all_load_violation.loc[self.all_load_violation['classe'] != 'adeq'].copy()
        load_violation = self.all_load_violation.loc[
            self.all_load_violation['classe'] != 'adeq',
            ['load', 'classe', 'patamar', 'bus', 'tipo']
        ].copy()

        # Contar patamares únicos por load/tipo/classe
        agg = (
            load_violation.groupby(['load', 'tipo', 'classe'])['patamar']
                .nunique()
                .unstack(fill_value=0)
        )
        # Garantir colunas (caso alguma não exista)
        cols = [
            'bt_undervoltage_prec', 'bt_undervoltage_crit',
            'bt_overvoltage_prec', 'bt_overvoltage_crit',
            'mt_undervoltage_prec', 'mt_undervoltage_crit',
            'mt_overvoltage_prec', 'mt_overvoltage_crit'
        ]
        agg = agg.reindex(columns=cols, fill_value=0)

        for (load, tipo), row in agg.groupby(level=[0, 1]):
            row = row.iloc[0]
            demanda = 0
            if tipo == 'bt':
                nlp = row['bt_undervoltage_prec'] + row['bt_overvoltage_prec']
                nlc = row['bt_undervoltage_crit'] + row['bt_overvoltage_crit']
                demanda = demand_load_bt.loc[demand_load_bt['cod_id'] == load, ['avg_demand']].values[0][0]
            else:
                nlp = row['mt_undervoltage_prec'] + row['mt_overvoltage_prec']
                nlc = row['mt_undervoltage_crit'] + row['mt_overvoltage_crit']
                demanda = demand_load_mt.loc[demand_load_mt['cod_id'] == load, ['avg_demand']].values[0][0]

            if nlp > 0:
                drp_list.append(DRP(load=load, tipo=tipo, demanda=demanda, num_leituras=nun_leituras, value=(nlp / nun_leituras) * 100))

            if nlc > 0:
                drc_list.append(DRC(load=load, tipo=tipo, num_leituras=nun_leituras, value=(nlc / nun_leituras) * 100))

        indicadores = Indicadores(
            drc=drc_list,
            drp=drp_list,
            data_ref=indic_data_ref,
            circuito=self.circuit,
            #nl=agg.index.get_level_values(0).nunique()
            nl=self.all_load_violation['load'].unique().shape[0]
        )

        """
        loads = load_violation['load'].unique()
        for load in loads:
            cond_bt_undervoltage_prec = (load_violation['classe'] == 'bt_undervoltage_prec') & (
                        load_violation['load'] == load)
            cond_bt_undervoltage_crit = (load_violation['classe'] == 'bt_undervoltage_crit') & (
                        load_violation['load'] == load)
            cond_bt_overvoltage_prec = (load_violation['classe'] == 'bt_overvoltage_prec') & (
                        load_violation['load'] == load)
            cond_bt_overvoltage_crit = (load_violation['classe'] == 'bt_overvoltage_crit') & (
                        load_violation['load'] == load)

            cond_mt_undervoltage_prec = (load_violation['classe'] == 'mt_undervoltage_prec') & (
                    load_violation['load'] == load)
            cond_mt_undervoltage_crit = (load_violation['classe'] == 'mt_undervoltage_crit') & (
                    load_violation['load'] == load)
            cond_mt_overvoltage_prec = (load_violation['classe'] == 'mt_overvoltage_prec') & (
                    load_violation['load'] == load)
            cond_mt_overvoltage_crit = (load_violation['classe'] == 'mt_overvoltage_crit') & (
                    load_violation['load'] == load)

            nlp_undervoltage_bt = load_violation.loc[cond_bt_undervoltage_prec, 'patamar'].nunique()
            nlc_undervoltage_bt = load_violation.loc[cond_bt_undervoltage_crit, 'patamar'].nunique()
            nlp_overvoltage_bt = load_violation.loc[cond_bt_overvoltage_prec, 'patamar'].nunique()
            nlc_overvoltage_bt = load_violation.loc[cond_bt_overvoltage_crit, 'patamar'].nunique()

            nlp_undervoltage_mt = load_violation.loc[cond_mt_undervoltage_prec, 'patamar'].nunique()
            nlc_undervoltage_mt = load_violation.loc[cond_mt_undervoltage_crit, 'patamar'].nunique()
            nlp_overvoltage_mt = load_violation.loc[cond_mt_overvoltage_prec, 'patamar'].nunique()
            nlc_overvoltage_mt = load_violation.loc[cond_mt_overvoltage_crit, 'patamar'].nunique()

            nlp_bt = np.nansum([nlp_undervoltage_bt, nlp_overvoltage_bt])
            nlc_bt = np.nansum([nlc_undervoltage_bt, nlc_overvoltage_bt])
            nlp_mt = np.nansum([nlp_undervoltage_mt, nlp_overvoltage_mt])
            nlc_mt = np.nansum([nlc_undervoltage_mt, nlc_overvoltage_mt])

            if nlp_bt > 0:
                drp = DRP(load=load, tipo="bt", value=((nlp_bt / nun_leituras) * 100))
                drp_list.append(drp)
            if nlc_bt > 0:
                drc = DRC(load=load, tipo="bt", value=((nlc_bt / nun_leituras) * 100))
                drc_list.append(drc)
            if nlp_mt > 0:
                drp = DRP(load=load, tipo="mt", num_leituras=nun_leituras, value=((nlp_mt / nun_leituras) * 100))
                drp_list.append(drp)
            if nlc_mt > 0:
                drc = DRC(load=load, tipo="mt", num_leituras=nun_leituras, value=((nlc_mt / nun_leituras) * 100))
                drc_list.append(drc)

        indicadores = Indicadores(drc=drc_list, drp=drp_list, data_ref=indic_data_ref, nl=len(loads))
        """
        p_dict = asdict(indicadores)

        # write json
        with open(rf'C:\pastaD\TSEA\Analises\base_case\{self.circuit}_indicadores.json', 'w') as f:
            # Convert dataclass to a dictionary

            # Serialize the dictionary to a JSON string
            indi_json = json.dumps(p_dict, indent=4)
            f.write(indi_json)

    def __indic_DRP_DRC_old(self):
        """
        # Indicadores individuais de tensão em regime permanente
        nlp = maior valor entre as fases do número de leituras situadas na faixa precária; e
        nlc = maior valor entre as fases do número de leituras situadas na faixa crítica.
        :return:
        """
        indic_data_ref = '20260701'
        nun_leituras = int(1008 / 7)  # amostras 10 min, 7 dias = 168 horas
        drc_list = []
        drp_list = []

        # selecionar as barras de carga
        bus_carga = self.load_bus.loc[(self.load_bus['tr_vln'] > 0) & (self.load_bus['load'].str.endswith('m1')) &
                                      (~self.load_bus['load'].str.startswith('pip'))]

        for bus_name, load, node in zip(bus_carga['bus'], bus_carga['load'], bus_carga['node']):
            nlp_undervoltage = 0
            nlp_overvoltage = 0
            nlc_undervoltage = 0
            nlc_overvoltage = 0

            if load.startswith('bt'):
                df_nlp_undervoltage = self.bt_undervoltage_prec.loc[(self.bt_undervoltage_prec['tr_vln'] > 0) &
                                                                    (self.bt_undervoltage_prec[
                                                                         'bus'] == bus_name)].drop_duplicates()
                if not df_nlp_undervoltage.empty:
                    nlp_undervoltage = df_nlp_undervoltage[
                        'patamar'].nunique()  # df_nlp_undervoltage.loc[df_nlp_undervoltage['nodes'].isin(node)]

                df_nlp_overvoltage = self.bt_overvoltage_prec.loc[(self.bt_overvoltage_prec['tr_vln'] > 0) &
                                                                  (self.bt_undervoltage_prec[
                                                                       'bus'] == bus_name)].drop_duplicates()
                if not df_nlp_overvoltage.empty:
                    nlp_overvoltage = df_nlp_overvoltage['patamar'].nunique()

                nlp = nlp_undervoltage + nlp_overvoltage

                df_nlc_undervoltage = self.bt_undervoltage_crit.loc[(self.bt_undervoltage_crit['tr_vln'] > 0) &
                                                                    (self.bt_undervoltage_crit[
                                                                         'bus'] == bus_name)].drop_duplicates()
                if not df_nlc_undervoltage.empty:
                    nlc_undervoltage = df_nlc_undervoltage['patamar'].nunique()

                df_nlc_overvoltage = self.bt_overvoltage_crit.loc[(self.bt_overvoltage_crit['tr_vln'] > 0) &
                                                                  (self.bt_undervoltage_crit[
                                                                       'bus'] == bus_name)].drop_duplicates()
                if not df_nlc_overvoltage.empty:
                    nlc_overvoltage = df_nlc_overvoltage['patamar'].nunique()

                nlc = nlc_undervoltage + nlc_overvoltage

                if nlp > 0:
                    drp = DRP(load=load, tipo="bt", bus=bus_name, value=((nlp / nun_leituras) * 100))
                    drp_list.append(drp)
                if nlc > 0:
                    drc = DRC(load=load, tipo="bt", bus=bus_name, value=((nlc / nun_leituras) * 100))
                    drc_list.append(drc)
            else:
                # indicador para a MT
                df_nlp_undervoltage = self.mt_undervoltage_prec.loc[(self.mt_undervoltage_prec['tr_vln'] > 0) &
                                                                    (self.mt_undervoltage_prec[
                                                                         'bus'] == bus_name)].drop_duplicates()
                if not df_nlp_undervoltage.empty:
                    nlp_undervoltage = df_nlp_undervoltage['patamar'].nunique()
                nlp = nlp_undervoltage

                df_nlc_undervoltage = self.mt_undervoltage_crit.loc[(self.mt_undervoltage_crit['tr_vln'] > 0) &
                                                                    (self.mt_undervoltage_crit[
                                                                         'bus'] == bus_name)].drop_duplicates()
                if not df_nlc_undervoltage.empty:
                    nlc_undervoltage = df_nlc_undervoltage['patamar'].nunique()

                df_nlc_overvoltage = self.mt_overvoltage_crit.loc[(self.mt_overvoltage_crit['tr_vln'] > 0) &
                                                                  (self.mt_overvoltage_crit[
                                                                       'bus'] == bus_name)].drop_duplicates()
                if not df_nlc_overvoltage.empty:
                    nlc_overvoltage = df_nlc_overvoltage['patamar'].nunique()
                nlc = nlc_undervoltage + nlc_overvoltage

                if nlp > 0:
                    drp = DRP(load=load, tipo="mt", bus=bus_name, value=((nlp / nun_leituras) * 100))
                    drp_list.append(drp)
                if nlc > 0:
                    drc = DRC(load=load, tipo="mt", bus=bus_name, value=((nlc / nun_leituras) * 100))
                    drc_list.append(drc)

        indicadores = Indicadores(drc=drc_list, drp=drp_list, data_ref=indic_data_ref, circuito=self.circuit, nl=len(bus_carga))

        p_dict = asdict(indicadores)

        # write json
        with open(rf'C:\pastaD\TSEA\Analises\base_case\{self.circuit}indicadores.json', 'w') as f:
            # Convert dataclass to a dictionary

            # Serialize the dictionary to a JSON string
            indi_json = json.dumps(p_dict, indent=4)
            f.write(indi_json)

    def __get_load_class(self):

        bus_stats = (
            self.all_bus_kv
            .groupby(['bus', 'patamar'])['vln_pu']
            .agg(min_pu='min', max_pu='max')
            .reset_index()
        )

        bus_carga = self.load_bus.loc[(~self.load_bus['load'].str.startswith('pip'))]
        self.all_load_violation = bus_carga.merge(bus_stats, on='bus', how='left')

        self.all_load_violation['tipo'] = self.all_load_violation['load'].str[:2]
        is_bt = self.all_load_violation['tipo'] == 'bt'
        is_mt = self.all_load_violation['tipo'] == 'mt'

        conditions = [
            (is_bt & (self.all_load_violation['min_pu'] > 0.2) & (self.all_load_violation['min_pu'] < 0.866)),
            (is_bt & (self.all_load_violation['min_pu'] >= 0.866) & (self.all_load_violation['min_pu'] < 0.92)),
            (is_bt & (self.all_load_violation['max_pu'] > 1.05) & (self.all_load_violation['max_pu'] <= 1.063)),
            (is_bt & (self.all_load_violation['max_pu'] > 1.063)),
            (is_mt & (self.all_load_violation['min_pu'] >= 0.90) & (self.all_load_violation['min_pu'] < 0.93)),
            (is_mt & (self.all_load_violation['min_pu'] > 0.2) & (self.all_load_violation['min_pu'] < 0.90)),
            (is_mt & (self.all_load_violation['max_pu'] > 1.05)),
        ]

        choices = [
            "bt_undevoltage_crit",
            "bt_undervoltage_prec",
            "bt_overvoltage_prec",
            "bt_overvoltage_crit",
            "mt_undervoltage_prec",
            "mt_undervoltage_crit",
            "mt_overvoltage_crit",
        ]

        self.all_load_violation['classe'] = np.select(conditions, choices, default='adeq')
        self.all_load_violation.to_csv(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_list_all_load_classe.csv')

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

    def __get_transformer_from_load(self, load):
        """

        :param load:
        :return:
        """
        table_load = ''
        vln = vll = 0
        load_name = load[3:-3]
        if load.startswith('pip'):
            load_name = load[4:-3]
            table_load = 'PIP'
        elif load.startswith('bt'):
            load_name = load[3:-3]
            table_load = 'UCBT'
        elif load.startswith('mt'):
            return self.dss.circuit.name
        else:
            print("Erro tipo de carga desconhecida!!!")
        tr_name, tr = get_trafo_from_load(load_name, circuito, table_load, database)
        return tr_name

    def __get_transformer_kv_base(self, load, node):
        """

        :param load:
        :return:
        """
        table_load = ''
        vln = vll = 0
        load_name = load[3:-3]
        if load.startswith('pip'):
            load_name = load[4:-3]
            table_load = 'PIP'
        elif load.startswith('bt'):
            load_name = load[3:-3]
            table_load = 'UCBT'
        elif load.startswith('mt'):
            return round(self.dss.vsources.base_kv, 3), round(self.dss.vsources.base_kv / np.sqrt(3), 3)
        else:
            print("Erro tipo de carga desconhecida!!!")

        tr_name, tr = get_trafo_from_load(load_name, circuito, table_load, database)

        """
        for i in range(tr.shape[0]): # banco de transformadores
            # if tr['MRT'][0] == 1:

            if len(node) != 3:
                for n in node:
                    if str(n) in nos(tr['LIG_FAS_S'][i]):
                        print(f'find {n}')
        """
        self.dss.transformers.first()
        for _ in range(self.dss.transformers.count):
            tr_nome = self.dss.transformers.name
            if tr_name.lower() == tr_nome[4:-1].lower():
                self.dss.circuit.set_active_element(f"transformer.{tr_nome}")
                tr_ph = self.dss.cktelement.num_phases
                if tr_ph == 3:
                    self.dss.transformers.wdg = 2
                    vll = self.dss.transformers.kv
                    vln = self.dss.transformers.kv / np.sqrt(3)

                elif tr_ph == 1:
                    num_wdg = self.dss.transformers.num_windings
                    if num_wdg == 2:
                        self.dss.transformers.wdg = 2
                        if self.dss.transformers.is_delta:
                            vll = self.dss.transformers.kv
                            vln = vll / 2
                        else:
                            vln = self.dss.transformers.kv
                            vll = vln * 2
                    elif num_wdg == 3:
                        self.dss.transformers.wdg = 2
                        vln = self.dss.transformers.kv
                        vll = 2 * vln

                # energymeter_voltage[self._dss.transformers.name] = (round(vll, 2), round(vln, 2))
                break
            self.dss.transformers.next()

        return round(vll, 3), round(vln, 3)

    def __add_energymeters(self):
        energymeter_voltage = dict()
        self.dss.transformers.first()
        for _ in range(self.dss.transformers.count):
            self.dss.text(f"new energymeter.{self.dss.transformers.name} "
                          f"element=transformer.{self.dss.transformers.name} terminal=1")

            self.dss.circuit.set_active_element(f"transformer.{self.dss.transformers.name}")
            tr_ph = self.dss.cktelement.num_phases

            if tr_ph == 3:
                self.dss.transformers.wdg = 2
                vll = self.dss.transformers.kv
                vln = self.dss.transformers.kv / np.sqrt(3)

            elif tr_ph == 1:
                num_wdg = self.dss.transformers.num_windings

                if num_wdg == 2:
                    self.dss.transformers.wdg = 2
                    if self.dss.transformers.is_delta:
                        vll = self.dss.transformers.kv
                        vln = vll / np.sqrt(3)
                    else:
                        vln = self.dss.transformers.kv
                        vll = vln * np.sqrt(3)
                elif num_wdg == 3:
                    self.dss.transformers.wdg = 2
                    vln = self.dss.transformers.kv
                    vll = 2 * vln

            energymeter_voltage[self.dss.transformers.name] = (round(vll, 2), round(vln, 2))
            self.dss.transformers.next()

    def __get_load_bus(self):
        load_bus_list = []
        loads = self.dss.loads.names
        loads_filter = [name for name in loads if not name[:3] == 'pip']
        loads_filter_m1 = [name for name in loads_filter if name.endswith('m1')]

        data = []
        append = data.append

        tr_map = self._transformer_kv_map
        tr_map[f'trf_{self.dss.circuit.name.lower()}a'] = [self.dss.vsources.base_kv, self.dss.vsources.base_kv/np.sqrt(3)]
        tr_cache = {}

        print(f"Obtendo as tensões das cargas a partir das tensões dos seus transformadores...")
        for load in loads_filter_m1:
            # self.dss.circuit.set_active_element(f'Load.{load}')
            self.dss.loads.name = load  # ativa diretamente o load
            elem = self.dss.cktelement
            tr_key = tr_cache.get(load)
            if tr_key is not None:
                tr_vll, tr_vln = tr_map(tr_key, (None, None))
            else:
                tr_name = self.__get_transformer_from_load(load)
                tr_name = f'trf_{tr_name}a'
                if tr_name:
                    tr_cache[load] = tr_name.lower()
                    tr_vll, tr_vln = tr_map.get(tr_name.lower(), (None, None))

            #tr_vll, tr_vln = self.__get_transformer_kv_base(load, elem.node_order)
            #print(f'{load}: Vll:{tr_vll}  vln:{tr_vln}')
            append((
                elem.bus_names[0].split('.', 1)[0],
                elem.node_order,
                load,
                tr_vll,
                tr_vln
            ))

        return pd.DataFrame(data, columns=["bus", "node", "load", "tr_vll", "tr_vln"])

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
        dss.text("set controlmode = time")   # Todo avaliar resultado para Static
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

    def __get_num_buses(self):
        self.all_num_buses = len(self.dss.circuit.nodes_names)
        self.phases_num_buses = sum(not node.endswith('.4') for node in self.dss.circuit.nodes_names)
        self.bt_phases_num_buses = sum((not node.endswith('.4')) & (node.startswith('bt'))
                                       for node in self.dss.circuit.nodes_names)
        self.mt_phases_num_buses = sum((not node.endswith('.4')) & (node.startswith('mt'))
                                       for node in self.dss.circuit.nodes_names)

        # load and bus
        self.load_bus = self.__get_load_bus()

        # Export the DataFrame to an Excel
        self.load_bus.to_excel(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_load_bus.xlsx')

        # self.total_loads = len(self.load_bus)
        self.total_loads_bt = 0
        self.total_loads_mt = 0
        for load in self.load_bus['load']:
            if 'bt' in load:
                self.total_loads_bt += 1
            if 'mt' in load:
                self.total_loads_mt += 1
        print(f'Circuito: {self.circuit} - Total loads bt:{self.total_loads_bt} Total loads_mt:{self.total_loads_mt}')

    def __solve_circuit(self):
        total_number = self.total_patamar

        voltage_bus_list_all = []
        voltage_bus_list = []

        for number in range(1, total_number + 1):
            print(f"Patamar:{number}")
            self.dss.solution.solve()
            status = self.dss.solution.converged
            if status == 0:
                print(f'OpenDSS: File {self.dss_file} not solved to time {number}!')
                # TODO Alterar potencia e tentar a convergencia novamente.
                # executar o mesmo patamar alterando levemente a potencia
                self.dss.text(f"set number = {number}")
                self.dss.text(f"set loadmult=1.01")
                self.dss.solution.solve()
                status = self.dss.solution.converged
                if status == 0:
                    print(f'OpenDSS: File {self.dss_file} alter loadMult 1.01 and not solved to time {number}!')
                    # return False
                    continue
                else:
                    print(f'OpenDSS: File {self.dss_file} alter loadMult 1.01 and solved to time {number}!')

            all_v_mag = self.dss.circuit.buses_vmag_pu  # Tensões de fase
            all_bus_name = self.dss.circuit.nodes_names

            my_dict = dict(zip(all_bus_name, all_v_mag))
            voltage_bus_list.append(my_dict.copy())

            vll_list = []
            for bus_name in self.dss.circuit.nodes_names:
                active_bus, bus_node = bus_name.split('.', 1)
                self.dss.circuit.set_active_bus(active_bus)

                # print(bus_name)
                if bus_node == '4':  # para desconsiderar tensão de neutro
                    continue
                # if self.dss.bus.kv_base < 1:  # para desconsiderar a baixa tensão
                #    continue
                num_nodes = len(self.dss.bus.vll) // 2
                # num_nodes = self.dss.bus.num_nodes
                # Não existe valores de tensão de linha para barras monofásicas
                if num_nodes == 1:
                    pos = 0
                    vll_1 = 0
                    vll_pu_1 = 0
                else:
                    pos = int(bus_node) - 1
                    vll_1 = round(convert2polar(self.dss.bus.vll[pos * 2],
                                                self.dss.bus.vll[(pos * 2) + 1])[0], 3)
                    vll_pu_1 = round(
                        convert2polar(self.dss.bus.pu_vll[pos * 2], self.dss.bus.pu_vll[(pos * 2) + 1])[0], 3)

                # tensões de fase
                # print(self.dss.bus.kv_base)
                # print(self.dss.bus.vmag_angle)
                vln_1 = round(convert2polar(self.dss.bus.voltages[pos * 2],
                                            self.dss.bus.voltages[(pos * 2) + 1])[0], 3)
                vln_pu_1 = round(convert2polar(self.dss.bus.pu_voltages[pos * 2],
                                               self.dss.bus.pu_voltages[(pos * 2) + 1])[0], 3)

                all_bus_kv = self.load_bus.loc[self.load_bus['bus'] == bus_name.split('.')[0]]
                tr_vln = 0
                if not all_bus_kv.empty:
                    tr_vln = all_bus_kv['tr_vln'].values[0]

                vll_list.append([f"{bus_name.split('.')[0]}", pos + 1, vll_1, vll_pu_1, vln_1, tr_vln, vln_pu_1,
                                 self.dss.bus.kv_base])

            for bus, nodes, vll, vll_pu, vln, tr_vln, vln_pu, kv_base in vll_list:
                voltage_bus_list_all.append({"patamar": number, "bus": bus, "nodes": nodes, "vll": vll, "vln": vln,
                                             "vll_pu": vll_pu, "vln_pu": vln_pu, "tr_vln": tr_vln,
                                             "tr_kv_base": safe_divide(vln, tr_vln) / 1000, "kv_base": kv_base})

        # proc_time_ini = time.time()

        self.all_bus_kv = pd.DataFrame(voltage_bus_list_all)
        self.all_bus_kv['tr_vln'] = pd.to_numeric(self.all_bus_kv['tr_vln'], errors='coerce')
        self.all_bus_kv = self.all_bus_kv.sort_values(['patamar', 'tr_vln', 'kv_base'])

        # para transformadores fase-fase obert o valor da tensão de linha
        self.all_bus_kv.loc[self.all_bus_kv['vln_pu'] == 0, 'vln_pu'] = self.all_bus_kv['vll']/self.all_bus_kv['kv_base'] / 1000
        
        # print(f"total: {round(time.time() - proc_time_ini, 4)}")

        # CLASSIFICAÇÃO VETORIZADA (muito mais rápida)
        bt = self.all_bus_kv['kv_base'] <= 1
        mt = self.all_bus_kv['kv_base'] > 1
        v = self.all_bus_kv['vln_pu']

        self.bt_undervoltage_crit = self.all_bus_kv[bt & (v < 0.866) & (v > 0.2)]
        self.bt_undervoltage_prec = self.all_bus_kv[bt & (v < 0.92) & (v >= 0.866)]
        self.bt_overvoltage_prec = self.all_bus_kv[bt & (v > 1.05) & (v <= 1.063)]
        self.bt_overvoltage_crit = self.all_bus_kv[bt & (v > 1.063)]

        self.mt_undervoltage_prec = self.all_bus_kv[mt & (v < 0.93) & (v >= 0.90)]
        self.mt_undervoltage_crit = self.all_bus_kv[mt & (v < 0.90) & (v > 0.2)]
        self.mt_overvoltage_crit = self.all_bus_kv[mt & (v > 1.05)]

        """
        self.bt_undervoltage_crit = self.all_bus_kv[
            (self.all_bus_kv['kv_base'] <= 1) & (self.all_bus_kv['vln_pu'] < 0.866) & (self.all_bus_kv['vln_pu'] > 0.2)]
        self.bt_undervoltage_prec = self.all_bus_kv[
            (self.all_bus_kv['kv_base'] <= 1) & (self.all_bus_kv['vln_pu'] < 0.92) & (
                    self.all_bus_kv['vln_pu'] >= 0.866)]
        self.bt_overvoltage_prec = self.all_bus_kv[
            (self.all_bus_kv['kv_base'] <= 1) & (self.all_bus_kv['vln_pu'] > 1.05) & (
                    self.all_bus_kv['vln_pu'] <= 1.063)]
        self.bt_overvoltage_crit = self.all_bus_kv[
            (self.all_bus_kv['kv_base'] <= 1) & (self.all_bus_kv['vln_pu'] > 1.063)]

        self.mt_undervoltage_prec = self.all_bus_kv[
            (self.all_bus_kv['kv_base'] > 1) & (self.all_bus_kv['vln_pu'] < 0.93) & (self.all_bus_kv['vln_pu'] >= 0.90)]
        self.mt_undervoltage_crit = self.all_bus_kv[
            (self.all_bus_kv['kv_base'] > 1) & (self.all_bus_kv['vln_pu'] < 0.90) & (self.all_bus_kv['vln_pu'] > 0.2)]
        self.mt_overvoltage_crit = self.all_bus_kv[
            (self.all_bus_kv['kv_base'] > 1) & (self.all_bus_kv['vln_pu'] > 1.05) & (self.all_bus_kv['vln_pu'] < 0.90)]
        """
        # Export the DataFrame to an Excel
        self.bt_undervoltage_prec.to_csv(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_bt_undervoltage_prec.csv')
        self.bt_undervoltage_crit.to_csv(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_bt_undervoltage_prec.csv')
        self.bt_overvoltage_prec.to_csv(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_bt_overvoltage_prec.csv')
        self.bt_overvoltage_crit.to_csv(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_bt_overvoltage_crit.csv')

        self.mt_undervoltage_prec.to_csv(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_mt_undervoltage_prec.csv')
        self.mt_undervoltage_crit.to_csv(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_mt_undervoltage_prec.csv')
        self.mt_overvoltage_crit.to_csv(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_mt_overvoltage_crit.csv')

        """ 
        # ValueError: This sheet is too large! Your sheet size is: 1141402, 10 Max sheet size is: 1048576, 16384
        self.bt_undervoltage_prec.to_excel(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_bt_undervoltage_prec.xlsx')
        self.bt_undervoltage_crit.to_excel(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_bt_undervoltage_prec.xlsx')
        self.bt_overvoltage_prec.to_excel(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_bt_overvoltage_prec.xlsx')
        self.bt_overvoltage_crit.to_excel(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_bt_overvoltage_crit.xlsx')

        self.mt_undervoltage_prec.to_excel(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_mt_undervoltage_prec.xlsx')
        self.mt_undervoltage_crit.to_excel(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_mt_undervoltage_prec.xlsx')
        self.mt_overvoltage_crit.to_excel(rf'C:\pastaD\TSEA\Analises\base_case\{circuito}_mt_overvoltage_crit.xlsx')
        """
        # Metodologia 2  ================================================
        self.bt_undervoltage_crit_2 = pd.DataFrame(
            [sum(1 for k, v in d.items() if k.startswith('bt') and 0.2 < v < 0.866)
             for d in voltage_bus_list])
        self.bt_undervoltage_prec_2 = pd.DataFrame(
            [sum(1 for k, v in d.items() if k.startswith('bt') and 0.866 <= v < 0.92)
             for d in voltage_bus_list])
        self.bt_overvoltage_prec_2 = pd.DataFrame(
            [sum(1 for k, v in d.items() if k.startswith('bt') and 1.05 < v <= 1.063)
             for d in voltage_bus_list])
        self.bt_overvoltage_crit_2 = pd.DataFrame([sum(1 for k, v in d.items() if k.startswith('bt') and v > 1.063)
                                                   for d in voltage_bus_list])
        self.mt_undervoltage_prec_2 = pd.DataFrame(
            [sum(1 for k, v in d.items() if k.startswith('mt') and 0.90 <= v < 0.93)
             for d in voltage_bus_list])
        self.mt_undervoltage_crit_2 = pd.DataFrame(
            [sum(1 for k, v in d.items() if k.startswith('mt') and 0.2 < v < 0.90)
             for d in voltage_bus_list])
        self.mt_overvoltage_crit_2 = pd.DataFrame([sum(1 for k, v in d.items() if k.startswith('mt') and v > 1.05)
                                                   for d in voltage_bus_list])

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

        # num_buses = len(self.dss.circuit.nodes_names)
        counts_bt_under_prec_perc = counts_bt_under_prec / self.phases_num_buses * 100
        counts_bt_under_crit_perc = counts_bt_under_crit / self.phases_num_buses * 100
        counts_bt_over_prec_perc = counts_bt_over_prec / self.phases_num_buses * 100
        counts_bt_over_crit_perc = counts_bt_over_crit / self.phases_num_buses * 100
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

        counts_mt_under_prec_perc = counts_mt_under_prec / self.phases_num_buses * 100
        counts_mt_under_crit_perc = counts_mt_under_crit / self.phases_num_buses * 100
        counts_mt_over_crit_perc = counts_mt_over_crit / self.phases_num_buses * 100
        mt_df_perc = pd.DataFrame({'mt_undervoltage_prec': counts_mt_under_prec_perc,
                                   'mt_undervoltage_crit': counts_mt_under_crit_perc,
                                   'mt_overvoltage_crit': counts_mt_over_crit_perc})

        # Cargas associadas as barras com problemas =====================================================
        index = np.arange(1, 145)  # [0, 1, 2, ..., 9]
        load_violation = self.all_load_violation.groupby(['patamar', 'classe'], as_index=False).size()
        total_consumidor_under_prec = load_violation.loc[load_violation['classe'] == 'bt_undervoltage_prec']
        total_consumidor_under_prec = total_consumidor_under_prec.set_index('patamar')
        total_consumidor_under_prec = total_consumidor_under_prec.reindex(index, fill_value=0)
        counts_loads_bt_under_prec_perc = total_consumidor_under_prec['size'] / self.total_loads_bt * 100

        total_consumidor_under_crit =load_violation.loc[load_violation['classe'] == 'bt_undervoltage_crit']
        total_consumidor_under_crit = total_consumidor_under_crit.set_index('patamar')
        total_consumidor_under_crit = total_consumidor_under_crit.reindex(index, fill_value=0)
        counts_loads_bt_under_crit_perc = total_consumidor_under_crit['size'] / self.total_loads_bt * 100

        total_consumidor_over_prec = load_violation.loc[load_violation['classe'] == 'bt_overvoltage_prec']
        total_consumidor_over_prec = total_consumidor_over_prec.set_index('patamar')
        total_consumidor_over_prec = total_consumidor_over_prec.reindex(index, fill_value=0)
        counts_loads_bt_over_prec_perc = total_consumidor_over_prec['size'] / self.total_loads_bt * 100

        total_consumidor_over_crit = load_violation.loc[load_violation['classe'] == 'bt_overvoltage_crit']
        total_consumidor_over_crit = total_consumidor_over_crit.set_index('patamar')
        total_consumidor_over_crit = total_consumidor_over_crit.reindex(index, fill_value=0)
        counts_loads_bt_over_crit_perc = total_consumidor_over_crit['size'] / self.total_loads_bt * 100

        bt_df_loads = pd.DataFrame({'bt_loads_undervoltage_prec': counts_loads_bt_under_prec_perc,
                                    'bt_loads_undervoltage_crit': counts_loads_bt_under_crit_perc,
                                    'bt_loads_overvoltage_prec': counts_loads_bt_over_prec_perc,
                                    'bt_loads_overvoltage_crit': counts_loads_bt_over_crit_perc})

        total_consumidor_mt_under_prec = load_violation.loc[load_violation['classe'] == 'mt_undervoltage_prec']
        total_consumidor_mt_under_prec = total_consumidor_mt_under_prec.set_index('patamar')
        total_consumidor_mt_under_prec = total_consumidor_mt_under_prec.reindex(index, fill_value=0)
        counts_loads_mt_under_prec_perc = total_consumidor_mt_under_prec['size'] / self.total_loads_mt * 100

        total_consumidor_mt_under_crit = load_violation.loc[load_violation['classe'] == 'mt_undervoltage_crit']
        total_consumidor_mt_under_crit = total_consumidor_mt_under_crit.set_index('patamar')
        total_consumidor_mt_under_crit = total_consumidor_mt_under_crit.reindex(index, fill_value=0)
        counts_loads_mt_under_crit_perc = total_consumidor_mt_under_crit['size'] / self.total_loads_mt * 100

        total_consumidor_mt_over_crit = load_violation.loc[load_violation['classe'] == 'mt_overvoltage_crit']
        total_consumidor_mt_over_crit = total_consumidor_mt_over_crit.set_index('patamar')
        total_consumidor_mt_over_crit = total_consumidor_mt_over_crit.reindex(index, fill_value=0)
        counts_loads_bt_over_crit_perc = total_consumidor_mt_over_crit['size'] / self.total_loads_mt * 100

        mt_df_loads = pd.DataFrame({'mt_loads_undervoltage_prec': counts_loads_mt_under_prec_perc,
                                    'mt_loads_undervoltage_crit': counts_loads_mt_under_crit_perc,
                                    'mt_loads_overvoltage_crit': counts_loads_bt_over_crit_perc})
        
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

        if not bt_df_loads.empty:
            ax = bt_df_loads.plot(kind='bar', stacked=True)
            plt.title(f"LOADS Violation : {self.circuit}")
            plt.ylabel(f"Number (%)")
            plt.xlabel(f"Time steps")
            ax.xaxis.set_major_locator(ticker.MultipleLocator(6))
            plt_path = os.path.join(plt_path_base, "bt_loads_voltages_perc.png")
            plt.savefig(plt_path, dpi=300, bbox_inches='tight', transparent=False)
            plt.show(block=True)

        else:
            print("Sem violação nas cargas BT.")

        if not mt_df_loads.empty:
            ax = mt_df_loads.plot(kind='bar', stacked=True)
            plt.title(f"LOADS Violation : {self.circuit}")
            plt.ylabel(f"Number (%)")
            plt.xlabel(f"Time")
            ax.xaxis.set_major_locator(ticker.MultipleLocator(6))
            plt_path = os.path.join(plt_path_base, "mt_loads_voltages_perc.png")
            plt.savefig(plt_path, dpi=300, bbox_inches='tight', transparent=False)
            plt.show(block=isblock)
        else:
            print("Sem violação nas cargas MT.")

    def plot_data_result_2(self, isblock=True):

        dirname = os.path.dirname(self.dss_file)
        path_dir = os.path.abspath(os.path.join(dirname, fr'output'))

        plt_path_base = os.path.join(rf"C:\pastaD\TSEA\Analises\base_case", self.circuit)
        os.makedirs(plt_path_base, exist_ok=True)

        if self.bt_undervoltage_prec_2.empty:
            counts_bt_under_prec = pd.Series(dtype=object)
            counts_bt_under_prec_perc = pd.Series(dtype=object)
        else:
            counts_bt_under_prec = self.bt_undervoltage_prec_2.iloc[:, 0]
            counts_bt_under_prec_perc = self.bt_undervoltage_prec_2.iloc[:, 0] / self.phases_num_buses * 100

        if self.bt_undervoltage_crit_2.empty:
            counts_bt_under_crit = pd.Series(dtype=object)
            counts_bt_under_crit_perc = pd.Series(dtype=object)
        else:
            counts_bt_under_crit = self.bt_undervoltage_crit_2.iloc[:, 0]
            counts_bt_under_crit_perc = self.bt_undervoltage_crit_2.iloc[:, 0] / self.phases_num_buses * 100

        if self.bt_overvoltage_prec_2.empty:
            counts_bt_over_prec = pd.Series(dtype=object)
            counts_bt_over_prec_perc = pd.Series(dtype=object)
        else:
            counts_bt_over_prec = self.bt_overvoltage_prec_2.iloc[:, 0]
            counts_bt_over_prec_perc = self.bt_overvoltage_prec_2.iloc[:, 0] / self.phases_num_buses * 100

        if self.bt_overvoltage_crit_2.empty:
            counts_bt_over_crit = pd.Series(dtype=object)
            counts_bt_over_crit_perc = pd.Series(dtype=object)
        else:
            counts_bt_over_crit = self.bt_overvoltage_crit_2.iloc[:, 0]
            counts_bt_over_crit_perc = self.bt_overvoltage_crit_2.iloc[:, 0] / self.phases_num_buses * 100

        bt_df = pd.DataFrame({'bt_undervoltage_prec': counts_bt_under_prec,
                              'bt_undervoltage_crit': counts_bt_under_crit,
                              'bt_overvoltage_prec': counts_bt_over_prec,
                              'bt_overvoltage_crit': counts_bt_over_crit})
        bt_df = bt_df.reset_index(drop=True)
        bt_df.index = bt_df.index + 1

        bt_df_perc = pd.DataFrame({'bt_undervoltage_prec': counts_bt_under_prec_perc,
                                   'bt_undervoltage_crit': counts_bt_under_crit_perc,
                                   'bt_overvoltage_prec': counts_bt_over_prec_perc,
                                   'bt_overvoltage_crit': counts_bt_over_crit_perc})
        bt_df_perc = bt_df_perc.reset_index(drop=True)
        bt_df_perc.index = bt_df_perc.index + 1

        if self.mt_undervoltage_prec_2.empty:
            counts_mt_under_prec = pd.Series(dtype=object)
            counts_mt_under_prec_perc = pd.Series(dtype=object)
        else:
            counts_mt_under_prec = self.mt_undervoltage_prec_2.iloc[:, 0]
            counts_mt_under_prec_perc = self.mt_undervoltage_prec_2.iloc[:, 0] / self.phases_num_buses * 100

        if self.mt_undervoltage_crit_2.empty:
            counts_mt_under_crit = pd.Series(dtype=object)
            counts_mt_under_crit_perc = pd.Series(dtype=object)
        else:
            counts_mt_under_crit = self.mt_undervoltage_crit_2.iloc[:, 0]
            counts_mt_under_crit_perc = self.mt_undervoltage_crit_2.iloc[:, 0] / self.phases_num_buses * 100

        if self.mt_overvoltage_crit_2.empty:
            counts_mt_over_crit = pd.Series(dtype=object)
            counts_mt_over_crit_perc = pd.Series(dtype=object)
        else:
            counts_mt_over_crit = self.mt_overvoltage_crit_2.iloc[:, 0]
            counts_mt_over_crit_perc = self.mt_overvoltage_crit_2.iloc[:, 0] / self.phases_num_buses * 100

        mt_df = pd.DataFrame({'mt_undervoltage_prec': counts_mt_under_prec,
                              'mt_undervoltage_crit': counts_mt_under_crit,
                              'mt_overvoltage_crit': counts_mt_over_crit})
        mt_df = mt_df.reset_index(drop=True)
        mt_df.index = mt_df.index + 1

        mt_df_perc = pd.DataFrame({'mt_undervoltage_prec': counts_mt_under_prec_perc,
                                   'mt_undervoltage_crit': counts_mt_under_crit_perc,
                                   'mt_overvoltage_crit': counts_mt_over_crit_perc})
        mt_df_perc = mt_df_perc.reset_index(drop=True)
        mt_df_perc.index = mt_df_perc.index + 1

        if not bt_df.empty:
            ax = bt_df.plot(kind='bar', stacked=True)
            plt.title(f"BUS Violation : {self.circuit}")
            plt.ylabel(f"Number")
            plt.xlabel(f"Time steps")
            ax.xaxis.set_major_locator(ticker.MultipleLocator(6))
            plt_path = os.path.join(plt_path_base, "bt_voltages_2.png")
            plt.savefig(plt_path, dpi=300, bbox_inches='tight', transparent=False)
            plt.show(block=False)

            ax = bt_df_perc.plot(kind='bar', stacked=True)
            plt.title(f"BUS Violation : {self.circuit}")
            plt.ylabel(f"Number (%)")
            plt.xlabel(f"Time steps")
            ax.xaxis.set_major_locator(ticker.MultipleLocator(6))
            plt_path = os.path.join(plt_path_base, "bt_voltages_perc_2.png")
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
            plt_path = os.path.join(plt_path_base, "mt_voltages_2.png")
            plt.savefig(plt_path, dpi=300, bbox_inches='tight', transparent=False)
            plt.show(block=False)

            ax = mt_df_perc.plot(kind='bar', stacked=True)
            plt.title(f"BUS Violation : {self.circuit}")
            plt.ylabel(f"Number (%)")
            plt.xlabel(f"Time")
            ax.xaxis.set_major_locator(ticker.MultipleLocator(6))
            plt_path = os.path.join(plt_path_base, "mt_voltages_perc_2.png")
            plt.savefig(plt_path, dpi=300, bbox_inches='tight', transparent=False)
            plt.show(block=isblock)
        else:
            print("Sem violação de tensão MT.")


if __name__ == '__main__':
    # list_circuit = ['RAVP1303', 'RBOI1302', 'RBRR1301', 'RMTQ1302']

    # dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RAVP1303\output\master.dss'
    # dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RAVP1303\DU_7_Master_391_AVP_RAVP1303.dss'
    #dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RAVP1303\DU_7_Master_391_AVP_RAVP1303_144.dss'
    #circuito = 'RAVP1303'

    #dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RBOI1302\output\master.dss'
    dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RBOI1302\DU_7_Master_391_BOI_RBOI1302_144.dss'
    #dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RBOI1302\DU_7_Master_391_BOI_RBOI1302.dss'
    circuito = 'RBOI1302'
    patamares = 144

    # dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RBRR1301\output\master.dss'
    # dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RBRR1301\DU_7_Master_391_BRR_RBRR1301.dss'
    dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RBRR1301\DU_7_Master_391_BRR_RBRR1301_144.dss'
    circuito = 'RBRR1301'

    # dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RMTQ1302\output\master.dss'
    #dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RMTQ1302\DU_7_Master_391_MTQ_RMTQ1302_144.dss'
    #circuito = 'RMTQ1302'

    # dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\RMTQ1306\output\master.dss'
    # circuito = 'RMTQ1306'

    #dss_file = r'C:\pastaD\TSEA\dss\2024\Ajuste_demanda\Ajuste_Modelo_de_carga\RBOI1302\output\Master.dss'
    #circuito = 'RBOI1302'

    # plot_indic(circuito)
    # print('ddd')
    simul = Condition(circuit=circuito, dss_file=dss_file, total_patamar=patamares)
