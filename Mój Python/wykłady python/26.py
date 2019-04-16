literki ='chrzańufnąbelgijskośćtępwyżmłódź'

słowa = set(open('popularne_slowa.txt').read().split()

slowa4 = {w for w in slowa if len(w)== 4}

def sasiedzi(w):
    res = set()
    for i in range(4):
        for a in literki:
            W=list(w)
            nowy = ''.join(W)
            if nowy in slowa4:
                res.add(nowy)
    return res
    

"""
G = {
    1:[2,3],
    2:[5,7],
    3:[4,5],
    4:[],
    5:[8],
    6:[8],
    7:[6],
    8:[]
    }
def connected(a,b,G):
    if a == b:
        return True
    if a not in G:
        return False
    for e in G[a]:
        if connected(e,b,G):
            return True
    return False
"""

def path(a,b,G,visited):
    if a == b:
        return [a]
    if a in visited:
        return []
    if a not in G:
        return []
    visited.add(a)
    for e in G[a]:
        p = path(e, b, G, visited)
        if p:
            return [a] + p
    return []

P = [(1,8), (2,7), (1,6), (2,6), (3,2)]

for a,b in P:
    print(a,b,connected(a,b, G))
