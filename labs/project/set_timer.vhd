library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;   
use ieee.std_logic_unsigned.all;
------------------------------------------------------------------------
-- Entity declaration for Stopwatch
------------------------------------------------------------------------
entity set_timer is
port (
     clk_i    : in  std_logic;
     srst_n_i : in  std_logic;   -- Synchronous reset (active low)
     plus_i,minus_i  : in std_logic;
     com_i     : in std_logic;
     
     sec_h_o  : out std_logic_vector(4-1 downto 0); --counter for tens of seconds
     sec_l_o  : out std_logic_vector(4-1 downto 0); --counter for seconds
     min_h_o  : out std_logic_vector(4-1 downto 0); --counter for tens of minutes
     min_l_o  : out std_logic_vector(4-1 downto 0); --counter for minutes
     pwm_sec_o : out std_logic_vector(12-1 downto 0); -- var value for pwm generator
     pwm_max_o : out std_logic_vector(12-1 downto 0) -- maximal value for pwm generator
);
end entity set_timer;
------------------------------------------------------------------------
-- Architecture declaration for stopwatch
------------------------------------------------------------------------
architecture Behavioral of set_timer is  
    signal s_cnt0 : unsigned(4-1 downto 0) := (others => '0'); -- seconds 
    signal s_cnt1 : unsigned(4-1 downto 0) := (others => '0'); -- ten of seconds
    signal s_cnt2 : unsigned(4-1 downto 0) := (others => '0'); -- minutes
    signal s_cnt3 : unsigned(4-1 downto 0) := (others => '0'); -- ten of minutes
    signal pwm_counter: unsigned(12 - 1 downto 0)  := (others  => '0');
	 signal pwm_max_s: unsigned(12 - 1 downto 0)  := (others  => '0');
    signal com_s : std_logic  := '1';
begin
    counter: process(plus_i,minus_i, clk_i, com_i)
    begin
    	if com_i = '0' then
						    				


    		if com_s  <= '1' then
    			com_s  <= '0';
    		else
    			com_s  <= '1';

    		end if;
    	end if;
   	if com_s = '1' then
    	if srst_n_i = '0' then
    		s_cnt0  <= (others  => '0');
    		s_cnt1  <= (others  => '0');
    		s_cnt2  <= (others  => '0');
    		s_cnt3  <= (others  => '0');
    		com_s  <= '1';
    		pwm_counter  <= (others  => '0');
    	else
--	  --------------------------------------------------------------------
--    -- counting up
--	  --------------------------------------------------------------------
			if (plus_i = '1') then
				if s_cnt0 = x"9" and s_cnt1 = x"5" and s_cnt2 = x"9" and s_cnt3 = x"5" then
					pwm_counter  <= x"E0F";
				else
					pwm_counter  <= pwm_counter +1;
				   pwm_max_s  <= pwm_counter ;

--					pwm_max_o  <= std_logic_vector(pwm_counter);
				end if;
	    		if s_cnt0 = x"9" then
	    			-- if seconds are count to 10
	    			s_cnt0  <= (others  => '0');
	    			s_cnt1  <= s_cnt1 +1;
	    			if s_cnt1  = x"5" then
	    				--if ten of seconds are equal to 6
	    				s_cnt1  <= (others  => '0');
	    				s_cnt2  <= s_cnt2 +1;
	    				if s_cnt2 = x"9" then
	    					-- if minutes are equal to 10
	    					s_cnt2  <= (others  => '0');
	    					s_cnt3  <= s_cnt3 +1;
	    					if s_cnt3  = x"5" then
	    						-- if ten of minutes are equal to 6
	    						s_cnt0  <= x"9";
	    						s_cnt1  <= x"5";
	    						s_cnt2  <= x"9";
	    						s_cnt3  <= x"5";
	    					else
	    						s_cnt3  <= s_cnt3 +1;
	    					end if;
	    				else
	    					s_cnt2  <=  s_cnt2 +1;
	    				end if;
	    			else
	    				s_cnt1  <= s_cnt1 +1;
	    			end if;
	    		else
	    			s_cnt0 <= s_cnt0 +1;
	    		end if;
	    	end if;
--	  --------------------------------------------------------------------
--    -- counting down
--	  --------------------------------------------------------------------
			if (minus_i = '1') then
				if pwm_counter  = x"0" then
					pwm_counter  <= (others  => '0');
					pwm_max_s  <= pwm_counter ;
--					pwm_max_o  <= std_logic_vector(pwm_counter);
				else
					pwm_counter  <= pwm_counter -1;
					pwm_max_s  <= pwm_counter ;
--					pwm_max_o  <= std_logic_vector(pwm_counter);
				end if;
				if s_cnt0 = x"0" then
					--- when seconds are equal to 0
					if s_cnt1 = x"0" then
						-- when ten of seconds are equal to 0
						if s_cnt2 = x"0" then
							-- when minutes are equal to 0
							if s_cnt3 = x"0" then
								-- when ten of minutes are equal to 0
								s_cnt0  <= (others  => '0');
								s_cnt1  <= (others  => '0');
								s_cnt2  <= (others => '0');
								s_cnt3  <= (others  => '0');
							else
								s_cnt3  <= s_cnt3 -1;
								s_cnt2  <= x"9";
							end if;
						else
							s_cnt2  <= s_cnt2 -1;
							s_cnt1  <= x"5";
						end if;
					else
						s_cnt1  <= s_cnt1 -1;
						s_cnt0  <= x"9";
					end if;
				else
					s_cnt0  <= s_cnt0 -1;
				end if;
			end if;
		end if;
	elsif com_s = '0' then
--    --------------------------------------------------------------------
--    -- p_stopwatch_cnt:
--    --------------------------------------------------------------------
    		if rising_edge(clk_i) then
    			if srst_n_i = '0' then
    				s_cnt0  <= (others  => '0');
    				s_cnt1  <= (others  => '0');
    				s_cnt2  <= (others  => '0');
    				s_cnt3  <= (others  => '0');
    				pwm_counter <= (others  => '0');
    				com_s  <= '1';
    			else
    				if pwm_counter = "0" then
    					pwm_counter  <= (others  => '0');
    				else
    					pwm_counter  <= pwm_counter -1;
    				end if;
					 pwm_max_o <= std_logic_vector(pwm_max_s);
					 pwm_sec_o  <= std_logic_vector(pwm_counter);
					 
    				if s_cnt0 = x"0" then
					   s_cnt0  <= x"9";

    					-- count seconds down
    					if s_cnt1 = x"0" then
						   s_cnt1  <= x"5";
						
    						-- count ten of seconds down
    						if s_cnt2 = x"0" then
							   s_cnt2  <= x"9";
    							-- count minutes down
    							if s_cnt3 = x"0" then
    								-- count ten of minutes down
									s_cnt0  <= (others  => '0');
									s_cnt1  <= (others  => '0');
									s_cnt2  <= (others => '0');
									s_cnt3  <= (others  => '0');
									com_s  <= '1';
    							else
    								s_cnt3  <= s_cnt3 -1;

    							end if;
    						else
    							s_cnt2  <= s_cnt2 -1;

    						end if;
    					else
    						s_cnt1  <= s_cnt1 -1;
    					end if;
    				else
    					s_cnt0 <= s_cnt0 -1;
    				end if; 
    			end if;
    		end if;
    	end if;

	
    end process counter;

        min_h_o <= std_logic_vector(s_cnt3);
        min_l_o <= std_logic_vector(s_cnt2);
        sec_h_o <= std_logic_vector(s_cnt1);
        sec_l_o <= std_logic_vector(s_cnt0); 

end architecture Behavioral;