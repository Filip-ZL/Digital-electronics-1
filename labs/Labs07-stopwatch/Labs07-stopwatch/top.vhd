------------------------------------------------------------------------
--
-- Driver for seven-segment displays.
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
-- Entity declaration for display driver
------------------------------------------------------------------------
entity driver_7seg is
port (
    clk_i    : in  std_logic;
    srst_n_i : in  std_logic;   -- Synchronous reset (active low)
    cnt_en_i : in  std_logic;   -- Input logic

    seg_o    : out std_logic_vector(7-1 downto 0);
    dig_o    : out std_logic_vector(4-1 downto 0)
);
end entity driver_7seg;

------------------------------------------------------------------------
-- Architecture declaration for display driver
------------------------------------------------------------------------
architecture Behavioral of driver_7seg is
	 signal data0_i  : unsigned(4-1 downto 0);  
    signal data1_i  : unsigned(4-1 downto 0);
    signal data2_i  : unsigned(4-1 downto 0);
    signal data3_i  : unsigned(4-1 downto 0);
    signal s_en  : std_logic;
    signal s_hex : std_logic_vector(4-1 downto 0);
    signal s_cnt : std_logic_vector(2-1 downto 0) := "00";
begin

    --------------------------------------------------------------------
    -- Sub-block of clock_enable entity. Create s_en signal.
    --- WRITE YOUR CODE HERE
Clock_en: entity work.clock_enable
generic map (g_NPERIOD=>x"0064")
port map (
				srst_n_i=>srst_n_i,
				clock_enable_o=>s_en,
				clk_i=>clk_i
			);

    --------------------------------------------------------------------
    -- Sub-block of hex_to_7seg entity
    --- WRITE YOUR CODE HERE
Hex2Seg: entity work.hex_to_7seg
port map (hex_i=>s_hex,
			seg_o=>seg_o
			);
			
    --------------------------------------------------------------------
    -- Sub-block of stopwatch entity

Stopwatch: entity work.stopwatch
port map (clk_i=>clk_i,
			stst_n_i =>srst_n_i,
			ce_100Hz_i => s_en,
			hth_l_o=>data0_i,
			hth_h_o=>data1_i,
			sec_l_o=>data2_i,
			sec_h_o=>data3_i	

			);


    --------------------------------------------------------------------
    -- p_select_cnt:
    -- Sequential process with synchronous reset and clock enable,
    -- which implements an internal 2-bit counter s_cnt for multiplexer 
    -- selection bits.
    --------------------------------------------------------------------
    p_select_cnt : process (clk_i)
    begin
        if rising_edge(clk_i) then  -- Rising clock edge
            if srst_n_i = '0' then  -- Synchronous reset (active low)
				-- WRITE YOUR CODE HERE
                s_cnt<="00";
            elsif s_en = '1' then
				-- WRITE YOUR CODE HERE
                s_cnt<=s_cnt+1;
            end if;
        end if;
    end process p_select_cnt;

    --------------------------------------------------------------------
    -- p_mux:
    -- Combinational process which implements a 4-to-1 mux.
    --------------------------------------------------------------------
    p_mux : process (s_cnt, data0_i, data1_i, data2_i, data3_i, dp_i)
    begin
        case s_cnt is
        when "00" =>
            -- WRITE YOUR CODE HERE
				s_hex<=data0_i;
				dig_o<="1110";

				
        when "01" =>
            -- WRITE YOUR CODE HERE
				s_hex<=data1_i;
				dig_o<="1101";

				
        when "10" =>
            -- WRITE YOUR CODE HERE
				s_hex<=data2_i;
				dig_o<="1011";

        when others =>
            -- WRITE YOUR CODE HERE
				s_hex<=data3_i;
				dig_o<="0111";

        end case;
    end process p_mux;

end architecture Behavioral;

