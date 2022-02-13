-------------------------------------------------------------------------------
-- Title      : edge_detector.vhd 
-- Project    : Keyboard VLSI Lab
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Description: 
-- 		        Make sure not to use 'EVENT on anyother signals than clk
-- 		        
--
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


entity edge_detector is
    port (
	     clk : in std_logic;
	     reset : in std_logic;
	     kb_clk_sync : in std_logic;
	     edge_found : out std_logic
	 );
end edge_detector;


architecture edge_detector_arch of edge_detector is

signal kb_clk_sync_old : std_logic  := '0';

begin
	process (clk)
	begin 
		if (clk = '1') and (clk'event) then
			if reset = '1' then
				edge_found  <= '0';
			elsif kb_clk_sync_old > kb_clk_sync then
				edge_found <= '1';
			else
				edge_found <= '0';
			end if;
			kb_clk_sync_old <= kb_clk_sync;
		end if;
	end process;

end edge_detector_arch;
