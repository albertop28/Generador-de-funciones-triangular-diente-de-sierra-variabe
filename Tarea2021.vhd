library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Tarea2021 is port (
	senal,Display: out std_logic_vector (7 downto 0);
	convs,AN,ANA: out std_logic_vector (3 downto 0);
	clock, en1, en2, sensor: in std_logic);
end Tarea2021;

architecture Behavioral of Tarea2021 is
	signal clk,uhr0,uhr1,frecF,ent1,ent2,sensor1,sensor2,ascendente: std_logic := '1';
-------------------------------------------------------------------------------
	signal div1,div2,div3,div4,div5: std_logic := '1'; --relojes para divisores
	signal div6,div7,div8,div9,div0: std_logic := '1'; --de frcuencia
-------------------------------------------------------------------------------
	signal c1,c2,c3,c4,c5: integer := 1;--contadores para divisores
	signal c6,c7,c8,c9,c0: integer := 1;--de frecuencia
-------------------------------------------------------------------------------
	signal delay1,delay2,delay3,delay4: std_logic := '1';
	signal delay5,delay6,delay7,delay8: std_logic := '1';
-------------------------------------------------------------------------------
	signal cont0,cont1,cont2: integer:= 1;
	signal Dien,Trian,displays: std_logic_vector (7 downto 0):= "00000001";
	signal B : std_logic_vector(3 downto 0) := "0001";
	signal ANS : std_logic_vector(3 downto 0) := "1110";
begin
clk <= clock;
convs <= B;
display <= displays;
ANA <= "1111";
---------Proceso de topes de frecuencia---------
process (B) begin
	if B = "1010" then
		sensor1 <= '0';
		sensor2 <= '1';
	elsif B = "0001" then
		sensor1 <= '1';
		sensor2 <= '0';
	else 
		sensor1 <= '0';
		sensor2 <= '0';
	end if;
end process;
---------Process de Frec---------
process (B,div0,div1,div2,div3,div4,div5,div6,div7,div8,div9,ans) begin
	case B is--Case de selección de frecuencia y asignación de displays
		when "0001" => frecF <= div0;
			if ANS = "1110" then
				displays <= "00000011";--0
			elsif ANS = "1101" then
				displays <= "00000011";--0
			elsif ANS = "1011" then
				displays <= "10011111";--1
			else 
				displays <= "11111111";
			end if;
		when "0010" => frecF <= div1;
			if ANS = "1110" then
				displays <= "00000011";--0
			elsif ANS = "1101" then
				displays <= "00011001";--9
			else
				displays <= "11111111";
			end if;
		when "0011" => frecF <= div2;
			if ANS = "1110" then
				displays <= "00000011";--0
			elsif ANS = "1101" then
				displays <= "00000001";--8
			else
				displays <= "11111111";
			end if;
		when "0100" => frecF <= div3;
			if ANS = "1110" then
				displays <= "00000011";--0
			elsif ANS = "1101" then
				displays <= "00011111";--7
			else
				displays <= "11111111";
			end if;
		when "0101" => frecF <= div4; 
			if ANS = "1110" then
				displays <= "00000011";--0
			elsif ANS = "1101" then
				displays <= "01000001";--6
			else
				displays <= "11111111";
			end if;
		when "0110" => frecF <= div5; 
			if ANS = "1110" then
				displays <= "00000011";--0
			elsif ANS = "1101" then
				displays <= "01001001";--5
			else
				displays <= "11111111";
			end if;
		when "0111" => frecF <= div6; 
			if ANS = "1110" then
				displays <= "00000011";--0
			elsif ANS = "1101" then
				displays <= "10011001";--4
			else
				displays <= "11111111";
			end if;
		when "1000" => frecF <= div7; 
			if ANS = "1110" then
				displays <= "00000011";--0
			elsif ANS = "1101" then
				displays <= "00001101";--3
			else
				displays <= "11111111";
			end if;
		when "1001" => frecF <= div8;
			if ANS = "1110" then
				displays <= "00000011";--0
			elsif ANS = "1101" then
				displays <= "00100101";--2
			else
				displays <= "11111111";
			end if;
		when "1010" => frecF <= div9;
			if ANS = "1110" then
				displays <= "00000011";--0
			elsif ANS = "1101" then
				displays <= "10011111";--1
			else
				displays <= "11111111";
			end if;
		when others => frecF <= div0; 
			if ANS = "1110" then
				displays <= "00000011";--0
			elsif ANS = "1101" then
				displays <= "00000011";--0
			elsif ANS = "1011" then
				displays <= "10011111";--1
			else 
				displays <= "11111111";
			end if;
	end case;
end process;
---------Main process---------
process (uhr1,ent1,ent2) begin
	if uhr1'event and uhr1 = '1' then
		if ent1'event and ent1 = '0' then
		--Caso de giro en sentido horario
			if ent2 = '0' and sensor2 = '0' then
				B <= B + "0001";
		--Caso de limite en sentido horario
			elsif ent2 = '0' and sensor2 = '1' then
				B <= B;
		--Caso de giro en sentido antihorario
			elsif ent2 = '1' and sensor1 = '0' then
				B <= B - "0001";
		--Caso de limite en sentido antihorario
			elsif ent2 = '1' and sensor1 = '1' then
				B <= B;
			else
				B <= B;
			end if;
		else
			B <= B;
		end if;
	end if;
