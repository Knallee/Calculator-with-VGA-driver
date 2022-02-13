library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ALU_components_pack.all;
entity ALU is
   port ( A         	: in  std_logic_vector (7 downto 0);   -- Input A
          B         	: in  std_logic_vector (7 downto 0);   -- Input B
          FN        	: in  std_logic_vector (3 downto 0);   -- ALU functions provided by the ALU_Controller (see the lab manual)
		  result 		: out std_logic_vector (15 downto 0);  -- ALU output (unsigned binary)
	      signALU       : out std_logic                        -- '1' if the result is a negative value, '0' otherwise
        );
end ALU;

architecture behavioral of ALU is

-- SIGNAL DEFINITIONS HERE IF NEEDED
signal a_1, a_2, a_3: unsigned (7 downto 0);
signal temp_sApB, temp_sAmB: std_logic_vector (7 downto 0);
-- signal overflow_temp: signed (8 downto 0);

begin

-- Modulo calculation
	-- a_4 <= (unsigned(A xor "11111111") + 1) when ((A(7) = '1') and (FN = s_A_MOD3)) else
					   -- unsigned(A); 
	a_1 <= unsigned("0000" & A(7 downto 4))  +  unsigned(A and "00001111");
    a_2 <= "00" & a_1(7 downto 2)  +  unsigned(std_logic_vector(a_1) and "00000011");
    a_3 <= "00" & a_2(7 downto 2)  +  unsigned(std_logic_vector(a_2) and "00000011");	
------------------------------------------------------------------------------------------------------

	temp_sApB <= std_logic_vector(unsigned(A) + unsigned(B));
	temp_sAmB <= std_logic_vector(unsigned(A) - unsigned(B));
-----------------------------------------------------------------------------------------------------	
	
	comb: process (FN, A , B, a_1, a_2, a_3, temp_sAmB, temp_sApB)
	begin

		signALU <= '0';
		
		case FN is
	
			when A_PLUS_B =>
				
				if unsigned(temp_sApB) < unsigned(A) then
					result <= "00000001" & std_logic_vector(unsigned(A)+unsigned(B));
				else
					result <= "00000000" & std_logic_vector(unsigned(A)+unsigned(B));
				end if;
				-- ===================================================================================
				-- ===================================================================================
			when A_MINUS_B =>
				if (unsigned(A) < unsigned(B)) then
					signALU <= '1';	
					result <= "00000000" & std_logic_vector(unsigned(temp_sAmB xor "11111111") + 1);
				else
					result <= "00000000" & std_logic_vector(unsigned(A) - unsigned(B)); -- we can output U for underflow if needed
				end if;
				
			when A_times_B =>
				result <= std_logic_vector(unsigned(A)*unsigned(B));	
				
			when A_MOD3 =>
				if (a_3 > 2) then
					result <= "00000000" & std_logic_vector(a_3-3);
				else
					result <= "00000000" & std_logic_vector(a_3);
				end if;
				

			when others =>
				result <= (others => '0');
				
		end case;
			
		-- when s_A_PLUS_B =>		
		    -- if ((signed(A) > 0) and (signed(B) > 0)) then
                
                -- if ((signed(A) + signed(B)) < 0) then 
                    -- overflow <= '1';
                -- else
                    -- overflow <= '0';
                -- end if;
            -- end if;
               
		    -- if ((signed(A) < 0) and (signed(B) < 0)) then
                
                -- if ((signed(A) + signed(B)) > 0) then 
                    -- overflow <= '1';
                -- else
                    -- overflow <= '0';
                -- end if;
            -- end if;
			
			-- if (temp_sApB(7) = '1') then
				-- result <= std_logic_vector(unsigned(temp_sApB xor "11111111") + 1);
				-- signALU <= '1';
			-- else 
			    -- result <= temp_sApB; 
			-- end if;
			
--===================================================================================
--===================================================================================
			
		-- when s_A_MINUS_B =>
            -- if ((signed(A) - signed(B) < signed(A)) xor (signed(B) > 0)) then
                -- overflow <= '1';
            -- end if;
						
			-- if (temp_sAmB(7) = '1') then
				-- result <= std_logic_vector(unsigned(temp_sAmB xor "11111111") + 1);
				-- signALU <= '1';
			-- else 
			    -- result <= temp_sAmB; 
			-- end if;
			
			
			
			
			
		-- when s_A_MOD3 =>
              -- if (a_3 > 2) then
                  -- result <= std_logic_vector(a_3-3);
              -- else
                  -- if (A(7) = '1') then                 
                  -- result <= std_logic_vector(3-a_3);
                  -- else
                  -- result <= std_logic_vector(a_3);
                  -- end if;
              -- end if;
			
		
	end process comb;



end behavioral;
