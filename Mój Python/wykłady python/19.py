licznik = 1

czteroliterowce = set()
kandydaci = []

def dobre(s):
    for i in range(0, len(s), 4):
        if s[i:i+4] in czteroliterowce:
            return False
    return True

for x in open('slowa.txt'):
    x = xstrip() #obcina białe znaki z początku i końca

    if len(x) == 4:
        czteroliterowce.add(x)
        
    if len(x) % 4 != 0:
        continue

    #print('Wiersz', licznik, x, len(x) % 4)
    licznik += 1
print (len(czteroliterowce))
