--Autor: Barbara Cerqueira
--Data: 14/12/2021
--Projeto: Componente Somador 4 bits, com entrada de Carry in e saídas de Carry out e Overflow 




library ieee;
use IEEE.STD_LOGIC_1164.ALL;



--Portas da Entidade SOMADOR_4bits:
--A, B = Vetores de entrada A e B (4 bits)
--Soma = Resultado da operação de soma (4 bits)
--Carry_in, Carry_out = Carries In/Out do somador
--Overflow = Overflow da saída

ENTITY SOMADOR_4bits IS

PORT ( A, B: in STD_LOGIC_VECTOR(3 downto 0);
		 Carry_in: in STD_LOGIC;
       Soma: out STD_LOGIC_VECTOR(3 downto 0);
		 Carry_out: out STD_LOGIC;
		 Overflow: out STD_LOGIC );
		 
END SOMADOR_4bits;



ARCHITECTURE SOMADOR_4bits_architecture OF SOMADOR_4bits IS

       signal S_carry: STD_LOGIC_VECTOR(4 downto 0); --Sinal que vai guardar os carries da soma


BEGIN
       
       S_carry(0) <= Carry_in;

       Adder: FOR i in 0 to 3 GENERATE  --Full adder de 1 bit em loop para cada bit dos operandos
		 
		           Soma(i) <= (A(i) XOR B(i)) XOR S_carry(i);
					  S_carry(i+1) <= (A(i) AND B(i)) OR (A(i) AND S_carry(i)) OR (B(i) AND S_carry(i));
					  
		 END GENERATE Adder;
		 
		 Carry_out <= S_carry(4);
		 
		 Overflow <= S_carry(4) XOR S_carry(3);



END SOMADOR_4bits_architecture;


