from losowanie_fragmentow import losuj_fragment

def losuj_haslo(n):
    pas=""
    while True:
        x=losuj_fragment()
        if n-len(x)>=0 and n-len(x)!=1:
            n=n-len(x)
            pas=pas+x
            if n==0:
                return pas

n=int(input("Podaj n:"))
               
for i in range(10):
    print(losuj_haslo(n))
    print()

