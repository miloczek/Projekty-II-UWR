def przypisz(s):
    litery=list(s)
    D={}
    licznik=1
    for i in range(len(litery)):    #przyporządkowuje kolejnym literom słownika, kolejne wartości liczbowe
        if litery[i] not in D:
            D[litery[i]] = licznik
            licznik+=1
    return D

def zamiana(s):
    D=przypisz(s)
    wynik=[]
    for i in range(len(s)):
        wynik.append(str(D[s[i]]))  #zamieniam na string, aby działała funkcja join
    return '-'.join(wynik)
        
 
print(zamiana("indianin"))
print(zamiana("tak"))
print(zamiana("nie"))
print(zamiana("tata"))

