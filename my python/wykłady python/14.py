import random
N = 10

def pisz(T):
    for i in range(len(T)):
        for j in range(len(T[i])):
            print (T[i][j], end='')
        print()

#T =N * [N * ['.']] #NIEEEEEEEE

T=[]
for i in range(N):
    T.append(N*['.'])

for i in range(30):
    y = random.randint(0, N-1)
    x = random. randint(0, N-1)
    #T-- lista list napisów
    wiersz = T[y] #wiersz -- lista napisów
    wiersz[x] = random.choice("abcdefghijkl")
    
    T[y][x] = random.choice("abcdefghijkl")


pisz(T)
