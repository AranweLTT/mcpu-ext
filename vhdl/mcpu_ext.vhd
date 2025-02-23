-- > States :
-- 00 fetch instruction
-- 01 load operand
-- 10 execute

-- > Instructions :
-- 00 NOR
-- 01 ADD
-- 10 STA
-- 11 JCC


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mcpu_ext is
port (
	-- Control
	rst:	in	std_logic;	-- active low
	clk:	in	std_logic;
	-- SRAM interface
	data:	inout	std_logic_vector(7 downto 0);
	adress:	out	std_logic_vector(8 downto 0);
	oe:		out	std_logic; 	-- active low
	we:		out	std_logic 	-- active low
	);
end;

architecture ar of mcpu_ext is

component reg_univ_n is
generic ( n : natural := 4 ) ;
port ( 	clk, arazb : in std_logic ;
        sraz,sload : in std_logic ;
        E : std_logic_vector (n-1 downto 0) ;
        S : out std_logic_vector (n-1 downto 0) ) ;
end component ;

signal	states:	std_logic_vector(1 downto 0);
signal	opcode:	std_logic_vector(1 downto 0);

-- Data
signal	akku_in:	std_logic_vector(7 downto 0);
signal	akku_out:	std_logic_vector(7 downto 0);
signal	adreg_in:	std_logic_vector(7 downto 0);
signal	adreg_out:	std_logic_vector(7 downto 0);
signal 	pc_in:		std_logic_vector(7 downto 0);
signal 	pc_out:		std_logic_vector(7 downto 0);
signal 	sum:		std_logic_vector(8 downto 0);
signal 	carry:		std_logic;
signal  ista:       std_logic;

-- Control
signal isload_akku 	: std_logic;
signal isload_adreg : std_logic;
signal isload_pc 	: std_logic;

begin
	-- Registers
	reg_akku:reg_univ_n
	generic map( n => 8 )
	port map (	
		clk 	=> clk,
		arazb 	=> rst,
		sraz 	=> '0',
		sload 	=> isload_akku,
		E		=> akku_in,
		S 		=> akku_out 
	);
	
	reg_adreg:reg_univ_n
	generic map( n => 8 )
	port map (	
		clk 	=> clk,
		arazb 	=> rst,
		sraz 	=> '0',
		sload 	=> isload_adreg,
		E		=> adreg_in,
		S 		=> adreg_out 
	);
	
	reg_pc:reg_univ_n
	generic map( n => 8 )
	port map (	
		clk 	=> clk,
		arazb 	=> rst,
		sraz 	=> '0',
		sload 	=> isload_pc,
		E		=> pc_in,
		S 		=> pc_out 
	);
	
	-- Address path
	pc_in      <= adreg_out + 1;
	isload_pc  <= states(1) nor states(0);
	isload_adreg <= opcode(1) or opcode(0) or carry or isload_pc or states(0);
	-- isload_adreg <= opcode(1) or opcode(0) or carry or isload_pc;
	-- isload_adreg <= not(((opcode(0) nor opcode (1)) and (not carry) and (not isload_pc)));
	adreg_in   <=  pc_out when states(1) = '1' else
	               data when states(0) = '1' else 
	               "00" & data(5 downto 0);
	
	-- Data path
	sum <= ("0" & akku_out) + ("0" & data);
	akku_in <= sum(7 downto 0) when opcode = "10" else (akku_out nor data);
	isload_akku <= states(1) when opcode(1) = '1' else '0';
	
	process(clk,rst)
	begin
		if (rst = '0') then
            states	<= "00";
            opcode	<= "00";
            carry   <= '0';
		elsif rising_edge(clk) then            
            -- ALU / Data Path
            if (states(1) = '1') then
                case opcode is
                    when "00"   => carry <= '0';     -- clear carry
                    when "10"   => carry <= sum(8);  -- store carry
                    when others => null;
                end case;
            end if;

            -- State machine
            if (isload_pc = '1') then 
                states <= states(0) & '1';
                opcode <= not data(7 downto 6);
            else states <= states(0) & '0';
            end if;
		end if;
	end process;
	
	-- Output
	ista    <= not opcode(1) and opcode(0) and states(1);
	data 	<= "ZZZZZZZZ" when ista = '0' else akku_out(7 downto 0);
	adress(7 downto 0)	<= adreg_out;
	adress(8) <= not isload_pc;
	oe 		<= '1' when (rst='0' or ista = '1') else '0';
	we 		<= '1' when (rst='0' or ista = '0') else '0';
end ar;
