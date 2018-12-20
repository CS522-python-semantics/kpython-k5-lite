class A:
    def __init__(self):
        self.a = 10

class B(A):
    def __init__(self):
        print(self.a)

test = B()
