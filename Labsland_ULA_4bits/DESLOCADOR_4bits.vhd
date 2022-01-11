--Autor: Barbara Cerqueira
--Data: 14/12/2021
--Projeto: Componente Deslocador lógico de 1 casa para vetor binário de 4 bits 
--         com chave de seleção para direita ou esquerda.




library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



--Portas da Entidade DESLOCADOR_4bits:
--A = Vetor de entrada A (4 bits)
--Seletor_direcao = 0 para deslocamento à esquerda e 1 para deslocamento à direita
--A_Deslocado = Vetor resultante do deslocamento de A (4 bits)

ENTITY DESLOCADOR_4bits IS
    
PORT ( A: in STD_LOGIC_VECTOR(3 downto 0);
		 Seletor_direcao: in STD_LOGIC;     -- 0=esquerda; 1=direita
		 A_Deslocado: out STD_LOGIC_VECTOR(3 downto 0));
		 
END DESLOCADOR_4bits;




ARCHITECTURE DESLOCADOR_4bits_architecture OF DESLOCADOR_4bits IS

--Sinais unsigned temporarios para poder acessar as funções "SLL" e "SRL":

       signal temp_A: unsigned(3 downto 0);
		 signal temp_resultado: unsigned(3 downto 0);


BEGIN
		  
		 temp_A <= unsigned(A);

       WITH Seletor_direcao SELECT
		    temp_resultado <= temp_A SLL 1 WHEN '0',
			                temp_A SRL 1 WHEN '1',
							    "0000" WHEN OTHERS;
								 
		 A_Deslocado <= std_logic_vector(temp_resultado);
		 

END DESLOCADOR_4bits_architecture;


