from random import randint

def gra1():
    z=100
    l=[]
    x=0
    smok=0
    while(z!=0):
        y=randint(1,6)
        l.append(y)
        print(l[x])
        if(l[x]>l[x-1]>l[x-2]>l[x-3]>l[x-4]):
            print("Wygrałeś!")
            True
            break
        z=z-1
        x=x+1
    if z==0:
        False
        

def gra2():
    z=100
    l=[]
    x=0
    while(z!=0):
        y=randint(1,6)
        l.append(y)
        print(l[x])
        if((x>6) and (l[x]>=l[x-1]>=l[x-2]>=l[x-3]>=l[x-4]>=l[x-5])):
            print("Wygrałeś!")
            break
        z=z-1
        x=x+1
    if z==0:
        gra2()

p=input("Witaj w mojej jaskini, przejdziesz tylko jeśli rzucając sto razy kością, uda Ci się wyrzucić pięczioelementowy ciąg rosnący, lub sześcioelementowy ciąg niemalejący. Aby wybrać pierwszy wpisz '1' lub '2', aby wybrać drugi. Powodzenia!")

if int(p)==1:
    gra1()
else:
    gra2()


def test():
    good=0
    for i in range(100000):
        gra1()
        if gra1()==True:
            good=good + 1
    return good/100000
    
    



