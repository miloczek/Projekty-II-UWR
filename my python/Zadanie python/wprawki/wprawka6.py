from forms import *

f=disj((var("x")), conj(neg(var("y")),(var("z"))))

def FV(f):
    if isVar(f):
        return set(getVar(f))
    if isNeg(f):
        return FV(getNeg(f))
    if isConj(f):
        return FV(getConjL(f)) | FV(getConjR(f))
    if isDisj(f):
        return FV(getDisjL(f)) | FV(getDisjR(f))

print(FV(f))


def val(f,S):
    if isVar(f):
        return S[getVar(f)]
    if isNeg(f):
        return not val(getNeg(f),S)
    if isConj(f):
        return val(getConjL(f),S) and val(getConjR(f),S)
    if isDisj(f):
        return val(getDisjL(f),S) or val(getDisjR(f),S)
          
S={ "x" : True,
    "y" : False,
    "z" : False}

print(val(f,S))


"""    


def tautologia(f):
    def wartosc_formuly(F, wart): 
  F = F.replace('T', 'True')   #dodaję stałe 
  F = F.replace('F', 'False')
  F = F.replace('*', ' and ')
  F = F.replace('+', ' or ')
  F = F.replace('-', ' not ')
  print (F, wart)
  return eval(F, wart)
  """
    
