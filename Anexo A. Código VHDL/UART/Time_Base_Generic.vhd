----------------------------------------------------------------------------------
--Generic Time Base with 50MHz base clock (non-toggled)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Time_Base_Generic is
    generic (n : integer := 8);
    Port ( ENA : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           FIN : out STD_LOGIC;
           CONT : in STD_LOGIC_VECTOR (n-1 downto 0));
end Time_Base_Generic;

architecture Behavioral of Time_Base_Generic is
    signal Qp, Qn : STD_LOGIC_VECTOR (n-1 downto 0);
begin
    --Combinational process to asign next output state
    combinacional : process (Qp, ENA)
    begin
        if ENA='1' then
            if Qp<CONT then
                FIN<='0';
                Qn<=Qp+1;
            else
                FIN<='1';
                Qn<=(others=>'0');
            end if;
        else
            FIN<='0' ;
            Qn<=Qp;
        end if;
    end process combinacional;
    --Secuencial process to reset and asign present output state   
    secuencial : process (RST, CLK)
    begin
        if RST = '1' then
           Qp <= (others => '0');
        elsif CLK'event and CLK = '1' then
            Qp <= Qn;
        end if;
    end process secuencial;
end Behavioral;