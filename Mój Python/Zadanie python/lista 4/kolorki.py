from turtle import *
from random import choice

speed('fastest')

def kwadrat(bok, kolor):
  fillcolor(kolor)
  begin_fill()
  for i in range(4):
    fd(bok)
    rt(90)
  end_fill()
  
kolory = ['red', 'blue', 'purple', 'yellow', 'pink', 'light blue', 'green', 'gray', 'dark green']

BOK = 30

for j in range(10):
  for i in range(10):
    x=choice(kolory)
    kwadrat(BOK, x)
    fd(BOK)
  pu()
  bk(10*BOK)
  lt(90)
  fd(BOK)
  rt(90)
  pd()

