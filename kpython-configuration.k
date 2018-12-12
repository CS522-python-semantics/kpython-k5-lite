require "kpython-syntax.k"

module KPYTHON-CONFIGURATION
  imports KPYTHON-SYNTAX
  imports DOMAINS
  configuration <T color="red"> //This configuration is from KOOL
                  <k color="green"> $PGM:Stmts </k>
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
endmodule
