plik = open('slowa.txt', encoding="utf8").read().split()

s = set(plik) 

def palindromy(s):
    ogolna = []
    użyte = [] 
    for e in s:
        palindrom = () #robię krotkę
        test = () #testowa krotka
        rev = str(e[::-1]) #rev odwraca kolejność
        if rev in s:
            test = (e, rev) #w testowej krotce e i rev są w innej koejności niż w krotce palindrom
            if test not in użyte: #sprawdzam czy testowa jest na liście już użytych, jak nie to ok
                palindrom = (rev, e) 
                ogolna.append(palindrom) #dodaje palindrom do ogolnej
                użyte.append(palindrom) #i dodaje do zuzytych zeby potem sprawdzac, zeby tylko raz wywalalo
    print(ogolna)
    
palindromy(s)
