def literka(s):
    L=list(s)
    D={}
    for i in range(len(L)):         #tworzę słownik z liter i ich ilości
        if L[i] not in D:
            D[L[i]]= 1
        else:
            D[L[i]]= D[L[i]] + 1
    return D
        
def sprawdz(s,f):    
    D=literka(f)
    for k in s:
        if k in D:
            D[k]-=1
        if k not in D:                  #jeśli klucz(litera) pojawia się w słowniku 2, odejmuję wartość
            return False
        if D[k]<0:
            return False
    return True
                                #jeśli skończyły się wartości
                        #jeśli w ogóle nie pojawia się w słownik
    


#print(sprawdz('motyl','lokomotywa'))
#print(sprawdz('tylko','lokomotywa'))
#print(sprawdz('żółtko','półka'))
#print(sprawdz('imadło','piec'))
#print(sprawdz('żuk','żuczek'))
#print(sprawdz('kk','k'))
print(literka("duppa"))

