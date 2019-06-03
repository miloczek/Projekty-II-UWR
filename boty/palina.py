import numpy as np
import random

dictionary ={}
counter = 0
with open('poleval_base_vectors.txt', encoding = 'utf8') as f:
        f.readline()
        for line in f:
            L=line.split()
            doc = [float(s) for s in L[1:]]
            vec = np.array(doc, dtype = 'single')
            dictionary[L[0]] = vec
            counter+=1
            if counter % 10000 == 0:
                print("#", end='')

begin = ["","Hej, co tam wczoraj robiłeś? ", "Cześć, co powiesz? ", "Nawijaj ", "Siemka, co tam? ", "Mam przeczucie, że chcesz mi coś powiedzieć. ", "Mów przyjacielu. ", "Rozmawianie z rana jest jak śmietana."]

               
def reklama():
    sentence = input(random.choice(begin))
    like_i_care = 8
    sums={}
    words = sentence.split()
    with open('reklamy.txt', encoding = 'utf8') as f:
        for line in f:
            count = 0
            L = line.split()
            for word in words:
                for i in L:
                    if (i not in dictionary.keys()) or (word not in dictionary.keys()) :
                        next
                    elif dictionary[i].dot(dictionary[word]) <= like_i_care:
                        next
                    else:
                        count += dictionary[i].dot(dictionary[word])
            sums[count] = line
    print(sums[max(sums, key = float)])
    reklama()

                    
                    
reklama()
    
    
