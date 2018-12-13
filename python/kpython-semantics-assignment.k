require "kpython-semantics-list.k"

module KPYTHON-SEMANTICS-ASSIGNMENT
  imports KPYTHON-SEMANTICS-LIST

  rule E1 += E2; => E1 = E1 + E2;                                   [macro]
  rule E1 -= E2; => E1 = E1 - E2;                                   [macro]
  rule E1 *= E2; => E1 = E1 * E2;                                   [macro]
  rule E1 /= E2; => E1 = E1 / E2;                                   [macro]
  rule E1 %= E2; => E1 = E1 % E2;                                   [macro]

  syntax KItem ::= "undefined"  [latex(\bot)]
  syntax KItem ::= initial(Id)
  rule <k> initial(X:Id) => . ...</k>
       <env> Env => Env[X <- L] </env>
       <store>... .Map => L |-> undefined ...</store>
       <nextLoc> L:Int => L +Int 1 </nextLoc>

  syntax KItem ::= "envStackFrame" "(" Id "," Map ")"
  syntax Val ::= loc(Int)
  syntax Exp ::= checkl(K)
  context (HOLE => checkl(HOLE)) = _

  rule <k> checkl(X:Id => loc(L)) ...</k> <env>... X |-> L:Int ...</env>   [structural]

  rule <k> checkl(X:Id => loc(L)) ...</k> 
      <env> Env </env>  
      <crntObj> 
                <crntClass> _ </crntClass> 
                <envStack> ListItem(envStackFrame(_, X|->L _)) _ </envStack> 
      </crntObj>  
      when notBool (X in keys(Env))  [structural]

  rule <k> checkl(X:Id) => initial(X) ~> checkl(X) ...</k> 
       <env> Env </env>  
       <envStack> ListItem(envStackFrame(_, ES)) _ </envStack> 
       when notBool (X in keys(Env)) andBool notBool (X in keys(ES))   [structural]  

  rule <k> checkl(X:Id) => initial(X) ~> checkl(X) ...</k> 
       <env> Env </env>  
       <envStack> .List </envStack> 
       when notBool (X in keys(Env))  [structural]  

  rule <k> loc(L) = V:Val => V ...</k> 
       <store>... L |-> (_ => V) ...</store> [assignment]

  context checkl(_::Exp[HOLE::Exps])
  context checkl(HOLE::Exp[_::Exps])
  rule checkl(lookup(L:Int) => loc(L))  [structural]

  // rule <k> lvalue(X:Id => self . X) ...</k>  <env> Env </env>
  //   when notBool(X in keys(Env))  [structural]

  // context lvalue((HOLE . _)::Exp)
  // rule lvalue(objectClosure(Class, ListItem(envStackFrame(Class,Env)) EStack) . X
  //             => lookupMember(ListItem(envStackFrame(Class,Env)) EStack, X))  [structural]
  // rule lvalue(objectClosure(Class, (ListItem(envStackFrame(Class':Id,_)) => .List) _) . X)
  //   when Class =/=K Class'  [structural]
endmodule