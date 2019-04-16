import itertools
import re
 
def zagadka(rownanie):
     rown = set(rownanie)
     znaki =set(' =+')
     kandydaci = rown - znaki #tworzę zbiór samych liter bez znaków
     ilosc = len(kandydaci)
     if ilosc > 10 or ilosc == 0:
     #mam 10 cyfr od 0-9 jeśli mam więcej liter do przypisania a brak cyfr to zwróć none, lub gdy nie mma liter
     # wtedy zwracam zupełnie to samo = None
         return None
     else:
         # *podejrzani, wynik = 1,2,3,4,5 da:
         # podejrzani = [1,2,3,4]
         # wynik = 5
         *podejrzani, wynik = re.findall(r"[a-zA-Z]+", rownanie)
 
         cyfry = range(10) # bo 0-9
    # wygeneruję wszystkie permutacje już bez tych powtarzających się dzięki funkcji z modułu itertools
    #krotki długości len(kandydaci) z wszystkimi mozliwymi ustawieniami cyfr
         for ustawienie in itertools.permutations(cyfry,len(kandydaci)):                                    
            solucja = dict(zip(kandydaci,ustawienie)) # zip tworzy mi listę krotek jedno z jednej listy drugie z drugiej
            if sum(wartosc(slowo,solucja) for slowo in podejrzani) == wartosc(wynik,solucja):
                return solucja
         return None       #gdy nie ma rozwiązania
 
def wartosc(slowo,chytrus):
    ile = 0
    lit = 1
    for znak in reversed(slowo):    # dla każdej literki od końca, bo mają być w 
        ile = lit*chytrus[znak]     #porządku 100, a nie 001
        lit = lit*10
    return ile
 
 
 
print(zagadka(' send + more = money '))
