dziennik={}

for x in open('dziennik.txt'):
    wiersz=x.split()
    if not wiersz:
        continue
    if wiersz[0] == 'przedmiot:':
        przedmiot = ' '.join(wiersz[1:])
    else:
        osoba = wiersz[0]
        oceny = [ int(o) for o in wiersz[1].split(',')]
        if osoba not in dziennik:
            dziennik[osoba] = {}
        dziennik[osoba][przedmiot] = oceny

for osoba in dziennik:
    print('Uczeń', osoba)
    for przedmiot in dziennik[osoba]:
        print(przedmiot, dziennik[osoba][przedmiot])
    print()
        
