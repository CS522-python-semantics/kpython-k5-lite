# Testing recursion

class C:
  def f(self, x):
    if x <= 1:
      return 1
    else: 
      return x * f(x - 1)

  def __init__(self):
    print(f(f(5)), "\n")

c = C()

# (5!)!


