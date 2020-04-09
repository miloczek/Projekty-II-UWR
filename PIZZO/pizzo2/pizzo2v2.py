import json

def make_empty_graph(n):
    graph = {}
    maximum_elem = 1
    while maximum_elem <= n:
        graph[maximum_elem] = []
        maximum_elem += 1
    return graph

def conflicts_graph(graph, dict):
    for elem in dict['konflikty']:
        nr_nielubiany = elem['nielubiany'] + 1
        nr_zrzeda = elem['zrzeda'] + 1
        if nr_nielubiany not in graph[nr_zrzeda]:
            graph[nr_zrzeda].append(nr_nielubiany)
            if nr_zrzeda not in graph[nr_nielubiany]:
                graph[nr_nielubiany].append(nr_zrzeda)
    return graph

def simplyfy_graph(graph):
    to_erase = []
    for v in graph:
        if len(graph[v]) < 4:
            to_erase.append(v)
    for item in to_erase:
        del graph[item]
    for v in graph:
        for item in to_erase:
            if item in graph[v]:
                graph[v].remove(item)
    return graph

def good_enumerate_variables(graph):
    counter = 1
    for v in graph:
        if v == counter:
            counter += 1
        elif v != counter:
            for z in graph:
                if v in graph[z]:
                    graph[z].remove(v)
                    graph[z].append(counter)
            counter += 1
    new_graph = {}
    counter = 1
    for lists in graph.values():
        new_graph[counter] = lists
        counter += 1
    return new_graph

def can_reduce(graph):
    for v in graph:
        if len(graph[v]) < 4:
            return True


def generate_var(tutor_num, vertex_num, number_of_meaning_verteces):
    return tutor_num * number_of_meaning_verteces + vertex_num

def local_one_color(vertex, set_of_tutors, n):
    clause = []
    base = []
    for num in set_of_tutors:
        base.append(generate_var(num, vertex, n))
    clause.append(base)
    for i in range(0, len(base)):
        for j in range(0, len(base)):
            if i == j:
                break
            clause.append([-base[i], -base[j]])
    return clause

def global_unique_color(graph, vertex, set_of_tutors, n,  used):
    clause = []
    for v in graph[vertex]:
        if (v, vertex) not in used:
            for num in set_of_tutors:
                clause.append([-generate_var(num, vertex, n), -generate_var(num, v, n)])
    return clause

def main():
    file_name = input()
    tutors = [0, 1, 2, 3]
    variables = max_deg = 0
    cnf = []
    used = []
    with open(file_name, 'r') as f:
        tutorzy_dict = json.load(f)
    n = tutorzy_dict['studenci']
    empty = make_empty_graph(n)
    graph = conflicts_graph(empty, tutorzy_dict)
    while can_reduce(graph):
        graph = simplyfy_graph(graph)
    graph = good_enumerate_variables(graph)
    for v in graph:
        if len(graph[v]) > max_deg:
            max_deg = len(graph[v])
    if max_deg < 4:
        print("p cnf 1 1")
        print("1 0")
    else:
        n = len(graph)
        for v in graph:
            if graph[v]:
                loc = local_one_color(v, tutors, n)
                variables += 4
                glo = global_unique_color(graph, v, tutors, n, used)
                for elem in graph[v]:
                    used.append((v, elem))
                cnf += loc + glo
            else:
                loc = local_one_color(v, tutors, n)
                variables += 4
                cnf += loc
        print("p cnf " + str(variables) + " " + str(len(cnf)))
        for clau in cnf:
            string = ""
            for var in clau:
                string += str(var) + " "
            string += "0"
            print(string)

main()


