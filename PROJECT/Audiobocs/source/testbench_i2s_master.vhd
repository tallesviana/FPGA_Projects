-------------------------------------------
-- Testbench for I2S Master on Audio Synth
-------------------------------------------
-- 01/05 - tallesvv - 1st version
-------------------------------------------

LIBRARY ieee;
  use ieee.std_logic_1164.all;

--=========  ENTITY DECLARATION --=========
ENTITY testbench_i2s_master IS 

END testbench_i2s_master;


--========= ARCHITECTURE OF TESTBENCH  =========
ARCHITECTURE struct OF testbench_i2s_master IS 

COMPONENT i2s_master IS 
    PORT(
        clk_12M  :  IN std_logic;
        reset_n  :  IN std_logic;

        DACDAT_pr_i  :  IN std_logic_vector(15 downto 0); -- Parallel signal input from filters
        DACDAT_pl_i  :  IN std_logic_vector(15 downto 0);
        ADCDAT_s_i   :  IN std_logic;  -- Serial ADC IN from WM8731

        ADCDAT_pr_o  :  OUT std_logic_vector(15 downto 0); -- Parallel signal out to filters
        ADCDAT_pl_o  :  OUT std_logic_vector(15 downto 0);
        DACDAT_s_o   :  OUT std_logic;  -- Serial DAC OUT to WM8731

        INIT_N       :  IN std_logic;  -- Key to init
        STROBE_o     :  OUT std_logic; -- Load
        BCLK_o       :  OUT std_logic; 
        WS_o         :  OUT std_logic -- ADCLRCK and DACLRCK
    );
END COMPONENT;

    --========= SIGNALS =========
    -- Inputs
    SIGNAL tb_clk_12M  :  std_logic;
    SIGNAL tb_reset_n  :  std_logic;
    SIGNAL tb_init_n   :  std_logic;

    -- ADC serial data IN
    SIGNAL tb_adc_s_i  :  std_logic;
    SIGNAL tb_adc_test :  std_logic_vector(127 downto 0);

    -- DAC serial data OUT
    SIGNAL tb_dac_s_o  : std_logic;

    -- Digital data -- LOOP
    SIGNAL tb_pr_data:  std_logic_vector(15 downto 0);
    SIGNAL tb_pl_data:  std_logic_vector(15 downto 0);

    --Auxiliary signals
    SIGNAL tb_strobe   :  std_logic;
    SIGNAL tb_bclk     :  std_logic;
    SIGNAL tb_ws       :  std_logic;

    -- Constants / Clock
    SIGNAL CLK_12M_HALFP:  time := 40ns;  -- Half Period of a 12,5MHz clock

BEGIN
    -- Instantiations
    DUT:i2s_master
    PORT MAP(
        clk_12M     => tb_clk_12M,
        reset_n     => tb_reset_n,

        DACDAT_pr_i => tb_pr_data,    -- Looping data
        DACDAT_pl_i => tb_pl_data,
        ADCDAT_s_i  => tb_adc_s_i,

        ADCDAT_pr_o => tb_pr_data,    -- Looping data
        ADCDAT_pl_o => tb_pl_data,
        DACDAT_s_o  => tb_dac_s_o,

        INIT_N      => tb_init_n,
        STROBE_o    => tb_strobe,
        BCLK_o      => tb_bclk,
        WS_o        => tb_ws
    );

    -- Process of generating the 12,5MHz clock
    generate_clock: PROCESS
    BEGIN
        tb_clk_12M <= '1';
        wait for CLK_12M_HALFP;
        tb_clk_12M <= '0';
        wait for CLK_12M_HALFP;
    END PROCESS generate_clock;

    -- Stimuli process
    stimuli: PROCESS
    BEGIN
        -- STEP 0
        report " Initializing: Stimuli process - define  and pulse reset";
        tb_adc_test <= X"AAAA111111111111_BBBB222222122222";
		tb_adc_s_i  <= '0';
		tb_reset_n  <= '0';
		tb_init_n   <= '1';
        ----------------------------
        wait for 12*CLK_12M_HALFP;
        tb_reset_n <= '1';
        tb_init_n  <= '0';
        wait for 4*CLK_12M_HALFP;
        tb_init_n  <= '1';
        
		-- STEP 1
		report "Waiting WS/BCLK falling edge...";
		wait until falling_edge(tb_ws);
		wait until falling_edge(tb_bclk);
		
		report "Sending serial data IN !!";
		for i in 127 downto 0 loop
		    tb_adc_s_i <= tb_adc_test(i);
			wait until falling_edge(tb_bclk);
		end loop;
		
		wait for 30us;

		assert false report "Serial transmission finished!! Check outputs";
		
    END PROCESS stimuli;
END struct;