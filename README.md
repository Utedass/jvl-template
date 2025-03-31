# Jegatron VHDL Library Template

This is a template project, based on the jvl-generic-clk-en-divider project.

Just copy this project and make changes as necessary. Remove this chapter.

# jvl-generic-clk-en-divider

Jegatron VHDL Library - Generic Clock Enable Divider

Entity: generic_clk_en_divider

Divides the clock into single-clock-length enable pulses to use as enable signals for other modules in the same clock domain. To make other modules run slower :)

en_out(0) is clk / 2\
en_out(1) is clk / 4\
etc

Declaring component

```vhdl
	component generic_clk_en_divider is
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
	end component;
```

Instantiating

```vhdl
	my_9_bit_divider : generic_clk_en_divider
		generic map(
			divider_bits => 9
		)
		port map(
			clk => my_clock_signal,
			rstn => my_resetn_signal,
			en => my_enable_signal,
			en_out => my_divided_en_signals
		);
```
