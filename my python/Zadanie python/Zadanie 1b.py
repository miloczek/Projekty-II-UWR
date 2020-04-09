import math
import numpy as np

def liczenie_zle(x):
    return np.float32(x**(-3))*np.float32((math.pi/2 - x - (math.pi/2 - math.atan(x))))

def liczenie_dobre(x):
    suma = 0
    for n in range(42):
        suma += np.float32(((-1)**(n+1))/(2*n + 3) * x**(2*n))
    return np.float32(suma)


print(liczenie_zle(0 - 0.001))
print(liczenie_dobre(0 - 0.001))
        
