# -*- coding: utf-8 -*-
# @Author  : Guilherme Broslavschi
# @Email   : guibroslavschi@usp.br
# @File    : Hosting_Capacity.py
# @Software: PyCharm

import os
import yaml
import json
import time
import gc
from collections import defaultdict

class All:
    def unify_json_substation(group: dict, utility: str):
        """
            Unifica os arquivos JSON.
        """
        from Hosting_Capacity import HCSteps

        project_root = HCSteps._find_project_root(marker_folder="ui")
        base_root = project_root / "ui" / "static" / "scenarios" / "Hosting Capacity" / utility

        substation = group["substation"]
        type_day = group["type_day"]
        year = group["year"]
        month = group["month"]
        json_files = group["json_files"]

        contents = list()
        read_errors = list()
        for p in sorted(json_files):
            try:
                with open(p, "r", encoding="utf-8") as f:
                    data = json.load(f)
                contents.append((p, data))
            except Exception as e:
                read_errors.append((p, str(e)))
                print(f"❌ Erro lendo {p}: {e}")

        if not contents:
            return {"output_path": None, "n_files": 0, "errors": read_errors}

        merged = dict()
        for (p, data) in contents:
            if not isinstance(data, list):
                raise ValueError(f"Arquivo {p} não contém uma lista, mas {type(data)}")

            for item in data:
                if not isinstance(item, dict):
                    raise ValueError(f"Item em {p} não é dict: {item}")

                for k, v in item.items():
                    merged[k] = v

        output_obj = [merged]

        out_dir = base_root / substation / f"SUB_{substation}" / type_day / year / month
        out_dir.mkdir(parents=True, exist_ok=True)
        out_path = out_dir / "All.json"

        try:
            with open(out_path, "w", encoding="utf-8") as f:
                json.dump(output_obj, f, ensure_ascii=False, indent=4)
        except Exception as e:
            print(f"❌ Erro ao gravar {out_path}: {e}")
            return {"output_path": None, "n_files": len(contents), "error": str(e)}

        gc.collect()
        print(f"✅ All.json criado para {substation}/{type_day}/{year}/{month})")
        if read_errors:
            print(f"⚠️ Erros de leitura: {len(read_errors)} arquivos (veja logs).")

        return {"output_path": out_path, "n_files": len(contents), "read_errors": read_errors, "feeders": group.get("feeders", [])}

    def find_json_groups(utility: str):
        """
        Detecta automaticamente todos os grupos de arquivos JSON, retornando uma lista.
        """
        from Hosting_Capacity import HCSteps

        project_root = HCSteps._find_project_root(marker_folder="ui")
        root_path = project_root / "ui" / "static" / "scenarios" / "Hosting Capacity" / utility
        groups_map = defaultdict(lambda: {"json_files": [], "feeders": set()})

        for substation_dir in root_path.iterdir():
            if not substation_dir.is_dir():
                continue
            substation = substation_dir.name
            feeders = HCSteps.discover_feeders_for_substation(root_path, substation)
            for feeder in feeders:
                feeder_path = substation_dir / feeder
                if not feeder_path.exists():
                    continue
                for type_day_dir in feeder_path.iterdir():
                    if not type_day_dir.is_dir():
                        continue
                    type_day = type_day_dir.name
                    for year_dir in type_day_dir.iterdir():
                        if not year_dir.is_dir():
                            continue
                        year = year_dir.name
                        for month_dir in year_dir.iterdir():
                            if not month_dir.is_dir():
                                continue
                            month = month_dir.name
                            json_files = [p for p in month_dir.glob("*.json") if p.name.lower() != "all.json"]
                            if not json_files:
                                continue

                            key = (substation, type_day, year, month)
                            groups_map[key]["json_files"].extend(json_files)
                            groups_map[key]["feeders"].add(feeder)

        groups = list()
        for (substation, type_day, year, month), info in groups_map.items():
            unique_files = sorted(set(info["json_files"]))
            groups.append({
                "substation": substation,
                "type_day": type_day,
                "year": year,
                "month": month,
                "json_files": unique_files,
                "feeders": sorted(info["feeders"])
            })

        return groups


    def run_all_unifications(config):
        """
        Realiza a unificação de todos os grupos de arquivos JSON encontrados automaticamente no disco.
        """

        utility = str(config["utility"])
        groups = All.find_json_groups(utility)

        all_unifications = list()
        for group in groups:
            summary = All.unify_json_substation(group, utility=utility)
            all_unifications.append(summary)

        return


if __name__ == '__main__':
    inicio = time.time()
    base_dir = os.path.dirname(os.path.abspath(__file__))
    config_path = os.path.join(base_dir, "config_hc.yml")

    with open(config_path, "r", encoding="utf-8") as file:
        config = yaml.safe_load(file)["data_HC"]

    All.run_all_unifications(config)

    fim = time.time()
    tempo_total = fim - inicio

    horas = int(tempo_total // 3600)
    minutos = int((tempo_total % 3600) // 60)
    segundos = int(tempo_total % 60)

    print(f"Tempo total de execução: {horas:02d}h{minutos:02d}min{segundos:02d}seg")
    print("\n✅ Execution completed")