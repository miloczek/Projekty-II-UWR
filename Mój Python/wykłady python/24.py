def ciagi_binarne(N):
    if N == 0:
        return [[]]
    return [ [b] + c for b in [True, False] for c in ciagi_binarne(N-1)]

def wartosciowania(zmienne):
    cb= ciagi_binarne(len(zmienne))
    return [dict(zip(zmienne, ciag)) for ciag in cb]

def wartosc_formuly(F,wart):
    F = F.replace('*', ' and ')
    F = F.replace('+', ' or ')
    F = F.replace('-', ' not ')
    print(F, wart)
    return eval(F, wart)

def spelnialna(F):
    zmienne = set(F) - set('+*()- ')
    for wart in wartosciowania(zmienne):
        if wartosc_formuly(F, wart) == True:
            return True
    return False

print(spelnialna('(-p) * (-q) * r'))
