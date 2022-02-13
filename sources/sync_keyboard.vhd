-------------------------------------------------------------------------------
-- Title      : sync_keyboard.vhd 
-- Project    : Keyboard VLSI Lab
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Description: 
-- 		        Synchronize keyboard signals to system clock
--
--
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;



entity sync_keyboard is
    port (
	     clk : in std_logic; 
	     kb_clk : in std_logic;
	     kb_data : in std_logic;
	     kb_clk_sync : out std_logic;
	     kb_data_sync : out std_logic
	 );
end sync_keyboard;


architecture sync_keyboard_arch of sync_keyboard is

begin
	process (clk)
	begin 
		if (clk = '1') and (clk'event) then
			kb_clk_sync <= kb_clk;
			kb_data_sync <= kb_data;
		end if;
	end process;

end sync_keyboard_arch;
