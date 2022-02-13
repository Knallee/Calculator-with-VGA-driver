library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity RAM_top is
	port (
		clk 		: in std_logic;
		rst 		: in std_logic;
		BTNL		: in std_logic;
		BTNC		: in std_logic;
		enter		: in std_logic;
		word_in		: in std_logic_vector(7 downto 0);
		AopB_out	: out std_logic_vector(23 downto 0);
		valid_out	: out std_logic
	);
end RAM_top;

architecture structural of RAM_top is

component RAM_ctrl is
    port ( 	clk 			: in 	std_logic;
			rst 			: in 	std_logic;
			BTNL			: in 	std_logic;
			BTNC			: in 	std_logic;
			enter			: in	std_logic;
			word_in			: in	std_logic_vector(7 downto 0);
			from_RAM		: in	std_logic_vector(7 downto 0);
			to_RAM			: out	std_logic_vector(7 downto 0);
			write_en		: out 	std_logic_vector(0 DOWNTO 0);
			addra			: out 	std_logic_vector(15 downto 0);
			AopB_out		: out	std_logic_vector(23 downto 0);
			valid_out		: out	std_logic
	);
end component;



component myRAM is
  port (
    clka 	: in std_logic;
    wea 	: in std_logic_vector(0 downto 0);
    addra 	: in std_logic_vector(15 downto 0);
    dina 	: in std_logic_vector(7 downto 0);
    douta 	: out std_logic_vector(7 downto 0)
  );
end component;

signal s_to_RAM		:std_logic_vector(7 downto 0);
signal s_write_en	: std_logic_vector(0 downto 0);
signal s_addra		: std_logic_vector(15 downto 0);
signal s_from_RAM	: std_logic_vector(7 downto 0);



begin
	
	RAM_ctrl_inst: RAM_ctrl
	port map ( 	clk 			=> clk,
				rst 			=> rst,
				BTNL			=> BTNL,
				BTNC			=> BTNC,
				enter			=> enter,
				word_in			=> word_in,
				from_RAM		=> s_from_RAM,
				to_RAM			=> s_to_RAM,
				write_en		=> s_write_en,
				addra			=> s_addra,
				AopB_out		=> AopB_out,
				valid_out		=> valid_out
	);
	
	myRAM_inst: myRAM
	port map (
		clka 	=> clk,
		wea 	=> s_write_en,
		addra 	=> s_addra,
		dina 	=> s_to_RAM,
		douta 	=> s_from_RAM
  );


end structural;