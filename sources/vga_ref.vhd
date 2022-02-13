library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.vga_ref_pack.all;

entity vga_ref is
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
end vga_ref;

architecture Behavioral of vga_ref is

--component clk_wiz_0 is
-- port (
--  clk_in1   : in std_logic;
--  clk_out1  : out std_logic;
--  reset     : in std_logic;
--  locked    : out std_logic
-- );
-- end component;

	
component vga_controller_640_60 is
     port ( rst       : in  std_logic; 
            pixel_clk : in  std_logic; 
            HS        : out std_logic; 
            VS        : out std_logic; 
            blank     : out std_logic; 
            hcount    : out std_logic_vector(10 downto 0); 
            vcount    : out std_logic_vector(10 downto 0)
		  );
   end component;

component romCow is
	port ( addra      : in  std_logic_vector(15 downto 0);
		   clka       : in  std_logic;
		   douta	  : out std_logic_vector(2 downto 0)
	 	  );
   end component;

-- General signals
--signal clk_sys	: std_logic; 
--signal clk_locked, rst_sys : std_logic;

-- VGA module
signal blank : std_logic;
signal hcount,vcount : std_logic_vector(10 downto 0);

-- Picture ROM
signal crnt_rom_addr, next_rom_addr, rom_addr : std_logic_vector(15 downto 0);
signal rom_dout : std_logic_vector(2 downto 0);

signal r_out    : std_logic_vector(3 downto 0);
signal g_out    : std_logic_vector(3 downto 0);
signal b_out    : std_logic_vector(3 downto 0);

signal rgb              : std_logic_vector(2 downto 0);

--input registers--
signal crnt_A, next_A, crnt_B, next_B 	: std_logic_vector(29 downto 0);
signal crnt_operation, next_operation	: std_logic_vector(9 downto 0);
signal crnt_R, next_R					: std_logic_vector (59 downto 0);

constant digit_width	: std_logic_vector (9 downto 0)     := "0000100011";


--pointers to each digit in our ROM
constant pointer_zero	: std_logic_vector (9 downto 0) 	:= "0000000000";
constant pointer_one	: std_logic_vector (9 downto 0)  	:= "0000100100";
constant pointer_two    : std_logic_vector (9 downto 0)  	:= "0001001000";
constant pointer_three  : std_logic_vector (9 downto 0)  	:= "0001101100";
constant pointer_four   : std_logic_vector (9 downto 0)  	:= "0010010000";
constant pointer_five   : std_logic_vector (9 downto 0)  	:= "0010110100";
constant pointer_six    : std_logic_vector (9 downto 0)  	:= "0011011000";
constant pointer_seven  : std_logic_vector (9 downto 0)  	:= "0011111100";
constant pointer_eight  : std_logic_vector (9 downto 0)  	:= "0100100000";
constant pointer_nine   : std_logic_vector (9 downto 0)  	:= "0101000100";
constant pointer_plus	: std_logic_vector (9 downto 0) 	:= "0101101000";
constant pointer_minus  : std_logic_vector (9 downto 0)  	:= "0110001100";
constant pointer_times  : std_logic_vector (9 downto 0)  	:= "0110110000";
constant pointer_modulo : std_logic_vector (9 downto 0)  	:= "0111010100";
constant pointer_equal  : std_logic_vector (9 downto 0)  	:= "0111111000";
constant pointer_point  : std_logic_vector (9 downto 0)  	:= "1000011100";
constant pointer_root   : std_logic_vector (9 downto 0)  	:= "1001000000";
	
	
	
begin

--	rst_sys <= rst or (not clk_locked);		-- Release system reset when clock is stable
	
	
	-- Replicate the r g and b signals for nexys 4 board
	rgb_out(11 downto 8) <= r_out;
	rgb_out(7 downto 4)  <= g_out;
	rgb_out(3 downto 0)  <= b_out;
	
	r_out <= rgb(2) & rgb(2) & rgb (2) & rgb(2);
	g_out <= rgb(1) & rgb(1) & rgb (1) & rgb(1);
	b_out <= rgb(0) & rgb(0) & rgb (0) & rgb(0);
	
	rom_addr <= crnt_rom_addr;

	
