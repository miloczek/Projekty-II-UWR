def klepsydra(n):
    x=0
    y=2*n
    for i in range(n):
        print(x//2*' ',y*'*',x//2*' ')
        x+=2
        y-=2
    print(x//2*' ','*',x//2*' ')
    for e in range(n):
        print(x//2*' ',y*'*',x//2*' ')
        x-=2
        y+=2
    return ''
    
print(klepsydra(29))
