def fprint(plik, *arg, **opcje):
    arg= [str(x) for x in arg]
    sep= ' '
    end= '\n'
    if 'sep' in opcje:
        sep = opcje['sep']
    if 'end' in opcje:
        end = opcje['end']
        
    plik.write(sep.join(arg) + end)          # *arg to lista argumentów a **opcje to słownik z opcjami

plik = open('plik.txt', 'w')

plik.write('To jest napis1\n')
plik.write('To jest napis2\n')

fprint(plik,1,2,3,4, sep= '*')
fprint(plik,1,2,3, end=' ')
fprint(plik,1,2,3, end=' ')
fprint(plik,1,2,3, end=' ')
fprint(plik,1,2,3, end=' ')
fprint(plik,1,2,3, end=' ')
fprint(plik,"Ala", "ma", [1,2,3])


plik.close()
