from turtle import *

speed ("fastest")


def kwadrat(bok):
    for i in range(4):
        fd(bok)
        lt(90)
    pu()
    fd(bok)
    lt(90)
    fd(bok)
    lt(90)
    fd(0.9 * bok)
    rt(180)
    pd()

def kwadrat_rev(bok):
    for i in range(4):
        fd(bok)
        lt(90)
    fd(bok)
    lt(90)
    fd(bok)
    lt(90)
    fd(0.9 * bok)
    rt(180)
    
        
def sześciobok(bok):
    rt(30)
    for i in range(6):
        fd(bok)
        rt(60)
        
def wieża(bok):
    for i in range(5):
        kwadrat(bok)
        bok= 0.8 * bok

def wieża_rev(bok):
    for i in range(5):
        kwadrat_rev(bok)
        bok= 0.8 * bok
   
   


def patryk(bok):
    sześciobok(bok)
    for i in range(6):
        wieża(bok)
        pu()
        wieża_rev(-bok)
        pd()
        fd(bok)
        rt(60)
    
    
    
    

patryk(100)


        
