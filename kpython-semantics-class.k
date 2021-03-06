require "kpython-semantics-assignment.k"

module KPYTHON-SEMANTICS-CLASS
    imports KPYTHON-SEMANTICS-ASSIGNMENT
    rule class C:Id S => class C (Object) S   
    
    syntax Val ::= objectClosure(Id, List)
    syntax KItem ::= fstackFrame(Map,K,List,K)

    rule <k> class Class1:Id (Class2:Id) { S } => declareStmts(Class1, S); ...</k>
        <classes>... (.Bag => <classData>
                            <className> Class1 </className>
                            <baseClass> Class2 </baseClass>
                            <declarations> S </declarations>
                        </classData>)
        ...</classes>
        <storeClass> ... .Map => Class1 |-> Class2 ... </storeClass>
        <classStaticVars>... (.Bag => <classStaticData>
                            <classStaticName> Class1 </classStaticName>
                            <classStaticDeclaration> .Map </classStaticDeclaration>
                        </classStaticData>)
        ...</classStaticVars>
        [structural]

    syntax Stmt ::= "declareStmts" "(" Id "," Stmts ")" ";"
                  | "declareStmt" "(" Id "," Stmt ")" ";"
    
    rule declareStmts(Class, S:Stmt); => declareStmt(Class, S); [structural]
    rule declareStmts(Class, S:Stmt Es:Stmts); => declareStmt(Class, S);declareStmts(Class, Es); [structural]

    rule <k> declareStmt(Class, def F:Id(Xs:Ids) S); => . ... </k>
        <classStaticName> Class </classStaticName>
        <classStaticDeclaration> Env => Env[F <- "function"] </classStaticDeclaration>

    rule <k> declareStmt(Class, X:Id = V:Val ; ) ; => . ... </k>
        <classStaticName> Class </classStaticName>
        <classStaticDeclaration> Env => Env[X <- V] </classStaticDeclaration>

    rule <k> Class:Id(Vs:Vals) ~> K => create(Class) ~> storeObj ~> __init__(Vs); return self; </k>
        <env> Env => .Map </env>
        <nextLoc> L:Int => L +Int 1 </nextLoc>
        <control> <xstack> XS </xstack>
            <crntObj> Obj
                    => <crntClass> Object </crntClass>
                        <envStack> ListItem(envStackFrame(Object, .Map)) </envStack>
                        <location> L </location>
            </crntObj>
            <fstack> .List => ListItem(fstackFrame(Env, K, XS, <crntObj> Obj </crntObj>)) ...</fstack>
        </control>
        <storeClass> StoreClass </storeClass>
        when Class in keys(StoreClass)

    syntax KItem ::= create(Id)

    rule <k> create(Class:Id)
            => create(Class1) ~> setCrntClass(Class) ~> S ~> addInit ~> addEnvLayer ...</k>
        <className> Class </className>
        <baseClass> Class1:Id </baseClass>
        <declarations> S </declarations>  [structural]

    rule <k> create(Object) => . ...</k>  [structural]

    syntax KItem ::= setCrntClass(Id)

    rule <k> setCrntClass(C) => . ...</k>
        <crntClass> _ => C </crntClass>  [structural]

    syntax KItem ::= "addInit"
    rule <k> addInit => def __init__(.Ids) {} ...</k>
        <env> Env </env>
        when notBool(__init__ in keys(Env))
    rule <k> addInit => . ...</k>
        <env>... __init__|-> _ ...</env>

    syntax KItem ::= "addEnvLayer"

    rule <k> addEnvLayer => . ...</k>
        <env> Env => .Map </env>
        <crntClass> Class:Id </crntClass>
        <envStack> .List => ListItem(envStackFrame(Class, Env)) ...</envStack>
        [structural]

    syntax KItem ::= "storeObj"

    rule <k> storeObj => . ...</k>
        <crntObj> <crntClass> CC </crntClass> <envStack> ES </envStack> (<location> L:Int </location> => .Bag) </crntObj>
        <store>... .Map => L |-> objectClosure(CC, ES) ...</store>

    // isinstance
    rule isinstance(objectClosure(_, ListItem(envStackFrame(C,_)) _),C) => true
    rule isinstance(objectClosure(_, (ListItem(envStackFrame(C,_)) => .List) _),C')  when C =/=K C'  [structural]
    rule isinstance(objectClosure(_, .List),_) => false

    // static variables
    syntax KItem ::= "lookupd" "(" Id "," Id ")"
    syntax KItem ::= "lookupenv" "(" Id "," Map ")"

    rule <k> C:Id . Y:Id => lookupd(C, Y) ... </k>
        <storeClass> StoreClass </storeClass>
        when C in keys(StoreClass)      [structural]

    rule <k> lookupd(C:Id, Y:Id) => lookupenv(Y, Env) ... </k>
        <classStaticName> C </classStaticName>
        <classStaticDeclaration> Env </classStaticDeclaration>

    rule lookupenv(Y:Id, Y|->V:Val _) => V

endmodule