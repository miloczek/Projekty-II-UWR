"""
zakres = range(1,100)
tp = [(x,y,z) for x in zakres for y in zakres for z in zakres if x**2 + y**2 == z**2 and x<y]

for t in tp[:10]:
    print(t)
"""
from turtle import *

speed('fastest')

def silnia(n):
    if n==0:
        return 1
    return n * silnia(n-1)

print(silnia(5))

def koch(poziom, dlugosc):
    if poziom == 0:
        fd(dlugosc)
    else:
        dlugosc = dlugosc / 3
        koch(poziom -1, dlugosc)
        lt(60)
        koch(poziom -1, dlugosc)
        rt(120)
        koch(poziom -1, dlugosc)
        lt(60)
        koch(poziom -1, dlugosc)

for i in range(3):
    koch(2,500)
    rt(120)

input()
        
