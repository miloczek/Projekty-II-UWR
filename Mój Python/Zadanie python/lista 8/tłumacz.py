def popularny(X):
  L=[]
  for i in range(len(X)):
    licznik=0
    for e in open('brown.txt'):
      e=e.split()
      for j in range(len(e)):
        if e[j]==X[i]:
          licznik= licznik + 1            #zliczam wystąpienia słowa w brown.txt
    L.append((licznik,X[i]))
  L.sort()
  L = [(X[i]) for licznik,X[i] in L]    #olewam licznik i wypisuję tylko słowo
  rez = L[len(L)-1]                     #wybieram najpopularniejszy
  return rez
          
  

def tlumacz(txt):
  wynik = []
  for p in txt.split():
    if p in pol_ang:
      D=pol_ang[p]
      if len(D)>1:
        wynik.append(popularny(D))
      else:
        continue
    else:
      wynik.append('?' + p)
  return ' '.join(wynik)
      
pol_ang = {} # pusty słownik

for x in open('pol_ang.txt',  encoding="utf8"):
  x = x.strip()
  L = x.split('=')
  if len(L) != 2:
    continue
  pol, ang = L
  
  if pol not in pol_ang:
    pol_ang[pol] = [ang]
  else:  
    pol_ang[pol].append(ang)
  
  

txt="samochód jechać na rower"

print (tlumacz(txt))
