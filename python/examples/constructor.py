# Testing new, constructor, method invocation.

class C:
  i = 0
  j = 0
  def __init__(x):
    i = x
    j = x+1
  def add(d):
    i = i+d
    j = j-d
  def print2():
    print(i, " ", j, "\n")

if __name__ == '__main__':
    a = b = 5
    c = [[2,3],2]*2
    h = [2,3,4,5]
    h[3] = 88
    k = range(5)
    w = range(2,5)
    f = range(1,6,3)
    r = 100 if (a-3 not in f) else 500
    i = 0
    while i < 5:
      i += 1
    o = C(a)
    if isinstance(o,C):
      print ("yes")
    o.print2()
    o.add(b+1)
    o.print2()
    d = c[0]
    e = a
    print (c)

# 5 6
# 11 0
