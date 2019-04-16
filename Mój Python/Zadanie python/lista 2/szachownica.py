def kwadrat1(n,k):
    return((" "*k + "#"*k)*n + "\n")
        
def kwadrat2(n,k):
    return(("#"*k + " "*k)*n + "\n")
    
def szachownica(n,k):
    print((kwadrat1(n,k)*k + kwadrat2(n,k)*k)*n)
    

            
