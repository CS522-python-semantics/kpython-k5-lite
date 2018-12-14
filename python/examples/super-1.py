# Testing dynamic method dispatch and super

class C1:
  def m1(self):
    return(m2())
  def m2(self): 
    return 13

class C2 (C1):
  def m1(self):
    return 22
  def m2(self):
    return 23
  def m3(self):
    return(super().m1())

class C3 (C2):
  def m1(self):
    return 32
  def m2(self):
    return 33


o3 = C3()
print(o3.m3(), "\n")


# 33 
