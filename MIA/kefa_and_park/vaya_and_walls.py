def dfs(node, prev, g, s, d, depth, odd, even):
    flag = ((depth % 2) & odd) or (((depth + 1) % 2) and even)
    if d[node] ^ flag:
        s.add(node)

    if depth & 1:
        odd = 1 - odd

    else:
        even = 1 - even

    for p in range(len(g[node])):
        u = g[node][p]
        if u == prev:
            continue
        dfs(u, node, g, s, d, (depth + 1) % 2, odd, even)

    return

if __name__ == '__main__':
    a = b = w = []
    n = int(input())
    g = [[] for i in range(n)]

    for i in range(1, n):
        x, y = map(int, input().split())
        g[x-1].append(y-1)
        g[y-1].append(x-1)

    a = list(map(int, input().split()))
    b = list(map(int, input().split()))
    for i in range(n):
        w[i] = a[i] ^ b[i]