--	Inst_clock_gen:
--	clk_wiz_0
--	port map (   clk_in1  	=> clk,
--				 clk_out1 	=> clk_sys,			-- Don't touch! active high reset
--				 reset    	=> rst,		        -- Divided 50MHz input clock
--				 locked     => clk_locked
--			);

	vgactrl640_60:
	vga_controller_640_60
	port map ( pixel_clk 	=> clk,
              rst			=> rst,
              blank			=> blank,
              hcount		=> hcount,
              hs			=> hs,
              vcount		=> vcount,
              vs			=> vs
			);
				
	picture_rom:
	romCow
	port map ( clka  => clk,
	           addra => rom_addr,
	           douta => rom_dout);	
	
	
	
	reg: process(clk)
	begin
		if (clk'event and clk = '1') then
			if rst = RESET_SYSTEM then
				crnt_rom_addr 	<= (others => '0');
				crnt_A 			<= (others => '0');
				crnt_B 			<= (others => '0');
				crnt_R 			<= (others => '0');
				crnt_operation 	<= pointer_plus;
				
			else
				crnt_rom_addr 	<= next_rom_addr;
				crnt_A 			<= next_A;
				crnt_B 			<= next_B;
				crnt_R 			<= next_R;
				crnt_operation 	<= next_operation;
			end if;
		end if;	
	end process reg;
	
	
	
	
	-- WE NEED INPUT A, B, R, OPERATION, VALID, OVERFLOW, SIGN
	
	comb: process (crnt_rom_addr, crnt_A, crnt_B, crnt_R, crnt_operation,  blank, vcount, hcount, rom_dout, A, B, R, OP)
	begin
	    next_rom_addr 	<= crnt_rom_addr;
		next_A 			<= A;
		next_B 			<= B;
		next_R 			<= R;
		next_operation 	<= OP;
		
		-- WE NEED LOGIC TO STORE INPUT IF VALID!!!
		
		
		if blank = '1' then
			rgb <= (others => '0');		-- Have to be zeros during the blank period
		else
			rgb <= COLOR_WHITE;			-- Background color
		end if;		
		if vcount >= MESSAGE_START_V and vcount <= MESSAGE_START_V + MESSAGE_HEIGHT then
			if hcount >= MESSAGE_START_H and hcount <= MESSAGE_START_H + MESSAGE_WIDTH - 1 then	
				rgb <= rom_dout;
				
				if (crnt_rom_addr = ROM_DEPTH - 1 or vcount = MESSAGE_START_V) then		-- ROM address is counted from 0, therefore "ROM_DEPTH - 1"
				
					next_rom_addr 			<= "000000" & crnt_A(29 downto 20);
								
				elsif hcount = MESSAGE_START_H + pointer_one -1 then
                    next_rom_addr <= crnt_rom_addr - digit_width - crnt_A(29 downto 20) + crnt_A(19 downto 10);    -- 35 is digit_width
				
				elsif hcount = MESSAGE_START_H + pointer_two -1 then
                    next_rom_addr <= crnt_rom_addr - digit_width - crnt_A(19 downto 10) + crnt_A(9 downto 0);   -- We might need to concatenate "000000" !!!!
				
				elsif hcount = MESSAGE_START_H + pointer_three -1 then
                    next_rom_addr <= crnt_rom_addr - digit_width - crnt_A(9 downto 0) + crnt_operation; 
				
				elsif hcount = MESSAGE_START_H + pointer_four -1 then
                    next_rom_addr <= crnt_rom_addr - digit_width - crnt_operation + crnt_B(29 downto 20); 
				
				elsif hcount = MESSAGE_START_H + pointer_five -1 then
                    next_rom_addr <= crnt_rom_addr - digit_width - crnt_B(29 downto 20) + crnt_B(19 downto 10); 
				
				elsif hcount = MESSAGE_START_H + pointer_six -1 then
                    next_rom_addr <= crnt_rom_addr - digit_width - crnt_B(19 downto 10) + crnt_B(9 downto 0); 
				
				elsif hcount = MESSAGE_START_H + pointer_seven -1 then
                    next_rom_addr <= crnt_rom_addr - digit_width - crnt_B(9 downto 0) + pointer_equal; 
				
				elsif hcount = MESSAGE_START_H + pointer_eight -1 then
                    next_rom_addr <= crnt_rom_addr - digit_width - pointer_equal + crnt_R(59 downto 50);      -- should be sign bit
				
				elsif hcount = MESSAGE_START_H + pointer_nine -1 then
                    next_rom_addr <= crnt_rom_addr - digit_width - crnt_R(59 downto 50) + crnt_R(49 downto 40); 
					
                elsif hcount = MESSAGE_START_H + pointer_plus -1 then
					next_rom_addr <= crnt_rom_addr - digit_width - crnt_R(49 downto 40) + crnt_R(39 downto 30); 
				
				elsif hcount = MESSAGE_START_H + pointer_minus -1 then
					next_rom_addr <= crnt_rom_addr - digit_width - crnt_R(39 downto 30) + crnt_R(29 downto 20); 
				
				elsif hcount = MESSAGE_START_H + pointer_times -1 then
					next_rom_addr <= crnt_rom_addr - digit_width - crnt_R(29 downto 20) + crnt_R(19 downto 10); 
				
				elsif hcount = MESSAGE_START_H + pointer_modulo -1 then
					next_rom_addr <= crnt_rom_addr - digit_width - crnt_R(19 downto 10) + crnt_R(9 downto 0); 
				
				elsif hcount = MESSAGE_START_H + MESSAGE_WIDTH -1 then
					next_rom_addr <= crnt_rom_addr - digit_width - crnt_R(9 downto 0) + crnt_A(29 downto 20) + "0000001001100100";
					
				else
					
					next_rom_addr 			<= crnt_rom_addr + 1;

				end if;
				
				
				

				
			end if;
		end if;
	end process comb;
	
	
end Behavioral;
