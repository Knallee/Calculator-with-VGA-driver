-------------------------------------------------------------------------------
-- Title      : convert_scancode.vhd 
-- Project    : Keyboard VLSI Lab
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Description: 
-- 		        Implement a shift register to convert serial to parallel
-- 		        A counter to flag when the valid code is shifted in
--
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity convert_scancode is
    port (
	     clk : in std_logic;
	     reset : in std_logic;
	     edge_found : in std_logic;
	     serial_data : in std_logic;
	     valid_scan_code : out std_logic;
	     scan_code_out : out unsigned(7 downto 0)
	 );                
end convert_scancode;

architecture convert_scancode_arch of convert_scancode is

signal current_count, next_count: unsigned(3 downto 0);
signal current_parallel_data, next_parallel_data: unsigned(9 downto 0);
signal crnt_out, next_out: unsigned(7 downto 0);
signal crnt_vaild, next_valid : std_logic;

begin
	
	valid_scan_code <= crnt_vaild;
    scan_code_out  	<= crnt_out;

    reg: process (clk)
	begin
	   if (clk = '1') and (clk'Event) then
           if (reset = '1') then
                current_parallel_data 	 <= (others => '0');
                current_count			 <= (others => '0');
                crnt_out 				 <= (others => '0');
				crnt_vaild 				 <= '0';
           else
				current_count 			<= next_count;
                current_parallel_data  	<= next_parallel_data;
                crnt_out				<= next_out;
				crnt_vaild 				<= next_valid;
           end if;
        end if;
   
	end process reg;
	
	comb: process (edge_found, serial_data, current_count, current_parallel_data, crnt_vaild, crnt_out)
	begin
	
		next_parallel_data 	<= current_parallel_data;
		next_out  			<= crnt_out;
	    next_valid 			<= crnt_vaild;
		next_count 			<= current_count;
		
	    if (current_count < 11) then 
			next_valid <= '0';
			if (edge_found = '1') then
			
				next_count 			<= current_count + 1;
				next_parallel_data 	<= serial_data & current_parallel_data(9 downto 1);                
				
			end if;
		else  
		
		    next_valid 		<= '1';
		    next_out 	    <= current_parallel_data(7 downto 0);
		    next_count		<= (others => '0'); 
			
		end if;
		
	end process comb;
   

					
end convert_scancode_arch;
