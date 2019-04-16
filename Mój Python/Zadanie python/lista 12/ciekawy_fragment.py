def ciekawy_fragment(bohater,zakres):
    tekst=open('lalka.txt').read().split()
    indeksy = []
    for i in range(len(tekst)):
        if tekst[i].startswith(bohater): #czy dany wyraz zaczyna się od szukanego słowa
            indeksy.append(i)
    aktualne = 0
    początek = 0
    koniec = 0
    for i in range(len(indeksy)): # tak dużo jak ich znalazłem
        licznik = 0
        if indeksy[i]+zakres>len(tekst): # jeśli ponad zakres
            break
        for j in range(indeksy[i],indeksy[i]+zakres): # range żeby mieścił się w określonym zakresie
            if tekst[j].startswith(bohater): # jesli tekst zaczyna sie od szukanego słowa
                licznik += 1 # zliczam se słowa
        if licznik > aktualne: # poszukuję fragmentu gdzie mam najwięcej
            aktualne = licznik
            początek  = indeksy[i]
            koniec = indeksy[i]+zakres
    tekst = tekst[początek:koniec]
    print(*tekst,'\n',aktualne) #"*" aby wyświetlać jako tekst ciągły,nie listę, oraz ilość wystąpień szukanego słowa
    return ''

print(ciekawy_fragment("Wokuls",120))
        
