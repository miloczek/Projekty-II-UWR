słowa=open('slowa.txt', encoding='utf8').read().split()
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

def szyfr(s):
    odkodowane=[]
    wyrazy=s.split()
    for i in wyrazy:
        for j in słowa:
            if len(i) == len(j):
                if zamiana(i) == zamiana(j):
                    odkodowane.append(j)
                    break
    return ' '.join(odkodowane)
    

print(szyfr("fulfolfu ćtąśśótą tlźlźltą"))
print(szyfr("udhufńfd ąuąuęąę yrrożdśś śdśsdtsć"))

