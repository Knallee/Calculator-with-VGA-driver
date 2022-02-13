library ieee;
use ieee.std_logic_1164.all;

entity tb_binary2BCD is
end tb_binary2BCD;

architecture structural of tb_binary2BCD is

   component  binary2BCD is
   generic ( WIDTH : integer := 8   -- 8 bit binary to BCD
           );
   port (	binary_in 	: in  std_logic_vector(WIDTH-1 downto 0);  -- binary input width
			BCD_out   	: out std_logic_vector(9 downto 0)        -- BCD output, 10 bits [2|4|4] to display a 3 digit BCD value when input has length 8
        );
   end component;

signal binary_in:   std_logic_vector (7 downto 0);
signal BCD_out:   std_logic_vector (9 downto 0);
   
   constant period   : time := 25 ns;

begin  -- structural
   
   DUT: binary2BCD
   port map ( binary_in => binary_in,
			  BCD_out => BCD_out 
            );
   
   -- *************************
   -- User test data pattern
   -- *************************
   
   binary_in <= "00000101",                    -- A = 5
        "00001001" after 1 * period,   -- A = 9
        "00010001" after 2 * period,   -- A = 17
        "10010001" after 3 * period,   -- A = 145
        "10010001" after 3 * period,   -- A = 145
        "11010101" after 5 * period,   -- A = 213
        "10100011" after 6 * period,   -- A = 35
        "11110010" after 7 * period,   -- A = 242
        "00110001" after 8 * period,   -- A = 49
        "01111111" after 9 * period;   -- A = 127
  
                                              
end structural;    