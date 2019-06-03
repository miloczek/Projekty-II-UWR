import random
import numpy as np


slownik={}
counter = 0
with open('poleval_base_vectors.txt', encoding = 'utf8') as f:
        f.readline()
        for line in f:
            L=line.split()
            doc = [float(s) for s in L[1:]]
            vec = np.array(doc, dtype = 'single')
            slownik[L[0]] = vec
            counter+=1
            if counter % 10000 == 0:
                print(counter)



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
    suma = {}
    dokladnosc = 8
    odpowiedzi = []
    los = random.choice(dodatki)
    wynik = ""
    moje_slowo = ""
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
                odpowiedzi.append(line)
    for line in odpowiedzi:
        counter = 0
        L = line.split()
        for wyraz in zdanie:
            for i in L:
                if (i not in slownik.keys()) or (wyraz not in slownik.keys()):
                    counter += 0
                elif slownik[i].dot(slownik[wyraz]) <= dokladnosc:
                    counter += 0
                else:
                    counter += slownik[i].dot(slownik[wyraz])
        suma[counter] = line
       
    wynik = suma[max(suma, key = float)]
    personalizuj(los + wynik)
    botek()
                
        
    


botek()
    
