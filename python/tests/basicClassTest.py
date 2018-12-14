class TestBasic:
    def Sum(self, a, b):
        return a + b

a = TestBasic()
b = a.Sum(1, 3)
print(b)
print(a.Sum(1, 3000))
