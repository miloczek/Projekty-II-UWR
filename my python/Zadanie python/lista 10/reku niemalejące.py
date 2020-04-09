def lista(a,b):
    L=[]
    for i in range(a,b+1):
        L.append(i)
    return L
        
def zbiory(L):   
    if len(L) == 0:
        return [[]]
    return zbiory(L[1:]) + [[L[0]] + i for i in zbiory(L[1:])]

def ciagi(L,n):
    wynik=[]
    for i in L:
        if len(i)==n:
            wynik.append(i)
    return wynik
    
def main(a,b,n):
    return ciagi(zbiory(lista(a,b)),n)

print(main(1,4,2))

