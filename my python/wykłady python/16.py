from turtle import *
import random

speed('fastest')

def kwadrat(bok, kolor):
    fillcolor(kolor)
    begin_fill()
    for i in range(4):
        fd(bok)
        rt(90)
    end_fill()

kolory = ['red','blue', 'purple', 'yellow', 'black', 'pink', 'white', 'green', 'gray', 'magenta', 'indigo', 'cyan']

BOK= 30

def mieszanka(a, k1, k2):
    r1,g1,b1=k1
    r2,g2,b2=k2

    return (a * r1 + (1-a) * r2,
            a * g1 + (1-a) * g2,
            a * b1 + (1-a) * b2)

k1= (1,1,0)
k2= (0,1,0.5)

for i in range(100):
    a = i * 0.1
    kwadrat(BOK, mieszanka(a, k1, k2))
    rt(90)
    fd(BOK)
input()
