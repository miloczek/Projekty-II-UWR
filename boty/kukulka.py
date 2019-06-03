import numpy as np

def generuj(word):
    wektory = []
    with open('poleval_base_vectors.txt', encoding = 'utf8') as f:
        f.readline()
        for line in f:
            L = line.split()
            searching = L[0]
            if word == searching:
                for i in L[1:]:
                    wektory = np.append(wektory, float(i))

    file = open('wektorki.txt', 'w')
    with open('poleval_base_vectors.txt', encoding = 'utf8') as f:
        f.readline()
        for line in f:
            L = line.split()
            word = L[0]
            doc = [float(s) for s in L[1:]]
            vec = np.array(doc, dtype = 'single')
            skalary = wektory.dot(vec)
            file.write(str(skalary) + ' ' + word + '\n')
    file.close()
    return skalary

#print(generuj('kukułka'))

def podobne():
    bliskie=[]
    result={}
    with open('wektorki.txt', 'r') as f:
        for line in f:
            L = line.split()
            result[float(L[0])] = L[1]
    del result[max(result, key=float)]
    for i in range(10):
        bliskie.append(result[max(result, key=float)])
        del result[max(result, key=float)]
    return ' '.join(bliskie)


print(podobne())
        
