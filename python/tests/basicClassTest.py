class TestBasic:
    def __init(self)__:
        self.a = 8
        self.b = 10
    def Sum(self, a, b):
        return a + b + self.a + self.b
    def Sum2(self, c, d):
        a = c
        b = d
        return a + b + self.a + self.b

a = TestBasic()
b = a.Sum(1, 3)
print(b)
print(a.Sum(1, 3000))
