vsim -pli %DESimPath%\%DESimulator%.vpi -Lf 220model -Lf altera_mf -t 1ns -c -do "set StdArithNoWarnings 1" -do "set NumericStdNoWarnings 1" -do "run -all" tb %QuestaArg% 
