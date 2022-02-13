----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/09/2015 05:00:14 PM
-- Design Name: 
-- Module Name: BCDtoBi - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.ALU_components_pack.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BCDtoBi is
    Port ( 	key_bcd 		: in unsigned (3 downto 0);
			valid_key 		: in std_logic;
			clk 			: in std_logic;
			reset 			: in std_logic;
			BTNC            : in std_logic;
			key_bin 		: out std_logic_vector (7 downto 0);
			valid_out		: out std_logic;
			overflow        : out std_logic;
			enter			: out std_logic
	);
end BCDtoBi;



architecture Behavioral of BCDtoBi is

signal crnt_shift_register, next_shift_register: unsigned (11 downto 0);
signal extended_bin: std_logic_vector (10 downto 0);
signal next_valid, crnt_valid : std_logic;
signal old_BTNC					: std_logic;
signal BTNC_edge				: std_logic;

begin

extended_bin <= std_logic_vector(("1100100"*crnt_shift_register(11 downto 8)) + ("000" & "1010"*crnt_shift_register(7 downto 4)) + ("0000000" & crnt_shift_register(3 downto 0)));
key_bin 	 <= extended_bin(7 downto 0);
valid_out	 <= crnt_valid;

	reg: process(clk)
	begin
	
	if (clk'event and clk = '1') then
		if (reset = '1') then 
			crnt_shift_register <= (others => '0');
			crnt_valid			<= '0';
			BTNC_edge 		<= '0';
			old_BTNC 		<= '0';
			
		else
			crnt_shift_register <= next_shift_register;
			crnt_valid 			<= next_valid;

                        
            if old_BTNC < BTNC then
                 BTNC_edge <= '1';
            else
                 BTNC_edge <= '0';
            end if;
                        
            old_BTNC <= BTNC;
		end if;
	end if;
	
    end process reg;
	
	comb: process(crnt_shift_register, valid_key, key_bcd, extended_bin, crnt_valid, BTNC_edge)
	begin
		
		next_valid 	<= '0';
		enter 		<= '0';
		
		next_shift_register <= crnt_shift_register;
		
	    if (unsigned(extended_bin) > "11111111" ) then
	       overflow <= '1';
	    else
	       overflow <= '0';
	    end if;
	    
	    if BTNC_edge = '1' then
	       
	       next_shift_register <= (others => '0');
	       
	    end if;
		
		if (valid_key = '1') then
		    if (key_bcd = ENTER_BCD) then
				enter <= '1';
				next_shift_register <= (others => '0');
			
		    elsif (key_bcd = DELETE_BCD) then
				
				next_valid <= '1';
				next_shift_register(11 downto 8)	<= (others => '0');
				next_shift_register(7 downto 4) 	<= crnt_shift_register(11 downto 8);
				next_shift_register(3 downto 0)		<= crnt_shift_register(7 downto 4);
			
			else
			
				next_valid <= '1';
				next_shift_register(11 downto 8)	<= crnt_shift_register(7 downto 4);
				next_shift_register(7 downto 4) 	<= crnt_shift_register(3 downto 0);
				next_shift_register(3 downto 0) 	<= key_bcd;
				
			end if;

		end if;
	end process comb;


end Behavioral;
