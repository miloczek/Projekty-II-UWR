from turtle import *
from random import *
speed("fastest")

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

def last_2(bok):
   pu()
   lt(90)
   fd(5 * bok)
   rt(90)
   fd(6 * bok)
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
         if e==4:
            last_2(bok)   #w ostatnim wierszu musi przejść w prawo po ukończeniu aby zacząć następną cyfrę
            
bok=40
kolory = ['red', 'blue', 'purple', 'yellow', 'pink', 'light blue', 'green', 'gray', 'dark green']
n = 735

liczba(bok,kolory,n)

      

    
                
               
