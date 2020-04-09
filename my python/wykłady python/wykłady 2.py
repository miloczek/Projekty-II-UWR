import math
D=40
for i in range(100):
    ile_gwiazdek = int( D*abs(math.sin(0.1 * i)))
    print ( (D - ile_gwiazdek) * ' ' + 2 * ile_gwiazdek * "*")

