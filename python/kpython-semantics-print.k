require "kpython-configuration.k"

module KPYTHON-SEMANTICS-PRINT
  imports KPYTHON-CONFIGURATION

  rule print(E:Exps); => iprint(E);iprint("\n");            [macro]

  syntax Stmt ::= "iprint" "(" Exps ")" ";"              [strict]
  rule iprint(V:Val, Es:Vals); => iprint(V);iprint(" ");iprint(Es);   when Es =/=K .Vals    [structural]
  rule <k> iprint(V:SimpleVal, Es => Es); ...</k> <output>... .List => ListItem(V) </output>   when Es ==K .Vals  [print]
  rule <k> iprint(V:NoneVal, Es => Es); ...</k> <output>... .List => ListItem("None") </output>   when Es ==K .Vals  [print]
  rule iprint(V:CombinedVal, Es:Vals); => iprint("[");sprint(V);iprint("]");  when Es ==K .Vals [structural]

  syntax Stmt ::= "sprint" "(" Exp ")" ";"              [strict]
  rule sprint(V:Val); => iprint(V[0]);  [structural]

  rule iprint(.Vals); => .                                               [structural]

endmodule