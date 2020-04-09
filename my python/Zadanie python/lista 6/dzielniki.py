def pierwsza(n):
    for i in range(2, n):
        if (n % i) == 0:
            return False
    return True

def dzielniki(n):
    P=[]
    L=set()
    for i in range(2,n+1):
        if n % i == 0 and pierwsza(i):
            L.add(i)
    
    return L
    

print(dzielniki(77))
