litery=list('aąbcćdeęfghijklłmnńoóprsśtuwyzźż')
def ceasar(s,k):
    slowo=[]
    alfabet={}
    licznik=1
    for i in litery:        #przyporządkowuję literom alfabetu kolejne liczby
        alfabet[i]=licznik
        licznik+=1
    szyfr=alfabet.copy()
    for i in alfabet:
        if i in szyfr:
            szyfr[i]+=k
            if szyfr[i]>32:
                szyfr[i]-=32
    for e in s:
        wart=szyfr[e]
        for j in alfabet:
            if alfabet[j]==wart:
                slowo.append(j)
    return ''.join(slowo)

            
    

        
    
print(ceasar('rapier',12))
print(ceasar('mama',45))
print(ceasar('ortodoksyjny',5))
print(ceasar('palto',4))
