def moments(x,y):
    n = len(x) - 1
    q = [None] * n
    u = [None] * n
    M = [None] * (n+1)

    q[0] = 0
    u[0] = 0

    for k in range(1,n): #algorytm do liczenia momentów z zadania  4
        l = (x[k] - x[k-1])/(x[k+1] - x[k-1]) #lambda
        p = l * q[k-1] + 2
        d = 6.0 * (((y[k+1]-y[k]) / (x[k+1]-x[k])) - ((y[k]-y[k-1]) / (x[k]-x[k-1]))) / (x[k+1] - x[k-1])
        q[k] = (l - 1) / p
        u[k] = (d - l * u[k-1])/p

    M[n-1] = u[n-1]
    M[n] = 0.0
    M[0] = 0.0
    for k in range(n-2,0,-1):
        M[k] = u[k] + q[k] * M[k+1]
    return M

def cubic_spline(m,x,y): #funkcja do szukania NIFS3
    M = moments(x,y) #liczy nam momenty
    delta = 1 / m  
    T = 0     #to będą nasze wartości "x" ze wzoru 
    result = []
    for k in range(1,len(x)):
        hk = x[k] - x[k-1] #w naszym przypadku zawsze to będzie 1/27
        while(T <= x[k]): #dopóki nie zamkniemy tego przedziału
            result.append( (M[k-1]*(x[k]-T)*(x[k]-T)*(x[k]-T)/6 + M[k]*(T-x[k-1])*(T-x[k-1])*(T-x[k-1])/6 + (y[k-1] - M[k-1]*hk*hk/6)*(x[k]-T) + (y[k] - M[k]*hk*hk/6)*(T - x[k-1]))/hk )
            T+=delta  #wprowadzamy to aby dodatkowo wypełnić "x" bo są ustawione zbyt "rzadko"
    return result   

xs = [15.5, 12.5, 8, 10, 7, 4, 8, 10, 9.5, 14, 18, 17, 22, 25, 19, 24.5, 23, 17, 16, 12.5, 16.5, 21, 17, 11, 5.5, 7.5, 10, 12]
ys = [32.5, 28.5, 29, 33, 33, 37, 39.5, 38.5, 42, 43.5, 42, 40, 41.5, 37, 35, 33.5, 29.5, 30.5, 32, 19.5, 24.5, 22, 15, 10.5, 2.5, 8, 14.5, 20]
tx = [i/27 for i in range(28)]
sx = cubic_spline(1000,tx,xs)
sy = cubic_spline(1000,tx,ys)

import matplotlib.pyplot as plt
plt.plot( sx, sy)

plt.title('Kwiatuszek')
plt.xlabel('x')
plt.ylabel('y')
plt.show()
