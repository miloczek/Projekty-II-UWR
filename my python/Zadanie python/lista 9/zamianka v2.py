def zamianka(x,y):
    zużyte={}
    X=list(x)
    Y=list(y)
    if x == y:
        return None
    else:
        for i in range(len(X)):
            if X[i] != Y[i]:
                zużyte[(X[i])]=Y[i]
    for e in zużyte:
        print(X[e],'->',zużyte[(X[e])])

print(zamianka('duka','duci'))
print(zamianka('kuka','puza'))
