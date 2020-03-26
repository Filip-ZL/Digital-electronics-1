--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:10:50 03/26/2020
-- Design Name:   
-- Module Name:   D:/VHDL/Projekt/Labs08-traffic_lights/Semafor.vhd
-- Project Name:  Labs08-traffic_lights
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Semafor IS
END Semafor;
 
ARCHITECTURE behavior OF Semafor IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         clk_i : IN  std_logic;
         srst_n_i : IN  std_logic;
         light_ON_o : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal srst_n_i : std_logic := '0';

 	--Outputs
   signal light_ON_o : std_logic_vector(5 downto 0);

   -- Clock period definitions
   constant clk_i_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          clk_i => clk_i,
          srst_n_i => srst_n_i,
          light_ON_o => light_ON_o
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/3;
		clk_i <= '1';
		wait for clk_i_period/3;
   end process;
 

   -- Stimulus process
    stim_proc: process
    begin
         srst_n_i <= '1';
        wait for 500 NS;
        srst_n_i <= '0';
        wait until rising_edge(clk_i);
        wait until rising_edge(clk_i);
        wait until rising_edge(clk_i);
        srst_n_i <= '1';
      -- insert stimulus here 

      wait;
   end process;

END;
