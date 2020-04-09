def f(s):
    R = []
    for i in range(len(s)):
        if s[i] == '.':
            break
        if s[i] in '0123456789':
            R.append(s[i])
    return ''.join(R) + '?' + s[i+1:]
L = 3 * [0,1]
L = L + [L[2:4]]
L[0] = f('a0b0c7.To dobry znak!')
L.append('x')
L += f(str(3 * 111))
