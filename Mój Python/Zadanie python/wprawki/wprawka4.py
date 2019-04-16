def num(i):
    return 1

def den(i):
    return i + 2

def cont_frac(num,den,k):
    wynik=num(k)/den(k)
    while k>=0:
        wynik= num(k-1)/(wynik + den(k-1))
        k = k-1
    return wynik
                         


print(cont_frac(num,den,3))
            
    
