def moduł(n):
    if n<0:
        return n * (-1)
    else:
        return n
def f(x):
    return x+1

def val(p,x):
    wynik = 0
    z = len(p)
    for i in range(z):
        wynik = wynik + (potega(x, (z - 1))) * p[i]
        z = z-1
    return wynik


def bisect(f, x, y):
    z = 2 ** -32
    assert(f(x)<0 and f(y)<0 or f(x)>0 and f(y)>0), "Prawdopodobnie brak miejsca zerowego"
    if x>y:
        a=x
        b=y
        x=b
        y=a
    else:
        if moduł(f(x))< z:
            return x
        s = f(x+y)/2
        if s == 0:
            return (x+y)/2
        elif s>0 and x>0 or s<0 and x<0:
            y=s
            return bisect(f,x,y)
        elif s>0 and y>0 or s<0 and y<0:
            x=s
            return bisect(f,x,y)

p=[-5,22]

print(bisect(f,-2,50))
            
            
        
    
