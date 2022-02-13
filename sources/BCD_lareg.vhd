library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity bin2bcd_15bit is
    Port ( binIN : in  STD_LOGIC_VECTOR (15 downto 0);
           bcd_out : out STD_LOGIC_VECTOR (19 downto 0)
          );
end bin2bcd_15bit;

architecture Behavioral of bin2bcd_15bit is

begin

bcd1: process(binIN)

  -- temporary variable
  variable temp : STD_LOGIC_VECTOR (15 downto 0);
  
  -- variable to store the output BCD number

  variable bcd : UNSIGNED (19 downto 0) := (others => '0');

  -- by
  -- https://en.wikipedia.org/wiki/Double_dabble
  
  begin
    -- zero the bcd variable
    bcd := (others => '0');
    
    -- read input into temp variable
    temp(15 downto 0) := binIN;
    
    -- cycle 15 times as we have 15 input bits
    -- this could be optimized, we dont need to check and add 3 for the 
    -- first 3 iterations as the number can never be >4
    for i in 0 to 15 loop
    
      if bcd(3 downto 0) > 4 then 
        bcd(3 downto 0) := bcd(3 downto 0) + 3;
      end if;
      
      if bcd(7 downto 4) > 4 then 
        bcd(7 downto 4) := bcd(7 downto 4) + 3;
      end if;
    
      if bcd(11 downto 8) > 4 then  
        bcd(11 downto 8) := bcd(11 downto 8) + 3;
      end if;
    
	  if bcd(15 downto 12) > 4 then  
        bcd(15 downto 12) := bcd(15 downto 12) + 3;
      end if;
	  
	  if bcd(19 downto 16) > 4 then  
        bcd(19 downto 16) := bcd(19 downto 16) + 3;
      end if;
    
      -- shift bcd left by 1 bit, copy MSB of temp into LSB of bcd
      bcd := bcd(18 downto 0) & temp(15);
    
      -- shift temp left by 1 bit
      temp := temp(14 downto 0) & '0';
    
    end loop;
 
    -- set outputs
    bcd_out  <= STD_LOGIC_VECTOR(bcd(19 downto 0));
  
  end process bcd1;            
  
end Behavioral;