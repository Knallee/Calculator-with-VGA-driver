library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ALU_components_pack.all;

entity ALU_Top2 is
   port ( clk       	: in  std_logic;
          reset     	: in  std_logic;
          enter    		: in  std_logic;
          key_bin     	: in  std_logic_vector(7 downto 0);
		  overflow      : in std_logic;
		  valid_key		: in std_logic;
		  BTNL			: in std_logic;
		  BTNC			: in std_logic;
		  A_p 			: out std_logic_vector(29 downto 0);
		  B_p			: out std_logic_vector(29 downto 0);
		  R_p 			: out std_logic_vector(59 downto 0);
		  OP_p 			: out std_logic_vector(9 downto  0)		  
        );
end ALU_Top2;

architecture structural of ALU_Top2 is

   
component ALU_ctrl is
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
		  FN      		: out std_logic_vector (3 downto 0);
		  A				: out std_logic_vector (7 downto 0);
		  B				: out std_logic_vector (7 downto 0) 
        );
end component;
   
component RAM_top is
	port (
		clk 		: in std_logic;
		rst 		: in std_logic;
		BTNL		: in std_logic;
		BTNC		: in std_logic;
		enter		: in std_logic;
		word_in		: in std_logic_vector(7 downto 0);
		AopB_out	: out std_logic_vector(23 downto 0);
		valid_out	: out std_logic
	);
end component; 
   
component ALU is
   port ( A         	: in  std_logic_vector (7 downto 0);   
          B         	: in  std_logic_vector (7 downto 0);   
          FN        	: in  std_logic_vector (3 downto 0);   
		  result 		: out std_logic_vector (15 downto 0);   
	      signALU       : out std_logic                        
        );
end component;
 
component binary2BCD is
	generic ( WIDTH : integer := 8   -- 8 bit binary to BCD
		);
	port (	binary_in 	: in  std_logic_vector(WIDTH-1 downto 0);  -- binary input width
			BCD_out   	: out std_logic_vector(11 downto 0)        -- BCD output, 10 bits [2|4|4] to display a 3 digit BCD value when input has length 8
		);
end component;

component bin2bcd_15bit is
     Port ( binIN 	: in  STD_LOGIC_VECTOR (15 downto 0);
            bcd_out : out STD_LOGIC_VECTOR (19 downto 0)
          );
end component;

component ALU_to_VGA is
	Port ( 	ALU_output 	: in  std_logic_vector(47 downto 0);
			sign		: in  std_logic;
			overflow	: in std_logic_vector (1 downto 0); 
		    A_p 		: out std_logic_vector(29 downto 0);
			B_p 		: out std_logic_vector(29 downto 0);
			R_p 		: out std_logic_vector(59 downto 0);
			OP_p 	    : out std_logic_vector(9 downto  0)
	);
end component;

   -- SIGNAL DEFINITIONS

signal A, B , word_in 	:std_logic_vector (7 downto 0);  
signal R             	:std_logic_vector (15 downto 0);  
signal FN				:std_logic_vector (3 downto 0);
signal ALU_output 		:std_logic_vector(47 downto 0); 
signal sign, valid_RAM  :std_logic;
signal totaflow        	:std_logic_vector (1 downto 0); 
signal AopB 			:std_logic_vector (23 downto 0); 

  
begin
	
--#####################################################################################################################
--#####################################################################################################################
--#####################################################################################################################
--#####################################################################################################################

-- to provide a clean signal out of a bouncy one coming from the push button
-- input(b_Enter) comes from the pushbutton; output(Enter) goes to the FSM 
	ALU_output(23 downto 20) <= FN;
	
	
	ALU_ctrl_inst: ALU_ctrl
	port map ( 	clk     	=> clk  ,	
				reset   	=> reset  ,	
				enter   	=> enter  ,
				key_bin 	=> key_bin  ,	
				valid_key	=> valid_key  ,
				overflow 	=> overflow   ,
				AopB_in		=> AopB,
				valid_RAM	=> valid_RAM,
				BTNC		=> BTNC,
				BTNL		=> BTNL,
				word_in		=>  word_in,
				totaflow   	=> totaflow  ,
				FN      	=> FN  ,	
				A			=> A  ,	
				B	        => B 
	);
	
	ALU_inst: ALU
	port map ( 	A         	  	=> 	A,						
				B         	  	=>  B,                   	
				FN        	  	=>  FN,                     
				result 			=>  R,                 
				signALU       	=> 	sign				
	);
	
	RAM_top_inst: RAM_top
	port map (
		clk 		=>	clk,
		rst 	    =>  reset,
		BTNL	    =>  BTNL,
		BTNC	    =>  BTNC,
		enter	    =>  enter,
		word_in	    =>  word_in,
		AopB_out    =>  AopB,
		valid_out   =>  valid_RAM
	);              
	
	
	binary2BCD_A: binary2BCD
	port map (	binary_in 	=> A,			-- binary input width
				BCD_out   	=> ALU_output(47 downto 36)       	-- BCD output, 10 bits [2|4|4] to display a 3 digit BCD value when input has length 8
	);
	
	binary2BCD_B: binary2BCD
	port map (	binary_in 	=> B,			-- binary input width
				BCD_out   	=> ALU_output(35 downto 24)       	-- BCD output, 10 bits [2|4|4] to display a 3 digit BCD value when input has length 8
	);
	
	bin2bcd_15bit_inst: bin2bcd_15bit
	port map (	binIN 		=> R(15 downto 0),			
				bcd_out 	=> ALU_output(19 downto 0)
	);

	ALU_to_VGA_inst: ALU_to_VGA
	Port map( 	ALU_output 		=> ALU_output,
				sign			=> sign,
				overflow		=> totaflow,
				A_p 			=> A_p,
				B_p 			=> B_p,
				R_p 			=> R_p,
				OP_p 			=> OP_p
	);
	


end structural;
