from turtle import fd, bk, lt, rt, pu, pd, speed

speed('fastest')

def kwadrat(bok):
    for i in range(4):
        fd(bok)
        rt(90)

def rozeta(N, a, b):
    for i in range(N):
        fd(b)
        kwadrat(a)
        bk(b)
        rt (360 / N)

def wzorek():
    for i in range(100):
        kwadrat(20 + i)
        rt(4)
        pu() # znika nam część kwadratów
        fd(12)
        pd() #również znika


rozeta(36,20,50)
