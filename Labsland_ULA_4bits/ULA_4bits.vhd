--Autor: Barbara Cerqueira
--Data: 12/12/2021
--Projeto: ULA de 4 bits com 8 funcionalidades, como segue com os respectivos códigos: 
--         Soma A+B (000),
--         Subtração A-B (001), 
--         Incremento de A em 1 unidade (010),
--         Troca de Sinal de A (011), 
--         Multiplicação de A por 2 (100), 
--         Deslocamento lógico de A à direita (101), 
--         Deslocamento lógico de A à esquerda (110),
--         Decremento de A em 1 unidade (111).
--         Além disso, com flags de saída zero, negativo, carry out e overflow.



library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



--Portas da Entidade ULA_4bits:
--A = Vetor de entrada A (4 bits), B = Vetor de entrada B (4 bits)
--SELETOR = Codigo para seleção do comando a ser executado pela ULA (3 bits)
--SAIDA = Vetor resultado da operação (4 bits)
--ZERO, NEG, COUT, OV = Flags de saída zero, negativo, carry out e overflow, respectivamente

ENTITY ULA_4bits IS
    
PORT ( V_SW: in STD_LOGIC_VECTOR(10 downto 0);         --ENTRADAS: SELETOR(2 downto 0), A(6 downto 3), B(10 downto 7)
	G_HEX0: out STD_LOGIC_VECTOR(6 downto 0);         --SAIDA da ULA
	G_LEDR: out STD_LOGIC_VECTOR(3 downto 0);         --ZERO, NEG, COUT, OV nessa ordem (3 downto 0)
	G_HEX2: out STD_LOGIC_VECTOR(6 downto 0);      --Saida para exibir o valor de entrada A no display
	G_HEX1: out STD_LOGIC_VECTOR(6 downto 0) );    --Saida para exibir o valor de entrada B no display
		 
END ULA_4bits;


ARCHITECTURE ULA_4bits_architecture OF ULA_4bits IS

         signal S_SOMA, S_SUBTRACAO, S_INCREMENTO,
		        S_TROCA_SINAL, S_DOBRO, S_DESLOCAMENTO_DIREITA, 
				S_DESLOCAMENTO_ESQUERDA, S_DECREMENTO: STD_LOGIC_VECTOR(3 downto 0);    --Sinais que vão guardar os resultados de cada operação
		 signal S_COUT_SOM, S_COUT_SUB, S_COUT_INC, S_COUT_DEC, 
		        S_OV_SOM, S_OV_SUB, S_OV_INC, S_OV_DEC, S_OV_DOBRO, S_OV_TS: STD_LOGIC;  	    --Sinais que vão guardar as flags de Carry Out e Overflow de cada operação 
		 signal S_SAIDA: STD_LOGIC_VECTOR(3 downto 0);                                 
		 
		 

--Mapeamento dos componentes:

COMPONENT SOMADOR_4bits PORT (
         A, B: in STD_LOGIC_VECTOR(3 downto 0);
		 Carry_in: in STD_LOGIC;
         Soma: out STD_LOGIC_VECTOR(3 downto 0);
		 Carry_out: out STD_LOGIC;
		 Overflow: out STD_LOGIC );
END COMPONENT;


COMPONENT DESLOCADOR_4bits PORT (
         A: in STD_LOGIC_VECTOR(3 downto 0);
		 Seletor_direcao: in STD_LOGIC;     -- 0=esquerda; 1=direita
		 A_Deslocado: out STD_LOGIC_VECTOR(3 downto 0));
END COMPONENT;


COMPONENT DOBRO_4bits PORT (
         A: in STD_LOGIC_VECTOR(3 downto 0);
		 Dobro: out STD_LOGIC_VECTOR(3 downto 0);
		 Overflow: out STD_LOGIC);
END COMPONENT;


COMPONENT dec7seg PORT (       --Converte a entrada binaria para saida em representação hexadecimal no display de 7 segmentos      
        hex_digit: in std_logic_vector(3 downto 0);
	    segment_7dis: out std_logic_vector(0 to 6));
END COMPONENT;


BEGIN