end process;
Process (sensor, Dien, Trian) begin
	if sensor = '0' then
		senal <= Dien;
	else
		senal <= trian;
	end if;
end process;
---------Proceso de Anódos---------
process (ANS,uhr1) begin
	if uhr1'event and uhr1 = '1' then
		ANS(0) <= ANS(1);
		ANS(1) <= ANS(2);
		ANS(2) <= ANS(3);
		ANS(3) <= ANS(0);
		AN <= ANS;
	end if;
end process;
---Proceso de contador señal Diente de sierra
Process (frecF) begin
	if frecF'event and frecF = '1' then
		if Dien = "11111111" then
			Dien <= "00000000";
		else
			Dien <= Dien + "00000001";
		end if;
	end if;
end process;
---Proceso de contador señal Triangular
process(frecF)begin
	if frecF'event and frecF = '1' then
		if cont2 = 256 then
			ascendente <= not ascendente;
			cont2 <= 0;
		else
			cont2 <= cont2 + 1;
		end if;
	end if;
end process;
Process(ascendente, frecF)begin
	if frecF'event and frecF = '1' then
		if ascendente = '1' then
			Trian <= Trian + "00000001";
		else
			Trian <= Trian - "00000001";
		end if;
	end if;
end process;
---------Div. Frec. 1---------
process (clk) begin--Para filtro de señal
	if clk'event and clk = '1' then
		if cont0 = 42828 then --583.73Hz
			cont0 <= 1;
			uhr0 <= not uhr0;
		else
			cont0 <= cont0 + 1;
		end if;
	end if;
end process;
---------Div. Frec. 2---------
process (clk) begin--Para Main process
	if clk'event and clk = '1' then
		if cont1 = 125000 then --2kHz
			cont1 <= 1;
			uhr1 <= not uhr1;
		else
			cont1 <= cont1 + 1;
		end if;
	end if;
end process;
---------Div. Frec. SEÑAL 1---------
process (clk) begin
	if clk'event and clk = '1' then
		if c0 = 256 then
			c0 <= 1;
			div0 <= not div0;
		else
			c0 <= c0 + 1;
		end if;
	end if;
end process;
---------Div. Frec. SEÑAL 2---------
process (clk) begin
	if clk'event and clk = '1' then
		if c1 = 256*2 then
			c1 <= 1;
			div1 <= not div1;
		else
			c1 <= c1 + 1;
		end if;
	end if;
end process;
---------Div. Frec. SEÑAL 3---------
process (clk) begin
	if clk'event and clk = '1' then
		if c2 = 256*3 then
			c2 <= 1;
			div2 <= not div2;
		else
			c2 <= c2 + 1;
		end if;
	end if;
end process;
---------Div. Frec. SEÑAL 4---------
process (clk) begin
	if clk'event and clk = '1' then
		if c3 = 256*4 then 
			c3 <= 1;
			div3 <= not div3;
		else
			c3 <= c3 + 1;
		end if;
	end if;
end process;
---------Div. Frec. SEÑAL 5---------
process (clk) begin
	if clk'event and clk = '1' then
		if c4 = 256*5 then 
			c4 <= 1;
			div4 <= not div4;
		else
			c4 <= c4 + 1;
		end if;
	end if;
end process;
---------Div. Frec. SEÑAL 6---------
process (clk) begin
	if clk'event and clk = '1' then
		if c5 = 256*6 then 
			c5 <= 1;
			div5 <= not div5;
		else
			c5 <= c5 + 1;
		end if;
	end if;
end process;
---------Div. Frec. SEÑAL 7---------
process (clk) begin
	if clk'event and clk = '1' then
		if c6 = 256*7 then 
			c6 <= 1;
			div6 <= not div6;
		else
			c6 <= c6 + 1;
		end if;
	end if;
end process;
---------Div. Frec. SEÑAL 8---------
process (clk) begin
	if clk'event and clk = '1' then
		if c7 = 256*8 then 
			c7 <= 1;
			div7 <= not div7;
		else
			c7 <= c7 + 1;
		end if;
	end if;
end process;
---------Div. Frec. SEÑAL 9---------
process (clk) begin
	if clk'event and clk = '1' then
		if c8 = 256*9 then
			c8 <= 1;
			div8 <= not div8;
		else
			c8 <= c8 + 1;
		end if;
	end if;
end process;
---------Div. Frec. SEÑAL 10---------
process (clk) begin
	if clk'event and clk = '1' then
		if c9 = 2560 then 
			c9 <= 1;
			div9 <= not div9;
		else
			c9 <= c9 + 1;
		end if;
	end if;
end process;
---------Fitro 1 y 2 ---------
process(uhr0,en1,delay1,delay2,delay3,delay4) begin
	if (uhr0'event and uhr0 = '1') then
		delay1 <= en1;--Filtro FlipFlop
		delay2 <= delay1;
		delay3 <= delay2;
		delay4 <= delay3;
	end if;
	ent1 <= delay1 and delay2 and delay3 and delay4;
end process;

process(uhr0,en2,delay5,delay6,delay7,delay8) begin
	if (uhr0'event and uhr0 = '1') then
		delay5 <= en2;--Filtro FlipFlop
		delay6 <= delay5;
		delay7 <= delay6;
		delay8 <= delay7;
	end if;
	ent2 <= delay5 and delay6 and delay7 and delay8;
end process;
end Behavioral;

