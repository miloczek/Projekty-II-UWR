def slownikmeski(texts):
    slownik = {}
    with open(texts, encoding='utf8') as f:
        for line in f:
            a,b = line.split()
            slownik[b] = a
    return slownik

def slownikdamski(texts):
    slownik = {}
    with open(texts, encoding='utf8') as f:
        for line in f:
            a,b = line.split()
            slownik[a] = b
    return slownik

damskie = slownikdamski("verb_czytalam.txt")
meskie = slownikmeski("verb_czytalem.txt")
    

def verbalize(string):
    line = string.split()
    for word in line:
        if word.endswith("łem"):
            searched = damskie[meskie[word]]
    return searched

def deleteContent(fName):
    with open(fName, "w"):
        pass            

def botek():
    wynik = ""
    maxi = 0
    file = open("wyniki.txt", "w")
    napis = input("Cześć, co powiesz? ")
    zdanie = napis.split()
    for word in zdanie:
        if word.endswith('łem'):
            moje_slowo = verbalize(word)
    with open('personal_corpora.txt', encoding = 'utf8') as f:
        for line in f:
            if moje_slowo in line.split():
                file.write(line)
        file.close()
    with open("wyniki.txt", 'r') as w:
        for line in w:
            counter = 0
            for i in range(0, len(zdanie)):
                if zdanie[i] in line.split():
                    counter+=1
            if counter >= maxi:
                maxi = counter
                wynik = line
    deleteContent("wyniki.txt")
    print(wynik)
    botek()

botek()
