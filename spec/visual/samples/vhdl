-- VHDL Lexer

entity test_module is
	port (
		clk_in : in  std_logic;
		a_in   : in  std_logic_vector(2 downto 0);
		b_in   : in  std_logic_vector(2 downto 0);
		data_q : out std_logic
	);
end entity test_module;

architecture RTL of test_module is

	signal data : std_logic := '0';
	
	function test(a, b : integer) return std_logic_vector is
	begin
	
		if (a < b) then
			return x"A";
		else
			return "0101";
		end if;
	end function;
	
begin

	data_q <= data;

	data_proc : process (clk_in)
		variable a : integer range 0 to 100 := 0;
		variable b : integer;
	begin
	
		if (rising_edge(clk_in)) then
		
			a := to_integer(unsigned(a_in));
			b := to_integer(unsigned(b_in));
		
			data <= not test(a, b);
			
		end if;
	
	end process; 

end architecture RTL;
