library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ALU_components_pack.all;

entity ALU_ctrl is
   port ( clk     		: in  std_logic;
          reset   		: in  std_logic;
          enter   		: in  std_logic;
		  key_bin 		: in std_logic_vector (7 downto 0);
		  valid_key		: in std_logic;
		  overflow 		: in std_logic;
		  AopB_in		: in std_logic_vector(23 downto 0);
		  valid_RAM		: in std_logic;
		  BTNC			: in std_logic;
		  BTNL			: in std_logic;
		  word_in		: out std_logic_vector(7 downto 0);
		  totaflow 		: out std_logic_vector (1 downto 0); 
          FN      		: out std_logic_vector (3 downto 0);   -- ALU functions
		  A				: out std_logic_vector (7 downto 0);
		  B				: out std_logic_vector (7 downto 0)
        );
end ALU_ctrl;

architecture behavioral of ALU_ctrl is

type state_type is (sA, sAopB, sB, sRST, sEnter, sE);

signal current_state, next_state 			: state_type;
signal crnt_A, crnt_B, next_A, next_B 		: std_logic_vector (7 downto 0);
signal crnt_FN, next_FN						: std_logic_vector (3 downto 0);
signal crnt_flow, next_flow 				: std_logic_vector (1 downto 0);
signal old_BTNL, old_BTNC					: std_logic;
signal BTNL_edge, BTNC_edge					: std_logic;

begin

	FN	<=	crnt_FN ;
	A	<=  crnt_A  ;
	B	<=  crnt_B  ;
	
	totaflow <= crnt_flow;
	
	reg: process (clk) -- The register process
	begin -- process register
	if (clk'event and clk = '1') then 
		if (reset = '1') then -- asynchronous reset (active high)
			current_state 	<= sRST;
			crnt_A 			<= (others => '0');
			crnt_B 			<= (others => '0');
			crnt_FN 		<= (others => '0');
			crnt_flow		<= (others => '0');
			
			old_BTNL 		<= '0';			
			old_BTNC 		<= '0';
			BTNL_edge 		<= '0';
			BTNC_edge 		<= '0';
			
		else
            current_state 	<= next_state;  
			crnt_A 			<= next_A 	 ;
			crnt_B 			<= next_B 	 ;
			crnt_FN 		<= next_FN   ;
			crnt_flow		<= next_flow ;
			
			if old_BTNL < BTNL then
				BTNL_edge 		<= '1';
			else
				BTNL_edge <= '0';
			end if;
		
			old_BTNL <= BTNL;
			
			if old_BTNC < BTNC then
				BTNC_edge 		<= '1';
			else
				BTNC_edge <= '0';
			end if;
			
			old_BTNC <= BTNC;
			
		end if;
	end if;
	end process reg;

	comb: process (overflow, key_bin, valid_key, enter, BTNC_edge, BTNL_edge, valid_RAM, AopB_in, current_state, crnt_A, crnt_B, crnt_FN, crnt_flow)
	begin
	-- Defaults--------------------------- 
		next_state 	<= current_state;
		next_A 		<= crnt_A  	;
		next_B      <= crnt_B 	;
		next_FN     <= crnt_FN 	;
		next_flow	<= crnt_flow;
	--------------------------------------		
		
		
		case current_state is
		
			when sRST =>
				next_A 		<= (others => '0');
				next_B 		<= (others => '0');
				next_FN		<= "0010";
				word_in		<= (others => '0');
				next_flow   <= "00";
				next_state  <= sA;
			-- ===================================================================================			
			
			when sA =>
			
				word_in		<= crnt_A;
			
				if overflow = '1' then
					next_flow(1) <= '1';
					word_in <= "11111111";
				else
					next_flow(1) <= '0';
				end if;

				if valid_key = '1' then
					next_A <= key_bin;
				end if;
				
				if (BTNC_edge = '1') then

					next_state <= sAopB;
					
				elsif enter = '1' then
				
					next_state <= sEnter;
				
				elsif (BTNL_edge = '1') then

					next_state <= sRST;  			-- WE CAN ADD SYCLING BUT WE NEED BETTER CONTROLLER
				
				end if;
			-- ===================================================================================			
			
			when sAopB =>
				
				word_in	  <= ("1000" & crnt_FN);
				
				next_FN   <= key_bin(3 downto 0);

				if (BTNC_edge = '1') then				
				
					if crnt_FN = "0101" then
						next_state  <= sRST;
						next_B  	<= "00000011";

					else
						next_state <= sB;
					end if;
					
				elsif enter = '1' then
				
					next_state <= sEnter;
					
				elsif (BTNL_edge = '1') then

					next_state <= sA;  			-- WE CAN ADD SYCLING BUT WE NEED BETTER CONTROLLER
				
				end if;
			-- ===================================================================================			
			
			when sB =>
			
				word_in		<= crnt_B;
				
				if overflow = '1' then
					next_flow(0) <= '1';
					word_in <= "11111111";
				else
					next_flow(0) <= '0';
				end if;
				
				if valid_key = '1' then
					next_B <= key_bin;
				end if;
				
				if (BTNC_edge = '1') then	

					next_state <= sRST;
									
				elsif enter = '1' then
				
					next_state <= sEnter;
					
				elsif (BTNL_edge = '1') then

					next_state <= sAopB;  			-- WE CAN ADD SYCLING BUT WE NEED BETTER CONTROLLER
				
				end if;
			-- ===================================================================================							
			
			when sEnter =>
				
				word_in		<= (others => '0');
				
				if valid_key = '1' then
				
					next_state <= sRST;
				
				end if;
				
				if valid_RAM = '1' then
				
					next_A  <= AopB_in(7 downto 0);
					next_B  <= AopB_in(23 downto 16);
					next_FN <= AopB_in(11 downto 8);
				
				end if;
				
			when others =>
				word_in		<= (others => '0');
				next_FN <= "0010";
				next_state <= sRST;
			-- ===================================================================================
			
		end case;
	        
	    
	        
	end process comb;
end behavioral;
            