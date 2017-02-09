"""
A part of Source Detection.
Author: Biao Chang, changb110@gmail.com, from University of Science and Technology of China
created at 2017/1/9.
"""

# coding=utf-8

import random
from time import clock

import networkx as nx

import data
import distance_center as dc
import dynamic_importance as di
import dynamic_message_passing as dmp
import jordan_center as jc
import map_gsba as gsba
import reverse_infection as ri
import rumor_center as rc


def initialize_evaluation_measures(precision, error, topological_error, ranking, methods):
    precision['full_test'] = {}
    precision['random_test'] = {}
    error['full_test'] = {}
    error['random_test'] = {}
    topological_error['full_test'] = {}
    topological_error['random_test'] = {}
    ranking['full_test'] = {}
    ranking['random_test'] = {}
    for m in methods:
        precision['full_test'][m.method_name] = list()
        precision['random_test'][m.method_name] = list()
        error['full_test'][m.method_name] = list()
        error['random_test'][m.method_name] = list()
        topological_error['full_test'][m.method_name] = list()
        topological_error['random_test'][m.method_name] = list()
        ranking['full_test'][m.method_name] = list()
        ranking['random_test'][m.method_name] = list()


def detection_test(d, precision, error, topological_error, ranking, methods, random_test=False, random_num=1):
    """Full test: each node is selected to be the source
        Random test: randomly select a node as the infection source
    """
    test = 'full_test'
    nodes = d.graph.nodes()
    number_of_nodes = len(nodes)
    if random_test:
        test = 'random_test'
        """randomly select the sources"""
        temp = list()
        v = 0
        while v < random_num:
            temp.append(nodes[random.randint(0, number_of_nodes)])
            v += 1
        nodes = temp
        number_of_nodes = len(nodes)
    i = 0
    p = 0.1
    print test, len(nodes)
    for s in nodes:
        i += 1
        if abs(i - number_of_nodes * p) < 1:
            print '\t percentage: ', p
            p += 0.1
        infected = d.infect_from_source_SI(s)
        if d.debug:
            print 'source = ', s, infected
        for m in methods:
            result = m.detect()
            """evaluate the result"""
            if len(result) > 0:
                if d.debug:
                    print result[0][0], result[0][1], result, m.method_name
                if result[0][0] == s:
                    precision[test][m.method_name].append(1)
                else:
                    precision[test][m.method_name].append(0)
                # error['full_test'][m.method_name].append(distances[result[0][0]][s])
                # topological_error['full_test'][m.method_name].append(topological_distances[result[0][0]][s])
                error[test][m.method_name].append(
                    nx.dijkstra_path_length(d.subgraph, result[0][0], s, weight='weight'))
                topological_error[test][m.method_name].append(
                    nx.dijkstra_path_length(d.subgraph, result[0][0], s, weight=None))
                r = 0
                for u in result:
                    r += 1
                    if u[0] == s:
                        ranking[test][m.method_name].append(r)
                        break


start_time = clock()
print "Starting..."
d = data.Graph("../data/test.txt", weighted=1)
d = data.Graph("../data/power-grid.txt")
d.debug = False
d.ratio_infected = 0.001
random_num=0.01 * d.graph.number_of_nodes()
print 'Graph size: ', d.graph.number_of_nodes(), d.graph.number_of_edges(), d.graph.number_of_nodes() * d.ratio_infected
weight = nx.get_edge_attributes(d.graph, 'weight')
if d.debug:
    print weight

methods = [rc.RumorCenter(d), di.DynamicImportance(d), dc.DistanceCenter(d),
           jc.JordanCenter(d), ri.ReverseInfection(d), dmp.DynamicMessagePassing(d), gsba.GSBA(d)]
methods = [dmp.DynamicMessagePassing(d), gsba.GSBA(d) ]

precision = {}  # Detection Rate
error = {}  # Detection Error
topological_error = {}  # Detection topological Error
ranking = {}  # Normalized Ranking

initialize_evaluation_measures(precision, error, topological_error, ranking, methods)

# distances = nx.all_pairs_dijkstra_path_length(d.graph, weight='weight')
# topological_distances = nx.all_pairs_dijkstra_path_length(d.graph, weight=None)
# if d.debug:
#     print distances
initialize_time = clock()
#detection_test(d, precision, error, topological_error, ranking, methods)
full_test_time = clock()

detection_test(d, precision, error, topological_error, ranking, methods, random_test=True,
               random_num=random_num)
random_test_time = clock()
print "Runing time:", start_time, (initialize_time - start_time), (full_test_time - initialize_time), (
random_test_time - full_test_time)

test = "full_test"
for m in methods:
    l = len(precision[test][m.method_name])+1.0
    print sum(precision[test][m.method_name])/l, sum(error[test][m.method_name])/l, sum(
        topological_error[test][m.method_name])/l, sum(ranking[test][m.method_name])/l, m.method_name
test = "random_test"
for m in methods:
    l = len(precision[test][m.method_name])+1.0
    print sum(precision[test][m.method_name])/l, sum(error[test][m.method_name])/l, sum(
        topological_error[test][m.method_name])/l, sum(ranking[test][m.method_name])/l, m.method_name