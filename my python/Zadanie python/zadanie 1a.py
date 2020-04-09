import math
import numpy as np

def liczenie_zle(x):
    return np.float32((math.e)**x**2) - np.float32((math.e)**(3*x)**5)

def w_realu(x):
    return (math.e)**x**2 - (math.e)**(3*x)**5

def liczenie_dobre(x):
    suma = 0
    for n in range(1,10):
        suma += ((3*x**5 - x**2)**n)/math.factorial(n)
        
    return -(np.float32((math.e)**x**2))* np.float32(suma)

print (liczenie_zle(0 - 0.001))
print (liczenie_dobre(0 - 0.001))

#wg wolframa to jest jakieś 10^(-6)
