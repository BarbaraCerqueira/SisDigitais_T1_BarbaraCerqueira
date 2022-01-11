--Autor: Barbara Cerqueira
--Data: 14/12/2021
--Projeto: Componente que vai multiplicar um vetor binário de 4 bits por 2, com saída de overflow



library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



--Portas da Entidade DOBRO_4bits:
--A = Vetor de entrada A (4 bits)
--Dobro = Resultado da operação de multiplicação por 2 (4 bits)
--Overflow = Overflow da saída

ENTITY DOBRO_4bits IS

PORT ( A: in STD_LOGIC_VECTOR(3 downto 0);
		 Dobro: out STD_LOGIC_VECTOR(3 downto 0);
		 Overflow: out STD_LOGIC);
		 
END DOBRO_4bits;


ARCHITECTURE DOBRO_4bits_architecture OF DOBRO_4bits IS
       
		 signal S_Resultado: STD_LOGIC_VECTOR(4 downto 0); --Sinal que vai armazenar o resultado da multiplicação
		 
BEGIN
		 
		 S_Resultado <= A & '0'; --Um binario multiplicado por 2 resulta nele próprio mais um zero adicionado à direita de seu bit menos significativo, ficando nesse caso 5 bits
       
       Dobro <= S_Resultado(3 downto 0); --Manda para a saída só os ultimos 4 bits do resultado pois a saída é de 4 bits
		 
		 
--Haverá overflow se S_Resultado for maior que 7 ou menor que -8, que é a capacidade de nossos vetores de 4 bits em complemento de 2:
       
		 Overflow <= '1' WHEN ((signed(S_Resultado) > "00111") OR (signed(S_Resultado) < "11000")) ELSE '0';
		 

END DOBRO_4bits_architecture;

