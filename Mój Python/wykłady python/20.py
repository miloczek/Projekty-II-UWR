"""
for x in open(ścieżka):  #przeglądanie w plikach
    L = x.split()
    if len(L) != 3:
        print('WARNING: bad line', x)
        continue
    licznik, a,b = L
    licznik = int(licznik)

    if licznik > 1:
        if b == 'kobieta' or b == 'mężczyzna':
            if a[-1] in 'ay':
                print (licznik, a,b)
"""
"""
#wzór na liczbę pierwszą z wykorzystaniem "for i in range"
set(range(2,100)) - {x * y for x in range(2,100) for y in range(2,100)
"""
"""
slowa = set(open('slowa.txt').read().split()) #plik.read() -- zwraca tekst będący treścią całego pliku

odwrocone_slowa =  [s[::-1] for s in slowa ] #odwraca słowa
for x in sorted(slowa): #sortuje słowa alfabetycznie
    print(x[::-1])
"""
"""
def odwrocone(s):
    return s[::-1]
slowa = open('slowa.txt').read().split()
for x in sorted(slowa, key= lambda x:x[::-1]): #lambda tworzy nam własną funkcję
    print(x)
"""
S={eval(a+op+b) for a in "01234567" for b in "01234567" for op in "+-*"}
#bardzo przydatne!
#eval oblicza dane wyrażenie
