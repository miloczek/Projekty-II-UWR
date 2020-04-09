from math import *

def Rombert(n, a, b, f):
    T = n*[0]

    for i in range(n):
        T[i] = n*[0]

    for i in range(0,n): #wyliczam pierwszą kolumnę z sumy kolejnych f(a + ih)
        h = (b-a) / (2**i)
        s = 0
        for j in range(2**i+1):
            if j == 0 or j == 2**i:
                s += (1/2)*(f(a+j*h))
            else:
                s += f(a+j*h)
        T[0][i] = h*s

    for m in range(1,n):  #tutaj kolejene wyrazy w tablicy Romberta
        for k in range(n-m):
            T[m][k] = ((4**m) * T[m-1][k+1] - T[m-1][k]) /  (4**m - 1)

    return T[m][0]

def f1(x):
    return 2019*(x**5) - 2018*(x**4) + 2017*(x**3)

def f2(x):
    return 1/(1+25*x*x)

def f3(x):
    return sin(9*x+1)/x

print(Rombert(15, -1, 2, f1))
print("Błąd wynosi:")
print((308889/20) - (Rombert(15, -1, 2, f1)))
print("***************")
print(Rombert(15, -1, 1, f2))
print("Błąd wynosi:")
print((2*atan(5))/5 - (Rombert(15, -1, 1, f2)))
print("***************")
print(Rombert(15, 1, 2*pi, f3))
print("Błąd wynosi:")
print((-0.07738641956328774789400576265394737461719586343823409338018566468014856027006920756288308651976467762) - (Rombert(15, 1, 2*pi, f3)))
