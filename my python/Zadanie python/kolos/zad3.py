# abs = wartość bezwzględna
# int = integer (całkowita, funkcja obcina ułamek)
# round = zaokrąglenie
# modulo czyli % 1 = ułamek
# % = reszta z dzielenia

import math

D = 10

for i in range(100):
    ile_gwiazdek = int(D * abs(math.sin(0.1*i)))
    print (( D - ile_gwiazdek) * ' ' + (ile_gwiazdek * '*')*2)
    i=i+20
