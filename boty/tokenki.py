import re
def tokenize(str):
    with open(str, encoding = 'utf8') as f:
        text = f.read().lower()
        pattern = r"\s*\w*\s*"
        result = re.findall(pattern, text)
        print(''.join(result))
    

tokenize('reklamy.txt')
    
