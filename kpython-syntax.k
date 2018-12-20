module KPYTHON-SYNTAX
  imports DOMAINS-SYNTAX

  syntax Id ::= "Object" [token] | "Main" [token] | "__init__" [token] //legacy

  syntax Decl ::= "var" Exps ";"
                | "def" Id "(" Ids ")" Block
                | "def" Id "(" "self" ")" Block
                | "def" Id "(" "self" "," Ids ")" Block
                | "class" Id Block
                | "class" Id "(" Id ")" Block

  syntax Exp ::= Int | Bool | String | Id
               | "True"
               | "False"
               | "self"
               | "super" "(" ")"
               | "(" Exp ")"             [bracket]
               | "[" Exps "]"            [strict]
               | "range" "(" Exps ")"    [strict]
               | "isinstance" "(" Exp "," Id ")"     [strict(1)] 
               | "(" Id ")" Exp          [strict(2)] 
               | Exp "." Id                           
               > Exp "[" Exps "]"        [strict]
               > Exp "(" Exps ")"        [strict(2)]    
               | "-" Exp                 [strict]
               | "len" "(" Exp ")"       [strict]
               | "read" "(" ")"
               > left:
                 Exp "*" Exp             [strict, left]
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
               | Exp "in" Exp            [strict, non-assoc]
               | Exp "not" "in" Exp      [strict, non-assoc]
               > "not" Exp               [strict]
               > left:
                 Exp "and" Exp           [strict(1), left]
               | Exp "or" Exp            [strict(1), left]
               > Exp "if" Exp "else" Exp [strict(2), right]
               > Exp "=" Exp             [strict(2), right]

  syntax Ids  ::= List{Id,","}

  syntax Exps ::= List{Exp,","}          [strict]

  syntax Block ::= "{" "}"
                | "{" Stmts "}"

  syntax Stmt ::= Decl | Block
                | Exp ";"                               [strict]
                | Exp "+="  Exp ";"                     [strict(2), right]
                | Exp "-="  Exp ";"                     [strict(2), right]
                | Exp "*="  Exp ";"                     [strict(2), right]
                | Exp "/="  Exp ";"                     [strict(2), right]
                | Exp "%="  Exp ";"                     [strict(2), right]
                | "if" Exp Block "else" Block           [strict(1), avoid]
                | "if" Exp Block                        [strict(1)]
                | "if" "__name__" "==" "'__main__'" Block
                | "while" Exp Block
                | "for" Exp "in" Exp Block              [strict(2)]
                | "return" Exp ";"                      [strict]
                | "return" ";"
                | "print" "(" Exps ")" ";"              [strict]
                | "try" Block "except" Id Block
                | "raise" Exp ";"                       [strict]
                | "pass" ";"
                | "break" ";"
                | "continue" ";"

  syntax Stmts ::= Stmt
                 | Stmts Stmts                          [right]
  
  syntax SimpleVal ::= Int | Bool | String
  syntax CombinedVal ::= array(Int,Int)
  syntax NoneVal ::= "None"
  syntax Val ::= SimpleVal | CombinedVal | NoneVal
  syntax Vals ::= List{Val,","}
  syntax Exp ::= Val
  syntax Exps ::= Vals

endmodule