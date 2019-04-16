def krzyzyk(n):
    for i in range(n):
        print (" "*n,end="")
        for j in range(n):
            print ("*", end="")
        print()
    for i in range(n):
        for j in range(3*n):
            print ("*", end="")
        print()
    for i in range(n):
        print (" "*n,end="")
        for j in range(n):
            print ("*", end="")
        print()


