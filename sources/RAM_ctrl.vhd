library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity RAM_ctrl is
    Port ( 	clk 			: in 	std_logic;
			rst 			: in 	std_logic;
			BTNL			: in 	std_logic;
			BTNC			: in 	std_logic;
			enter			: in	std_logic;
			word_in			: in	std_logic_vector(7 downto 0);
			from_RAM		: in	std_logic_vector(7 downto 0);
			to_RAM			: out	std_logic_vector(7 downto 0);
			write_en		: out 	std_logic_vector(0 DOWNTO 0);
			addra			: out 	std_logic_vector(15 downto 0);
			AopB_out		: out	std_logic_vector(23 downto 0);
			valid_out		: out	std_logic
	);
end RAM_ctrl;


--###################################
-- A 	~ AopB_out(7 downto 0)		#
-- op 	~ AopB_out(15 downto 8)		#
-- B 	~ AopB_out(23 downto 16)	#
--###################################


architecture Behavioral of RAM_ctrl is



type state_type is (sCount, sLatch, sPop0, sPop1, sPop2, sdPop0, sdPop1, sdPop2);

signal current_state, next_state : state_type;

constant MODULUS3 : std_logic_vector (7 downto 0) := "10000101";

signal crnt_addr, 		next_addr 			: std_logic_vector(15 downto 0);
signal crnt_tout0,		next_tout0			: std_logic_vector(7 downto 0);
signal crnt_tout1,		next_tout1			: std_logic_vector(7 downto 0);
signal crnt_tout2,		next_tout2			: std_logic_vector(7 downto 0);
signal next_en, crnt_en						: std_logic_vector(0 DOWNTO 0);
signal crnt_AopB, next_AopB					: std_logic_vector(23 downto 0);
signal crnt_to_RAM, next_to_RAM 			: std_logic_vector(7 downto 0);
signal theBug								: std_logic;

signal crnt_valid_out,	next_valid_out		: std_logic;
signal crnt_mod,		next_mod			: std_logic;


signal old_BTNL, old_BTNC					: std_logic;
signal BTNL_edge, BTNC_edge					: std_logic;



begin

	AopB_out	<= crnt_AopB;
	valid_out 	<= crnt_valid_out;
	addra 		<= crnt_addr;
	write_en	<= crnt_en;
	to_RAM		<= crnt_to_RAM;
	
	reg: process(clk)
	begin
	
	if (clk'event and clk = '1') then
		
		if (rst = '1') then 
			
			current_state 	<= sCount;
			

			crnt_tout0		<= (others => '0');
			crnt_tout1      <= (others => '0');
			crnt_tout2		<= (others => '0');

			crnt_addr 		<= (others => '0');
			crnt_AopB		<= (others => '0');
			crnt_valid_out  <= '0';
			crnt_en			<= (others => '0');
			crnt_to_RAM		<= (others => '0');
			
			old_BTNL 		<= '0';
			old_BTNC 		<= '0';
			BTNL_edge 		<= '0';
			BTNC_edge 		<= '0';
			
			theBug <= '0';
			
		else
		
			current_state 	<= next_state;

			crnt_tout0		<= next_tout0;
			crnt_tout1		<= next_tout1;
			crnt_tout2		<= next_tout2;
			crnt_mod		<= next_mod;
			
			crnt_AopB		<= next_AopB;
			crnt_en			<= next_en;
			crnt_addr 		<= next_addr;
			crnt_valid_out  <= next_valid_out;
			crnt_to_RAM 	<= next_to_RAM;
			
			
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
	

	
	comb: process(BTNL_edge, BTNC_edge, enter, from_RAM, word_in, crnt_en, crnt_addr, current_state, crnt_AopB, crnt_to_RAM, crnt_mod, crnt_valid_out, crnt_tout0, crnt_tout1, crnt_tout2)
	begin                                                                                                                              
		
		next_state 		<= current_state;
		
		next_AopB		<= crnt_AopB;
		next_en			<= "0";	
		next_to_RAM		<= crnt_to_RAM;
		next_addr 		<= crnt_addr;
		next_valid_out  <= '0';		
		
		next_mod 		<= crnt_mod;

		next_tout0		<= crnt_tout0;	
		next_tout1		<= crnt_tout1;
		next_tout2		<= crnt_tout2;
		
		
		case current_state is
						
			when sCount	=> ----------------------------------------------------------------------------------
				
				next_state 	<= sCount;
				theBug <= '0';
				if (enter = '1') and (crnt_addr >= "0000000000000001") then 

						next_addr 	<= std_logic_vector(unsigned(crnt_addr) - 1);			-- RAM(fetch)
						next_state 	<= sdPop0;					

				elsif (BTNL_edge = '1') and (crnt_addr > "0000000000000000") then
					
						next_addr 	<= std_logic_vector(unsigned(crnt_addr) - 1);
								
				elsif (BTNC_edge = '1') then
										
					next_state 	<= sLatch;
					next_en 	<= "1";
					next_to_RAM <= word_in;
					
					
				end if;
				

			
			when sLatch	=> ----------------------------------------------------------------------------------
				next_state 	<= sCount;
				next_addr 	<= std_logic_vector(unsigned(crnt_addr) + 1);
				
			
			when sdPop0 => 
			
				next_state <= sPop0;
			
			
			when sPop0 	=> ----------------------------------------------------------------------------------
			
				next_tout0 	<= from_RAM;
				next_addr	<= std_logic_vector(unsigned(crnt_addr) - 1);

				next_state <= sdPop1;
			
			
			when sdPop1 =>
				
				next_state <= sPop1;
			
			

			when sPop1 	=> ----------------------------------------------------------------------------------
			
				next_tout1 	<= from_RAM;
				
				if (crnt_tout0 = MODULUS3) then
					next_mod 	<= '1';

				else 
					next_mod 	<= '0';
					next_addr 	<= std_logic_vector(unsigned(crnt_addr) - 1);
				end if;
				
				next_state <= sdPop2;
				
			
			
			when sdPop2 =>
				
				next_state <= sPop2;
			
			
			
			when sPop2 	=> ----------------------------------------------------------------------------------
				
				if (crnt_mod = '1') then
					next_tout2				<= "00000011";
					next_AopB(23 downto 16) <= "00000011";
					next_AopB(15 downto 8) 	<= crnt_tout0;
					next_AopB(7 downto 0)	<= crnt_tout1;
					theBug					<= '1';
					
				elsif(crnt_mod = '0') then 
					next_tout2				<= from_RAM;
					next_AopB(23 downto 16) <= crnt_tout0;
					next_AopB(15 downto 8) 	<= crnt_tout1;
					next_AopB(7 downto 0) 	<= from_RAM;
					
				end if;
				
				next_valid_out <= '1';
				
				next_state <= sCount;
			
			
			when others =>
				null;
			
		end case;
	
	end process comb;


end Behavioral;