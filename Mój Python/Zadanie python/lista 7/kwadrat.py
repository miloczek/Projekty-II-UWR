from murek import *
from turtle import *

def zrob_kwadrat(n):
    s = ""
    for i in range(n,0,-1):
        s += i * 'f' + 'r' + (i - 1) * 'f' + 'r'
    return s

def zrob_spirale(n):
    s = ''
    for i in range(n,0,-1):
        s += i * 'f' + 'r'
    return s

def zrob_kolorki(s):
    temp = zwroc_kolory()
    kolorki = ''
    i = 0
    for letter in s:
        if letter == 'f' or letter == 'b':
            kolorki += temp[i][0]
            i += 1
        if i >= len(temp):
            i = 0
    return kolorki

def przesun():
    penup()
    goto(-200, 200)
    pendown()


def main():
    tracer(0, 0)
    s = zrob_kwadrat(10)
    murek(s, 20, len(s) * '', len(s) * 'B')

    przesun()
    s = zrob_spirale(10)
    k = zrob_kolorki(s)
    murek(s, 20, k, len(s) * 'B')
    input()


main()
