class A:
    a = "Static Variable"
    def __init__(self):
        a = "Local Variable"
        self.a = "Member Variable"
        print(self.a, "is Member Variable")
        print(A.a, "is Static Variable")
        print(a, "is Local Variable")

print(A.a, "is initialized when declared")
test1 = A()
print(test1.a, "should print Member Variable")
