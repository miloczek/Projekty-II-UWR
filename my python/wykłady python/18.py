def make_set(L):
    result = set() #dlaczego nie {}?
    for e in L:
        result.add(e)
    return result

A = {1,2,3,4,5,5,5}
B = {5,6,7,8,3}
C = {3,3,3,3,3,5,6,7,8,7}

print(A,B)
print(B==C)

print('A-B', A - B)
print('A*B', A & B)
print('A+B', A | B)
print('A ^ B', A ^ B) #wsztstkie elementy które są w jednym ze zbiorów, jeśli się powtarza element to go nie wypisze

print(12 in A) #należenie ( czy 12 należy do A ?)
print(A <= B)  #czy podzbiór?
print(sorted(A))
print(max(A))
print(min(A))
print(sum(A))
print(len(A | B))

zbior1 = make_set(['ala ma kota i dwa kanarki'])
zbior2 = set(['ala', 'ma', 'kota'])

print(zbior1)
print(zbior2)
