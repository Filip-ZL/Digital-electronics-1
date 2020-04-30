library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

 

entity analyser is
    port(
        srst_n_i: in std_logic;
        A_i,B_i: in std_logic;
        plus_o,minus_o : out std_logic
       
    );
end entity;

 

architecture arch of analyser is
    signal plus: std_logic  := '0';
    signal minus: std_logic := '0';
begin
    p_cnt: process(A_i, B_i)
    begin
        if(falling_edge(A_i) and B_i = '1') then
            plus  <= '1';
            minus  <= '0';
        elsif(falling_edge(B_i) and A_i = '1') then
            minus  <= '1';
            plus  <= '0';
        else
            minus  <= '0';
            plus  <= '0';
        end if;
    end process;
    plus_o  <= plus;
    minus_o  <= minus;
    
     
end arch;