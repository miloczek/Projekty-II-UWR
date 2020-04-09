def upper_case(s):
    if 'a' <= s <= 'z':
        return chr (ord(s) - ord('a') + ord('A'))
    return s
napis = ['ala ma kota']
