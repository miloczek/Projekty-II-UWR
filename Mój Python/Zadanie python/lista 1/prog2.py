def silnia(n):
    x=1
    for i in range(1,n+1):
        x=x*i
    return x

for i in range(4,101):
    z=silnia(i)
    f=len(str(z)) 
    if ((f//10)%10==1):
        print (i,"! ma",f,"cyfr")
    elif f%10==2 or f%10==3 or f%10==4:
        print (i,"! ma",f,"cyfry")
    else:
        print (i,"! ma",f,"cyfr")
    


        
    
