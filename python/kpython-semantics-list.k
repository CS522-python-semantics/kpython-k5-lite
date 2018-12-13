require "kpython-semantics-logic.k"

module KPYTHON-SEMANTICS-LIST
  imports KPYTHON-SEMANTICS-LOGIC

  // [Vals]*Int
  rule N:Int*array(L:Int, N:Int) => array(L, N)*N
  rule <k> array(K:Int, M:Int)*N:Int => listJoin(K, M, N, L +Int 1) ~> array(L +Int 1, N *Int M) ...</k>
       //<store>... .Map => L |-> array(L +Int 1, N *Int M) ...</store>
       <nextLoc> L:Int => L +Int 1 +Int (N *Int M) </nextLoc>
    when N >=Int 0

  syntax KItem ::= listJoin(Int,Int,Int,Int)
  rule <k> listJoin(K:Int, M:Int, 0, L:Int) => . ...</k>
  rule <k> listJoin(K:Int, M:Int, N:Int, L:Int) => forEach(L, K, M -Int 1) ~> listJoin(K, M, N -Int 1, L +Int M) ...</k>
      when N >=Int 1

  syntax KItem ::= forEach(Int, Int, Int)
  rule <k> forEach(L:Int, K:Int, -1) => . ...</k>
  rule <k> forEach(L:Int, K:Int, M:Int) => save(L +Int M, V) ~> forEach(L, K, M -Int 1) ...</k>
        <store>... K +Int M |-> V:Val ...</store>  
        when M >=Int 0

  // [Vals]
  rule <k> [Vs:Vals] => listInitial(L,1,Vs) ...</k>
       <nextLoc> L:Int </nextLoc>  [structural]
  
  syntax KItem ::= listInitial(Int,Int,Vals)
  rule <k> listInitial(N:Int,I:Int,(V:Val, Vs:Vals)) => save(N +Int I, V) ~> listInitial(N, I +Int 1, Vs) ...</k> 
  rule <k> listInitial(L:Int,I:Int,.Vals) => array(L +Int 1, I -Int 1) ...</k>
       //<store>... .Map => L |-> array(L +Int 1, I -Int 1) ...</store>
       <nextLoc> _ => L +Int I </nextLoc>

  // range(N) = a list from 0 to N-1
  syntax Map ::= Int "..." Int "|->" Int Int Int [function, latex({#1}\ldots{#2}\mapsto{#3})]
  rule N...M |-> _ _ _=> .Map  when N >Int M
  rule N...M |-> S E I  => N |-> S (N +Int 1)...M |-> (S +Int I) E I  when N <=Int M
  
  rule <k> range(N:Int) => array(L +Int 1, N) ...</k>
       <store>... .Map =>  (L +Int 1)...(L +Int N) |-> 0 (N -Int 1) 1 ...</store>
       <nextLoc> L:Int => L +Int 1 +Int N </nextLoc>

  // range(N) = a list from N to M-1
  rule <k> range(N:Int,M:Int) => array(L +Int 1, M -Int N) ...</k>
       <store>... .Map =>  (L +Int 1)...(L +Int M -Int N) |-> N (M -Int 1) 1 ...</store>
       <nextLoc> L:Int => L +Int 1 +Int M -Int N </nextLoc>

  // range(N) = a list from N to M-1 with offset k
  rule <k> range(N:Int,M:Int,K:Int) => array(L +Int 1, ((M -Int 2) /Int K +Int 1)) ...</k>
       <store>... .Map =>  (L +Int 1)...(L +Int ((M -Int 2) /Int K +Int 1)) |-> N (M -Int 1) K ...</store>
       <nextLoc> L:Int => L +Int 1 +Int ((M -Int 2) /Int K +Int 1) </nextLoc>
  
  // for loop occurs under the list
  syntax KItem ::= forLoop(Id,Int,Int,Int,Stmts)
  rule forLoop(X,L,N,N,S) => .
  rule forLoop(X,L,N,K,S) => X = array(L,N)[K]; ~> S ~> forLoop(X,L,N,K +Int 1, S) when N >Int K
  rule for X:Id in array(L:Int, N:Int) {S:Stmts} => forLoop(X,L,N,0,S)  

  // check if a val V is in a list 
  rule <k> V:Val in array(L:Int, N:Int) => true ...</k>
        <store>... L |-> V ...</store>  
        when N >=Int 0 
  rule <k> V:Val in array(L:Int, N:Int) => V:Val in array(L +Int 1, N -Int 1) ...</k> 
       <store>... L |-> X ...</store>  
        when N >=Int 0 andBool V =/=K X
  rule <k> V:Val in array(L:Int, -1) => false ...</k>
  rule V:Val not in array(L:Int, N:Int) => not(V:Val in array(L, N))   [structural]
  
  // len(list) -length of the list
  rule len(array(_,N)) => N

  // lookup value in a list by index 
  rule V:Val[N1:Int, N2:Int, Vs:Vals] => V[N1][N2, Vs]                  [structural, anywhere]
  rule array(L,_)[N:Int] => lookup(L +Int N)                            [structural, anywhere]

  // save val V to location L
  syntax KItem ::= save(Int,Val)
  rule <k> save(L:Int, V:Val) => . ...</k>
       <store>... .Map => L |-> V ...</store>  
  
endmodule