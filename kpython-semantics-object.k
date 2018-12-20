require "kpython-semantics-class.k"
require "kpython-semantics-logic.k"

module KPYTHON-SEMANTICS-OBJECT 
    imports KPYTHON-SEMANTICS-CLASS
    imports KPYTHON-SEMANTICS-LOGIC
 
   rule <k> self => objectClosure(CC, ES) ...</k>
       <crntObj> 
                 <crntClass> CC </crntClass> 
                 <envStack> ES </envStack> 
       </crntObj>

  // rule <k> X:Id => self . X ...</k> <env> Env:Map </env> [[mark]]
  //   when notBool(X in keys(Env))  [structural]
  
  // self.X, object.X
  context HOLE._::Id when HOLE =/=K super()

  rule objectClosure(Class:Id, ListItem(envStackFrame(Class,Env)) EStack) . X:Id
        => lookupMember(ListItem(envStackFrame(Class,Env)) EStack, X) [structural]
  
  rule objectClosure(Class:Id, (ListItem(envStackFrame(Class':Id,_)) => .List) _) . X:Id
        when Class =/=K Class'                                        [structural]

  // When declaring a variable in a class, it will create the variable in the current class, rather than in its ancestor.
  //The rule of updating the environment in a object
  syntax Exp ::= assignMember(Id, Map, Val)  [function]
  rule objectClosure(Class:Id, ListItem(envStackFrame(Class,Env)) EStack) . X = V:Val => assignMember(Class, Env, V)

  rule <k> assignMember(C:Id, C|->L:Int _, V:Val) => V </k>
       <store>... L |-> (_ => V) ...</store> [assignment]

  rule <k> assignMember(C, Env, V) => V </k>
        <crntObj>
         <crntClass> CC </crntClass>
         <envStack> ListItem(envStackFrame(Class,Env=>Env[C <- L])) </envStack>
        </crntObj>
        <store>... .Map => L |-> V ...</store>
        <nextLoc> L => L +Int 1 </nextLoc>      when notBool(C in keys(Env))

  // super().X
  rule <k> super() . X => lookupMember(EStack, X) ...</k>
       <crntClass> Class:Id </crntClass>
       <envStack> ListItem(envStackFrame(Class,_)) EStack </envStack> [structural]
  rule <k> super() . X ...</k>
       <crntClass> Class </crntClass>
       <envStack> ListItem(envStackFrame(Class':Id,_)) => .List ...</envStack>
        when Class =/=K Class'                                        [structural]

  // Lookup member: 
  //It searches for the given member in the given environment stack,
  //starting with the most concrete class and going up in the hierarchy
  syntax Exp ::= lookupMember(List, Id)  [function]
  rule lookupMember(ListItem(envStackFrame(_, X|->L _)) _, X) => lookup(L)
  rule lookupMember(ListItem(envStackFrame(_, Env)) Rest,  X) => lookupMember(Rest, X)
    when notBool(X in keys(Env))

  rule (C) objectClosure(_ , EnvStack) => objectClosure(C ,EnvStack)

  // assignemnt for self.values
  context checkl((HOLE . _)::Exp)
  rule checkl(objectClosure(Class, ListItem(envStackFrame(Class,Env)) EStack) . X
              => lookupMember(ListItem(envStackFrame(Class,Env)) EStack, X))  [structural]
  rule checkl(objectClosure(Class, (ListItem(envStackFrame(Class':Id,_)) => .List) _) . X)
               when Class =/=K Class'  [structural]
endmodule