def only_one(L):
    P=[]
    for i in L:
        if i not in P:
            P.append(i)
    return P
            
L=[7,7,7,7,81,81,6,6,6,6,999,999,9999]

print(only_one(L))
