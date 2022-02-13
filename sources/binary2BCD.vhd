library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity  binary2BCD is
  generic ( WIDTH : integer := 8   -- 8 bit binary to BCD
          );
        port (	binary_in 	: in  std_logic_vector(WIDTH-1 downto 0);  -- binary input width
                BCD_out     : out std_logic_vector(11 downto 0)        -- BCD output, 10 bits [2|4|4] to display a 3 digit BCD value when input has length 8
        );
end entity;

architecture struct of binary2BCD is
    procedure add3 (signal binary_in: in  std_logic_vector (3 downto 0); 
                    signal BCD_out: out std_logic_vector (3 downto 0)) is
    variable is_gt_4:  std_logic;
    begin
        is_gt_4 := binary_in(3) or (binary_in(2) and (binary_in(1) or binary_in(0)));

        if is_gt_4 = '1' then
        -- if to_integer(unsigned (bin)) > 4 then
            BCD_out <= std_logic_vector(unsigned(binary_in) + "0011");
        else
            BCD_out <= binary_in;
        end if;
    end procedure;

    signal U0bin,U1bin,U2bin,U3bin,U4bin,U5bin,U6bin:
                std_logic_vector (3 downto 0);

    signal U0bcd,U1bcd,U2bcd,U3bcd,U4bcd,U5bcd,U6bcd:
                std_logic_vector (3 downto 0);       
begin
    U0bin <= '0' & binary_in (7 downto 5);
    U1bin <= U0bcd(2 downto 0) & binary_in(4);
    U2bin <= U1bcd(2 downto 0) & binary_in(3);
    U3bin <= U2bcd(2 downto 0) & binary_in(2);
    U4bin <= U3bcd(2 downto 0) & binary_in(1);

    U5bin <= '0' & U0bcd(3) & U1bcd(3) & U2bcd(3);
    U6bin <= U5bcd(2 downto 0) & U3bcd(3);

U0: add3(U0bin,U0bcd);

U1: add3(U1bin,U1bcd);

U2: add3(U2bin,U2bcd);

U3: add3(U3bin,U3bcd);

U4: add3(U4bin,U4bcd);

U5: add3(U5bin,U5bcd);

U6: add3(U6bin,U6bcd);

OUTP:
    BCD_out <= "00" & U5bcd(3) & U6bcd & U4bcd & binary_in(0);

end architecture;
		

	
