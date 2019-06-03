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

def podobne(word):
    result={}
    moj_wektor = slownik[word]
    for key in slownik:
        skalary = moj_wektor.dot(slownik[key])
        result[skalary] = key
    bliskie=[]
    del result[max(result, key=float)]
    for i in range(10):
        bliskie.append(result[max(result, key=float)])
        del result[max(result, key=float)]
    return ' '.join(bliskie)



