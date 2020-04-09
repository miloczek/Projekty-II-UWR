import random

def deleteContent(fName):
    with open(fName, "w"):
        pass

def personalizuj(string):
    nowy = ''
    los = random.randint(0,1)
    if los == 0:
        print(string)
    else:
        for word in string.split():
            if word.endswith('łam'):
                nowy = string.replace(word, ' ja ' + word)
        print(nowy)
                

dodatki = ["To ciekawe. ", "To interesujące. ", "Miło mi to słyszeć. ", "Dziękuję za informację. ", "Co Ty nie powiesz? ", "Niesamowite! ",
           "To Ci dopiero! ", "Wielkie nieba! ", "O! Nie wiedziałem! ", "Zaciekawiłeś mnie. "]

def botek():
    los = random.choice(dodatki)
    wynik = ""
    moje_slowo = ""
    maxi = 0
    file = open("wyniki.txt", "w")
    napis = input("Cześć, co powiesz? ")
    zdanie = napis.split()
    for word in zdanie:
        if word.endswith('łem'):
            moje_slowo = word.replace('łem', 'łam')
        if word.endswith('łaś'):
            moje_slowo = word.replace('łaś', 'łam')
    if moje_slowo == "":
        personalizuj(los + "Nie mam Ci nic do powiedzenia")
        botek()
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
    personalizuj(los + wynik)
    botek()
                
        
    


botek()
    
