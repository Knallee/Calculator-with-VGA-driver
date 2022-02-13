library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.ALU_components_pack.all;


entity ALU_Top1 is
    port (
	     clk        	 : in std_logic;
	     reset      	 : in std_logic;
	     kb_data		 : in std_logic;
	     kb_clk	 		 : in std_logic;
		 BTNL			 : in std_logic;
		 BTNC			 : in std_logic;	 
		 hs  			 : out std_logic;
		 vs  			 : out std_logic;
		 rgb_out 		 : out std_logic_vector (11 downto 0)
	);
end ALU_Top1;

architecture structural of ALU_Top1 is


component clk_wiz_0 is
 port (
  clk_in1   : in std_logic;
  clk_out1  : out std_logic;
  reset     : in std_logic;
  locked    : out std_logic
 );
 end component;


component keyboard_Top2 is
   port ( 
		 clk         : in std_logic;
	     reset       : in std_logic;
		 BTNC        : in std_logic;	     	     
	     kb_data	 : in std_logic;
	     kb_clk	 	 : in std_logic;
		 key_bin	 : out std_logic_vector(7 downto 0);
		 overflow    : out std_logic;
		 valid_out	 : out std_logic;
		 enter		 : out std_logic
        );
end component;

component ALU_Top2 is
   port ( 
		  clk       	: in  std_logic;
          reset     	: in  std_logic;
          enter    		: in  std_logic;
          key_bin     	: in  std_logic_vector(7 downto 0);
          overflow      : in std_logic;
		  valid_key 	: in std_logic;
		  BTNL			: in std_logic;
		  BTNC			: in std_logic;		  
		  A_p 			: out std_logic_vector(29 downto 0);
		  B_p 			: out std_logic_vector(29 downto 0);
		  R_p 			: out std_logic_vector(59 downto 0);
		  OP_p 			: out std_logic_vector(9 downto  0)	
        );
end component;

component vga_ref is
	Port (  clk 		: in  std_logic;
		    rst 		: in  std_logic;
			A 			: in std_logic_vector(29 downto 0);
			B 			: in std_logic_vector(29 downto 0);
			R 			: in std_logic_vector(59 downto 0);
			OP 			: in std_logic_vector(9 downto  0);
		    hs 			: out std_logic;
		    vs 			: out std_logic;
		    rgb_out 	: out std_logic_vector (11 downto 0)
    );
end component;

-- General signals
signal clk_sys	: std_logic; 
signal clk_locked, rst_sys : std_logic;


signal A, B :std_logic_vector(29 downto 0);
signal R	:std_logic_vector(59 downto 0);
signal OP	:std_logic_vector(9 downto  0);
signal key_bin     	    : std_logic_vector(7 downto 0);
signal overflow, enter  : std_logic;
signal valid_key		: std_logic;
signal dB_BTNL, dB_BTNC	: std_logic;



begin

	rst_sys <= reset or (not clk_locked);		-- Release system reset when clock is stable

	Inst_clock_gen:
	clk_wiz_0
	port map (   clk_in1  	=> clk,
				 clk_out1 	=> clk_sys,			-- Don't touch! active high reset
				 reset    	=> reset,		        -- Divided 50MHz input clock
				 locked     => clk_locked
			);

	debouncerBTNC: debouncer
	port map ( 	clk          => clk_sys,		
				reset        => rst_sys,    
				button_in    => BTNC,    
				button_out   => dB_BTNC    
	);
	
	debouncerBTNL: debouncer
	port map ( 	clk          => clk_sys,		
				reset        => rst_sys,    
				button_in    => BTNL,     
				button_out   => dB_BTNL		
	);
	

	keyboard_Top2_inst: keyboard_Top2
	port map ( 	
				clk        	=>  clk_sys,
				reset       =>  rst_sys,
				BTNC        =>  dB_BTNC,
				kb_data	    =>  kb_data,
				kb_clk	 	=>  kb_clk,
				key_bin	    =>  key_bin,
				overflow    =>  overflow,
				valid_out	=>  valid_key,
				enter		=>	enter
	);                      
	
	ALU_Top2_inst: ALU_Top2
	port map ( 	
				clk       			=> clk_sys,
				reset     	    	=> rst_sys,
				enter    			=> enter,
				key_bin     		=> key_bin,
				overflow        	=> overflow,
	            valid_key	    	=> valid_key,
				BTNL				=> dB_BTNL,
				BTNC                => dB_BTNC,
				A_p 			    => A,
				B_p 				=> B,
				R_p 			    => R,
				OP_p 			    => OP
	);                          
	
	vga_ref_inst: vga_ref
	Port map(   clk 		=>	clk_sys,
				rst 	    =>  rst_sys,
				A 		    =>  A,
				B 		    =>  B,
				R 		    =>  R,
				OP 		    =>  OP,
				hs 		    =>  hs,
				vs 		    =>  vs,
				rgb_out 	=>  rgb_out
	);
	
end structural;
