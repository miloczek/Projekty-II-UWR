def tylko_jeden(L):
    wynik= []
    zbior = set()
    
    for e in L:
        if not e in wynik:
            wynik.append(e)
            zbior.add(e)
            
    return wynik

print(tylko_jeden([1,2,3,4,5,6,7,1,2,111]))

długa_lista = list(range(100000))

tylko_jeden(długa_lista)

print(len(tylko_jeden(długa_lista)))

print('Skończyłem!')
