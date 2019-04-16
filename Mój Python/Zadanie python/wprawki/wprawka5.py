

def f(x):
    return x + 2
def g(x):
    return x * 3
def z(x):
    return x
"""
def compose(f,g):
    return f(g(x))

print(compose(f,g))
"""

def compose(f,g):
    def h(x):
        return f(g(x))
    return h


def repeated(f,n):
    złożenie = z
    for i in range(n):
        złożenie= compose(f,złożenie)
    return złożenie

print(repeated(f,1)(6))