--Exibir as entradas nos displays de 7 segmentos HEX0 e HEX1:

ENTRADA_A_7seg: dec7seg PORT MAP (V_SW(6 downto 3), G_HEX2);

ENTRADA_B_7seg: dec7seg PORT MAP (V_SW(10 downto 7), G_HEX1);


--Realização das operações da ULA para posterior seleção:

SOMA:SOMADOR_4bits PORT MAP(V_SW(6 downto 3), V_SW(10 downto 7), '0', S_SOMA, S_COUT_SOM, S_OV_SOM);

SUBTRACAO:SOMADOR_4bits PORT MAP(V_SW(6 downto 3), NOT V_SW(10 downto 7), '1', S_SUBTRACAO, S_COUT_SUB, S_OV_SUB);

INCREMENTO:SOMADOR_4bits PORT MAP(V_SW(6 downto 3), "0001", '0', S_INCREMENTO, S_COUT_INC, S_OV_INC);

TROCA_SINAL:SOMADOR_4bits PORT MAP(NOT V_SW(6 downto 3), "0001", '0', S_TROCA_SINAL, open, S_OV_TS); -- Complemento de 2 de A (bits de A invertidos + 1 unidade)

DOBRO:DOBRO_4bits PORT MAP(V_SW(6 downto 3), S_DOBRO, S_OV_DOBRO);

DESLOCAMENTO_DIREITA:DESLOCADOR_4bits PORT MAP(V_SW(6 downto 3), '1', S_DESLOCAMENTO_DIREITA);

DESLOCAMENTO_ESQUERDA:DESLOCADOR_4bits PORT MAP(V_SW(6 downto 3), '0', S_DESLOCAMENTO_ESQUERDA);

DECREMENTO:SOMADOR_4bits PORT MAP(V_SW(6 downto 3), NOT "0001", '1', S_DECREMENTO, S_COUT_DEC, S_OV_DEC); -- A + Complemento de 2 de "0001" = A - 0001



--Seleção da funcionalidade que a ULA vai realizar:
    
		 WITH V_SW(2 downto 0) SELECT   
		    S_SAIDA <= S_SOMA WHEN "000",
			           S_SUBTRACAO WHEN "001",
					   S_INCREMENTO WHEN "010",
					   S_TROCA_SINAL WHEN "011",
					   S_DOBRO WHEN "100",
					   S_DESLOCAMENTO_DIREITA WHEN "101",
					   S_DESLOCAMENTO_ESQUERDA WHEN "110",
					   S_DECREMENTO WHEN "111",
					   "0000" WHEN OTHERS;      --- Para faltas de alta impedância etc


--Mandar o resultado da operação selecionada para o display de 7 segmentos HEX3:


SAIDA_7seg: dec7seg PORT MAP (S_SAIDA, G_HEX0);			
						
						

--Seleção do valor a ser mandado para a flag de Carry Out:		
				
		 WITH V_SW(2 downto 0) SELECT
		    G_LEDR(1) <= S_COUT_SOM WHEN "000",
			     S_COUT_SUB WHEN "001",
			   	 S_COUT_INC WHEN "010",
				 S_COUT_DEC WHEN "111",
				 '0' WHEN OTHERS;
					
					
					
--Seleção do valor a ser mandado para a flag de Overflow:	
					
		 WITH V_SW(2 downto 0) SELECT
		    G_LEDR(0) <= S_OV_SOM WHEN "000",
			     S_OV_SUB WHEN "001",
				 S_OV_INC WHEN "010",
				 S_OV_DEC WHEN "111",
				 S_OV_DOBRO WHEN "100",
				 S_OV_TS WHEN "011",
				 '0' WHEN OTHERS;
				 
				 
					   	
--Seleção do valor a ser mandado para a flag de Zero:

         G_LEDR(3) <= '1' WHEN S_SAIDA = "0000" ELSE
		      '0';
				
				

--Seleção do valor a ser mandado para a flag de Negativo:
       
		 G_LEDR(2) <= '1' WHEN S_SAIDA(3) = '1' ELSE
		     '0';




END ULA_4bits_architecture;


