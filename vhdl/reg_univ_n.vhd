library ieee;
use ieee.std_logic_1164.all;


entity reg_univ_n is
	generic ( n : natural := 4 ) ;
	port ( 	clk, arazb : in std_logic ;
			sraz,sload : in std_logic ;
			E : std_logic_vector (n-1 downto 0) ;
			S : out std_logic_vector (n-1 downto 0) ) ;
end reg_univ_n ;

architecture synth of reg_univ_n is
	signal reg : std_logic_vector (n-1 downto 0);
begin

	process (clk,arazb)
	begin
		if arazb = '0' then reg <= (others => '0');
		elsif clk = '1' and clk'event then
			if sraz = '1' then reg <= (others => '0') ;
			elsif sload = '1' then reg <= E ;
			end if ;
		end if ;
	end process ;
	
	S <= reg ;
end ;