# -*- coding: utf-8 -*-
# @Author  : Guilherme Broslavschi
# @Email   : guibroslavschi@usp.br
# @File    : Hosting_Capacity.py
# @Software: PyCharm

import py_dss_interface
import os
import csv
import pathlib
import numpy as np
import math


class HCSteps:

    max_kw = 100000
    step_kw = 1000
    ov_threshold = 1.05
    mv_13800 = 13800 / math.sqrt(3)

    @classmethod
    def hosting_capacity(cls):
        buses = list()
        dss.loads.first()
        data_hc = []

        count = 0 #PARA TESTE DO ARQUIVO .CSV
        for _ in range(dss.loads.count):
            dss.circuit.set_active_element(f"load[{dss.loads.name}]")
            load_name = dss.loads.name

            if load_name.endswith('_m2') or load_name.startswith('pip'):
                dss.loads.next()
                continue

            bus_node = dss.cktelement.bus_names[0]
            bus = bus_node.split(".")[0]

            if bus in buses:
                dss.loads.next()
                continue

            #buses.append(bus)
            #dss.loads.next()

            #PARA TESTE DO ARQUIVO .CSV
            if count <= 1:
                count = count + 1
                buses.append(bus)
                dss.loads.next()

            else:
                break


        for bus in buses:
            dss.text(f"compile [{dss_file}]")
            dss.circuit.set_active_bus(bus)
            kv = dss.bus.kv_base * np.sqrt(3)

            gen_bus = {"gen": dss.bus.name}
            gen_kv = {"gen": kv}

            HCSteps.add_gen(dss, gen_bus, gen_kv)

            for number in range(25):
                if number >= 1:

                    i = 0
                    while i * HCSteps.step_kw < HCSteps.max_kw:
                        i = i + 1
                        i_kw = i * HCSteps.step_kw
                        gen_kw = {"gen": i_kw}
                        HCSteps.increase_gen(dss, gen_kw)

                        dss.text(f"set number={number}")
                        HCSteps.solve_powerflow(dss)

                        #if HCSteps.check_overvoltage_violation(dss):
                        if HCSteps.check_medium_overvoltage_violation(dss):
                            hosting_capacity_value = (i - 1) * HCSteps.step_kw

                            data_hc.append({
                                "bus": bus,
                                "number": number,
                                "hc_violation": hosting_capacity_value
                            })

                            print(f"bus={bus}; number= {number}; hc_violation={hosting_capacity_value}; ")
                            break

        return data_hc

    @classmethod
    def add_gen(cls, dss: py_dss_interface.DSS, gen_bus: dict, gen_kv: dict):
        for gen in gen_bus.keys():
            dss.text(f"new generator.{gen} "
                     f"phases=3 bus1={gen_bus[gen]} kv={gen_kv[gen]} "
                     f"kw=0.0001 pf=1 Vminpu=0.7 Vmaxpu=1.2")

    @classmethod
    def increase_gen(cls, dss: py_dss_interface.DSS, gen_kw: dict):
        for gen, kw in gen_kw.items():
            dss.text(f"Edit generator.{gen} kw={kw}")

    @classmethod
    def solve_powerflow(cls, dss: py_dss_interface.DSS):
        dss.text("solve")

    @classmethod
    def check_overvoltage_violation(cls, dss: py_dss_interface.DSS):
        violation = False
        voltages = dss.circuit.buses_vmag_pu
        max_voltage = max(voltages)

        if max_voltage > cls.ov_threshold:
            violation = True

        return violation

    @classmethod
    def check_medium_overvoltage_violation(cls, dss: py_dss_interface.DSS):
        violation = False
        voltages = dss.circuit.buses_vmag
        medium_voltages = list()

        for medium_voltage in voltages:
            if medium_voltage >= 7000:
                medium_voltages.append(medium_voltage)

        max_voltage = max(medium_voltages)
        medium_voltage_pu = max_voltage / cls.mv_13800

        if medium_voltage_pu > cls.ov_threshold:
            violation = True

        return violation


if __name__ == '__main__':

    utility = '391'
    substation = 'APA'
    feeder = 'RAPA1301'
    day = 'DU'
    month = '1'

    script_path = os.path.dirname(os.path.abspath(__file__))
    dss_file = pathlib.Path(script_path).joinpath(
        f"C:/BDGD2SqlServer/dss/{utility}/{substation}/{feeder}/{day}_{month}_Master_{utility}_{substation}_{feeder}.dss")
    dss = py_dss_interface.DSS()

    base_path = pathlib.Path(
        f"C:/BDGD2SqlServer/ui/static/scenarios/hosting_capacity/{utility}/{substation}/{feeder}/{month}/{day}")
    base_path.mkdir(parents=True, exist_ok=True)
    csv_path = base_path / f"hc_{feeder}_{month}_{day}.csv"

    dss.text(f"compile [{dss_file}]")
    data_hc = HCSteps.hosting_capacity()

    with open(csv_path, mode='w', newline='') as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=["bus", "number", "hc_violation"])
        writer.writeheader()
        writer.writerows(data_hc)

    print(f"here")









