require "kpython-semantics-arithmetic.k"
require "kpython-semantics-assignment.k"
require "kpython-semantics-class.k"
require "kpython-semantics-method.k"
require "kpython-semantics-object.k"
require "kpython-semantics-calls.k"
require "kpython-semantics-exception.k"
require "kpython-semantics-print.k"

module KPYTHON
  imports KPYTHON-SEMANTICS-ARITHMETIC
  imports KPYTHON-SEMANTICS-ASSIGNMENT
  imports KPYTHON-SEMANTICS-CLASS
  imports KPYTHON-SEMANTICS-METHOD
  imports KPYTHON-SEMANTICS-EXCEPTION 
  imports KPYTHON-SEMANTICS-OBJECT 
  imports KPYTHON-SEMANTICS-CALLS
  imports KPYTHON-SEMANTICS-PRINT


  // rule <k> execute => . ...</k> 
  rule <k> execute => . ...</k> 
       <crntObj> Obj
                => <crntClass> Object </crntClass>
                    <envStack> .List </envStack>
                    <location> 0 </location>
        </crntObj>
        <store> .Map => 0 |-> objectClosure(Object, .List) </store>
        
endmodule
