library ieee;
use ieee.std_logic_1164.all;

entity testbench is
    --port ();
end testbench;

architecture ar of testbench is

component sram is
    port (
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
end component;

component mcpu_ext is
	port (
		rst:	in	std_logic;
		clk:	in	std_logic; -- active low
		
		-- SRAM interface
		data:	inout	std_logic_vector(7 downto 0);
		adress:	out	std_logic_vector(8 downto 0);
		oe:	out	std_logic;    -- active low
		we:	out	std_logic     -- active low
	);
end component;

signal idata : std_logic_vector(7 downto 0);
signal data_in : std_logic_vector(7 downto 0);
signal data_out : std_logic_vector(7 downto 0);
signal addr : std_logic_vector(8 downto 0);

signal oe  :std_logic;
signal we  :std_logic;
signal iwe  :std_logic;

signal clk_ram : std_logic;
signal iclk  :std_logic;
signal iarazb  :std_logic;

begin
    iwe <= not we;
    clk_ram <= not iclk;
    data_in <= idata;
    idata <= "ZZZZZZZZ" when oe='1' else data_out;

    ram:sram
    port map(
        clka    => clk_ram,
        ena     => iarazb,
        wea(0)  => iwe,
        addra   => addr,
        dina    => data_in,
        douta   => data_out
    );

    cpu:mcpu_ext
    port map (
        rst     => iarazb,
        clk     => iclk,
        data    => idata,
        adress  => addr,
        we      => we,
        oe      => oe
    );
    
    -- Create clock
    process
    begin
        -- Reset sequence
        iclk <= '0';
        iarazb <= '1';
        WAIT FOR 50 ns;
        iclk <= '0';
        iarazb <= '0';
        WAIT FOR 50 ns;
        iclk <= '1';
        WAIT FOR 25 ns;
        iarazb <= '1';
        WAIT FOR 25 ns;
        
        -- Run
        for k in 0 to 20000 loop
            iclk <= '0';
            WAIT FOR 50 ns;
            iclk <= '1';
            WAIT FOR 50 ns; -- clock.
        end loop;
    end process;

end ar;
