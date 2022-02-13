library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_to_VGA is
	Port ( 	ALU_output 	: in  std_logic_vector(47 downto 0);
			sign		: in  std_logic;
			overflow	: in std_logic_vector (1 downto 0); 
		    A_p 			: out std_logic_vector(29 downto 0);
			B_p 			: out std_logic_vector(29 downto 0);
			R_p 			: out std_logic_vector(59 downto 0);
			OP_p 			: out std_logic_vector(9 downto  0)
	);
end ALU_to_VGA;

architecture struct of ALU_to_VGA is


constant pointer_zero	: std_logic_vector (9 downto 0) 	:= "0000000000";
constant pointer_one	: std_logic_vector (9 downto 0)  	:= "0000100100";
constant pointer_two    : std_logic_vector (9 downto 0)  	:= "0001001000";
constant pointer_three  : std_logic_vector (9 downto 0)  	:= "0001101100";
constant pointer_four   : std_logic_vector (9 downto 0)  	:= "0010010000";
constant pointer_five   : std_logic_vector (9 downto 0)  	:= "0010110100";
constant pointer_six    : std_logic_vector (9 downto 0)  	:= "0011011000";
constant pointer_seven  : std_logic_vector (9 downto 0)  	:= "0011111100";
constant pointer_eight  : std_logic_vector (9 downto 0)  	:= "0100100000";
constant pointer_nine   : std_logic_vector (9 downto 0)  	:= "0101000100";
constant pointer_plus	: std_logic_vector (9 downto 0) 	:= "0101101000";
constant pointer_minus  : std_logic_vector (9 downto 0)  	:= "0110001100";
constant pointer_times  : std_logic_vector (9 downto 0)  	:= "0110110000";
constant pointer_modulo : std_logic_vector (9 downto 0)  	:= "0111010100";
constant pointer_equal  : std_logic_vector (9 downto 0)  	:= "0111111000";
constant pointer_point  : std_logic_vector (9 downto 0)  	:= "1000011100";
constant pointer_root   : std_logic_vector (9 downto 0)  	:= "1001000000";


begin


	comb : process(ALU_output, sign, overflow)
	begin
		
		if overflow = "10" then
		
			A_p(29 downto 20) <= pointer_times;
		    A_p(19 downto 10) <= pointer_times;
			A_p( 9 downto 0 ) <= pointer_times;
			
			B_p(29 downto 20) <= std_logic_vector("100100"*unsigned(ALU_output(35 downto 32)));
			B_p(19 downto 10) <= std_logic_vector("100100"*unsigned(ALU_output(31 downto 28)));
			B_p( 9 downto 0 ) <= std_logic_vector("100100"*unsigned(ALU_output(27 downto 24)));
			

		elsif overflow = "01" then
		
			B_p(29 downto 20) <= pointer_times;
		    B_p(19 downto 10) <= pointer_times;
		    B_p( 9 downto 0 ) <= pointer_times;
			
			A_p(29 downto 20) <= std_logic_vector("100100"*unsigned(ALU_output(47 downto 44)));			
			A_p(19 downto 10) <= std_logic_vector("100100"*unsigned(ALU_output(43 downto 40)));			
			A_p( 9 downto 0 ) <= std_logic_vector("100100"*unsigned(ALU_output(39 downto 36)));			
			
			

		elsif overflow = "11" then
		
			A_p(29 downto 20) <= pointer_times;
			A_p(19 downto 10) <= pointer_times;
			A_p( 9 downto 0 ) <= pointer_times;
			
			B_p(29 downto 20) <= pointer_times;
			B_p(19 downto 10) <= pointer_times;
			B_p( 9 downto 0 ) <= pointer_times;
			
		
		else
		
			A_p(29 downto 20) <= std_logic_vector("100100"*unsigned(ALU_output(47 downto 44)));
			A_p(19 downto 10) <= std_logic_vector("100100"*unsigned(ALU_output(43 downto 40)));
			A_p( 9 downto 0 ) <= std_logic_vector("100100"*unsigned(ALU_output(39 downto 36)));
		
			B_p(29 downto 20) <= std_logic_vector("100100"*unsigned(ALU_output(35 downto 32)));
			B_p(19 downto 10) <= std_logic_vector("100100"*unsigned(ALU_output(31 downto 28)));
			B_p( 9 downto 0 ) <= std_logic_vector("100100"*unsigned(ALU_output(27 downto 24)));		
		
		end if;
		
		R_p(49 downto 40) <= std_logic_vector("100100"*unsigned(ALU_output(19 downto 16)));
		R_p(39 downto 30) <= std_logic_vector("100100"*unsigned(ALU_output(15 downto 12)));
		R_p(29 downto 20) <= std_logic_vector("100100"*unsigned(ALU_output(11 downto  8)));
		R_p(19 downto 10) <= std_logic_vector("100100"*unsigned(ALU_output(7  downto  4)));
		R_p( 9 downto 0 ) <= std_logic_vector("100100"*unsigned(ALU_output(3  downto  0)));
	
	
		case ALU_output(23 downto 20) is
		
			when "0010" =>
				OP_p <= pointer_plus;
				
			when "0011" =>
				OP_p <= pointer_minus;
				
			when "0100" =>
				OP_p <= pointer_times;
				
			when "0101" =>
				OP_p <= pointer_modulo;

			when "0110" =>
				OP_p <= pointer_root;
				
			when others =>
				OP_p <= pointer_plus;

		end case;
		
		if sign = '1' then
			R_p(59 downto 50) <= pointer_minus;
		else
			R_p(59 downto 50) <= pointer_plus;
		end if;
	
	end process comb;
	
end struct;