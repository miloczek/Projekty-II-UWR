### FIRST VERSION ###
# It assumes that the text is formatted correctly
# Each potential long word is checked for punctuation sign
# at it's last char's place. If none are found or if one is found
# while it's length - 1 would be higher / same as the current longest,
# it passes as a long one
def longest_words(fname):
    file = open(fname, "r")
    longest = [""]  # current longest words
    for line in file:
        for word in line.split():
            if is_same_len(longest[0], word):
                longest.append(word)
            elif len(word) > len(longest[0]):
                longest = [word]
    longest.sort()
    return longest


def is_same_len(word1, word2):
    if len(word1) == len(word2) or (
        len(word1) + 1 == len(word2) and word2[len(word2) - 1] in ",.;:!?") or (
        len(word1) == len(word2) + 1 and word1[len(word1) - 1] in ",.;:!?"):
        return True
    return False

### SECOND VERSION ###
# each potential long word is checked for punctuation signs
# if one is found, the check_punct function discards all 'bad' signs
def longest_words2(fname):
    file = open(fname, "r")
    longest = [""]  # current longest words
    for line in file:
        for word in line.split():
            if len(word) >= len(longest[0]):
                word = fix_punct(word)
                if len(word) > len(longest[0]):
                    longest = [word]
                elif len(word) == len(longest[0]):
                    longest.append(word)
    longest.sort()
    return longest


def fix_punct(word):
    for ch in word:
        if ch in ",.;:?!/":
            word = word.replace(ch, "")
    return word
### END OF SECOND VERSION ###

def main():
    fname1 = "lektura.txt"
    print(longest_words(fname1))
    fname2 = "pan wolodyjowski.txt"
    print(longest_words(fname2))


main()
