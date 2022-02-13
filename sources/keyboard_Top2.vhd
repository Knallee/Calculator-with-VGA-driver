-------------------------------------------------------------------------------
-- Title      : keyboard_top.vhd 
-- Project    : Keyboard VLSI Lab
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Description: 
-- 		Keyboard top level	
-- 		Functionality of all sub-modules are mentioned in manual.
--		All the required interconnects are already done, students have
-- 		to basically fill vhdl code in the sub-modules !!
--		
--
--
--
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


entity keyboard_Top2 is
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
end keyboard_top2;

architecture keyboard_Top2_arch of keyboard_Top2 is


    component edge_detector is
	port (
		 clk 			: in std_logic;
		 reset 			: in std_logic;
		 kb_clk_sync 	: in std_logic;
		 edge_found 	: out std_logic
	);
    end component;

    component sync_keyboard is
	port (
		 clk 			: in std_logic; 
		 kb_clk 		: in std_logic;
		 kb_data 		: in std_logic;
		 kb_clk_sync 	: out std_logic;
		 kb_data_sync 	: out std_logic
	);
    end component;

    component convert_scancode is
	port (
		 clk 				: in std_logic;
		 reset 				: in std_logic;
		 edge_found 		: in std_logic;
		 serial_data 		: in std_logic;
		 valid_scan_code 	: out std_logic;
		 scan_code_out 		: out unsigned(7 downto 0)
	     );
    end component;

    component keyboard_ctrl is
	port (
		 clk 			: in std_logic; 
		 reset 			: in std_logic;
		 valid_code 	: in std_logic;
		 scan_code_in 	: in unsigned(7 downto 0);
		 valid_key 		: out std_logic;
		 key_bcd 		: out unsigned(3 downto 0)
	);
    end component;
	
	component BCDtoBi is
	Port ( 	
		  key_bcd 		: in unsigned (3 downto 0);
		  valid_key 	: in std_logic;
		  clk 			: in std_logic;
		  reset 		: in std_logic;
		  BTNC          : in std_logic;		  
		  key_bin 		: out std_logic_vector (7 downto 0);
		  valid_out		: out std_logic;
		  overflow      : out std_logic;
		  enter			: out std_logic
	);
	end component;

	

	
    signal kb_clk_sync, kb_data_sync 					: std_logic;
    signal edge_found 									: std_logic;
    signal scan_code 									: unsigned(7 downto 0);
    signal valid_scan_code, valid_key               	: std_logic;  -- , not_valid, enter 
    signal key_bcd	 									: unsigned(3 downto 0);
	

begin  

-- syncrhonize all the input signal from keyboard
    sync_keyboard_inst : sync_keyboard
    port map (
		 clk 				=> clk,
		 kb_clk 			=> kb_clk,
		 kb_data 			=> kb_data,
		 kb_clk_sync 		=> kb_clk_sync,
		 kb_data_sync 		=> kb_data_sync
	);

-- detect the falling edge of kb_clk
-- double check if its synthesizable !!
    edge_detector_inst : edge_detector
    port map (
		 clk 			=> clk,
		 reset 			=> reset,
		 kb_clk_sync 	=> kb_clk_sync,
		 edge_found 	=> edge_found
	);


-- basically convert serial kb_data to parallel scan code 
-- make sure not to use edge_found as clock !!! (i.e dont use edge_found'event)
    convert_scancode_inst : convert_scancode
    port map (
		 clk 				=> clk,
		 reset 				=> reset,
		 edge_found 		=> edge_found,
		 serial_data 		=> kb_data_sync,
		 valid_scan_code 	=> valid_scan_code,
		 scan_code_out 		=> scan_code
	);

-- control, implement state machine
    keyboard_ctrl_inst : keyboard_ctrl
    port map (
		 clk 				=> clk,
		 reset 				=> reset,
		 valid_code 		=> valid_scan_code,
		 scan_code_in 		=> scan_code,
		 valid_key 		 	=> valid_key,
		 key_bcd 			=> key_bcd
	);
		 
	BCDtoBi_inst : BCDtoBi
	port map ( 	
		key_bcd 		=> key_bcd,
		valid_key 		=> valid_key,
		clk 			=> clk,
		reset 			=> reset,
		BTNC            => BTNC,
		key_bin 		=> key_bin,
		valid_out		=> valid_out,
		overflow        => overflow,
		enter 			=> enter
	);
		
	-- binary2BCD_inst: binary2BCD
	-- port map  (	binary_in 	  => key_bin,
				-- BCD_out   	  => BCD_out
    -- );	
		
	-- seven_seg_driver_inst: seven_seg_driver
	-- port map  ( clk           => clk,
			  -- reset           => reset,
			  -- BCD_digit       => BCD_out,
			  -- signSeg         => enter,
			  -- overflow        => not_valid,
			  -- DIGIT_ANODE     => DIGIT_ANODE,
			  -- SEGMENT         => SEGMENT
    -- );
		 
	 
		 
end	keyboard_Top2_arch;