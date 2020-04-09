from forms import *

def to_nnf(f):
    if isVar(f):
        return getVar(f)
    if isConj(f):
        return to_nnf(getConjL(f)) and to_nnf(getConjR(f))
    if isDisj(f):
        return to_nnf(getDisjL(f)) or to_nnf(getDisjR(f))
    if isNeg(f):
        g=getNeg(f)
        if isNeg(g):
            return to_nnf(getNeg(g))
        if isVar(g):
            return neg(g)
        if isConj(g):
            return to_nnf(neg(getConjL(g))) or to_nnf(neg(getConjR(g)))
        if isDisj(g):
            return to_nnf(neg(getDisjL(g))) and to_nnf(neg(getDisjR(g)))

f=disj((var("x")), conj(neg(var("y")),(var("z"))))

print(to_nnf(f))
