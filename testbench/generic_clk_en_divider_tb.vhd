library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_clk_en_divider_tb is
end entity;

architecture beh of generic_clk_en_divider_tb is
    component generic_clk_en_divider is
        generic (
            divider_bits : integer := 8
        );
        port (
            clk    : in std_logic;
            rstn   : in std_logic;
            en     : in std_logic;
            en_out : out unsigned (divider_bits - 1 downto 0)
        );
    end component;

    constant freq           : integer := 50; -- MHz
    constant period         : time    := 1000 / freq * 1 ns;
    constant half_period    : time    := period / 2;
    signal num_rising_edges : integer := 0;

    signal clock  : std_logic := '0';
    signal enable : std_logic;
    signal resetn : std_logic;

    signal divided_en      : unsigned (8 downto 0);
    signal divided_en_last : unsigned (8 downto 0);

    signal running : boolean := true;
begin
    running <= true, false after 530 * period;

    resetn <= '1', '0' after 2 * period, '1' after 3 * period;

    enable <= '0', '1' after 5 * period;

    DUT : generic_clk_en_divider
    generic map(
        divider_bits => 9
    )
    port map(
        clk    => clock,
        rstn   => resetn,
        en     => enable,
        en_out => divided_en
    );

    -- clock process
    process is
    begin
        if running then
            wait for half_period;
            clock <= not clock;
        else report "End of simulation!";
            wait;
        end if;
    end process;
    process (clock) is
    begin
        if rising_edge(clock) then
            if resetn = '0' then
                num_rising_edges <= 0;
            elsif enable = '1' then
                num_rising_edges <= num_rising_edges + 1;
                divided_en_last  <= divided_en;
            else 
-- Explicit no change
                num_rising_edges <= num_rising_edges;
            end if;
        end if;
    end process;

    -- Automated checks
    process (clock) is
    begin
        if rising_edge(clock)
            and num_rising_edges > 1 then
            assert (divided_en and divided_en_last) = 0 report "Enable signal longer than one clock signal detected!" severity error;
        end if;
    end process;
end architecture;
