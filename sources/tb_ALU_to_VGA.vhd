library ieee;
use ieee.std_logic_1164.all;

entity tb_ALU_to_VGA is
end tb_ALU_to_VGA;

architecture structural of tb_ALU_to_VGA is

   component ALU_to_VGA
   port (
		 ALU_output : in  std_logic_vector(47 downto 0);
         overflow	: in  std_logic_vector(1 downto  0);
         sign		: in  std_logic;
         A 			: out std_logic_vector(29 downto 0);
         B 			: out std_logic_vector(29 downto 0);
         R 			: out std_logic_vector(59 downto 0);
         operation 	: out std_logic_vector(9 downto  0)
	);
   end component;

   signal ALU_output  	:  std_logic_vector(47 downto 0);
   signal overflow	  	:  std_logic_vector(1 downto  0);
   signal sign		  	:  std_logic;
   signal A 			:  std_logic_vector(29 downto 0); 
   signal B 			:  std_logic_vector(29 downto 0); 
   signal R 			:  std_logic_vector(59 downto 0); 
   signal operation 	:  std_logic_vector(9 downto  0);
   
   constant period   : time := 25 ns;

begin  -- structural
   
   DUT: ALU_to_VGA
   port map ( ALU_output 	 => ALU_output,
              overflow	 	 => overflow,
              sign		 	 => sign ,
              A 			 => A ,
              B 			 => B ,
              R 			 => R ,
              operation 	 => operation 	
			);
   
   -- *************************
   -- User test data pattern
   -- *************************
   
   ALU_output 	<=  "000100000010000000000011000000110011001101111011";                   -- A = 5
		
end structural;                           
