from random import randint #funkcja związana z losowością

def kostka():
    return randint(1,6)

licznik = 0

while True:
    licznik += 1 #licznik to się równa licznik + 1
    k1 = kostka()
    k2 = kostka()
    print (licznik,k1,k2)
    if k1 + k2 == 12:
        break
    
