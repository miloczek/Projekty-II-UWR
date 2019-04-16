L=[1,2,3,100]
def zbiory(L):
    if len(L) == 0:
        return [[]]
    return zbiory(L[1:]) + [[L[0]] + i for i in zbiory(L[1:])]

def suma(zbiory):
    sumy=set()
    for i in zbiory:
        suma=sum(i)
        sumy.add(suma)
    return sumy

def reku(L):
    return(suma(zbiory(L)))

#print(zbiory(L))
print(zbiory(L))
