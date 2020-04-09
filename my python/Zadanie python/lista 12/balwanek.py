from math import sin
from math import pi
 
def kolko(n):
    D = 40
    x = pi / n
    for i in range(n):
        ile_gwiazdek = int(n * sin(x * i))
        if (ile_gwiazdek > 0):              #żeby nie robił przerw
            print((D - ile_gwiazdek) * ' ' + 2 * ile_gwiazdek * '*') #mnożę razy 2 aby nie printowało mi pół bałwanka


def balwanek(wielkosc, wysokosc):
    for i in range(wysokosc):
        kolko(wielkosc)
        wielkosc+=4
    return ''

print(balwanek(7,3))
        
