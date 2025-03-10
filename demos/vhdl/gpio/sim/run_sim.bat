vsim -pli %DESimPath%\%DESimulator%.vpi -Lf 220model -Lf altera_mf_ver -Lf verilog -t 1ns -c -do "run -all" tb %QuestaArg% 
