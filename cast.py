class A {
  var x;
  method A() {
    x=10;
  }
  method getA() {
    return x;
  }
}

class B extends A {
  var x;
  method B() {
    super.A();
    x=20;
  }
  method getB() {
    return x;
  }
}

class Main {
  method Main() {
    var b = new B(), a = (A) b;
    print("b.x = ", b.x, "\n");
    print("a.x = ", a.x, "\n");
    print("a.getB() = ", a.getB(), "\n");  // this should not type check.  why?
    print("a.getA() = ", a.getA(), "\n");
  }
}
