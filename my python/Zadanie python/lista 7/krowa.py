from turtle import *
bok=7
speed('fastest')

def kwadrat(bok,kolor):
    fillcolor(kolor)
    begin_fill()
    for i in range(4):
        fd(bok)
        rt(90)
    end_fill()
    
colormode(255)
tracer(0,1)
pu()
goto(-100,100)
pd()

for wiersze in open('obrazek tekstowy.txt').readlines():
    L=wiersze.split()
    for i in range(len(L)):
        kolor=eval(L[i])
        kwadrat(bok,kolor)
        pu()
        rt(90)
        fd(bok)
        lt(90)
        pd()
    pu()
    fd(bok)
    lt(90)
    fd(len(L)*bok)
    rt(90)
    pd()
    

