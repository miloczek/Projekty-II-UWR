import itertools

def zagadka(rownanie):
     rown = set(rownanie)
     znaki =set('=+')
     kandydaci = rown - znaki #tworzę zbiór samych liter bez znaków
     ilosc = len(kandydaci)
     if ilosc > 10 or ilosc == 0:
     #mam 10 cyfr od 0-9 jeśli mam więcej liter do przypisania a brak cyfr to zwróć none, lub gdy nie mma liter
     # wtedy zwracam zupełnie to samo = None
         return None
     else:
         podejrzani, wynik = rownanie.split('=') # dzielę napis ze względu na = na listy podejrzani i wynik
         podejrzani = podejrzani.split('+') # z lewą stroną też robię podział na 2 listy

         cyfry = range(10) # bo 0-9
    # wygeneruję wszystkie permutacje już bez tych powtarzających się dzięki funkcji z modułu itertools
    #krotki długości len(kandydaci) z wszystkimi mozliwymi ustawieniami cyfr
         for ustawienie in itertools.permutations(cyfry,len(kandydaci)):                                    
            solucja = dict(zip(kandydaci,ustawienie)) # zip tworzy mi listę krotek jedno z jednej listy drugie z drugiej
            if sum(wartosc(slowo,solucja) for slowo in podejrzani) == wartosc(wynik,solucja):
                return solucja
         return None       #gdy nie ma rozwiązania

def wartosc(slowo,chytrus):
    zlicznik = 0
    lit = 1
    for znak in reversed(slowo):    # dla każdej literki od końca
        zlicznik = lit*chytrus[znak]
        lit = lit*10

    return zlicznik


print(zagadka('send+more=money'))
