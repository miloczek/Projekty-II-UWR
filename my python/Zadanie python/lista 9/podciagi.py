def podciag(L):
    i=0
    maxi=0
    wynik=[]
    for i in range(len(L)):
        if L[i] > maxi:
            maxi=L[i]
            wynik.append(maxi)
        else:
            continue
    return wynik
L=[1,2,3,4,5,0,6,7,8]
print(podciag(L))
