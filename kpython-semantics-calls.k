require "kpython-semantics-method.k"
require "kpython-semantics-object.k"
module KPYTHON-SEMANTICS-CALLS
    imports KPYTHON-SEMANTICS-METHOD
    imports KPYTHON-SEMANTICS-OBJECT 
    
    // method invocation
    rule <k> (X:Id => V)(_:Exps) ...</k>
        <env>... X |-> L ...</env>
        <store>... L |-> V:Val ...</store>  [lookup]

    /*rule <k> (X:Id => self . X)(_:Exps) ...</k>
        <env> Env </env>
        <storeClass> StoreClass </storeClass>
        when notBool(X in keys(Env)) andBool notBool(X in keys(StoreClass))  [structural]
 */
 
    // the method application or array accesses are allowed as first argument to application
    // because methods are allowed to return methods and arrays are allowed to hold methods
    context HOLE._::Id(_) when HOLE =/=K super()

    rule (objectClosure(_, EStack) . X  => lookupMember(EStack, X:Id))(_:Exps)      [structural]


    // super().X(exps)
    rule <k> (super() . X => lookupMember(EStack,X))(_:Exps)...</k>
        <crntClass> Class </crntClass>
        <envStack> ListItem(envStackFrame(Class,_)) EStack </envStack>      [structural]
    // remove if not match
    rule <k> (super() . X)(_:Exps) ...</k>
        <crntClass> Class </crntClass>
        <envStack> ListItem(envStackFrame(Class':Id,_)) => .List ...</envStack>
        when Class =/=K Class'                                              [structural]

    rule <k> (lookup(L) => V)(_:Exps) ...</k>  
            <store>... L |-> V:Val ...</store>  [lookup]
    
endmodule