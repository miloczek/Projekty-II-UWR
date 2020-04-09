import json
import sys


def status_change(letter, status):
    for transition in testowy_dict["transitions"]:
        if transition["letter"] == letter and transition["from"] == status:
            status = transition["to"]
    return status

file = input()
with open(file, 'r') as f:
    testowy_dict = json.load(f)

def automata_check():
    status_start = testowy_dict["initial"]
    while True:
        letter = sys.stdin.read(1)
        if not letter:
            break
        elif letter == '\n':
            if status_start in testowy_dict["accepting"]:
                print("yes")
            else:
                print("no")
        else:
            status_start = status_change(letter, status_start)


automata_check()