import math
import numpy as np

def liczenie(a,b,c):
    a = np.float32(a)
    b = np.float32(b)
    c = np.float32(c)
    
    delta = np.float32(b**2) - np.float32(4*a*c)

    x1 = (np.float32(-b) - np.float32(math.sqrt(delta)))/(2*a)
    x2 = (np.float32(-b) + np.float32(math.sqrt(delta)))/(2*a)

    print("ten bezpieczny: " +str(x1)+ " ten niebezpieczny: "+ str(x2))

def lepsze_liczenie(a,b,c):
    a = np.float32(a)
    b = np.float32(b)
    c = np.float32(c)
    
    delta = np.float32(b**2) - np.float32(4*a*c)


    x1 = (np.float32(-b) - np.float32(math.sqrt(delta)))/(2*a)

    lepszex2 = (np.float32(-b/a))-(x1)

    print("ten bezpieczny: " +str(x1)+ " ten niebezpieczny: "+ str(lepszex2))


def liczenie_bez(a,b,c):
    a = np.float64(a)
    b = np.float64(b)
    c = np.float64(c)
    
    delta = np.float64(b**2) - np.float64(4*a*c)

    x1 = (np.float64(-b) - np.float64(math.sqrt(delta)))/(2*a)
    x2 = (np.float64(-b) + np.float64(math.sqrt(delta)))/(2*a)

    print("ten bezpieczny bez float 32: " +str(x1)+ " ten niebezpieczny bez float 32: "+ str(x2))

def lepsze_liczenie_bez(a,b,c):
    a = np.float64(a)
    b = np.float64(b)
    c = np.float64(c)
    
    delta = np.float64(b**2) - np.float64(4*a*c)


    x1 = (np.float64(-b) - np.float64(math.sqrt(delta)))/(2*a)

    lepszex2 = (np.float64(-b/a))-x1

    print("ten bezpieczny bez float 32: " +str(x1)+ " ten niebezpieczny bez float 32: "+ str(lepszex2))


liczenie(14.0,(4.0)**12,9.0)
liczenie_bez(14.0,(4.0)**12,9.0)
lepsze_liczenie(14.0,(4.0)**12,9.0)
lepsze_liczenie_bez(14.0,(4.0)**12,9.0)

