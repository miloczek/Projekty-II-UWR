#########################################
#         o słownikach
#########################################

D= {
    "girl" : "dziewczyna",
    "boy" : "chłopiec",
    "house" : "dom",
    "car" : "samochód",
}

print(D)

print('Angielskie girl to', D['girl'])
D['table'] = 'stół'
print(D)

for k in D:
    print('Klucz', k, D[k]) #też jest szybkie

print(list(D), len(D))

for k,v in D.items():
    print(k,v)

print(D.keys())
print(D.values())

for k in ['a','the','girl']:   #to jest szybkie : )
    print(k,k in D)
