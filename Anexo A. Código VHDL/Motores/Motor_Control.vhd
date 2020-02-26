----------------------------------------------------------------------
-- Motor Controller Top module
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Motor_Control is
	port(
		i_Clk          : in	std_logic;
		i_Duty_Cycle	: in	std_logic_vector(7 downto 0);
		
		i_Data_Start	: in	std_logic;
		i_Data_RST		: in	std_logic;
		o_Data_END		: out std_logic;
		o_Data_OUT		: out std_logic;
		
		i_Mux				: in	std_logic;
		o_Mux_Control	: out std_logic_vector(3 downto 0);
		o_Mux_Check		: out std_logic_vector(4 downto 0);
		
		o_Motor_0_Dir	: out std_logic;
		o_Motor_0_En	: out std_logic;
		o_Motor_0_PWM	: out std_logic;
		o_Motor_1_Dir	: out std_logic;
		o_Motor_1_En	: out std_logic;
		o_Motor_1_PWM  : out std_logic;
		o_Motor_2_Dir	: out std_logic;
		o_Motor_2_En	: out std_logic;
		o_Motor_2_PWM  : out std_logic;
		o_Motor_3_Dir	: out std_logic;
		o_Motor_3_En	: out std_logic;
		o_Motor_3_PWM  : out std_logic
	);
end Motor_Control;

architecture Behavioral of Motor_Control is
	--signal r_Duty_Cycle : std_logic_vector(9 downto 0):= "1100000000";
	signal r_Mux		  : std_logic_vector(15 downto 0):= "0000000000000000";
	--DC motor controller
	component H_Bridge_DC_Motor is
		generic(
			g_BITS_RESOLUTION_PWM : integer := 10;
			g_FORWARD 				 : std_logic_vector := "01";
			g_REVERSE				 : std_logic_vector := "10";
			g_HOLD					 : std_logic_vector := "11";
			g_LIMIT_OFF				 : std_logic_vector := "11"	
		);
		port(
			i_Clk                : in std_logic;
			i_H_Bridge_Enable    : in std_logic;
			i_Duty_Cycle         : in std_logic_vector((g_BITS_RESOLUTION_PWM-1) downto 0);
			i_Control_Stick      : in std_logic_vector(1 downto 0);
			i_Limit_Switch       : in std_logic_vector(1 downto 0);
			o_H_Bridge_Direction : out std_logic;
			o_H_Bridge_Enable    : out std_logic;
			o_H_Bridge_PWM       : out std_logic
		);	
	end component;
	--Input multiplexer controller
	component Mux_Control is
		generic(
			g_BITS  			: integer  := 16;
			g_BITS_CONTROL	: integer  := 4;
			g_CLKS_PER_BIT : integer  := 100000
		);
		port(
			i_Clk	         : in std_logic;
			i_Mux				: in std_logic;
			o_Mux_Control	: out std_logic_vector((g_BITS_CONTROL-1) downto 0);
			o_Mux			   : out std_logic_vector((g_BITS-1) downto 0)
		);
	end component;
	--UART Transmitter
	component Data_Transmit is
		port(
			START : in STD_LOGIC; 
			CLK 	: in STD_LOGIC;
			RST 	: in STD_LOGIC;
			DIN 	: in STD_LOGIC_VECTOR (7 downto 0);
			EOT 	: out STD_LOGIC;
			TxD 	: out STD_LOGIC
		);
	end component;
	begin
		U0 : H_Bridge_DC_Motor generic map (8, "10", "01", "00", "11")
		port map(
			i_Clk,
			r_Mux(4),
			i_Duty_Cycle,
			r_Mux(8 downto 7),
			r_Mux(1 downto 0),
			o_Motor_0_Dir,
			o_Motor_0_En,
			o_Motor_0_PWM
		);
		U1 : H_Bridge_DC_Motor generic map (8, "10", "01", "00", "11")
		port map(
			i_Clk,
			r_Mux(5),
			i_Duty_Cycle,
			r_Mux(10 downto 9),
			r_Mux(3 downto 2),
			o_Motor_1_Dir,
			o_Motor_1_En,
			o_Motor_1_PWM
		);
		U2 : H_Bridge_DC_Motor generic map (8, "10", "01", "00", "11")
		port map(
			i_Clk,
			r_Mux(6),
			i_Duty_Cycle,
			r_Mux(12 downto 11),
			"11",
			o_Motor_2_Dir,
			o_Motor_2_En,
			o_Motor_2_PWM
		);
		U3 : H_Bridge_DC_Motor generic map (8, "10", "01", "00", "11")
		port map(
			i_Clk,
			r_Mux(6),
			i_Duty_Cycle,
			r_Mux(14 downto 13),
			"11",
			o_Motor_3_Dir,
			o_Motor_3_En,
			o_Motor_3_PWM
		);
		U4 : Mux_Control generic map (16, 4, 100000)
		port map(
			i_Clk,
			i_Mux,
			o_Mux_Control,
			r_Mux
		);
		U5 : Data_Transmit
		port map(
			i_Data_Start,
			i_Clk,
			not i_Data_RST,
			i_Duty_Cycle,
			o_Data_END,
			o_Data_OUT
		);
end Behavioral;