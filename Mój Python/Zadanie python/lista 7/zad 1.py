from turtle import *
from random import *
speed('fastest')

Cyfry = {}

Cyfry[0] = """
 ###  
#   #
#   #
#   #
 ###
"""

Cyfry[1] = """
  #
 ##
  #
  #
 ###
"""

Cyfry[4] = """
 # 
#
#####
  #
  #
"""


Cyfry[2] = """
 ###  
#   #
  ##
 #
#####
"""

Cyfry[5] = """
##### 
#   
####
    #
####
"""

Cyfry[8] = """
 ###  
#   #
 ### 
#   #
 ###
"""

Cyfry[6] = """
 ###  
#   
#### 
#   #
 ###
"""

Cyfry[9] = """
 ###  
#   #
 ####
    #
 ###
"""

Cyfry[3] = """
####  
    #
 ### 
    #
####
"""

Cyfry[7] = """
#####
   #
 ###
 #
# 
"""

Pytajnik = """
 ###  
#   #
  ##
   
  #
"""

def popraw(s):
   L = s.split('\n')
   for i in range(len(L)):
      if len(L[i]) < 5:
         L[i] += (5-len(L[i])) * " "
      else:
         L[i] = L[i][:5]   
   return L[1:-1]      

def dajCyfre(n):
   if n not in range(10):
      return popraw(Pytajnik)
   return popraw(Cyfry[n])

def kwadrat(bok, kolor):
    fillcolor(kolor)
    begin_fill()
    for i in range(4):
        fd(bok)
        lt(90)
    end_fill()
    pu()
    fd(bok)
    pd()

def pusty(bok):
    pu()
    fd(bok)
    pd()

def last_1(bok):
   pu()
   lt(180)
   fd(5 * bok)
   lt(90)
   fd(bok)
   lt(90)
   pd()


def liczba(bok,kolory,n):
   k=str(n)
   for i in k:
      kolor=choice(kolory)
      x=dajCyfre(int(i))
      for e in range(5):
         for j in range(5):
            if x[e][j]==" ":
               pusty(bok)
            else:
               kwadrat(bok,kolor)
            if j==4:
               last_1(bok)  #ostatni w wierszu hashów i spacji musi przemieścić się niżej
         
            
bok=9
kolory = ['red', 'blue', 'purple', 'orange', 'green', 'yellow', 'pink']


def rysunek(bok,ile):
    tracer(0,1)
    for i in range(ile):
        x=randint(1,9)    #losuję jaką cyfrę narysuje
        y=randint(1,6)    #losuję jaki warunek przejścia do następnej cyfry mi się zrobi
        liczba(bok,kolory,x)
        if y==1:
            pu()
            fd(bok*15)
            rt(90)
            fd(bok*7)
            lt(90)
            pd()
        elif y==2:
            pu()
            rt(90)
            fd(bok*3)
            lt(90)
            pd()
        elif y==3:
            pu()
            lt(180)
            fd(bok*2)
            rt(180)
            fd(bok*3)
            pd()
        elif y==4:
            pu()
            lt(90)
            fd(bok)
            rt(90)
            fd(bok*3)
            pd()
        elif y==5:
            pu()
            lt(180)
            fd(bok*2)
            lt(180)
            pd()
        else:
            pu()
            fd(bok*5)
            lt(90)
            fd(bok*5)
            rt(90)
            pd()
            
            
                 
    

      
rysunek(bok,56)

    
                
               
