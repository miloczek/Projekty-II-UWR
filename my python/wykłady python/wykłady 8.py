import time
import sys

sys.setrecursionlimit(10000000)
    
def rev1(L):    #funkcja odwracająca listę
    L0 = L[:]    #funkcja kopiująca listę
    for i in range(len(L) // 2): #dzielenie całkowiete
        j = len(L) - 1 - i
        L0[i], L0[j] = L0[j], L0[i]
    return L0    #pierwszy sposób

def rev2(L):
    wynik = []
    for i in range(len(L)):
        wynik.append( L[len(L) - i -1]) #dodaj kolejne elementy do pamięci, czyli rozszerzam wynik o wartość w nawiasie
    return wynik     #drugi sposób

def rev3(L):
    wynik = []
    for e in L:       #przeglądanie elementów listy
        wynik = [e] + wynik
    return wynik

def rev4(L):
    if len(L) == 0:
        return []
    return rev4(L[1:]) + [L[0]] 

def rev5(L):
    L=L[:]
    L.reverse()
    return L

def rev6(L):
    return L[::-1] #bierzemy max od prawej i lewej i wypisujemy od końca

    
def testuj(rev,N):
    L=list(range(N))
    T0=time.time()
    rev(L)
    print(rev,time.time()-T0)

for rev in [rev1,rev2,rev3,rev5,rev6]:
    testuj(rev, 15000)

