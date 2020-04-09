n = int(input())
string = list(input())
pointer1 = pointer2 = 0
for char in string:
    if char == '0':
        pointer1 += 1
    else:
        pointer2 += 1
result = min(pointer1, pointer2)
print(n - (2*result))