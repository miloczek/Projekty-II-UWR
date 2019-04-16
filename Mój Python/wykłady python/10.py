# ala ma 33 koty -> ala ma ** koty

def usun_cyfry(s):
    wynik = []
    for a in s:
        if "0" <= a <= "9":
            wynik.append("*")
        else:
            wynik.append(a)
    return "".join(wynik)

def usun_cyfry0(s):
    L=list(s)
    for i in range(len(L)):
        if L[i] >= "0" and L[i] <= "9":
            L[i] = "*"
        return "".join(L)

def usun_cyfry1(s):
    s=list(s)
    for i in range(len(s)):
        if s[i] >= "0" and s[i] <= "9":
            s[i] = "*"
        return "".join(s)

print (usun_cyfry("ala ma 33 koty i 56 kanarkow."))

print(usun_cyfry0("ala ma 33 koty i 56 kanarkow."))

print(usun_cyfry1("ala ma 33 koty i 56 kanarkow."))
