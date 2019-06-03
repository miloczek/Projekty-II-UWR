import numpy as np
import random

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

def reklama(sentence):
    dokladnosc = 8
    suma={}
    slowa = sentence.split()
    with open('reklamy.txt', encoding = 'utf8') as f:
        for line in f:
            count = 0
            L = line.split()
            for wyraz in slowa:
                for i in L:
                    if (i not in slownik.keys()) or (wyraz not in slownik.keys()) :
                        count += 0
                    elif slownik[i].dot(slownik[wyraz]) <= dokladnosc:
                        count += 0
                    else:
                        count += slownik[i].dot(slownik[wyraz])
            suma[count] = line
    return suma[max(suma, key = float)]
                    
                    
    
    
    
