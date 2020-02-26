----------------------------------------------------------------------
-- H Bridge DC Motor Top module
----------------------------------------------------------------------

library ieee;   
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity H_Bridge_DC_Motor is
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
end H_Bridge_DC_Motor;

architecture Behavioral of H_Bridge_DC_Motor is
	signal r_PWM_Pulse : std_logic := '0';
	signal r_PWM_N_Pulse : std_logic := '0';        
	--DC motor direction FSM
	component H_Bridge_Direction is
		generic(
			g_FORWARD 			: std_logic_vector := "01";
			g_REVERSE			: std_logic_vector := "10";
			g_HOLD				: std_logic_vector := "11";
			g_LIMIT_OFF			: std_logic_vector := "11"
		);
		port(
			i_Clk                : in std_logic;
			i_H_Bridge_Enable    : in std_logic;
			i_PWM_Pulse          : in std_logic;
			i_PWM_N_Pulse        : in std_logic;
			i_Control_Stick      : in std_logic_vector(1 downto 0);
			i_Limit_Switch       : in std_logic_vector(1 downto 0);
			o_H_Bridge_Direction : out std_logic;
			o_H_Bridge_Enable    : out std_logic;
			o_H_Bridge_PWM       : out std_logic
		);
	end component;
	--DC motor PWM signal
	component H_Bridge_PWM is
		generic(
			g_SYS_CLK         : integer := 100000000;
			g_PWM_FREQUENCY   : integer := 2000;
			g_BITS_RESOLUTION : integer := 10
		);
		port(
			i_Clk         : in std_logic;
			i_Duty_Cycle  : in std_logic_vector((g_BITS_RESOLUTION-1) downto 0);
			o_PWM_Pulse   : out std_logic;
			o_PWM_N_Pulse : out std_logic
		);
	end component;
	begin
		U0 : H_Bridge_Direction generic map (g_FORWARD, g_REVERSE, g_HOLD, g_LIMIT_OFF)
		port map(
			i_Clk,
			i_H_Bridge_Enable,
			r_PWM_Pulse,
			r_PWM_N_Pulse,
			i_Control_Stick,
			i_Limit_Switch,
			o_H_Bridge_Direction,
			o_H_Bridge_Enable,
			o_H_Bridge_PWM
		);
		U1 : H_Bridge_PWM generic map (100000000, 2000, g_BITS_RESOLUTION_PWM)
		port map(
			i_Clk,
			i_Duty_Cycle,
			r_PWM_Pulse,
			r_PWM_N_Pulse
		);
end Behavioral;