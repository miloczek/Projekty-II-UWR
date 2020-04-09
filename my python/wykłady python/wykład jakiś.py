import random

def tlumacz(txt):
    wynik=[]
    for p in txt.split():
        if p in pol_ang:
            wynik.append(pol_ang[p])
        else:
            wynik.append('?' + p)
    return ' '.join(wynik)

pol_ang = {} #pusty słownik

for x in open('pol_ang.txt'):
    x = x.strip()
    L = x.split('=')
    if len(L) != 2:
        continue
    pol, ang = L

    if pol not in pol_ang:
        pol_ang[pol] = [ang]
    else:
        pol_ang[pol].append(ang)

    """
 if pol not in pol_ang:
    pol_ang[pol] = []
 pol_ang[pol]
