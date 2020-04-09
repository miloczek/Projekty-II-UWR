def zamianka(x,y):
    X=list(x)
    Y=list(y)
    if x == y:
        return None
    else:
        for i in range(len(X)):
            if X[i] != Y[i]:
                print(X[i],'->',Y[i])
        return ""

print(zamianka('duka','duci'))
