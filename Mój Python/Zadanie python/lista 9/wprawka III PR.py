def dziel(n):
    ile = []
    while n > 1:
        for i in range(2, n+1):
            if n % i == 0:
                ile.append(i)
                n =n//i
                break
    return ile

print(dziel(256737))
