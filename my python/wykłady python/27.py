rl=[1,2,[2,3],[[[[4]]],4,4],[5,[4,5]]]

def flatten(rl):
    """spłaszczanie listy"""
    if str(rl).isnumeric(): #type(rl)== int
        return [rl]
    res = []
    for e in rl:
        res += flatten(e)
    return res

print(flatten(rl), sum(flatten(rl)))
