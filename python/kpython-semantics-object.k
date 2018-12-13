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

  rule <k> X:Id => self . X ...</k> <env> Env:Map </env>
    when notBool(X in keys(Env))  [structural]
  
  // self.X, object.X
  context HOLE._::Id when HOLE =/=K super()

  rule objectClosure(Class:Id, ListItem(envStackFrame(Class,Env)) EStack) . X:Id
        => lookupMember(ListItem(envStackFrame(Class,Env)) EStack, X) [structural]
  
  rule objectClosure(Class:Id, (ListItem(envStackFrame(Class':Id,_)) => .List) _) . X:Id
        when Class =/=K Class'                                        [structural]

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