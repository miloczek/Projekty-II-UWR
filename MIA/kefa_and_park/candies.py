n, m = map(int, input().split())
candies_per_friend = [n//m] * m
for i in range(n%m):
    candies_per_friend[i] += 1
for i in range(m):
    print(candies_per_friend[i], end = ' ')
