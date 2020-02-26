----------------------------------------------------------------------------------
--Data Transmition
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Data_Transmit is
    Port ( START : in STD_LOGIC; 
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR (7 downto 0);
           EOT : out STD_LOGIC;
           TxD : out STD_LOGIC);
end Data_Transmit;

architecture Behavioral of Data_Transmit is
--Signal declaration
signal SYN, FIN, LDI, PAR, STT : STD_LOGIC;
signal DATA : STD_LOGIC_VECTOR (7 downto 0);
signal SEL : STD_LOGIC_VECTOR (3 downto 0);

--LATCH
component Data_Latch is
    Port ( LDI : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR (7 downto 0);
           DATA : out STD_LOGIC_VECTOR (7 downto 0));
end component;
--Demultiplexer
component Data_Demultiplexer is
    Port ( PAR : in STD_LOGIC;
           SEL : in STD_LOGIC_VECTOR (3 downto 0);
           DATA : in STD_LOGIC_VECTOR (7 downto 0);
           TxD : out STD_LOGIC);
end component;
--Parity check
component Parity_Check is
    Port ( DATA : in STD_LOGIC_VECTOR (7 downto 0);
           PAR_N : out STD_LOGIC);
end component;
--Time Base
component Time_Base_Generic is
    generic (n : integer := 8);
    Port ( ENA : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           FIN : out STD_LOGIC;
           CONT : in STD_LOGIC_VECTOR (n-1 downto 0));
end component;
--FSM
component Transmition_FSM is
    Port ( STT : in STD_LOGIC;
           FIN : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           EOT : out STD_LOGIC;
           LDI : out STD_LOGIC;
           SYN : out STD_LOGIC;
           SEL : out STD_LOGIC_VECTOR (3 downto 0));
end component;
begin
    U0: Transmition_FSM port map (STT, FIN, CLK, RST, EOT, LDI, SYN, SEL);
    U1: Time_Base_Generic generic map(13)
                          port map(SYN,CLK,RST,FIN,"1010001011000");
    U2: Time_Base_Generic generic map(27)
                          port map(START,CLK,RST,STT,"101111101011110000100000000");
    U3: Parity_Check port map(DATA, PAR);
    U4: Data_Demultiplexer port map(PAR, SEL, DATA, TxD);
    U5: Data_Latch port map (LDI, CLK, RST, DIN, DATA);
end Behavioral;