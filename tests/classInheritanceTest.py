class A:
    def __init__(self):
        self.a = 10

class B(A):
    def __init__(self):
        super().__init__()
        print(self.a)

test = B()
