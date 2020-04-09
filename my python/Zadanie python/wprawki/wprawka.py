def potega(n,m):
    n = n ** m
    return n

def rev(p):
    return p[::-1]

def val(p,x):
    wynik = 0
    z = len(p)
    for i in range(z):
        wynik = wynik + (potega(x, (z - 1))) * p[i]
        z = z-1
    return wynik


    
p=[1,0,-1.5,2]



def horner(p, x):
    wynik = 0
    potega=1
    for i in range(len(p)):
        wynik+=p[i]*potega
        potega *= x
    return wynik

    
print(horner(p,2))       
        
    
    
    
