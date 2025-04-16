LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY inst_mem IS
	PORT
	(
		address : IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		clock	: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
END inst_mem;


ARCHITECTURE SYN OF inst_mem IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (11 DOWNTO 0);

BEGIN
	q    <= sub_wire0(11 DOWNTO 0);

	altsyncram_component : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "rainbow_160_12.mif",
		intended_device_family => "CYCLONE V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 32768,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		widthad_a => 15,
		width_a => 12,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => address,
		clock0 => clock,
		q_a => sub_wire0
	);

END SYN;
