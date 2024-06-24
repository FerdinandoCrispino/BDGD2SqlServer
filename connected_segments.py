# -*- encoding: utf-8 -*-

import pandas as pd
import matplotlib.pyplot as plt
import networkx as nx
from collections import defaultdict, deque


def build_graph(df, p1, p2):
    graph = defaultdict(list)
    for index, row in df.iterrows():
        start, end = row[p1], row[p2]
        graph[start].append(end)
        graph[end].append(start)
    return graph


def dfs(graph, start):
    visited = set()
    stack = deque([(start, None)])
    segments = []

    while stack:
        node, parent = stack.pop()
        if node is not visited:
            visited.add(node)
            if parent is not None:
                segments.append((parent, node))
            for neighbor in graph[node]:
                if neighbor not in visited:
                    stack.append((neighbor, node))

    return segments


def find_unconnected_segments(all_segments, connected_segments):
    connected_set = set((min(a, b), max(a, b)) for a, b in connected_segments)
    unconnected_segments = []
    for segment in all_segments:
        start, end = segment
        segment_tuple = (min(start, end), max(start, end))
        if segment_tuple not in connected_set:
            unconnected_segments.append((start, end))
    return unconnected_segments


def plot_tree(segments):

    # segments = [(22307576, 10916034), (10916034, 8629251), (8629251, 8627828), (8627828, 8171751)]
    G = nx.Graph()
    G.add_edges_from(segments)
    pos = nx.spring_layout(G)  # Spring layout for better tree representation

    plt.figure(figsize=(20, 12))
    nx.draw(G, pos, with_labels=True, node_size=500, node_color="skyblue", font_size=5, font_weight="bold",
            edge_color="gray")
    plt.title("Árvore de Segmentos de Reta Conectados")
    plt.show()


if __name__ == "__main__":

    # teste de funcionamento
    data = {
        'start': [1, 2, 2, 3, 4, 2, 20],
        'end': [2, 3, 4, 4, 5, 8, 40],
        'id': [1,2,3,4,5,6,7]
    }

    df = pd.DataFrame(data)
    start_point = 1
    print(df)

    # Construir o grafo
    graph = build_graph(df, 'start', 'end')

    # Encontrar e ordenar segmentos conectados usando DFS
    connected_segments = dfs(graph, start_point)
    df_connected_segments = pd.DataFrame.from_records(connected_segments, columns=['start', 'end'])
    print(connected_segments)

    # Não conectados
    df_left = df.merge(df_connected_segments.drop_duplicates(), on=['start', 'end'], how='left', indicator=True)
    df_left = df_left[df_left.merge != 'both']
    print(len(df_left))
    print(df_left)

    all_segments = list(zip(df['start'], df['end']))
    unconnected_segments = find_unconnected_segments(all_segments, connected_segments)
    print(len(unconnected_segments))
    print(unconnected_segments)

    # Plotar a árvore dos segmentos conectados
    plot_tree(connected_segments)

