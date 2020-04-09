import numpy as np

class DataProvider:

    def get_teddy(self):
        sentences = []
        with open('pan_tadeusz.txt', encoding = 'utf8') as f:
            splitted = [line.rstrip('\n') for line in f]
            for i in range(len(splitted)):
                sentences.append(splitted[i])
        return sentences

teddy = DataProvider()
teddy = teddy.get_teddy()


    
            
