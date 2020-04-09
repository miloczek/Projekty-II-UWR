
# formuły zdefiniowane przez φ ::= x | ¬ φ | φ ∧ φ | φ ∨ φ

# konstruktory
def var(x):
    return (0, x)

def neg(f):
    return (1, f)

def conj(f1, f2):
    return (2, f1, f2)

def disj(f1, f2):
    return (3, f1, f2)


# predykaty
def isVar(f):
    return f[0] == 0

def isNeg(f):
    return f[0] == 1

def isConj(f):
    return f[0] == 2

def isDisj(f):
    return f[0] == 3

# akcesory
def getVar(f):
    assert isVar(f), "malformed formula"
    return f[1]

def getNeg(f):
    assert isNeg(f), "malformed formula"
    return f[1]

def getConjL(f):
    assert isConj(f), "malformed formula"
    return f[1]

def getConjR(f):
    assert isConj(f), "malformed formula"
    return f[2]

def getDisjL(f):
    assert isDisj(f), "malformed formula"
    return f[1]

def getDisjR(f):
    assert isDisj(f), "malformed formula"
    return f[2]

f=disj((var("x")), conj(neg(var("y")),(var("z"))))
# równania:
# isVar(var(x)) == True
# isVar(φ) == False w p.p.
# isNeg(neg(φ)) == True
# isNeg(φ) == False w p.p.
# isConj(conj(φ₁, φ₂)) == True
# isConj(φ) == False w p.p.
# isDisj(disj(φ₁, φ₂)) == True
# isDisj(φ) == False w p.p.
# getVar(var(x)) == x
# getNeg(neg(φ)) == φ
# getConjL(conj(φ₁, φ₂)) == φ₁
# getConjR(conj(φ₁, φ₂)) == φ₂
# getDisjL(disj(φ₁, φ₂)) == φ₁
# getDisjR(disj(φ₁, φ₂)) == φ₂
