----------------------------------------------------------------------------------
--Data Transmition Parity Check
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Parity_Check is
    Port (DATA : in STD_LOGIC_VECTOR (7 downto 0);
          PAR_N : out STD_LOGIC);
end Parity_Check;

architecture Behavioral of Parity_Check is
signal Q1, Q2, Q3, Q4, Q5, Q6, Q7 : STD_LOGIC;
begin
    --Combinational process
    combinacional : process (DATA, Q1, Q2, Q3, Q4, Q5, Q6, Q7)
    begin
        Q1 <= DATA(0) XOR DATA(1);
        Q2 <= DATA(2) XOR DATA(3);
        Q3 <= DATA(4) XOR DATA(5);
        Q4 <= DATA(6) XOR DATA(7);
        
        Q5 <= Q1 XOR Q2;
        Q6 <= Q3 XOR Q4;
        
        Q7 <= Q5 XOR Q6;
        
        PAR_N <= Q7;
    end process combinacional;
end Behavioral;