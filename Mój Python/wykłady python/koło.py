from turtle import *
from math import *
speed('fastest')

def okrag(r, kolor):
    pu()   #ta i 2 nastepne wypierdala zolwia na orbite r
    fd(r)
    pd()
    fillcolor(kolor) #cos se koloruje
    begin_fill()
    for i in range(360): #jakis wzor z internetu bo sa takie grafiki ze sinusy i cosinusy w ukladzie kartezjanskim i jakis tam stosunek r kola i ktos napisal wzor i wstawil do neta to ukradlam
        goto(r*cos(i*0.018), r*sin(i*0.018))    #mnoznik taki a nie inny bo jak wiekszy to on robi w chuj kolek z jakiegos powodu
    pu()  #jak powiedzialam pry nie wiem czemu taki mnoznik ale on tez mnozy wiec i ja mnoze to i tak dal maksa i cos tam powiedzial ze to ma zwiazek z pi i okresem
    goto(0, 0) #wraca na miejsce
    end_fill()



n = 12
while n > 0: #kolorki sie mialy zmieniac co 3 wiec caly program dziala tylko dla liczb podzielnych przez 3 bo jestem leniwa bulwa
    okrag(10 * n, 'pink')
    okrag(10 * (n - 1), 'white')   
    okrag(10 * (n - 2), 'magenta')
    n = n - 3

input()
