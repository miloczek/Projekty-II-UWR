import random

def add_to_tree(e,T):
    if T == None:
        return(e,None, None)
    n, left, right = T
    if n == e:
        return T
    if e < n:
        return (n, add_to_tree(e,left), right)
    return(n, left, add_to_tree(e,right))

def in_tree(e,T):
    if T == None:
        return False
    n, left, right = T
    if n == e:
        return True
    #return in_tree(e,left) or in_tree(e,right)
    if e < n:
        return in_tree(e,left)
    return in_tree(e,right)

L = [3,4,1,6,3,4]

T = None

for e in L:
    T = add_to_tree(e,T)

print(all(in_tree(x,T) for x in L))
print(all(x in L for x in L))
