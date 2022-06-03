Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end fulladder;

architecture addlike of fulladder is
begin
  sum   <= a xor b xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;


--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is
	-- used fulladder as a component 
	component fulladder 
	 port (a : in std_logic;
          	b : in std_logic;
          	cin : in std_logic;
          	sum : out std_logic;
          	carry : out std_logic
	);
	end component; 
	signal bTempo: std_logic_vector(31 downto 0); 
	signal C1: std_logic_vector(32 downto 0); 
begin
	-- code for adder_subtracter register 
	
	C1(0) <= add_sub; 
	co <= C1(32); 
	
	with add_sub select 
		bTempo <= datain_b when '0',
			not datain_b when others; 
	
	initAdder: fulladder PORT MAP (datain_a(0),bTempo(0),C1(0),dataout(0),C1(1)); 
	createAdders: for i in 31 downto 1 generate 
	iterateAdder: fulladder PORT MAP (datain_a(i),bTempo(i),C1(i),dataout(i),C1(i+1));
	end generate; 
	
end architecture calc;

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain: in std_logic_vector(31 downto 0);
	   	dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is
	
begin
	with dir & shamt(1 downto 0) select 
		dataout <= datain(30 downto 0) & '0' when "001",
		'0' & datain(31 downto 1) when "101", 
		datain(29 downto 0) & "00" when "010",
		"00" & datain(31 downto 2) when "110", 
		datain(28 downto 0) & "000" when "011", 
		"000" & datain(31 downto 3) when "111", 
		datain when others; 

end architecture shifter;

--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;

	-- signals for standard operations (non-immediates) 
	signal carry_bit: std_logic;
	signal add_sub_output: std_logic_vector(31 downto 0); -- we are using 31 downto 0 bc its a 32 bit ALU
	signal shift_output: std_logic_vector(31 downto 0); 
	signal or_output: std_logic_vector(31 downto 0); 
	signal and_output: std_logic_vector(31 downto 0); 
	
	-- signals for standard operations (immediates) 
	signal iadd_sub_output:std_logic_vector(31 downto 0);
	signal ishift_output: std_logic_vector(31 downto 0);
	signal ior_output: std_logic_vector(31 downto 0);
	signal iand_output: std_logic_vector(31 downto 0);

	-- extra signals 
	signal add_sub: std_logic; 
	signal temp_out: std_logic_vector(31 downto 0); 

begin
	--- ALU implementation (does the listed operations in lab manual) 
	-- with select statement in order to control ALU operations 
	with ALUCtrl select 
		add_sub<='0' when "00000", -- adding operation 
				'0' when "10000", -- adding as well 
				'1' when others; -- subtracting op 


	-- standard ops (non-immediates) 
	con1: component adder_subtracter port map(DataIn1, DataIn2, add_sub, add_sub_output, carry_bit); 
	con2: component shift_register port map(Datain1, ALUCtrl(2),ALUCtrl,shift_output); 
	and_output <= DataIn1 AND DataIn2; 
	or_output <= DataIn1 OR DataIn2; 
	
	-- standard ops (immediates) 
	con3: component adder_subtracter port map(DataIn1, DataIn2, add_sub, iadd_sub_output, carry_bit); 
	con4: component shift_register port map(DataIn1, ALUCtrl(2), ALUCtrl, ishift_output); 
	iand_output <= DataIn1 AND DataIn2; 
	ior_output <= DataIn1 OR DataIn2; 
	
	with ALUCtrl select 
		temp_out <= add_sub_output when "00000",
			 add_sub_output when "00001", 
			and_output when "00010", 
			or_output when "00011", 
			shift_output when "00101", 
			shift_output when "00110", 
			shift_output when "00111", 
			shift_output when "01001", 
			shift_output when "01010", 
			shift_output when "01011", 
			
		-- handling the immediate operations 
			iadd_sub_output when "10000", 
			iadd_sub_output when "10001", 
			iand_output when "10010", 
			ior_output when "10011", 
			ishift_output when "10101", 
			ishift_output when "10110", 
			ishift_output when "10111", 
			DataIn2 when others; 

	ALUResult <= temp_out; 
	with temp_out select 
		Zero <= '1' when x"00000000",
			'0' when others; 
end architecture ALU_arch; 


