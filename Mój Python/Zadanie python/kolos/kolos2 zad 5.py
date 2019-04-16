'''
def prefix(s,t):
    for i in range(len(s)):
        if s[i]==t[i]:
            continue
        else:
            return False
    return True

print(prefix("pan","painniczyk"))
'''

def drabina(L):
    n=len(L)
    if n< 2:
        return False
    else:
        for i in range(0,n-1,2):
            if L[0]==L[i]:
                continue
            else:
                return False
        for e in range(1,n,2):
            if L[1]==L[e]:
                continue
            else:
                return False
        return True

print(drabina([1,2,1,2,1,3]))
