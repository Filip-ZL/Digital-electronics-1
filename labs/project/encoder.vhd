library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

 

entity encoder is
    generic(
        g_NPERIOD: integer  := 2
    );
    port(
        clk_i, clock_enable : in std_logic;
        UI : in std_logic_vector(2-1 downto 0);
        pulse_A, pulse_B, com : out std_logic
    );
end entity;

 

architecture Behavioral of encoder is    
begin
    signals: process(clk_i, UI)
    begin
        if UI = "01" then
			com   <= '1';
            if rising_edge(clk_i) then
                pulse_A  <= clock_enable;
            end if;
            if falling_edge(clk_i) then
                pulse_B  <= clock_enable;
            end if;
        elsif UI = "10" then
		    com   <= '1';
            if rising_edge(clk_i) then
                pulse_B  <= clock_enable;
            end if;
            if falling_edge(clk_i) then
                pulse_A  <= clock_enable;
            end if;
        elsif UI = "00" then
		      com   <= '1';
            pulse_A <= '1';
            pulse_B  <= '1';
        else
            com  <= '0';
            
        end if;
    
    end process;

 

    
end Behavioral;

