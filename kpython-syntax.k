module KPYTHON-SYNTAX
  imports DOMAINS-SYNTAX

  syntax Decl ::= "def" Id "(" Ids ")" ":" Block
                | "class" Id ":" Block

  syntax Exp ::= Int | Bool | String | Id
               | "self"
               | "super"
               | "(" Exp ")"             [bracket]
               | "++" Exp
               | Exp "instanceOf" Id     [strict(1)]
               | "(" Id ")" Exp          [strict(2)]
               | "new" Id "(" Exps ")"   [strict(2)]
               | Exp "." Id
               > Exp "[" Exps "]"        [strict]
               > Exp "(" Exps ")"        [strict(2)]
               | "-" Exp                 [strict]
               | "len" "(" Exp ")"    [strict]
               | "read" "(" ")"
               > left:
                 Exp "*" Exp             [strict, left]
                 Exp "**" Exp             [strict, left]
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
endmodule