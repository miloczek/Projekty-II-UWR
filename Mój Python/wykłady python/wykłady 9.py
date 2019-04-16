x = 1
y = [1,2,3]
a=b=0

def pisz():
    print("x,y=",x,y)

def f(a,b):
    a += 1   #równoważne a = a + 1
    b += ["nowy"]  #równoważne b.expand(["nowy"])
    print (a,b)

def f2(a,b):
    a += 1   
    b = b + ["nowy"]  
    print (a,b)

f(x,y); pisz()     
f2(x,y); pisz()

print("globalne a,b",a,b)
