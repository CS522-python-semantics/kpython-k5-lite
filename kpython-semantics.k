require "kpython-semantics-arithmetic.k"
require "kpython-semantics-class.k"
require "kpython-semantics-print.k"
require "kpython-semantics-lvalues.k"

module KPYTHON-SEMANTICS
  imports KPYTHON-SEMANTICS-ARITHMETIC
  imports KPYTHON-SEMANTICS-CLASS
  imports KPYTHON-SEMANTICS-PRINT

  rule if E : S => if E : S else : {}                                 [macro]
  rule N...M |-> _ => .Map  when N >Int M
  rule N...M |-> K => N |-> K (N +Int 1)...M |-> K  when N <=Int M

  rule if true: S else: _ => S
  rule if false: _ else: S => S

  rule <k> X:Id = V:Val => V ...</k>
      <env> Env => Env[X <- L] </env>
      <store>... .Map => L |-> V ...</store>
      <nextLoc> L:Int => L +Int 1 </nextLoc>

  rule <k> X:Id => V ...</k>
       <env>... X |-> L ...</env>
       <store>... L |-> V:Val ...</store>  [lookup]
endmodule