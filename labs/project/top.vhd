library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 

entity top is
    port(
        clk_i, srst_n_i : in std_logic;
        UI: in std_logic_vector(2-1 downto 0);
		  BTN0  : in std_logic;       -- Synchronous reset  
	     SW0_CPLD,  SW1_CPLD,  SW2_CPLD,  SW3_CPLD  : in std_logic; -- Input 0
        SW4_CPLD,  SW5_CPLD,  SW6_CPLD,  SW7_CPLD  : in std_logic; -- Input 1
        SW8_CPLD,  SW9_CPLD,  SW10_CPLD, SW11_CPLD : in std_logic; -- Input 2
        SW12_CPLD, SW13_CPLD, SW14_CPLD, SW15_CPLD : in std_logic; -- Input 3 
		  
		  disp_dp    : out std_logic; -- Decimal point
		  disp_seg_o : out std_logic_vector(7-1 downto 0);
		  disp_dig_o : out std_logic_vector(4-1 downto 0);


		  LD2 : out std_logic


    );
end entity top;

 

architecture RTL of top is
    signal clock_enable_o: std_logic;
    signal A: std_logic;
    signal B: std_logic;
	 signal plus_s: std_logic;
    signal minus_s: std_logic;
	 signal com_s: std_logic;
	 signal sec_h_s:  std_logic_vector(4-1 downto 0);
    signal sec_l_s:  std_logic_vector(4-1 downto 0);
    signal min_h_s:  std_logic_vector(4-1 downto 0);
    signal min_l_s:  std_logic_vector(4-1 downto 0);

	 signal pwm_max_s : std_logic_vector(12-1 downto 0);
	 signal pwm_sec_s : std_logic_vector(12-1 downto 0);
	 signal clock_sec_s: std_logic;
begin


    min_h_s(3) <= SW15_CPLD;
    min_h_s(2) <= SW14_CPLD;
    min_h_s(1) <= SW13_CPLD;
    min_h_s(0) <= SW12_CPLD;

    min_l_s(3) <= SW11_CPLD;
    min_l_s(2) <= SW10_CPLD;
    min_l_s(1) <= SW9_CPLD;
    min_l_s(0) <= SW8_CPLD;

    sec_h_s(3) <= SW7_CPLD;
    sec_h_s(2) <= SW6_CPLD;
    sec_h_s(1) <= SW5_CPLD;
    sec_h_s(0) <= SW4_CPLD;

    sec_l_s(3) <= SW3_CPLD;
    sec_l_s(2) <= SW2_CPLD;
    sec_l_s(1) <= SW1_CPLD;
    sec_l_s(0) <= SW0_CPLD;
	 
	 
    Clk_en: entity work.clock_enable
        generic map(
            g_NPERIOD => x"0002"
        )
        port map(
            clk_i          => clk_i,
            srst_n_i       => BTN0,
            clock_enable_o => clock_enable_o
        );
        
    Encoder: entity work.encoder
        generic map(
            g_NPERIOD => 2
        )
        port map(
            clk_i        => clk_i,
            clock_enable => clock_enable_o,
            UI           => UI,
            pulse_A      => A,
            pulse_B      => B,
            com          => com_s
            );
    Analyser: entity work.analyser
        port map(
            srst_n_i => BTN0,
            A_i      => A,
            B_i      => B,
            plus_o   => plus_s,
            minus_o  => minus_s
        );
		  
		  
	    SET_TIMER: entity work.set_timer
        port map(
            clk_i        => clk_i,
				com_i 	 => com_s,				
            srst_n_i => BTN0,
				pwm_max_o =>  pwm_max_s,
				pwm_sec_o => pwm_sec_s,
             sec_h_o  => sec_h_s,
             sec_l_o  => sec_l_s,
             min_h_o  => min_h_s,
             min_l_o  => min_l_s,
             plus_i   => plus_s,
             minus_i  => minus_s
        ); 
		  
		PWM_diod: entity work.pwm
			generic map(
				val_bits => 12
			)
			port map(
				clk_i => clk_i,			
				srst_n_i => BTN0,
				val_cur => pwm_sec_s,
				max_val  =>  pwm_max_s,
				pulse => LD2
			
			);
		
			
		Clk_sec: entity work.clock_sec
        generic map(
            g_NPERIOD => x"03e8"
        )
        port map(
            clk_i          => clk_i,
            srst_n_i       => BTN0,
            clock_sec_o =>  clock_sec_s
        );
		  
		  Driver : entity work.driver_7seg
    port map (
        clk_i    => clk_i,      
        srst_n_i => BTN0,       
        data0_i  => sec_l_s,    
        data1_i  => sec_h_s,
        data2_i  => min_l_s,
        data3_i  => min_h_s,
        dp_i     => "1011",
        dp_o     => disp_dp,
        seg_o    => disp_seg_o,
        dig_o    => disp_dig_o		  



    );
		  
		  
		  
end architecture RTL;