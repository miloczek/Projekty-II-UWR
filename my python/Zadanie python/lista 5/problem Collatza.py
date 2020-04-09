def F(n):
    if n % 2 == 0:
        return n / 2
    else:
        return 3 * n + 1 #Funkcja Collatza z treści zadania

def energia(n):
    L=[]
    while n != 1: #1 jest ostatnim elemenem listy złożonej z kolejnych uruchomień funkcji
        n= F(n)
        L.append(n)
    return len(L)

def energia_przedziału(a,b): 
    P=[]
    if a==b:
        return 
    else:
        for i in range(a,b+1):
            P.append(energia(i))
        return P
    
    
def średnia(P):
    licznik = 0
    for i in range(len(P)):
        licznik = licznik + P[i]
    licznik = licznik / len(P)
    return licznik

def mediana(P):
    L=sorted(P)
    d=len(L)
    if d % 2 != 0:
        return L[d // 2]
    else:
        return (L[d // 2] + L[d // 2 - 1]) / 2
    

def analiza(a,b):
    P= energia_przedziału(a,b)
    print(P)
    print("Średnia =", średnia(P))
    print("Mediana =", mediana(P))
    print("Maksymalna energia =", max(P))
    print("Minimalna energia =", min(P))


          
