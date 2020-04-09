import matplotlib.pyplot as plt

def Bernstein(n, i, t): #tutaj liczymy poszczególne wielomiany Barnsteina (ze wzoru)
    rest = (t**i) * ((1-t)**(n-i))
    return Newton(n, i) * rest

def Newton(n, k): #iteracyjny symbol newtona
    Wynik = 1
    for i in range(1, k+1):
        Wynik = Wynik * (n-i+1) / i
    return Wynik


def liczonko():
    n = 10 #bo mamy "10" pkt kontrolnych i "10" wag [od 0 do 10]
    x = [0, 3.5, 25, 25, -5, -5, 15, -0.5, 19.5, 7, 1.5]
    y = [0, 36, 25, 1.5, 3, 33, 11, 35, 15.5, 0, 10.5]
    waga = [1, 6, 4, 2, 3, 4, 2, 1, 5, 4, 1]
    #waga = [5, 1, 4, 1, 1, 5, 1, 1, 4, 1, 100]
    #waga = [1, 6, 4, 2, 3, 4, 2, 1, 5, 4, 1000]
    #waga = [1, 6, 4, 200, 3, 400, 2, 1, 200, 4, 1]
    sx = []
    sy = []
    

    for z in range(0,11):
        t = z/10 # co 1/100 biorę kolejne t
        first_x = 0
        first_y = 0
        current = 0
        mianownik = 0

        for i in range(0, n+1): #licznik wymiernej krzywej Beziera Rn dla x
            current = waga[i] * x[i] * Bernstein(n,i,t)
            first_x += current

        for i in range(0, n+1): #licznik wymiernej krzywej Beziera Rn dla y
            current = waga[i] * y[i] * Bernstein(n,i,t)
            first_y += current

            
        for i in range(0,n+1): #mianownik wymiernej krzywej Beziera Rn
            current = waga[i] * Bernstein(n,i,t)
            mianownik += current

      

        sx.append(first_x/mianownik)
        sy.append(first_y/mianownik)
    
    plt.plot(sx,sy, 'r.-')
    plt.plot(x,y, '.-')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.show()
    print(sx)
    print(sy)


liczonko()
