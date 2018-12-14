# Testing recursion

class C:
  def f(self, x):
    if x <= 1:
      return 1
    else: 
      return x * self.f(x - 1)

  def __init__(self):
    print(self.f(self.f(5)))

c = C()

# (5!)!


