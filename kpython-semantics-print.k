require "kpython-semantics-logic.k"

module KPYTHON-SEMANTICS-PRINT
  imports KPYTHON-SEMANTICS-LOGIC

  rule print(E:Exps); => iprint(E);iprint("\n");            [macro]

  syntax Stmt ::= "iprint" "(" Exps ")" ";"               [strict]
  rule iprint(V:Val, Es:Vals); => iprint(V);iprint(" ");iprint(Es);   
       when Es =/=K .Vals                                 [structural]

  rule <k> iprint(V:String); => . ...</k> 
       <output>... .List => ListItem(V) </output>    [print]

  rule <k> iprint(V:Int); => . ...</k> 
       <output>... .List => ListItem(V) </output>    [print]

  rule <k> iprint(V:Bool); => . ...</k> 
       <output>... .List => ListItem("True") </output>    
       when V ==K true                               [print]

  rule <k> iprint(V:Bool); => . ...</k> 
       <output>... .List => ListItem("False") </output>    
       when V ==K false                               [print]

  rule <k> iprint(V:NoneVal); => . ...</k> 
       <output>... .List => ListItem("None") </output>   [print]

  rule iprint(V:CombinedVal); => iprint("[");sprint(V);iprint("]");    [structural]

  syntax Stmt ::= "sprint" "(" Exp ")" ";"                 [strict]
  rule sprint(array(L:Int, N:Int)); => lprint(array(L, N)[0]); iprint(", "); sprint(array(L +Int 1, N -Int 1));
       when N >Int 1                                      [structural]
  rule sprint(array(L:Int, N)); => lprint(array(L, N)[0]);
       when N <=Int 1                                       [structural]

  syntax Stmt ::= "lprint" "(" Exp ")" ";"                 [strict]
  rule lprint(V:NoneVal); => iprint(V);
  rule lprint(V:CombinedVal); => iprint(V);
  rule lprint(V:String); => iprint("'");iprint(V);iprint("'");
  rule lprint(V:Int); => iprint(V);
  rule lprint(V:Bool); => iprint(V);
endmodule