import aiml

k = aiml.Kernel()
k.learn("task3.aiml")
while True:
    print(k.respond(input("> ")))
