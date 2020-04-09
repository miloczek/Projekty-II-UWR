import string
maxi=0
L=set()
plik='Iliada.txt'
for słowa in open(plik, "r"):
    x=słowa.split()
    for i in range(len(x)):
        s=x[i]
        for c in string.punctuation:  #zamieniam znaki interpunkcyjne na puste miejsca
            s=s.replace(c,"")
        if maxi<len(s):
            maxi=len(s)             #sprawdzam długość słowa i jeśli jest dłuższe od dotychczas dłuższego
                                    #dodaję tę długość do zmiennej maxi
for słowa in open(plik, "r"):
    x=słowa.split()
    for i in range(len(x)):         #sprawdzam ponownie i dodaję do listy te słowa, których długość ma wartośc maxi
        if len(x[i])==maxi:
            L.add(x[i])
L=sorted(L)
print(L)

                       





