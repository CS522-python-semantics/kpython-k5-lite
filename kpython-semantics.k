require "kpython-semantics-arithmetic.k"

module KPYTHON-SEMANTICS
  imports KPYTHON-SEMANTICS-ARITHMETIC
  imports DOMAINS

  syntax EnvCell
  syntax ControlCell
  syntax EnvStackCell
  syntax CrntObjCellFragment

  configuration <T color="red"> //This configuration is from KOOL
                  <k color="green"> $PGM:Stmts ~> execute </k>
                  <control color="cyan">
                    <fstack color="blue"> .List </fstack>
                    <xstack color="purple"> .List </xstack>
                    <crntObj color="Fuchsia">  // KOOL
                        <crntClass> Object </crntClass>
                        <envStack> .List </envStack>
                        <location multiplicity="?"> .K </location>
                    </crntObj>
                  </control>
                  <env color="violet"> .Map </env>
                  <store color="white"> .Map </store>
                  <input color="magenta" stream="stdin"> .List </input>
                  <output color="brown" stream="stdout"> .List </output>
                  <nextLoc color="gray"> 0 </nextLoc>
                  <classes color="Fuchsia">
                     <classData multiplicity="*" type="Map" color="Fuchsia">
                        <className color="Fuchsia"> Main </className>
                        <baseClass color="Fuchsia"> Object </baseClass>
                        <declarations color="Fuchsia"> .K </declarations>
                     </classData>
                  </classes>
                </T>

  syntax Map ::= Int "..." Int "|->" K [function]
  rule N...M |-> _ => .Map  when N >Int M
  rule N...M |-> K => N |-> K (N +Int 1)...M |-> K  when N <=Int M

  syntax Val ::= "None"
  syntax KItem ::= "execute"
  rule <k> execute => new Main(.Exps); </k> <env> .Map </env> [structural]
  rule _:Val; => .
  rule S1::Stmts S2::Stmts => S1 ~> S2  [structural]

  rule <k> X:Id = V:Val => V ...</k>
      <env> Env => Env[X <- L] </env>
      <store>... .Map => L |-> V ...</store>
      <nextLoc> L:Int => L +Int 1 </nextLoc>

  rule <k> X:Id => V ...</k>
       <env>... X |-> L ...</env>
       <store>... L |-> V:Val ...</store>  [lookup]
endmodule