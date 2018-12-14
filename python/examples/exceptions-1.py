class C:
  def foo(self):
    try:
      raise 5
      print(17)
    except e:
      raise e + 2
    raise 1


try:
  c = C()
  c.foo()
except e:
  print(e,"\n")

# 7
