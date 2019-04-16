def by_freq(pair):
    return pair[1]


def main():
    filename = "ropucha.txt"
    txt = open(filename, "r").read()
    txt = txt.lower()
    for char in ",.!?:'\"()[]":
        txt.replace(char, " ")
    words = txt.split()
    count = {}
    for word in words:
        count[word] = count.get(word, 0) + 1

    items = list(count.items())
    items.sort()
    items.sort(key=by_freq, reverse=True)

    for pair in items:
        if pair[1] == items[0][1]:
            print(pair[0], "->", pair[1])
        else:
            break

main()
