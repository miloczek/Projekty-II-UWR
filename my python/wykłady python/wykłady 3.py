def potega(a, n):
    wynik = 1
    for i in range(n):
        wynik *=a
    return wynik

def potega2(a, n): #bez for
    if n== 0:
        return 1
    return a * potega2(a, n-1)

def potega3(a, n):
    wynik = 1
    while n != 0:
        wynik *= a
        n -= 1
    return wynik

for i in range(900,910):
    print (potega(2, i), potega2(2,i), potega3(2,i))
