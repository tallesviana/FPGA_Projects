LIBRARY ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

ENTITY i2s_master IS 
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
END i2s_master;

ARCHITECTURE top OF i2s_master IS

------------------------------------------------
--             COMPONENTS 
------------------------------------------------

COMPONENT i2s_fsm_decoder IS 
    GENERIC(data_size : natural := 16);  -- I2S Data Size 16, 32, 64..
    PORT(
        reset_n     :  IN std_logic;
        clk         :  IN std_logic;
        init_n      :  IN std_logic;

        SHIRFT_L_o  :  OUT std_logic;
        SHIRFT_R_o  :  OUT std_logic;
        bclk_o      :  OUT std_logic;
        ws_o        :  OUT std_logic;
        strobe_o    :  OUT std_logic
    );
END COMPONENT;

COMPONENT s2p_block IS
    PORT(
        clk, reset_n   : IN std_logic;
        ENABLE_i       : IN std_logic;   -- BLCK signal
        SHIFT_i        : IN std_logic;
        SER_i          : IN std_logic;

        PAR_o          : OUT std_logic_vector(15 downto 0)
    );
END COMPONENT; 

COMPONENT p2s_block IS
    PORT(
        clk, reset_n  : IN std_logic;
        ENABLE_i      : IN std_logic;
        LOAD_i        : IN std_logic;
        SHIFT_i       : IN std_logic;
        PAR_i         : IN std_logic_vector(15 downto 0);

        SER_o         : OUT std_logic
    );
END COMPONENT;

--COMPONENT mux_block IS
  --  PORT(
    --    left_i, right_i :  IN std_logic;
      --  sel_i           :  IN std_logic;
        --channel_o       : OUT std_logic
    --);
--END COMPONENT;
    ------------------------------------------------
    --              Internal Signals   
    ------------------------------------------------

    SIGNAL t_shift_l  :  std_logic;  -- Control signal to shift serial
    SIGNAL t_shift_r  :  std_logic;

    SIGNAL t_ser_l_out  :  std_logic;  -- Serial data to be multiplexed
    SIGNAL t_ser_r_out  :  std_logic;

    SIGNAL t_bclk       : std_logic;
    SIGNAL t_strobe     : std_logic;
    SIGNAL t_ws         : std_logic;

BEGIN

i2s_decoder: i2s_fsm_decoder
    PORT MAP(
        reset_n     => reset_n,
        clk         => clk_12M,
        init_n      => INIT_N,

        SHIRFT_L_o  => t_shift_l,
        SHIRFT_R_o  => t_shift_r,
        bclk_o      => t_bclk,
        ws_o        => t_ws,
        strobe_o    => t_strobe
    );

s2p_right: s2p_block
    PORT MAP(
        clk         => clk_12M,
        reset_n     => reset_n,
        ENABLE_i    => t_bclk,
        SHIFT_i     => t_shift_r,
        SER_i       => ADCDAT_s_i,
        PAR_o       => ADCDAT_pr_o
    );

s2p_left: s2p_block
    PORT MAP(
        clk         => clk_12M,
        reset_n     => reset_n,
        ENABLE_i    => t_bclk,
        SHIFT_i     => t_shift_l,
        SER_i       => ADCDAT_s_i,
        PAR_o       => ADCDAT_pl_o
    );

p2s_right: p2s_block
    PORT MAP(
        clk         => clk_12M, 
        reset_n     => reset_n,
        ENABLE_i    => t_bclk,
        LOAD_i      => t_strobe,
        SHIFT_i     => t_shift_r,
        PAR_i       => DACDAT_pr_i,
        SER_o       => t_ser_r_out
    );

p2s_left: p2s_block
    PORT MAP(
        clk         => clk_12M, 
        reset_n     => reset_n,
        ENABLE_i    => t_bclk,
        LOAD_i      => t_strobe,
        SHIFT_i     => t_shift_l,
        PAR_i       => DACDAT_pl_i,
        SER_o       => t_ser_l_out
    );

-- MUX PROCESS to decide the channel going to WM8731 serial
    mux: PROCESS(t_ws, t_ser_l_out, t_ser_r_out)
    BEGIN
       CASE t_ws IS
           WHEN '0'=>
               DACDAT_s_o <= t_ser_l_out;
           WHEN '1'=>
               DACDAT_s_o <= t_ser_r_out;
           WHEN OTHERS =>
               DACDAT_s_o <= 'Z';
        END CASE;
    END PROCESS;

-- Assignments
BCLK_o <= t_bclk;
STROBE_o <= t_strobe;
WS_o <= t_ws;

END top;