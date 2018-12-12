module KPYTHON-SYNTAX
  imports DOMAINS-SYNTAX

  syntax Id ::= "Object" [token] | "Main" [token]

  syntax Decl ::= "def" Id "(" Ids ")" ":" Block
                | "class" Id ":" Block
                | "class" Id "(" Id ")" ":" Block
                | "def" Id "(" "self" "," Ids ")" ":" Block

  syntax Exp ::= Int | Bool | String | Id
               | "self"
               | "super()"
               | "(" Exp ")"             [bracket]
               | "++" Exp
               | Exp "instanceOf" Id     [strict(1)]
               | "(" Id ")" Exp          [strict(2)]
               | "new" Id "(" Exps ")"   [strict(2)]
               | Exp "." Id
               > Exp "[" Exps "]"        [strict]
               > Exp "(" Exps ")"        [strict(2)]
               | "-" Exp               [strict]
               | "len" "(" Exp ")"    [strict]
               | "read" "(" ")"
               > left:
                 Exp "*" Exp             [strict, left]
               | Exp "**" Exp             [strict, left]
               | Exp "/" Exp             [strict, left]
               | Exp "%" Exp             [strict, left]
               > left:
                 Exp "+" Exp             [strict, left]
               | Exp "-" Exp             [strict, left]
               > non-assoc:
                 Exp "<" Exp             [strict, non-assoc]
               | Exp "<=" Exp            [strict, non-assoc]
               | Exp ">" Exp             [strict, non-assoc]
               | Exp ">=" Exp            [strict, non-assoc]
               | Exp "==" Exp            [strict, non-assoc]
               | Exp "!=" Exp            [strict, non-assoc]
               > "!" Exp                 [strict]
               > left:
                 Exp "&&" Exp            [strict(1), left]
               | Exp "||" Exp            [strict(1), left]
               > Exp "=" Exp             [strict(2), right]

  syntax Ids  ::= List{Id,","}

  syntax Exps ::= List{Exp,","}          [strict]

  syntax Block ::= "{" "}"
                | "{" Stmts "}"

  syntax Stmt ::= Decl | Block
                | Exp ";"                               [strict]
                | "if" Exp ":" Block "else" ":" Block   [avoid, strict(1)]
                | "if" Exp ":" Block
                | "while" "(" Exp ")" Block
                | "for" "(" Stmts Exp ";" Exp ")" Block
                | "return" Exp ";"                      [strict]
                | "return" ";"
                | "print" "(" Exps ")" ";"              [strict]

  syntax Stmts ::= Stmt
                 | Stmts Stmts                          [right]

  syntax Val ::= Int | Bool | String
               | array(Int,Int)
  rule _:Val; => .
  rule S1::Stmts S2::Stmts => S1 ~> S2  [structural]

  syntax Vals ::= List{Val,","}
  syntax Exp ::= Val
  syntax Exps ::= Vals
  syntax KResult ::= Val
  syntax KResult ::= Vals
  syntax Val ::= "None"
  rule {} => .  [structural]

endmodule