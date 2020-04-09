from random import randint #funkcja związana z losowością

def kostka():
    return randint(1,6)

licznik = 0

k1 = k2 = 0
k1,k2 = 0,0

while k1 + k2 != 12:
    licznik += 1 #licznik to się równa licznik + 1
    k1 = kostka()
    k2 = kostka()
    print (licznik,k1,k2)
    
