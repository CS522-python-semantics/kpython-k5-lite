require "kpython-syntax.k"
require "kpython-configuration.k"

module KPYTHON-SEMANTICS-ENVIRONMENT
  imports KPYTHON-SYNTAX
  imports KPYTHON-CONFIGURATION

  syntax Val ::= objectClosure(Id, List)
               | methodClosure(Id,Int,Ids,Stmt)
  syntax KItem ::= "envStackFrame" "(" Id "," Map ")"
  syntax KItem ::= fstackFrame(Map,K,List,K)
  syntax Exp ::= lookupMember(List, Id)  [function]
  syntax Exp ::= lookup(Int)
  syntax Stmts ::= mkDecls(Ids,Vals)  [function]

  rule <k> { S } => S ~> setEnv(Env) ...</k>  <env> Env </env>  [structural]
  syntax KItem ::= setEnv(Map)
  rule <k> setEnv(Env) => . ...</k>  <env> _ => Env </env>  [structural]
  rule (setEnv(_) => .) ~> setEnv(_)  [structural]

  rule <k> lookup(L) => V ...</k> <store>... L |-> V:Val ...</store>  [lookup]
  rule <k> (lookup(L) => V)(_:Exps) ...</k>  <store>... L |-> V:Val ...</store>
    [lookup]
  rule mkDecls((X:Id, Xs:Ids), (V:Val, Vs:Vals)) => X = V; mkDecls(Xs,Vs)
  rule mkDecls(.Ids,.Vals) => {}

  syntax Map ::= Int "..." Int "|->" K  [function]

  syntax KItem ::= "storeObj"
  rule <k> storeObj => . ...</k>
       <crntObj> <crntClass> CC </crntClass> <envStack> ES </envStack> (<location> L:Int </location> => .Bag) </crntObj>
       <store>... .Map => L |-> objectClosure(CC, ES) ...</store>

  rule <k> self => objectClosure(CC, ES) ...</k>
       <crntObj> <crntClass> CC </crntClass> <envStack> ES </envStack> </crntObj>
  rule objectClosure(Class:Id, ListItem(envStackFrame(Class,Env)) EStack)
       . X:Id
    => lookupMember(ListItem(envStackFrame(Class,Env)) EStack, X)
    [structural]

  rule objectClosure(Class:Id, (ListItem(envStackFrame(Class':Id,_)) => .List) _)
       . X:Id
    when Class =/=K Class'  [structural]

  rule (objectClosure(_, EStack) . X
    => lookupMember(EStack, X:Id))(_:Exps)  [structural]

  rule objectClosure(_, ListItem(envStackFrame(C,_)) _)
       instanceOf C => true

  rule objectClosure(_, (ListItem(envStackFrame(C,_)) => .List) _)
       instanceOf C'  when C =/=K C'  [structural]

  rule objectClosure(_, .List) instanceOf _ => false

  rule (C) objectClosure(_ , EnvStack) => objectClosure(C ,EnvStack)

  rule lookupMember(ListItem(envStackFrame(_, X|->L _:Map)) _, X)
    => lookup(L)

  rule lookupMember(ListItem(envStackFrame(_, Env)) Rest, X) =>
       lookupMember(Rest, X)
    when notBool(X in keys(Env))

  rule <k> methodClosure(Class,OL,Xs,S)(Vs:Vals) ~> K
           => mkDecls(Xs,Vs) S return; </k>
       <env> Env => .Map </env>
       <store>... OL |-> objectClosure(_, EnvStack)...</store>
       <control>
          <xstack> XS </xstack>
          <fstack> .List => ListItem(fstackFrame(Env, K, XS, <crntObj> Obj' </crntObj>))
          ...</fstack>
          <crntObj> Obj' => <crntClass> Class </crntClass> <envStack> EnvStack </envStack> </crntObj>
       </control>

  rule <k> def F:Id(Xs:Ids) : S:Block => . ...</k>
       <crntClass> Class:Id </crntClass>
       <location> OL:Int </location>
       <env> Env => Env[F <- L] </env>
       <store>... .Map => L |-> methodClosure(Class,OL,Xs,S) ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>

  rule <k> return V:Val; ~> _ => V ~> K </k>
       <control>
         <fstack> ListItem(fstackFrame(Env,K,XS,<crntObj> CO </crntObj>)) => .List ...</fstack>
         <xstack> _ => XS </xstack>
         <crntObj> _ => CO </crntObj>
       </control>
       <env> _ => Env </env>

  rule return; => return None;   [macro]
endmodule