-------------------------------------------------------------------------------
-- Title      : keyboard_ctrl.vhd 
-- Project    : Keyboard VLSI Lab
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Description: 
-- 		        controller to handle the scan codes 
-- 		        
--
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


entity keyboard_ctrl is
    port (
	     clk 			: in std_logic; 
	     reset 			: in std_logic;
	     valid_code 	: in std_logic;
	     scan_code_in 	: in unsigned(7 downto 0);
		 valid_key 		: out std_logic;
	     key_bcd 		: out unsigned(3 downto 0)
	 );
end keyboard_ctrl;

architecture keyboard_ctrl_arch of keyboard_ctrl is
        
	type state_type is (sI, sOut, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, sE, sEnter, sDelete);
	
-- Registers ===================================================================================
	signal current_state, next_state 	: state_type;
	signal crnt_key_bcd, next_key_bcd	: unsigned(3 downto 0):= "0000";

-- =============================================================================================

	
	
begin
	
	key_bcd 		<= crnt_key_bcd;
	
	reg: process (clk) -- The register process
	begin -- process register
	if (clk'event and clk = '1') then 
		if (reset = '1') then -- asynchronous reset (active high)
		
			current_state 	<= sI;
            crnt_key_bcd 	<= (others => '0');

		else
		
            current_state 	<= next_state;
            crnt_key_bcd	<= next_key_bcd;  

		end if;
	end if;
	end process reg;
	
	
	-- Make Code
	-- 0	|   0x45	|	01000101
	-- 1 	| 	0x16	| 	00010110
	-- 2 	|   0x1E    | 	00011110
	-- 3 	|   0x26    |	00100110
	-- 4 	|   0x25    |	00100101
	-- 5 	|   0x2E    |	00101110
	-- 6 	|   0x36    |	00110110
	-- 7 	|   0x3D    |	00111101
	-- 8 	|   0x3E    |	00111110
	-- 9 	|   0x46    |   01000110
	
	-- Break Code
	-- 0	|   0xF0 0x45	|	11110000 01000101
	-- 1 	| 	0xF0 0x16 	| 	11110000 00010110
	-- 2 	|   0xF0 0x1E   | 	11110000 00011110
	-- 3 	|   0xF0 0x26   |	11110000 00100110
	-- 4 	|   0xF0 0x25   |	11110000 00100101
	-- 5 	|   0xF0 0x2E   |	11110000 00101110
	-- 6 	|   0xF0 0x36   |	11110000 00110110
	-- 7 	|   0xF0 0x3D   |	11110000 00111101
	-- 8 	|   0xF0 0x3E   |	11110000 00111110
	-- 9 	|   0xF0 0x46   |   11110000 01000110
	

	
	comb: process (valid_code, scan_code_in, current_state, crnt_key_bcd)
	begin
		
		
	    valid_key 		<= '0';
		next_state 		<= current_state;
		next_key_bcd	<= crnt_key_bcd;
		
        if (valid_code = '1') then
		
			
			
                case current_state is
								
                when sI =>
									
                    if (scan_code_in = "01000101") then
					
                        next_state <= s0;
                    
                    elsif (scan_code_in = "00010110") then
					
                        next_state <= s1;
                    
                    elsif (scan_code_in = "00011110") then
					
                        next_state <= s2;
                    
                    elsif (scan_code_in = "00100110") then
					
                        next_state <= s3;
                    
                    elsif (scan_code_in = "00100101") then
					
                        next_state <= s4;
                    
                    elsif (scan_code_in = "00101110") then
					
                        next_state <= s5;
                    
                    elsif (scan_code_in = "00110110") then
					
                        next_state <= s6;
                    
                    elsif (scan_code_in = "00111101") then
					
                        next_state <= s7;
                    
                    elsif (scan_code_in = "00111110") then
					
                        next_state <= s8;
                    
                    elsif (scan_code_in = "01000110") then
					
                        next_state <= s9;
						
					elsif (scan_code_in = "01011010") then
					
						next_state <= sEnter;
						
					elsif (scan_code_in = "01100110") then
					
						next_state <= sDelete;

                    else 
					
                        next_state <= sE;
						
                    end if;
            
			
                when s0 =>
                    if (scan_code_in = "11110000") then
						next_key_bcd 	<= "0000";
                        next_state  <= sOut;	
						
                    else
						
                        next_state 		<= s0;
						
                    end if;
                    
					
                when s1 =>
                    if (scan_code_in = "11110000") then
						next_key_bcd 	<= "0001";
                        next_state  <= sOut;
						
                    else 
						
                        next_state 		<= s1;
						
                    end if;
                    
					
                when s2 =>
                    if (scan_code_in = "11110000") then
						next_key_bcd 	<= "0010";
                        next_state  <= sOut;
						
                    else 
						
                        next_state 		<= s2;
						
                    end if;
                    
					
                when s3 =>
                    if (scan_code_in = "11110000") then

                        next_state  <= sOut;
						next_key_bcd 	<= "0011";
                    else 
						
                        next_state 		<= s3;
						
                    end if;
                    
					
                when s4 =>
                    if (scan_code_in = "11110000") then

                        next_state  <= sOut;
						next_key_bcd 	<= "0100";
                    else 
						
                        next_state 		<= s4;
						
                    end if;
                    
					
                when s5 =>
                    if (scan_code_in = "11110000") then

                        next_state  <= sOut;
						next_key_bcd <= "0101";
                    else 
						
                        next_state <= s5;
						
                    end if;
                    
					
                when s6 =>
                    if (scan_code_in = "11110000") then

                        next_state  	<= sOut;
						next_key_bcd <= "0110";
                    else 
						
                        next_state 		<= s6;
						
                    end if;
                    
					
                when s7 =>
                    if (scan_code_in = "11110000") then

                        next_state  	<= sOut;
						next_key_bcd 	<= "0111";
                    else 
						
                        next_state 		<= s7;
						
                    end if;
                    
					
                when s8 =>
                    if (scan_code_in = "11110000") then

                        next_state 		<= sOut;
						next_key_bcd 	<= "1000";
                    else 
						
                        next_state 		<= s8;
						
                    end if;
                    
					
                when s9 =>
                    if (scan_code_in = "11110000") then

                        next_state  	<= sOut;
						next_key_bcd 	<= "1001";
                    else 
						
                        next_state 		<= s9;
						
                    end if;
					
					
				when sEnter =>
                    if (scan_code_in = "11110000") then

                        next_state  	<= sOut;
						next_key_bcd 	<= "1010";
                    else 
						
                        next_state 		<= sEnter;
				end if;
				
				
				when sDelete =>
                    if (scan_code_in = "11110000") then

                        next_state  	<= sOut;
						next_key_bcd 	<= "1011";
                    else 
					
                        next_state 		<= sDelete;
						
				end if;
                
				
                when sOut =>
				
					next_state 		<= sI;
					valid_key 		<= '1';

                
                when sE =>
                    if (scan_code_in = "11110000") then

                        next_state  	<= sOut;
						next_key_bcd <= "1100";
                    else 
					
						
                        next_state 		<= sE;
						
                    end if;

                    
                when others => 
					next_key_bcd <= "1100";
                    next_state  	<= sI;		
					
                end case;			
			
        end if;

	end process comb;

end keyboard_ctrl_arch;
