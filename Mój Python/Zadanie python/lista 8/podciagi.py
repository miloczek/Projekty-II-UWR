plik= open('slowa.txt',encoding='utf8').read().split('\n')

def podciag(s):
    literki=list(s)
    L=[]
    for x in plik:
        for i in range(len(literki)):
            if literki[i] in x:
                continue
            else:
                break
        L.append(x)
    return L
        
print(podciag('mycie'))
