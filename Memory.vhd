-- components from Lab 3 
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;
begin
	-- code for an 8-bit register (without processes) 
	-- used PORT mapping for each bit of the register 
	
	first_bit: bitstorage PORT MAP(datain(0),enout,writein, dataout(0)); -- starts at 0 and goes up to 7 (8 bits) 
	second_bit: bitstorage PORT MAP(datain(1),enout,writein, dataout(1));
	third_bit: bitstorage PORT MAP(datain(2),enout,writein, dataout(2));
	fourth_bit: bitstorage PORT MAP(datain(3),enout,writein, dataout(3));
	fifth_bit: bitstorage PORT MAP(datain(4),enout,writein, dataout(4));
	sixth_bit: bitstorage PORT MAP(datain(5),enout,writein, dataout(5));
	seventh_bit: bitstorage PORT MAP(datain(6),enout,writein, dataout(6));
	eighth_bit: bitstorage PORT MAP(datain(7),enout,writein, dataout(7));


end architecture memmy;

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
	-- hint: you'll want to put register8 as a component here 
	-- so you can use it below
	component register8
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
	end component; 

	-- signals to use for with select statements
	signal output_en: std_logic_vector(2 downto 0); 
	signal writ_in: std_logic_vector(2 downto 0);
	signal output_enabling: std_logic_vector(3 downto 0); 
	signal writing_in: std_logic_vector(3 downto 0);
begin
	output_en <= enout32 & enout16 & enout8; -- concatinating enout32, 16, and 8  as an output of the enable 
	writ_in <= writein32 & writein16 & writein8;  

	-- with select statements for 32 bit register 
	with output_en select 
		output_enabling <= "1110" when "110",
				   "1100" when "101",
				   "0000" when "011",
				   "1111" when others; 
	with writ_in select 
		writing_in <= "0001" when "001",
			      "1111" when "100",
			      "0011" when "010",
			      "0000" when others; 

	-- port mapping using register8 as a component 
	-- need to map 4, 8-bit registers because we are making a 32 bit register 
	first_reg: register8 PORT MAP(datain(31 downto 24), output_enabling(3), writing_in(3), dataout(31 downto 24)); 
	second_reg: register8 PORT MAP(datain(23 downto 16), output_enabling(2), writing_in(2), dataout(23 downto 16));
	third_reg: register8 PORT MAP(datain(15 downto 8), output_enabling(1), writing_in(1), dataout(15 downto 8));
	fourth_reg: register8 PORT MAP(datain(7 downto 0), output_enabling(0), writing_in(0), dataout(7 downto 0));
	
end architecture biggermem;


--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
--
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

   type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   signal i_ram : ram_type;
   signal tempaddress: std_logic_vector(29 downto 0); 

begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

    if falling_edge(Clock) then
	-- Add code to write data to RAM
	-- Use to_integer(unsigned(Address)) to index the i_ram array

	if WE = '1' and to_integer(unsigned(Address)) >= 0 and to_integer(unsigned(Address)) <= 127 then 
		i_ram(to_integer(unsigned(Address))) <= DataIn; 
	elsif WE = '0' then 
		tempaddress<= address;
	end if; 
	
    end if;

    -- reading from memory 
   if to_integer(unsigned(Address)) >= 0 and to_integer(unsigned(Address)) <= 127 then 
	if OE = '0' then 
		DataOut <= i_ram(to_integer(unsigned(Address))); 
	else
		DataOut <= (others => 'Z'); 
	end if; 
   else 
	DataOut <= (others => 'Z'); 
   end if; 

  end process RamProc;

end staticRAM;	


--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;
	
	-- making an array for the register 
	type regtype is array(7 downto 0) of std_logic_vector(31 downto 0); 
	signal register_arr: regtype; 

	-- Register Bank Implementation 
    	signal enable0: std_logic; 
    	signal enable1: std_logic;
    	signal enable2: std_logic; 
    	signal enable3: std_logic; 
   	signal enable4: std_logic; 
    	signal enable5: std_logic; 
    	signal enable6: std_logic; 
    	signal enable7: std_logic; 
	
