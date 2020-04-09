from turtle import *
from random import choice

def kwadrat(bok):
   begin_fill()
   for i in range(4):
     fd(bok)
     rt(90)
   end_fill()
   
def murek(s,bok,p='',t=''):
  t = list(t)
  p = list(p)
  for a in s:
    if a == 'f' or a == 'b':
        c1 = ''
        c2 = ''
        for c1 in t:
            t.remove(c1)
            break
        for c2 in p:
            p.remove(c2)
            break
        kolor(c1, c2)
    if a == 'f':
       kwadrat(bok)
       fd(bok)
    elif a == 'b':
       kwadrat(bok)
       fd(bok)       
    elif a == 'l':
       bk(bok)
       lt(90)
    elif a == 'r':
      rt(90)
      fd(bok)
  update()



def kolor(t, p):
    t = wez_kolor(t)
    p = wez_kolor(p)
    color(t,p)

def wez_kolor(k):
    kolory = zwroc_kolory()
    if k == 'B':
        k = kolory[0]
    elif k == 'w':
        k = kolory[1]
    elif k == 'y':
        k = kolory[2]
    elif k == 'b':
        k = kolory[3]
    elif k == 'r':
        k = kolory[4]
    elif k == 'g':
        k = kolory[5]
    elif k == 'o':
        k = kolory[6]
    else:
        k = choice(kolory)
    return k

def zwroc_kolory():
    return ['Black', 'white', 'yellow', 'blue', 'red', 'green', 'orange']


