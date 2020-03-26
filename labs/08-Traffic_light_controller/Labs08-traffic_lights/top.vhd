----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:32:40 03/26/2020 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;  


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is


port (
    clk_i    : in  std_logic;
    srst_n_i : in  std_logic;   -- Synchronous reset (active low)
	 light_ON_o: out std_logic_vector(5 downto 0)

);

end entity top;

architecture Behavioral of top is
	 signal data : std_logic;
begin


		Clock_en: entity work.clock_enable
			generic map (g_NPERIOD=>x"0021")
			port map (
				srst_n_i=>srst_n_i,
				clock_enable_o=>data,
				clk_i=>clk_i
			);

	Traffic_controller : entity work.Traffic_controller
    port map(clk_i => clk_i,
    		cnt_en_i => data,
    		srst_n_i => srst_n_i,
            lights_o => light_ON_o
				);
            
end Behavioral;

