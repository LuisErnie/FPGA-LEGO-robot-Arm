----------------------------------------------------------------------
-- Pulse Width Modulation With Variable Duty Cycle
----------------------------------------------------------------------
-- Set Generic g_SYS_CLK as the desired system clock frequency in Hz
-- Set Generic g_PWM_FREQUENCY as the desired pwm frequency in Hz
-- Set Generic g_BITS_RESOLUTION as follows
-- g_BITS = (LN(maximum value pwm)/(LN(2))

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity H_Bridge_PWM is
	generic(
		g_SYS_CLK         : integer := 100000000;
      g_PWM_FREQUENCY	: integer := 2000;
		g_BITS_RESOLUTION : integer := 10
	);
	port(
		i_Clk         : in std_logic;
		i_Duty_Cycle  : in std_logic_vector((g_BITS_RESOLUTION-1) downto 0);
		o_PWM_Pulse   : out std_logic;
		o_PWM_N_Pulse : out std_logic
	);
end H_Bridge_PWM;

architecture Behavioral of H_Bridge_PWM is
    constant r_period   :  integer := g_SYS_CLK/g_PWM_FREQUENCY;    --number of clocks in 1 pwm period
    signal r_count      :  integer  range 0 to r_period := 0;       --number of clock cycles in 1 duty cycle
    signal r_half_duty  :  integer range 0 to r_period/2 := 0;      --number of clock cycles in 1/2 duty cycle
 begin
    -- Purpose: Increment Counter
    p_PWM_Counter : process (i_Clk, r_count, r_half_duty)  
    begin
    if i_Clk'event and i_Clk = '1' then
        if r_count = r_period - 1 then
            r_count <= 0;
            r_half_duty <= conv_integer(i_Duty_Cycle)*r_period/(2**g_BITS_RESOLUTION)/2; --set most recent duty cycle value
        else
            r_count <= r_count + 1;
        end if;
    end if;
    end process p_PWM_Counter;
    -- Purpose: Output PWM and N_PWM signals
    p_PWM_Output: process (i_Clk, r_count, r_half_duty)
    begin
        if i_Clk'event and i_Clk = '1' then
            if r_count = r_half_duty then
                o_PWM_Pulse   <= '0';
                o_PWM_N_Pulse <= '1';
            elsif r_count = (r_period-r_half_duty) then
                o_PWM_Pulse   <= '1';
                o_PWM_N_Pulse <= '0';
            end if;
        end if;        
    end process p_PWM_Output;
end Behavioral;