def f(s):
    r = []
    for i in range(len(s)):
        if s[i] == 'a':
            r.append(s[i] + '*')
        else:
            r.append(2 * s[i])
    return "".join(r)
L = [0,1,2]
L = [L] + L
L[0] = f('baba')
L[1] = f('tata') + f('mama')
L.append('x')
L += 2 * "ABC"
