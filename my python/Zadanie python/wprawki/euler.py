def num(i):
    return 1

def den(i):
    if i==0:
        return 1
    elif (i+2)%3:
        return ((i+2)/3)*2
    else:
        return 1
    

def cont_frac(num,den,k):
    wynik=num(k)/den(k)
    while k>0:
        wynik= num(k-1)/(wynik + den(k-1))
        k = k-1
    return wynik
                         


print(cont_frac(num,den,9))
            
    
