def f(L):
    for i in range(len(L)-1):
        if L[i]==L[i+1]:
            continue
        else:
            return False
            break
    return True

print(f([1,1,1,1,17,17]))

def najwieksza(L):
    maxi=0
    for i in range(len(L)-1):
        x=abs(L[i+1] - L[i])
        if x > maxi:
            maxi = x
    return maxi

print(najwieksza([15,677,477,243,5,433,2,2,3,88]))

def silnia(n):
    return [n * silnia(n-1) for  if n>0]

print(silnia(16))
