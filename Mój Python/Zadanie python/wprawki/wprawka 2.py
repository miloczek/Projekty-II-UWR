def potega(n,m):
    n = n ** m
    return n

def val(p,x):
    wynik = 0
    z = len(p)
    for i in range(z):
        wynik = wynik + (potega(x, (z - 1))) * p[i]
        z = z - 1
    return wynik

def pole(a,b):
    wynik = a * b
    if wynik < 0:
        wynik = wynik * (-1)
        return wynik
    else:
        return wynik

def surf(p, xS, xF, dx):
    rez = 0
    while xS <  xF:
        rez = rez + pole(val(p,xS), dx)
        xS += dx
    return rez
        
    
p= [1,0,3]   
print(surf(p, 0, 3, 0.0001))    
    
