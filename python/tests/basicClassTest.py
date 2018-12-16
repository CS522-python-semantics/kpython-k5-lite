class TestBasic:
    def __init__(self):
        return
    def Sum(self, a, b):
        return a + b
    def Sum2(self, c, d):
        print(c + d)

a = TestBasic()
b = a.Sum(1, 3)
print(b)
a.Sum2(1, 3000)
