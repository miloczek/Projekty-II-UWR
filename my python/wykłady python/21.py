def f1(a,b,c=123):
    print(a,b,c)

f1(1,2)
f1(1,2,3)

def f2(a,b,c=123, *x):
    print(a,b,c, x)

f2(1,2)
f2(1,2,3)
f2(1,2,3,4,5,6,7)


def f3(*x):
    print("Jestem w f3")
    for e in x:
        print('Argument', e)

f3(1,2,3)
f3()
f3(1,2,3,4,5,6)

def f4(*x, **y):
    print('f4',x,y)

f4(1,2,3, argument= 'napis', xx='napis2')
