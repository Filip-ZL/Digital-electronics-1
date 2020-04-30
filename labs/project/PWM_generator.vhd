library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

 

entity pwm is
    generic(
        val_bits: integer := 12
    );
    port(
        clk_i, srst_n_i: in std_logic;
        val_cur: in std_logic_vector((val_bits -1) downto 0);
        max_val: in std_logic_vector((val_bits -1) downto 0);
        pulse: out std_logic
    );
end entity;

 

architecture arch of pwm is
    signal cnt: std_logic_vector((val_bits -1) downto 0)  := (others  => '0');
    
begin

 

counting: process(clk_i) 
begin
    if rising_edge(clk_i) then
        if cnt > max_val then
            cnt  <= (others  => '0');
        else
            cnt  <= cnt +1;
        end if;
    end if;
end process;

 

pulsing: process(clk_i)
begin
    if falling_edge(clk_i) then
        if val_cur > cnt then
            pulse  <= '1';
        else
            pulse  <= '0';
        end if;
    end if;
end process;
end arch;