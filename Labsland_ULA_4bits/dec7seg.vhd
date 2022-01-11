library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dec7seg is port(
	hex_digit : in std_logic_vector(3 downto 0) := (others => '0');
	segment_7dis : out std_logic_vector(0 to 6)
	);
end dec7seg;

architecture arch_dec of dec7seg is
	signal segment_data : std_logic_vector(0 to 6);
	begin
		process (hex_digit)
		begin
			case hex_digit is
				when "0000"=> segment_data <="0111111";
				when "0001"=> segment_data <="0000110";
				when "0010"=> segment_data <="1011011";
				when "0011"=> segment_data <="1001111";
				when "0100"=> segment_data <="1100110";
				when "0101"=> segment_data <="1101101";
				when "0110"=> segment_data <="1111101";
				when "0111"=> segment_data <="0000111";
				when "1000"=> segment_data <="1111111";
				when "1001"=> segment_data <="1100111";
				--valor maior que 9 -> A=10, B=11, C=12, D=13, E=14 e F=15:
				when "1010"=> segment_data <="1110111";
				when "1011"=> segment_data <="1111100";
				when "1100"=> segment_data <="0111001";
				when "1101"=> segment_data <="1011110";
				when "1110"=> segment_data <="1111001";
				when "1111"=> segment_data <="1110001";
				when others=> segment_data <="0000000";
			end case;
		end process;
		segment_7dis <= not segment_data;
end arch_dec;