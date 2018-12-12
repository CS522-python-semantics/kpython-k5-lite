require "kpython-semantics-environment.k"

module KPYTHON-SEMANTICS-PRINT
  imports KPYTHON-SEMANTICS-ENVIRONMENT
  rule <k> print(V:Val, Es => Es); ...</k> <output>... .List => ListItem(V) </output>
    [print]
  rule print(.Vals); => .  [structural]
endmodule