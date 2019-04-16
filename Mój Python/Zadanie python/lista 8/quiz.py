from random import *

def sprawdz(s, n):
    wykaz=literka(n)
    for x in s:
        if x not in wykaz:
            return False
        wykaz[x]-=1
        if wykaz[x]<0:
            return False
    return True

def literka(s):
    L=list(s)
    D={}                            #funkcja z zadania 2
    for i in range(len(L)):         #tworzę słownik z liter i ich ilości
        if L[i] not in D:
            D[(L[i])]= 1
        else:
            D[(L[i])]= D[(L[i])] + 1
    return D

def quiz(tekst):
    litery=literka(tekst)
    L=[]
    pick=[]
    for x in open('slowa.txt', encoding="utf8").read().split():
        if sprawdz(x, tekst)==True:      #tworzę liste w której są słowa układalne z naszego tekstu
            L.append(x)
    for x in L:
        i=L.index(x)            #zwraca kolejne indeksy
        for y in L[i:]:         
            suma=x+y
            if len(suma)==len(tekst):            #potem czy nowe słowa mają tą samą długość co wyjściowe
                if sprawdz(suma, tekst)==True:
                    z=(x,y)
                    pick.append(z)
    print(' '.join(choice(pick)))
            
            
        

quiz('tomaszdupa')
#quiz('filipsieczkowski')
#quiz('')




