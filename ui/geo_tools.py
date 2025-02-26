import os
import geopandas as gpd
import pandas as pd
from flask import jsonify
from shapely.geometry import LineString, Point
import geojson as geoj

mapeamento = {600: "Magenta", 500: "blue", 440: "red", 345: "cyan", 230: "orange", 138: "DarkGreen", 88: "LightGreen"}


class GeoDataSIN:

    def __init__(self, gdb_name_file, gdb_layer=None):
        self.gdb_path = os.path.join(os.path.dirname(__file__), 'data', gdb_name_file)
        self.layer_name = gdb_layer

    def read_geojson_subs(self):
        """
        Leitura do arquivo tipo GOJSON de linhas do SIN obtido do https://sig.ons.org.br/app/sinmaps/
        adiciona dois campos de propriedades (tipo e cor) para ser tratado na vizualização do mapa.
        :return:
        """

        try:
            with open(self.gdb_path, encoding='utf-8') as file:
                geojson_data = geoj.load(file)

            for feature in geojson_data.get("features", []):
            #    voltage = feature['properties'].get("VN")
                feature.setdefault("properties", {})["tipo"] = "SIN-Subs"
                feature.setdefault("properties", {})["nome_sub"] = feature['properties'].get("NOMELONGO")
                feature.setdefault("properties", {})["opera"] = feature['properties'].get("AGE_PRIN_NOM")

            #    feature.setdefault("properties", {})["cor"] = mapeamento.get(voltage, "LightBlue")

            return dict(geojson_data)
        except Exception as e:
            return jsonify({"error": str(e)}), 500

    def read_geojson_line(self):
        """
        Leitura do arquivo tipo GOJSON de linhas do SIN obtido do https://sig.ons.org.br/app/sinmaps/
        adiciona dois campos de propriedades (tipo e cor) para ser tratado na vizualização do mapa.
        :return:
        """

        try:
            with open(self.gdb_path, encoding='utf-8') as file:
                geojson_data = geoj.load(file)

            for feature in geojson_data.get("features", []):
                voltage = feature['properties'].get("VN")
                feature.setdefault("properties", {})["tipo"] = "SIN-Lines"
                feature.setdefault("properties", {})["cor"] = mapeamento.get(voltage, "LightBlue")

            return dict(geojson_data)
        except Exception as e:
            return jsonify({"error": str(e)}), 500

    def read_gdb_ufv_to_json(self):
        eol = []
        proprietario = []
        ini_oper = []
        ceg = []
        potencia = []
        nome_ufv = []
        nome = []

        # Abrir o arquivo GDB com Fiona e GeoPandas
        try:
            df = gpd.read_file(self.gdb_path, driver="pyogrio", layer=self.layer_name,
                               ignore_geometry=False, use_arrow=True)
            if df.iloc[0]['geometry'].geom_type.upper() == 'POINT':
                df['latitude'] = df['geometry'].y  # lat
                df['longitude'] = df['geometry'].x

            df["ini_oper"] = pd.to_datetime(df["ini_oper"], errors='coerce').dt.strftime('%d/%m/%Y')
            eol_data = [
                ((row["longitude"], row["latitude"]), row["Potencia"], row["ini_oper"], row["ceg"],
                 row["propriet"], row["nome"]) for index, row in df.iterrows()]
            for PT, POT, DT_OPER, CEG, PROP, NOME in eol_data:
                eol.append(Point([PT]))
                potencia.append(POT)
                # ini_oper.append(datetime.strftime(DT_OPER, "%Y-%m-%d"))
                ini_oper.append(DT_OPER)
                ceg.append(CEG)
                proprietario.append(PROP)
                nome_ufv.append(NOME)
                nome.append('SIN-EOL')
            # Criar um GeoDataFrame com as geometrias e dados extras
            gdf = gpd.GeoDataFrame(
                {'geometry': eol, 'power': potencia, 'ini_oper': ini_oper, 'prop': proprietario,
                 'ceg': ceg, 'nome_eol': nome_ufv, 'tipo': nome}, crs="EPSG:4326")

            # Converter o GeoDataFrame para GeoJSON
            geojson = gdf.to_json()

            return geojson
        except Exception as e:
            return jsonify({"error": str(e)}), 500

    def read_gdb_eol_to_json(self):
        eol = []
        proprietario = []
        ini_oper = []
        ceg = []
        potencia = []
        nome_eol = []
        nome = []

        # Abrir o arquivo GDB com Fiona e GeoPandas
        try:
            df = gpd.read_file(self.gdb_path, driver="pyogrio", layer=self.layer_name,
                               ignore_geometry=False, use_arrow=True)
            if df.iloc[0]['geometry'].geom_type.upper() == 'POINT':
                df['latitude'] = df['geometry'].y  # lat
                df['longitude'] = df['geometry'].x

            df["ini_oper"] = pd.to_datetime(df["ini_oper"], errors='coerce').dt.strftime('%d/%m/%Y')
            eol_data = [
                ((row["longitude"], row["latitude"]), row["potencia"], row["ini_oper"], row["ceg"],
                 row["propriet"], row["Nome"]) for index, row in df.iterrows()]
            for PT, POT, DT_OPER, CEG, PROP, NOME in eol_data:
                eol.append(Point([PT]))
                potencia.append(POT)
                # ini_oper.append(datetime.strftime(DT_OPER, "%Y-%m-%d"))
                ini_oper.append(DT_OPER)
                ceg.append(CEG)
                proprietario.append(PROP)
                nome_eol.append(NOME)
                nome.append('SIN-EOL')
            # Criar um GeoDataFrame com as geometrias e dados extras
            gdf = gpd.GeoDataFrame(
                {'geometry': eol, 'power': potencia, 'ini_oper': ini_oper, 'prop': proprietario,
                 'ceg': ceg, 'nome_eol': nome_eol, 'tipo': nome}, crs="EPSG:4326")

            # Converter o GeoDataFrame para GeoJSON
            geojson = gdf.to_json()

            return geojson
        except Exception as e:
            return jsonify({"error": str(e)}), 500

    def read_gdb_sub_to_json(self):
        subs = []
        tensao = []
        concessao = []
        operacao = []
        nome_sub = []
        nome = []

        # Abrir o arquivo GDB com Fiona e GeoPandas
        try:
            df = gpd.read_file(self.gdb_path, driver="pyogrio", layer=self.layer_name,
                               ignore_geometry=False, use_arrow=True)
            if df.iloc[0]['geometry'].geom_type.upper() == 'POINT':
                df['latitude'] = df['geometry'].y  # lat
                df['longitude'] = df['geometry'].x

            subs_data = [
                ((row["longitude"], row["latitude"]),
                 row["Tensao"], row["Concession"], row["Ano_Opera"], row["Nome"]) for index, row in
                df.iterrows()]
            for pt, voltage, concession, opera, name in subs_data:
                subs.append(Point([pt]))
                tensao.append(voltage)
                concessao.append(concession)
                operacao.append(opera)
                nome_sub.append(name)
                nome.append('SIN-Subs')
            # Criar um GeoDataFrame com as geometrias e dados extras
            gdf = gpd.GeoDataFrame({'geometry': subs, 'voltage': tensao, 'concessao': concessao,
                                    'opera': operacao, 'nome_sub': nome_sub, 'tipo': nome}, crs="EPSG:4326")

            # Converter o GeoDataFrame para GeoJSON
            geojson = gdf.to_json()

            return geojson
        except Exception as e:
            return jsonify({"error": str(e)}), 500

    def read_gdb_line_to_json(self):
        lines = []
        tensao = []
        concessao = []
        extensao = []
        nome_linha = []
        nome = []
        cor = []

        # Abrir o arquivo GDB
        try:
            df = gpd.read_file(self.gdb_path, driver="pyogrio", layer=self.layer_name,
                               ignore_geometry=False, use_arrow=True)
            if df.iloc[0]['geometry'].geom_type == 'MultiLineString':
                bounds = df.geometry.boundary.explode(index_parts=True).unstack()
                df['start_latitude'] = bounds[0].y
                df['start_longitude'] = bounds[0].x
                df['end_latitude'] = bounds[1].y
                df['end_longitude'] = bounds[1].x

            line_segments = [
                ((row["start_longitude"], row["start_latitude"]), (row["end_longitude"], row["end_latitude"]),
                 row["Tensao"], row["Concession"], row["Extensao"], row["Nome"]) for index, row in df.iterrows()]
            for start, end, voltage, concession, ext, name in line_segments:
                lines.append(LineString([start, end]))
                tensao.append(voltage)
                concessao.append(concession)
                extensao.append(ext)
                nome_linha.append(name)
                nome.append('SIN-Lines')
                cor.append(mapeamento.get(voltage, "LightBlue"))
            # Criar um GeoDataFrame com as geometrias e dados extras
            gdf = gpd.GeoDataFrame({'geometry': lines, 'VN': tensao, 'AGE_NOME': concessao, 'cor': cor,
                                    'EXT': extensao, 'NOMELONGO': nome_linha, 'tipo': nome}, crs="EPSG:4326")

            # Converter o GeoDataFrame para GeoJSON
            geojson = gdf.to_json()

            return geojson
        except Exception as e:
            return jsonify({"error": str(e)}), 500