begin
--- writing to the registers 
  process(WriteData,WriteCmd) is 
  begin
	if WriteReg = "01010" and WriteCmd = '1' then 
		enable0 <= '1'; 
	elsif WriteReg = "01011" and WriteCmd = '1' then 
		enable1 <= '1'; 
	elsif WriteReg = "01100" and WriteCmd = '1' then 
		enable2 <= '1';
	elsif WriteReg = "01101" and WriteCmd = '1' then 
		enable3 <= '1'; 
	elsif WriteReg = "01110" and WriteCmd = '1' then 
		enable4 <= '1'; 
	elsif WriteReg = "01111" and WriteCmd = '1' then 
		enable5 <= '1'; 
	elsif WriteReg = "10000" and WriteCmd = '1' then 
		enable6 <= '1'; 
	elsif WriteReg = "10001" and WriteCmd = '1' then 
		enable7 <= '1'; 
	else -- considers all other possible enable outputs to the registers 
		enable0 <= '0'; 
		enable1 <= '0';
		enable2 <= '0';
		enable3 <= '0';
		enable4 <= '0';
		enable5 <= '0';
		enable6 <= '0';
		enable7 <= '0';
	end if;
 end process; 

	-- port map implementing 32-bit register 
	s0: register32 port map(WriteData, '0','1','1', enable0,'0','0',register_arr(0)); 
	s1: register32 port map(WriteData, '0','1','1', enable1,'0','0',register_arr(1)); 
	s2: register32 port map(WriteData, '0','1','1', enable2,'0','0',register_arr(2)); 
	s3: register32 port map(WriteData, '0','1','1', enable3,'0','0',register_arr(3)); 
	s4: register32 port map(WriteData, '0','1','1', enable4,'0','0',register_arr(4)); 
	s5: register32 port map(WriteData, '0','1','1', enable5,'0','0',register_arr(5)); 
	s6: register32 port map(WriteData, '0','1','1', enable6,'0','0',register_arr(6)); 
	s7: register32 port map(WriteData, '0','1','1', enable7,'0','0',register_arr(7));  

-- reading to register 1 
  process(ReadReg1) is 
  begin
	if ReadReg1 = "01010" then 
		ReadData1 <= register_arr(0); 
	elsif ReadReg1 = "01011" then 
		ReadData1 <= register_arr(1); 
	elsif ReadReg1 = "01100" then 
		ReadData1 <= register_arr(2); 
	elsif ReadReg1 = "01101" then 
		ReadData1 <= register_arr(3); 
	elsif ReadReg1 = "01110" then 
		ReadData1 <= register_arr(4); 
	elsif ReadReg1 = "01111" then 
		ReadData1 <= register_arr(5); 
	elsif ReadReg1 = "10000" then 
		ReadData1 <= register_arr(6); 
	elsif ReadReg1 = "10001" then 
		ReadData1 <= register_arr(7); 
	elsif ReadReg1 = "00000" then -- making a wired zero register 
		ReadData1 <= X"00000000"; 
	else 
		ReadData1 <= (others => 'Z'); 
	end if; 
 end process; 

 -- reading to register 2 
  process(ReadReg2) is  
  begin
	if ReadReg2 = "01010" then
		ReadData2 <= register_arr(0); 
	elsif ReadReg2 = "01011" then 
		ReadData2 <= register_arr(1); 
	elsif ReadReg2 = "01100" then 
		ReadData2 <= register_arr(2); 
	elsif ReadReg2 = "01101" then 
		ReadData2 <= register_arr(3); 
	elsif ReadReg2 = "01110" then 
		ReadData2 <= register_arr(4); 
	elsif ReadReg2 = "01111" then 
		ReadData2 <= register_arr(5); 
	elsif ReadReg2 = "10000" then 
		ReadData2 <= register_arr(6); 
	elsif ReadReg2 = "10001" then 
		ReadData2 <= register_arr(7); 
	elsif ReadReg2 = "00000" then 
		ReadData2 <=X"00000000"; 
	else 
		ReadData2 <= (others => 'Z'); 
	end if; 
  end process; 
end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
