def pierwsza(n):
    for i in range(2, int(n ** 0.5)):
        if (n % i) == 0:
            return False
    return True

L=[]
for i in range(1, 100000):
    if (pierwsza(i)):
        if (str(i).find("777") >= 0):
            L.append(1)
            print(i)
print("Jest", len(L), "liczb szczęśliwych!")
