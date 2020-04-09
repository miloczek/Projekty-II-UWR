dp = [[] for i in range(5005)]
n, m, k = map(int, input().split())
a = list(map(int, input().split()))

def take(i, couter):
    if dp[i][couter] != 1:
        return dp[i][couter]
    if i>(n-m) or couter >= k:
        return 0
    val1 = val2 = 0
    for v in range(i, (i+m)):
        val1 += a[v]
    val1 = val1 + take(i+m, couter+1)
    val2 = take(i+1, couter)
    dp[i][couter] = max(val1, val2)
    return dp[i][couter]

print(take(0,0))



