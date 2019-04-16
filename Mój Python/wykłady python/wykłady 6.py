def rev1(L):    #funkcja odwracająca listę
    L0 = L[:]    #funkcja kopiująca listę
    for i in range(len(L) // 2): #dzielenie całkowiete
        j = len(L) - 1 - i
        L0[i], L0[j] = L0[j], L0[i]
    return L0    #pierwszy sposób

def rev2(L):
    wynik = []
    for i in range(len(L)):
        wynik.append( L[len(L) - i -1])
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

L = [1,2,3,4,'Hej!']

print (rev1(L))
print (rev2(L))
print (rev3(L))
print (rev4(L))
