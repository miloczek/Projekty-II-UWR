from turtle import *

speed('fastest')

def reku(poziom, dlugosc):
    if poziom == 0:
        fd(dlugosc)
    else:
        dlugosc = dlugosc / 4
        reku(poziom -1, dlugosc)
        lt(90)
        reku(poziom -1, dlugosc)
        rt(90)
        reku(poziom -1, dlugosc)
        rt(90)
        reku(poziom -1, dlugosc)
        lt(90)
        reku(poziom -1, dlugosc)

for i in range(6):
    reku(3, 600)
    rt(60)
        
