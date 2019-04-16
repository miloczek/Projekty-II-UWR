import re

lalka = open('lalka.txt').read()

def spojny(S):
    F = re.findall('[^ąęółźśćżń]*', S)#wyrazenie takie ze nie zawiera wymienionych znakow dluzsze niz 1
    maxi = 0
    for e in F: #szuka najdluzszego fragmentu
        if len(e) > maxi:
            maxi = len(e)
    for e in F: #printuje najdluzszy fragment
        if len(e) == maxi:
            print(e)

spojny(lalka)
