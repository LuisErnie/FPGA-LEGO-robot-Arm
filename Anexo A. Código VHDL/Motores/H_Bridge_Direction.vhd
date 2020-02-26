----------------------------------------------------------------------
-- H Bridge DC Motor State Machine
----------------------------------------------------------------------
-- Set Generic g_FORWARD as the control stick value when motor is on forward
-- Set Generic g_REVERSE as the control stick value when motor is on reverse
-- Set Generic g_HOLD as the analog stick value when motor is on hold

library ieee;   
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity H_Bridge_Direction is
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
		--o_H_Bridge_State     : out std_logic_vector(3 downto 0);
		o_H_Bridge_Direction : out std_logic;
		o_H_Bridge_Enable    : out std_logic;
		o_H_Bridge_PWM       : out std_logic
	);
end H_Bridge_Direction;

architecture Behavioral of H_Bridge_Direction is
	type t_SM_Main is (s_Idle, s_Motor_Forward, s_Motor_Reverse, s_Motor_Hold);
	signal r_SM_Main : t_SM_Main := s_Idle;
begin
	-- Purpose: Control the state of the motor
	p_Motor_FSM : process (i_Clk)  
	begin
		if rising_edge(i_Clk) then
			case r_SM_Main is
				when s_Idle =>
					o_H_Bridge_Enable    <= '0';
					o_H_Bridge_Direction <= '0';
					o_H_Bridge_PWM       <= '0';
					--o_H_Bridge_State		<= "0001";
					if i_H_Bridge_Enable = '1' then
						r_SM_Main <= s_Motor_Hold;
					else
						r_SM_Main <= s_Idle;
					end if;
				-- Hold Motor Position
				when s_Motor_Hold =>
					o_H_Bridge_Enable    <= '1';
					o_H_Bridge_Direction <= '1';
					o_H_Bridge_PWM       <= '1';
					--o_H_Bridge_State		<= "0010";
					if i_H_Bridge_Enable = '1' then
						if i_Control_Stick = g_HOLD then
							r_SM_Main <= s_Motor_Hold;
						else
							if i_Limit_Switch = g_LIMIT_OFF then
								if i_Control_Stick = g_FORWARD then
									r_SM_Main <= s_Motor_Forward;
								elsif i_Control_Stick = g_REVERSE then
									r_SM_Main <= s_Motor_Reverse;
								else
									r_SM_Main <= s_Motor_Hold;
								end if;
							else
								r_SM_Main <= s_Motor_Hold;
							end if;
						end if;
					else
						r_SM_Main <= s_Idle;
					end if;
				-- Move the motor in the forward direction           
				when s_Motor_Forward =>
					o_H_Bridge_Enable    <= '1';
					o_H_Bridge_Direction <= '1';
					o_H_Bridge_PWM       <= i_PWM_N_Pulse;
					--o_H_Bridge_State		<= "0100";
					if i_H_Bridge_Enable = '1' then
						if i_Limit_Switch = g_LIMIT_OFF then
							if i_Control_Stick = g_FORWARD then						
								r_SM_Main <= s_Motor_Forward;
							else
								r_SM_Main <= s_Motor_Hold;
							end if;
						else
							r_SM_Main <= s_Motor_Hold;
						end if;
					else
						r_SM_Main <= s_Idle;
					end if;
				-- Move the motor in the forward direction           
				when s_Motor_Reverse =>
					o_H_Bridge_Enable    <= '1';
					o_H_Bridge_Direction <= '0';
					o_H_Bridge_PWM       <= i_PWM_Pulse;
					--o_H_Bridge_State		<= "1000";
					if i_H_Bridge_Enable = '1' then
						if i_Limit_Switch = g_LIMIT_OFF then
							if i_Control_Stick = g_REVERSE then						
								r_SM_Main <= s_Motor_Reverse;
							else
								r_SM_Main <= s_Motor_Hold;
							end if;
						else
							r_SM_Main <= s_Motor_Hold;
						end if;
					else
						r_SM_Main <= s_Idle;
					end if;
				when others =>
					r_SM_Main <= s_Idle;
			end case;
		end if;
	end process p_Motor_FSM;
end Behavioral;