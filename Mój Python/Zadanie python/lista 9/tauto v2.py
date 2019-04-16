def ciagi_binarne(N):
  if N == 0:
    return [ [] ]
  return [ [b] + c for b in [True, False] for c in ciagi_binarne(N-1)]  
    
# 2 --> [ [False, False], [False, True], [True, False], [True, True] ]    


def wartosciowania(zmienne):
  cb = ciagi_binarne(len(zmienne))
  return [ dict(zip(zmienne, ciag)) for ciag in cb] #zip sumuje tablice(robi pary)
                                                    #nadaje zmiennym wartości
  
def wartosc_formuly(F, wart): 
  F = F.replace('T', 'True')   #dodaję stałe 
  F = F.replace('F', 'False')
  F = F.replace('*', ' and ')
  F = F.replace('+', ' or ')
  F = F.replace('-', ' not ')
  print (F, wart)
  return eval(F, wart)
  

def spelnialna(F):
  zmienne = set(F) - set('+*()- ')
  for wart in wartosciowania(zmienne):
    if wartosc_formuly(F, wart) == True:
      return True
  return False

def tautologia(F):
    zmienne = set(F) - set('+*()- ')       #dodaję funkcję sprawdzającą czy F jest tautologią
    for wart in wartosciowania(zmienne):
        if wartosc_formuly(F,wart) == False:
          return False
    return True
  
  
print (tautologia('(-p) * (-q) * T'))
print (tautologia('p + T'))
