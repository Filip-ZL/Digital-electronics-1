library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity Traffic_controller is
	port(
    	clk_i    	: in  std_logic; 
        srst_n_i   	: in  std_logic;
        cnt_en_i 	: in  std_logic;        
        lights_o	: out std_logic_vector(5 downto 0)
		);
end entity Traffic_controller;

architecture Traffic of Traffic_controller is
    type state_type is (rg, ry, rr, gr, yr, rr2);
    
    signal position : state_type;
    signal count : unsigned(3 downto 0);
    
    constant SEC5: unsigned(3 downto 0) := "1111";
    constant SEC1: unsigned(3 downto 0) := "0011";
begin
    
	p_Controll_light : process (clk_i, srst_n_i, cnt_en_i)    
    begin
		if rising_edge(clk_i) then
            if srst_n_i = '0' then
                position <= rg;
                count <= x"0";
            elsif cnt_en_i = '1' then
				
				
                case position is
                    when rg =>
                        if count < SEC5 then
                            position <= rg;
                            count <= count + 1;
                        else
                            position <= ry;
                            count <= x"0";
                        end if;
								
								
								
                    when ry =>
                        if count < SEC1 then
                            position <= ry;
                            count <= count + 1;
                        else
                            position <= rr;
                            count <= x"0";
                        end if;  


								
                    when rr =>
                        if count < SEC1 then
                            position <= rr;
                            count <= count + 1;
                        else
                            position <= gr;
                            count <= x"0";
                        end if;
								
								
								
                    when gr =>
                        if count < SEC5 then
                            position <= gr;
                            count <= count + 1;
                        else
                            position <= yr;
                            count <= x"0";
                        end if; 


								
                    when yr =>
                        if count < SEC1 then
                            position <= yr;
                            count <= count + 1;
                        else
                            position <= rr2;
                            count <= x"0";
                        end if;


								
                    when rr2 =>
                        if count < SEC1 then
                            position <= rr2;
                            count <= count + 1;
                        else
                            position <= rg;
                            count <= x"0";
                        end if; 


								
                    when others =>
                        position <= rg;
								
								
								
                end case;
            end if;
        end if;    
    end process p_Controll_light;

	light_ON : process (position)
    begin
    	case position is
        	when rg => lights_o <= "011110";
            when ry => lights_o <= "011101";
            when rr => lights_o <= "011011";
            when gr => lights_o <= "110011";
            when yr => lights_o <= "101011";
            when rr2 => lights_o <= "011011";
            when others => lights_o <= "011110";
		end case;
	end process;
end Traffic;