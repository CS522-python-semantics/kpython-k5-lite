require "kpython-semantics-class.k"
require "kpython-semantics-logic.k"

module KPYTHON-SEMANTICS-METHOD
    imports KPYTHON-SEMANTICS-CLASS
    imports KPYTHON-SEMANTICS-LOGIC

    rule <k> def F:Id(Xs:Ids) S => . ...</k>
        <crntClass> Class:Id </crntClass>
        <location> OL:Int </location>
        <env> Env => Env[F <- L] </env>
        <store>... .Map => L |-> methodClosure(Class,OL,Xs,S) ...</store>
        <nextLoc> L => L +Int 1 </nextLoc>  
    // rule def __init__(Xs:Ids) S =


    syntax Stmts ::= mkDecls(Ids,Vals)  [function]
    rule mkDecls((X:Id, Xs:Ids), (V:Val, Vs:Vals)) => X=V; mkDecls(Xs,Vs) //remove var 
    rule mkDecls(.Ids,.Vals) => {}

    syntax Val ::= methodClosure(Id,Int,Ids,Stmt)
    
    rule <k> methodClosure(Class,OL,Xs,S)(Vs:Vals) ~> K => mkDecls(Xs,Vs) S return; </k>
        <env> Env => .Map </env>
        <store>... OL |-> objectClosure(_, EnvStack)...</store>
        <control>
            <xstack> XS </xstack>
            <fstack> .List => ListItem(fstackFrame(Env, K, XS, <crntObj> Obj' </crntObj>))
            ...</fstack>
            <crntObj> Obj' => <crntClass> Class </crntClass> <envStack> EnvStack </envStack> </crntObj>
        </control>

    rule return; => return None;   [macro]

    rule <k> return(V:Val); ~> _ => V ~> K </k>
        <control>
            <fstack> ListItem(fstackFrame(Env,K,XS,<crntObj> CO </crntObj>)) => .List ...</fstack>
            <xstack> _ => XS </xstack>
            <crntObj> _ => CO </crntObj>
        </control>
        <env> _ => Env </env>
endmodule