library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_clk_en_divider is
	generic (
		divider_bits : integer := 8
	);
	port
	(
		clk : in std_logic;
		rstn : in std_logic;
		en  : in std_logic;
		en_out : out unsigned (divider_bits - 1 downto 0)
	);
end entity;

architecture beh of generic_clk_en_divider is
	signal i_counter_val : unsigned (divider_bits -1 downto 0);
	signal i_counter_val_next : unsigned (divider_bits -1 downto 0);
begin
	-- Unbuffered output, for speedy service ;)
	en_out <= not i_counter_val_next and i_counter_val;
	
	-- Next counter value
	i_counter_val_next <= (others => '1') when rstn = '0'
	else i_counter_val when en = '0'
	else i_counter_val + 1;

	-- Positive edge detector
	process(clk) is
	begin
		if rising_edge(clk) then
			i_counter_val <= i_counter_val_next;
		end if;
	end process;

end architecture;
