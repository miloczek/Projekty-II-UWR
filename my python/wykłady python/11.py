from turtle import fd, bk, lt, rt, speed

speed('fastest')

def kwadrat(bok):
    for i in range(4):
        fd(bok)
        rt(90)

for i in range(100):
    kwadrat(20 + i)
    rt(4)
    pu() # znika nam część kwadratów
    fd(12)
    pd() #również znika




