def podziel(s):
    w = []
    n = ""
    for i in s:
        if i == " ":
            if len(n) > 0:
                w.append(n)
            n = ""
        else:
            n += i
    return w

print(podziel("       papapa hej      my  programie i część mojego słowa   "))    
