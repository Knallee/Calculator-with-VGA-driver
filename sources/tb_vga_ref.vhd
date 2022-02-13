library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_vga_ref is
end tb_vga_ref;

architecture structural of tb_vga_ref is

	component vga_ref is
    Port ( 	clk 	: in  std_logic;
    top_sim_clk : in std_logic;
		    rst 	: in  std_logic;
		    hs  	: out std_logic;
		    vs  	: out std_logic;
		    rgb_out : out std_logic_vector (11 downto 0)
	);
	end component;
	

	signal rst 		: std_logic;
	signal hs  		: std_logic;
	signal vs  		: std_logic;
	signal rgb_out 	: std_logic_vector (11 downto 0);
	signal clk 		: std_logic := '1';

begin

	DUT:  vga_ref
	port map ( 	clk 	=> clk,
	top_sim_clk        => clk,
				rst 	=> rst,
				hs  	=> hs,
				vs  	=> vs,
				rgb_out => rgb_out
	);
	
	clk 	<= not(clk) after 4 ns; -- f_clk = 50 MHz
	rst 	<= '1', '0' after 200 ns;
end structural; 