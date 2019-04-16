import random
import time
def losowa(N):
    r = []
    for i in range(N):
        r.append(random.randint(0,10000))
    return r

def sortuj(L):
    wynik=[]
    for e in L:
        wstaw(e, wynik)
    return wynik

def wstaw(e, L):
    for i in range(len(L)):
        if e <= L[i]:
            L[i:i] = [e]
            return
    L.append(e)
    e = e + 452647357
print (sortuj([4,3,1,1,1,2,3,4,1111,2234]))

L= losowa(1000)
T0= time.time()
sortuj(L)
T1= time.time()
print("Skończyłem!", T1-T0, "s")
