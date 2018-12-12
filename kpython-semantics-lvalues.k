require "kpython-semantics-environment.k"

module KPYTHON-SEMANTICS-LVALUES
  imports KPYTHON-SEMANTICS-ENVIRONMENT
  context (HOLE => lvalue(HOLE)) = _
  syntax Exp ::= lvalue(K)
  syntax Val ::= loc(Int)

  rule <k> lvalue(X:Id => loc(L)) ...</k>
       <env>... X |-> L:Int ...</env> [structural]

  context lvalue(_::Exp[HOLE::Exps])
  context lvalue(HOLE::Exp[_::Exps])

  rule lvalue(lookup(L:Int) => loc(L))  [structural]
  rule <k> lvalue(X:Id => self . X) ...</k>  <env> Env </env>
    when notBool(X in keys(Env))  [structural]

  context lvalue((HOLE . _)::Exp)


  rule lvalue(objectClosure(Class, ListItem(envStackFrame(Class,Env)) EStack)
              . X
              => lookupMember(ListItem(envStackFrame(Class,Env)) EStack,
                              X))  [structural]
  rule lvalue(objectClosure(Class, (ListItem(envStackFrame(Class':Id,_)) => .List) _)
              . X)
    when Class =/=K Class'  [structural]
endmodule