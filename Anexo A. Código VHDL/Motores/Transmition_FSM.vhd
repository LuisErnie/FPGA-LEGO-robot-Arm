----------------------------------------------------------------------------------
--Data Transmition FSM, control the data flow trought the transmition process
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Transmition_FSM is
    Port ( STT : in STD_LOGIC;
           FIN : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           EOT : out STD_LOGIC;
           LDI : out STD_LOGIC;
           SYN : out STD_LOGIC;
           SEL : out STD_LOGIC_VECTOR (3 downto 0));
end Transmition_FSM;

architecture Behavioral of Transmition_FSM is
Signal Qp, Qn : STD_LOGIC_VECTOR (3 downto 0);
begin
    --Combinational process
    combinacional : process (STT, FIN, Qp)
    begin
        case Qp is
            --IDLE State
            when "0000" =>
                LDI<='0';
                EOT<='1';
                SEL<="0000";
                SYN<='0';
                if STT='1' then
                    Qn<="0001";
                else
                    Qn<=Qp;
                end if;
            --Start
            when "0001" =>
                LDI<='1';
                EOT<='0';
                SEL<="0001";
                SYN<='1';
                if FIN='1' then
                    Qn<="0010";
                else
                    Qn<=Qp;
                end if;
            --BIT 0
            when "0010" =>
                LDI<='0';
                EOT<='0';
                SEL<="0010";
                SYN<='1';
                if FIN='1' then
                    Qn<="0011";
                else
                    Qn<=Qp;
                end if;
            --BIT 1
            when "0011" =>
                LDI<='0';
                EOT<='0';
                SEL<="0011";
                SYN<='1';
                if FIN='1' then
                    Qn<="0100";
                else
                    Qn<=Qp;
                end if;
            --BIT 2
            when "0100" =>
                LDI<='0';
                EOT<='0';
                SEL<="0100";
                SYN<='1';
                if FIN='1' then
                    Qn<="0101";
                else
                    Qn<=Qp;
                end if;
            --BIT 3
            when "0101" =>
                LDI<='0';
                EOT<='0';
                SEL<="0101";
                SYN<='1';
                if FIN='1' then
                    Qn<="0110";
                else
                    Qn<=Qp;
                end if;
            --BIT 4
            when "0110" =>
                LDI<='0';
                EOT<='0';
                SEL<="0110";
                SYN<='1';
                if FIN='1' then
                    Qn<="0111";
                else
                    Qn<=Qp;
                end if;
            --BIT 5
            when "0111" =>
                LDI<='0';
                EOT<='0';
                SEL<="0111";
                SYN<='1';
                if FIN='1' then
                    Qn<="1000";
                else
                    Qn<=Qp;
                end if;
            --BIT 6
            when "1000" =>
                LDI<='0';
                EOT<='0';
                SEL<="1000";
                SYN<='1';
                if FIN='1' then
                    Qn<="1001";
                else
                    Qn<=Qp;
                end if;
            --BIT 7
            when "1001" =>
                LDI<='0';
                EOT<='0';
                SEL<="1001";
                SYN<='1';
                if FIN='1' then
                    Qn<="0000";
                else
                    Qn<=Qp;
                end if;
            --Bit Stop
            when others =>
                LDI<='1';
                EOT<='1';
                SEL<="0000";
                SYN<='0';
                Qn<="0000";
        end case;
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