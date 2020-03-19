------------------------------------------------------------------------
--
-- N-bit binary counter.
-- Xilinx XC2C256-TQ144 CPLD, ISE Design Suite 14.7
--
-- Copyright (c) 2019-2020 Dusek Jasek
-- Dept. of Radio Electronics, Brno University of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    

------------------------------------------------------------------------
-- Entity declaration for Stopwatch
------------------------------------------------------------------------
entity stopwatch is

port (
    clk_i    : in  std_logic;
    srst_n_i : in  std_logic;   -- Synchronous reset (active low)
    ce_100Hz_i: in  std_logic;   -- Counting 10ms
	 cnt_en_i : in   std_logic;   -- Stopwatch eneble
	 
    sec_h_o  : out std_logic_vector(4-1 downto 0); --counter for tens of seconds
	 sec_l_o  : out std_logic_vector(4-1 downto 0); --counter for seconds
	 hth_h_o  : out std_logic_vector(4-1 downto 0); --counter for tenths of seconds
	 hth_l_o  : out std_logic_vector(4-1 downto 0) --counter for hundredths of seconds
);
end entity stopwatch;

------------------------------------------------------------------------
-- Architecture declaration for stopwatch
------------------------------------------------------------------------
architecture Behavioral of stopwatch is
    signal s_cnt0 : unsigned(4-1 downto 0) := (others => '0');
    signal s_cnt1 : unsigned(4-1 downto 0) := (others => '0');
    signal s_cnt2 : unsigned(4-1 downto 0) := (others => '0');
    signal s_cnt3 : unsigned(4-1 downto 0) := (others => '0');
	 signal cnt_en : std_logic;
begin

    --------------------------------------------------------------------
    -- p_stopwatch_cnt:
    --------------------------------------------------------------------
    p_stopwatch_cnt : process(clk_i)
    begin
        if rising_edge(clk_i) then  -- Rising clock edge
            if srst_n_i = '0' then 	-- Synchronous reset (active low)
					 s_cnt0 <= (others=> '0');   -- Clear all bits
                s_cnt1 <= (others=> '0');   -- Clear all bits
                s_cnt2 <= (others=> '0');   -- Clear all bits
                s_cnt3 <= (others=> '0');   -- Clear all bits		

            elsif cnt_en_i = '1' then
					IF ce_100Hz_i = '1' then
					
						if s_cnt0 = "1001" then
							s_cnt0  <=(others => '0');
							
							if s_cnt1 = "1001" then
								s_cnt1  <=(others => '0');
							
								if s_cnt2 = "1001" then
									s_cnt2  <=(others => '0');

									if s_cnt3 = "0101" then
										s_cnt3  <=(others => '0');
									else 
										s_cnt3 <= s_cnt3 + "0001";
									end if;
									
								else 
									s_cnt2 <= s_cnt2 + "0001";	
								end if;
								
							else 
								s_cnt1 <= s_cnt1 + "0001";
							end if;
							
						else 
							s_cnt0 <= s_cnt0 + "0001";
						end if;
						
					END IF;
					
            end if;
				
        end if;
    end process p_stopwatch_cnt;

        hth_l_o <= std_logic_vector(s_cnt0);
        hth_h_o <= std_logic_vector(s_cnt1);
        sec_l_o <= std_logic_vector(s_cnt2);
        sec_h_o <= std_logic_vector(s_cnt3);    

end architecture Behavioral;

