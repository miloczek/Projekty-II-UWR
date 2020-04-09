def hiperszczęśliwa(n, m):
    L=[]
    for i in range(10 ** n, 10 ** (n-1), -1):
        if (str(i).find("7" * m) >= 0):
            for j in range(2, int(i ** 0.5)):
                if i % j == 0:
                    break
            L.append(i)
            break
 
    print(L)
