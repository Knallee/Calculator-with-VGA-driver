library ieee;
use ieee.std_logic_1164.all;

entity tb_ALU_ctrl is
end tb_ALU_ctrl;

architecture structural of tb_ALU_ctrl is

   component ALU_ctrl
   port ( clk     : in  std_logic;
          reset   : in  std_logic;
          enter   : in  std_logic;
          sign    : in  std_logic;
          FN      : out std_logic_vector (3 downto 0);   -- ALU functions
          RegCtrl : out std_logic_vector (1 downto 0)   -- Register update control bits
        );
   end component;

	signal clk       :   std_logic:= '0';
	signal sys_rst   :   std_logic;
	signal enter     :   std_logic:= '0';
	signal sign      :  std_logic:= '0';
	signal FN        :  std_logic_vector (3 downto 0);   -- ALU functions
	signal RegCtrl   :  std_logic_vector (1 downto 0);   -- Register update control bits

begin  -- structural
   
	DUT:  ALU_ctrl
	port map ( clk      => clk,    
				reset    => sys_rst, 
				enter    => enter,  
				sign     => sign,   
				FN       => FN,     
				RegCtrl  => RegCtrl
				);
   
   -- *************************
   -- User test data pattern
   -- *************************
	clk <= not(clk) after 500 ns;		-- 2 MHz sys clock generated in testbench
	
	sys_rst <= '1', '0' after 2300 ns;
	
	
	enter <= not(enter) after 5000 ns;
	
	sign <= not(sign) after 5000 ns;
	
	-- process (sys_rst)
	-- begin
	-- if sys_rst = '1' then
		-- clk <= '0';
		-- enter <= '0';
		-- sign <= '0';
	-- end if;
	
--	end process;
   
                                              
end structural;      