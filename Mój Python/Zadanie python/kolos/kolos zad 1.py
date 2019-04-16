def trojkat(a,znak):
    for i in range(1,a+1):
        print(znak * i)
    return ''


def polchoinka(L):
    licznik=0
    for e in range(len(L)):
        if licznik%2==0:
            trojkat(L[e],"*")
            licznik+=1
        else:
            trojkat(L[e],"#")
            licznik+=1
    return ''

print(polchoinka([2,5,7]))
        
print(trojkat(5,"*"))
