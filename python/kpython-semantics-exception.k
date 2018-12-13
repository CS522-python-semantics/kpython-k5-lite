require "kpython-configuration.k"
module KPYTHON-SEMANTICS-EXCEPTION 
    imports KPYTHON-CONFIGURATION
    
    syntax KItem ::= "popx"

    rule <k> popx => . ...</k>
        <xstack> ListItem(_) => .List ...</xstack>

    syntax KItem ::= xstackFrame(Id,Stmt,K,Map,K) | (Id,Stmt,K,Map,K)

    rule <k> raise V:Val; ~> _ => { X = V; S2 } ~> K </k> //remove var 
        <control>
            <xstack> ListItem(xstackFrame(X, S2, K, Env, C)) => .List ...</xstack>
            (_ => C)
        </control>
        <env> _ => Env </env>

    rule <k> (try S1 except X {S2} => S1 ~> popx) ~> K </k>
        <control>
            <xstack> .List => ListItem(xstackFrame(X, S2, K, Env, C)) ...</xstack>
            C
        </control>
        <env> Env </env>

endmodule