def usun_nawiasy(s):
    L=list(s)
    z=False #zmienna
    for i in range(len(L)):
        if L[i]=='(':
            if i>2:
                L[i-1]=''
                z= True
            L[i]=''
            for j in range(i, len(L)):
                if L[j]==')':
                    L[j]=''
                    if(j+1)<len(L) and z==False:
                        L[j+1]=''
                    break
                else:
                    L[j]=''
    return ''.join(L)

print(usun_nawiasy('Ala ma (perskiego) kota'))
print(usun_nawiasy('Zęby (mnie bolą)!'))
print(usun_nawiasy('Czkawka (kawka i zabawka)'))

