library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_RAM_ctrl is
end tb_RAM_ctrl;

architecture structural of tb_RAM_ctrl is

	component RAM_ctrl is
		Port ( 	clk 			: in 	std_logic;
				rst 			: in 	std_logic;
				BTNL			: in 	std_logic;
				BTNC			: in 	std_logic;
				switch			: in 	std_logic;
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





-- signals

signal clk			: std_logic := '0';
signal rst      	: std_logic := '0';
signal BTNL	    	: std_logic	:= '0';
signal BTNC	    	: std_logic	:= '0';
signal switch		: std_logic	:= '0';
signal enter    	: std_logic	:= '0';
signal valid_out	: std_logic	:= '0';

signal word_in		: std_logic_vector(7 downto 0)	:= (others => '0');
signal from_RAM		: std_logic_vector(7 downto 0)	:= (others => '0');
signal to_RAM		: std_logic_vector(7 downto 0)	:= (others => '0');
signal write_en		: std_logic_vector(0 DOWNTO 0)	:= (others => '0');
signal addra		: std_logic_vector(15 downto 0)	:= (others => '0');
signal AopB_out		: std_logic_vector(23 downto 0)	:= (others => '0');


signal crnt_count, 		next_count		: integer range 0 to 20;
signal crnt_overflow, 	next_overflow 	: integer range 0 to 10;


begin


-- Device Under Test
	
	DUT: RAM_ctrl
	port map ( 	clk 			=> clk,
				rst 			=> rst,
                BTNL			=> BTNL,
                BTNC			=> BTNC,
				switch			=> switch,
				enter			=> enter,
				word_in			=> word_in,
				from_RAM		=> from_RAM,
				to_RAM			=> to_RAM,
				write_en		=> write_en,
				addra			=> addra,
				AopB_out		=> AopB_out,
				valid_out		=> valid_out                
	);
	
	clk 	<= not(clk) 	after 250 ns;
	rst 	<= '1', '0' 	after 2500 ns;

	
	
	
	reg: process(clk,rst)
	begin
		
if (clk'event and clk = '1') then
    		if (rst = '1') then 
    			crnt_count   	<= 0;
    			crnt_overflow  	<= 0;
    		else 
    			crnt_count   	<= next_count;
    			crnt_overflow  	<= next_overflow;
    
    		end if;
    	end if;
    end process reg;
    
    comb: process(crnt_count, crnt_overflow, rst)
    
    	begin  -- structural
    		
    		next_count <= crnt_count + 1;
    		
			if (rst = '0') then
				if ((crnt_count = 2) or (crnt_count = 6) or (crnt_count = 10)) then
					BTNL <= '1';
				else 
					BTNL <= '0';
				end if;
			end if;
		
-- BTNL
		
			if ((crnt_count = 15)) then
					enter <= '1';
				else 
					enter <= '0';
			end if;
			
-- SWITCH			
			if ((crnt_overflow < 5)) then
					switch <= '0';
				else 
					switch <= '0';
			end if;
			
			
-- ENTER			
			if ((crnt_count = 4) or (crnt_count = 8) or (crnt_count = 12)) then
					BTNC <= '1';
				else 
					BTNC <= '0';
			end if;
			
			case crnt_count is
			
    			when 0 =>
					from_RAM <= (others => '0');
    			when 1 =>
					from_RAM <= (others => '0');
    			when 2 =>
					from_RAM <= (others => '0');
    			when 3 =>
					from_RAM <= "00000111";
    			when 4 =>
					
				when 5 =>

    			when 6 =>

    			when 7 => 
					from_RAM <= "10000111";
    			when 8 =>
					
    			when 9 =>			
					
    			when 10 =>
					
				when 11 =>
					from_RAM <= "01000111";
    			when 12 =>
					
    			when 13 =>
					
    			when 14 =>
					
    			when 15 =>
					
    			when 16 =>
					
    			when 17 =>
					
    			when 18 => 
					
    			when 19 =>
					
    			when 20 =>			
					

    			when others => 
    		end case;
    	
    	
    		

    			
    			
    	
    		if (crnt_count = 20) then
    			next_overflow <= crnt_overflow + 1;
    			next_count <= 0;
    		end if;
    		if (crnt_overflow = 10) then
    			next_overflow <= 0;
    		end if;
    	
    end process comb;

end structural;