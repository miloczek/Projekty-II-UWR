m, n = map(int, input().split())
if n == 0:
    if m == 1:
        print("1")
    else:
        print("-1")
else:
    mini = k = result = 0
    helper = 1
    maxi = 105
    for i in range(n):
        x, y = map(int, input().split())
        if y == 1:
            if x > mini:
                mini = x
        else:
            w = (x - 1) // (y - 1)
            if w < maxi:
                maxi = w
            w = 0
            if x % y != 0:
                w += 1
            w += x // y
            if w > mini:
                mini = w
    if m % mini != 0:
        k += 1
    k += m//mini
    result = k
    k = 0
    if m % maxi != 0:
        k += 1
    k += m//maxi
    if result != k:
       helper = 0
    if helper == 1:
       print(result)
    else:
       print("-1")
