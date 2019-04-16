def kwadrat(n):
   for i in range(n):
      for j in range(n):   
         print ("*", end="")
      print()
      
def kwadrat2(n):
   for i in range(n):
      print (n * "*")

def kwadrat3(n):
   for i in range(n):
      for j in range(n):   
         print ("#", end="")
      print()      

def kwadrat4(n):
   for i in range(n):
      for j in range(n):
         print ("#", end="")
      print()
      
for i in range(5):
   print ("Przebieg:",i)
   print (20 * "-")
   if i % 2 == 0:   
      kwadrat(3+2*i)
   else:  
      kwadrat2(3+2*i)
   print()    
for i in range (5,10):
   print ("Przebieg:",i)
   print (20 * "-")
   if i % 2 == 0:   
      kwadrat3(i-2)
   else:  
      kwadrat4(i-2)
   print()    
   
         
     
   
