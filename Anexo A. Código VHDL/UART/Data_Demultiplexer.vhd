----------------------------------------------------------------------------------
--Data Demultiplexer, controls the flow of bits into the Serial output
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Data_Demultiplexer is
    Port ( PAR : in STD_LOGIC;
           SEL : in STD_LOGIC_VECTOR (3 downto 0);
           DATA : in STD_LOGIC_VECTOR (7 downto 0);
           TxD : out STD_LOGIC);
end Data_Demultiplexer;

architecture Behavioral of Data_Demultiplexer is
begin
    --Combinational process
    combinacional : process (SEL)
    begin
        case SEL is
            when "0000" =>
                TxD <= '1';
            when "0001" =>
                TxD <= '0';
            when "0010" =>
                TxD <= DATA(0);
            when "0011" =>
                TxD <= DATA(1);
            when "0100" =>
                TxD <= DATA(2);
            when "0101" =>
                TxD <= DATA(3);
            when "0110" =>
                TxD <= DATA(4);
            when "0111" =>
                TxD <= DATA(5);
            when "1000" =>
                TxD <= DATA(6);
            when "1001" =>
                TxD <= DATA(7);
            when "1010" =>
                TxD <= PAR;
            when others =>
                TxD <= '1';
        end case;
    end process combinacional;
end Behavioral;