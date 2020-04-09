fst_line = input()
snd_line = input()
n, m = map(int, fst_line.split())
cats = list(map(int, snd_line.split()))
paths = [[] for i in range(n)]

for i in range(n-1):
    line = input()
    a, b = map(int, line.split())
    paths[a-1].append(b-1)
    paths[b-1].append(a-1)

def step(curr, on_path, prev):
    counter = 0
    if cats[curr] == 0:
        counter = 0
    else:
        counter = on_path + cats[curr]
    if counter > m:
        return 0
    leaf = True
    result = 0
    for node in paths[curr]:
        if node == prev:
            continue
        leaf = False
        result += step(node, counter, curr)
    if leaf:
        return 1
    return result

print(step(0, 0, -1))


