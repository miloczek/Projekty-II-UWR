from turtle import fd, bk, lt, rt, pu, pd, speed
speed('fastest')

def gwiazdka(N, a):
    for i in range(10):
        fd(N)
        for j in range(10):
            fd(a)
            bk(a)
            lt(36)
        bk(N)
        lt(36)


gwiazdka(200,50)
