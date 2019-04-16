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

BOK= 100

for i in range(100):
    R= random.random()
    G= random.random()
    B= random.random()
    kwadrat(BOK,(R,G,B))
    rt(90)
    fd(BOK)
input()
