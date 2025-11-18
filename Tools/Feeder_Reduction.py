# -*- coding: utf-8 -*-
# @Author  : Guilherme Broslavschi
# @Email   : guibroslavschi@usp.br
# @File    : Feeder_Reduction.py
# @Software: PyCharm

import py_dss_interface
import pathlib
import os
import sys

""" 
O código apresentado tem como objetivo gerar um circuito reduzido do alimentador selecionado. Inicialmente, algumas 
chaves são unificadas às linhas a jusante correspondentes. Em seguida, são eliminados todos os barramentos terminais que 
não possuam cargas, capacitores ou derivações.

O arquivo do circuito reduzido será automaticamente salvo no diretório da subestação correspondente ao circuito original.       
"""

script_path = os.path.dirname(os.path.abspath(__file__))

# Choose the feeder path
dss_file = pathlib.Path(script_path).joinpath("C:/BDGD2SqlServer/dss/391/CSO/RCSO1301/DU_1_Master_391_CSO_RCSO1301.dss")
dss = py_dss_interface.DSS()

if not dss_file.exists():
    sys.exit(f"❌ O arquivo DSS não foi encontrado: {dss_file}")

dss.text("ClearAll")
dss.text(f"Redirect [{dss_file}]")
dss.text("Set ReduceOption = switches")
dss.text("Reduce")
dss.text("Solve")
dss.text("Set ReduceOption = default")
dss.text("Reduce")
dss.text("Solve")

feeder = dss_file.parent.name

output_dir = dss_file.parent.parent / f"{feeder}_Reduced"
output_dir.mkdir(exist_ok=True)

dss.text(f"Save Circuit Dir={output_dir}")

print(f"\n✅ Execution of feeder {feeder}_Reduced completed")