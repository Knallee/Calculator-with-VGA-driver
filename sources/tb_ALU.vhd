library ieee;
use ieee.std_logic_1164.all;

entity tb_ALU is
end tb_ALU;

architecture structural of tb_ALU is

   component ALU
   port ( A          : in  std_logic_vector(7 downto 0);
          B          : in  std_logic_vector(7 downto 0);
          FN         : in  std_logic_vector(3 downto 0);
          result     : out std_logic_vector(7 downto 0);
          overflow   : out std_logic;
          sign       : out std_logic
        );
   end component;

   signal A          : std_logic_vector(7 downto 0);
   signal B          : std_logic_vector(7 downto 0);
   signal FN         : std_logic_vector(3 downto 0);
   signal result     : std_logic_vector(7 downto 0);
   signal overflow   : std_logic;
   signal sign       : std_logic;
   
   constant period   : time := 25 ns;

begin  -- structural
   
   DUT: ALU
   port map ( A         => A,
              B         => B,
              FN        => FN,
              result    => result,
              sign      => sign,
              overflow  => overflow
            );
   
   -- *************************
   -- User test data pattern
   -- *************************
   
   A <= "00000101",                    -- A = 5
        "00001001" after 1 * period,   -- A = 9
        "00010001" after 2 * period,   -- A = 17
        "10010001" after 3 * period,   -- A = 145
        "10010001" after 3 * period,   -- A = 145
        "11010101" after 5 * period,   -- A = 213
        "10100011" after 6 * period,   -- A = 35
        "11110010" after 7 * period,   -- A = 242
        "00110001" after 8 * period,   -- A = 49
        "01111111" after 9 * period;   -- A = 127
  
   B <= "00000011",                    -- uB = 3,  
        "00010111" after 1 * period,   -- uB = 3
        "10010101" after 2 * period,   -- uB = 145
        "10110001" after 3 * period,   -- uB = 145
        "10010001" after 3 * period,   -- uB = 145
        "01101001" after 5 * period,   -- uB = 105
        "01110011" after 6 * period,   -- uB = 35
        "01101000" after 7 * period,   -- uB = 104
        "00101101" after 8 * period,   -- uB = 45
        "10001011" after 9 * period;   -- uB = 36
     
   FN <= "1010",                              -- Pass signed A + B
         "1010" after 1 * period,             -- Pass signed A - B
         "1010" after 2 * period,             -- Pass signed A + B
         "1010" after 3 * period,             -- Pass signed A - B
         "1010" after 4 * period,             -- Pass signed A + B
         "1010" after 5 * period,             -- Pass signed A - B  
         "1010" after 6 * period,             -- Pass signed A + B
         "1011" after 7 * period,             -- Pass signed A - B
         "1011" after 8 * period,             -- Pass signed A + B
         "1011" after 9 * period,             -- Pass signed A - B
         "1011" after 10 * period,            -- Pass signed A + B
         "1011" after 11 * period,            -- Pass signed A - B
         "1011" after 12 * period,            -- Pass signed A + B
         "1011" after 13 * period;            -- Pass signed A - B 
                                              
end structural;                           
