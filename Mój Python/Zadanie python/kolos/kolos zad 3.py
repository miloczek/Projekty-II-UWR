def dzielniki(n):
    lista=[]
    wynik={}
    for i in range(2,n):
        while n % i == 0:
            lista.append(i)
            n /= i
    for v in range(len(lista)):
        if lista[v] not in wynik:
            wynik[(lista[v])]= 1
        else:
            wynik[(lista[v])]+= 1
    return wynik
print(dzielniki(156))                     

def wymnóż(D):
    wynik=1
    for i in D:
        wynik= wynik * i ** D[i]
    return wynik
print(wymnóż(dzielniki(12)))

def nwd(n,m):
    D1=dzielniki(n)
    D2=dzielniki(m)
    for i in D2:
        if i in D1:
            wynik=i
            continue
        else:
            break
    return wynik

print(nwd(10,40))
        
