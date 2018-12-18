require "kpython-configuration.k"
require "kpython-semantics-arithmetic.k"

module KPYTHON-SEMANTICS-LOGIC
  imports KPYTHON-CONFIGURATION
  imports KPYTHON-SEMANTICS-ARITHMETIC


  syntax KResult ::= Val
  syntax KResult ::= Vals

  rule if E S => if E S else {}                                     [macro]
  rule def X:Id (self) B => def X (.Ids) B                              [macro]
  rule def X:Id (self, Y:Ids) B => def X (Y) B                [macro]

  rule if  true S else _ => S
  rule if false _ else S => S

  rule E if true else E' => E
  rule E if false else E' => E'

  rule while E S => if E {S while E S}  [structural]

  rule _:Val; => .
  rule S1::Stmts S2::Stmts => S1 ~> S2  [structural]

  rule <k> read() => I ...</k> <input> ListItem(I:Int) => .List ...</input>            [read]

  rule <k> X:Id => V ...</k>
      <env>... X |-> L ...</env>
      <store>... L |-> V:Val ...</store>  [lookup]

  rule if __name__ == '__main__' Block => Block                         [structural]

  rule {} => .                                                          [structural]
  rule <k> { S } => S ~> setEnv(Env) ...</k>  <env> Env </env>          [structural]

  syntax KItem ::= setEnv(Map)
  rule <k> setEnv(Env) => . ...</k>  <env> _ => Env </env>              [structural]
  rule (setEnv(_) => .) ~> setEnv(_)                                    [structural]

  syntax Exp ::= lookup(Int)
  rule <k> lookup(L) => V ...</k> <store>... L |-> V:Val ...</store>    [lookup]

  syntax KItem ::= "#freezerFunCall" "(" K ")"
  rule V:Val ~> #freezerFunCall(C:Exps) => V(C)
  rule (A:Exp(B:Exps))(C:Exps) => A(B) ~> #freezerFunCall(C)
  rule (A:Exp[B:Exps])(C:Exps) => A[B] ~> #freezerFunCall(C)
endmodule