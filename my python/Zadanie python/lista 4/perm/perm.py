from random import choice

def randperm(n):
    L=[]
    z=[]
    for i in range(n):
        L.append(i)
    for e in L:
        x=choice(L)
        if x not in z:
            z.append(x)
        else:
            L.append(x)
        
        
    return z
        
    

