samogloski = ('a','ą', 'e','ę', 'i', 'y', 'o', 'u')


def sylaby(slowo):
    wynik=[]
    litery = slowo.split()
    sylaba = ''
    for i in range(len(slowo)):
        if slowo[i] in samogloski:
            sylaba+=slowo[i]
            wynik.append(sylaba)
            sylaba = ''
        elif slowo[i] == "ó":
            sylaba += slowo[i]
            sylaba += slowo[i+1]
            wynik.append(sylaba)
            sylaba = ''
        elif i == (len(slowo) - 1):
            sylaba += slowo[i]
            wynik.append(sylaba)
        else:
            sylaba += slowo[i]
    print(wynik)
    return(len(wynik))

print(sylaby('chłopców'))
            
            
    
