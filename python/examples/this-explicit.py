# Testing the explicit use of "this"

class C:
  def m1(self):
    return self.m2()
  def m2(self):
    return 13

print((C()).m1(), "\n")


# 13
