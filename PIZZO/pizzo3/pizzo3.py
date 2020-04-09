import json
from z3 import *

def przygotuj_dane(skladniki, parametry, posilki):
    zmienna = 1
    dict = {}
    wynik = {}
    for jedzenie in skladniki:
        help = {}
        for parametr in parametry:
            help[parametr] = jedzenie[parametr]
        wynik[jedzenie['nazwa']] = help
    for posilek in posilki:
        helper = {}
        for niam in wynik.keys():
            helper[niam] = Int(str(zmienna))
            zmienna += 1
        dict[posilek] = helper
    return wynik, dict

def asercje(wynik, lista_jedzenia, zmienne_jedzenie, cel, konflikty):

    for posilek in zmienne_jedzenie.values():
        for zmienna in posilek.values():
            wynik.add(zmienna >= 0)

    for posilek in zmienne_jedzenie.values():
        wynik.add(Sum(list(posilek.values())) > 0)

    for elem in cel:
        ilosc = []
        for skladnik in lista_jedzenia:
            helper = []
            for posilek in zmienne_jedzenie:
                helper.append(ToReal(zmienne_jedzenie[posilek][skladnik]) * lista_jedzenia[skladnik][elem])
            ilosc.append(Sum(helper))
        total = Sum(ilosc)
        wynik.add(total >= cel[elem]['min'], total <= cel[elem]['max'])

    for konflikt in konflikty:
        nazwa1 = konflikt['nazwa1']
        nazwa2 = konflikt['nazwa2']
        for zmienne in zmienne_jedzenie.values():
            wynik.add(Or(
                And(zmienne[nazwa1] >= 0, zmienne[nazwa2] == 0),
                And(zmienne[nazwa1] == 0, zmienne[nazwa2] >= 0)))


def main():
    file_name = input()
    posiłki = ['śniadanie', 'lunch', 'obiad', 'podwieczorek', 'kolacja']
    with open(file_name, 'r', encoding= 'utf-8') as f:
        manuals = json.load(f)
    parametry = manuals['parametry']
    składniki = manuals['składniki']
    konflikty = manuals['konflikty']
    cel = manuals['cel']
    wynik = Solver()
    lista_jedzenia, zmienne = przygotuj_dane(składniki, parametry, posiłki)
    asercje(wynik, lista_jedzenia, zmienne, cel, konflikty)

    if wynik.check() == sat:
        menu = wynik.model()
        for posiłek in zmienne:
            jadlospis = []
            for skladnik in zmienne[posiłek]:
                ilosc = menu.evaluate(zmienne[posiłek][skladnik]).as_long()
                jadlospis += [skladnik] * ilosc
            print(posiłek + ': ', end='')
            print(', '.join(jadlospis))
    else:
        print('Nie można wygenerować diety.')

main()