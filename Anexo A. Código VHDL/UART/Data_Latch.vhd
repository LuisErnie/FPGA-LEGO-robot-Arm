----------------------------------------------------------------------------------
--Data Latch, retains data during transmition process
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Data_Latch is
    Port ( LDI : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR (7 downto 0);
           DATA : out STD_LOGIC_VECTOR (7 downto 0));
end Data_Latch;

architecture Behavioral of Data_Latch is
    signal Qp, Qn : STD_LOGIC_VECTOR (7 downto 0);
begin
    --Combinational process
    combinacional : process (LDI)
    begin
        if LDI='1' then
            Qn<=DIN;
        else
            Qn<=Qp;
        end if;
        DATA<=Qp;
    end process combinacional;
    --Secuencial process   
    secuencial : process (RST, CLK)
    begin
        if RST = '1' then
           Qp <= (others => '0');
        elsif CLK'event and CLK = '1' then
            Qp <= Qn;
        end if;
    end process secuencial;
end Behavioral;