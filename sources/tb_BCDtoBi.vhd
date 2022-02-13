library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_BCDtoBi is
end tb_BCDtoBi;

architecture structural of tb_BCDtoBi is


	component BCDtoBi is
    Port ( 	key_bcd 		: in unsigned (3 downto 0);
			valid_key 		: in std_logic;
			clk 			: in std_logic;
			reset 			: in std_logic;
			keys_bin 		: out std_logic_vector (7 downto 0)
	);
	end component;
	
	signal key_bcd 		: unsigned (3 downto 0);
	signal valid_key 	: std_logic := '0';
	signal clk 			: std_logic := '1';
	signal sys_reset	: std_logic;
	signal keys_bin 	: std_logic_vector (7 downto 0);

	constant period   : time := 2500 ns;

constant ENTER_BCD		: unsigned(3 downto 0) := "1010";
constant DELETE_BCD		: unsigned(3 downto 0) := "1011";
	
signal crnt_count, 		next_count		: integer range 0 to 20;  --initializing count to zero.
signal crnt_overflow, 	next_overflow 	: integer range 0 to 20;
--signal count : unsigned(3 downto 0) := "0000";

begin



	DUT:  BCDtoBi
	port map ( 	key_bcd 	=> key_bcd,    
				valid_key  	=> valid_key, 
				clk 		=> clk,  
				reset 	  	=> sys_reset,   
				keys_bin  	=> keys_bin     
	);
				
	clk <= not(clk) after 250 ns;
	sys_reset <= '1', '0' after 2500 ns;
	
	reg: process(clk)
	begin
		if (clk'event and clk = '1') then
			if (sys_reset = '1') then 
				crnt_count   	<= 0;
				crnt_overflow  	<= 0;
			else 
				crnt_count   	<= next_count;
				crnt_overflow  	<= next_overflow;
			end if;
		end if;
	end process reg;

comb: process(crnt_count, crnt_overflow, sys_reset)

	begin  -- structural
		
		next_count <= crnt_count + 1;
		
		if (crnt_count < 1 and sys_reset = '0') then
			valid_key <= '1';
		else 
			valid_key <= '0';
		end if;

		
		case crnt_overflow is
			when 0 =>
				key_bcd <= "0001";
			when 1 =>
				key_bcd <= "0001";
			when 2 =>
				key_bcd <= "0011";
			when 3 =>
				key_bcd <= "0011";
			when 4 =>
				key_bcd <= DELETE_BCD;
			when 5 =>
				key_bcd <= DELETE_BCD;
			when 6 =>       
				key_bcd <= DELETE_BCD;
			when 7 =>       
				key_bcd <= "0010";
			when 8 =>       
				key_bcd <= DELETE_BCD;
			when 9 =>       
				key_bcd <= ENTER_BCD;
			when 10 =>
				key_bcd <= "0001";
			when others => 
			end case;
	
		if (crnt_count = 20) then
			next_overflow <= crnt_overflow + 1;
			next_count <= 0;
		end if;
		if (crnt_overflow = 20) then
			next_overflow <= 0;
		end if;
	
	end process comb;


end structural; 