if [ -f ../Top.v ]
then
	vsim -pli simfpga.vpi -Lf 220model -Lf altera_mf_ver -Lf verilog -t 1ns -c -do "run -all" tb
fi
if [ -f -nolock ../Top.sv ]
then
	vsim -pli simfpga.vpi -Lf 220model -Lf altera_mf_ver -Lf verilog -t 1ns -c -do "run -all" tb
fi
if [ -f ../Top.vhd ]
then
	vsim -pli simfpga.vpi -Lf 220model -Lf altera_mf -t 1ns -c -do "set StdArithNoWarnings 1" -do "set NumericStdNoWarnings 1" -do "run -all" tb
fi

