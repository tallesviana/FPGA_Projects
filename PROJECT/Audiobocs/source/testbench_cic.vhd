LIBRARY ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.tone_gen_pkg.all;
  use work.audio_filter_pkg.all;

ENTITY testbench_cic IS

END testbench_cic;

ARCHITECTURE struct of testbench_cic IS

--=======      COMPONENTS     =========-

COMPONENT cic_top is
    generic (   RATE : unsigned(9 downto 0) := to_unsigned(100, 10);    -- Decimator
                ORDER: natural := 5);                                   -- How many I and C ?
    PORT(
        CLK, RESET_N: in std_logic;
        STROBE_IN   : in std_logic;

        SIGNAL_IN   : in std_logic_vector(15 downto 0);
        SIGNAL_OUT  : out std_logic_vector(15 downto 0)
    );
end COMPONENT;

COMPONENT square_gen IS
  PORT(
        clk, reset_n  :  IN  std_logic;

      audio_i       :  IN  std_logic_vector(15 downto 0);
      square_wave_o :  OUT std_logic
  );
END COMPONENT;

COMPONENT tuner_tone_by_count IS
  PORT(
      clk, reset_n  :  IN std_logic;
      wave_i        :  IN std_logic;
      
      note_o        :  OUT std_logic_vector(2 downto 0);
      delta_o       :  OUT std_logic_vector(16 downto 0)
  );
END COMPONENT;

COMPONENT dds IS
    PORT(
        clk, reset_n: IN std_logic;

        tone_on_i  :  IN std_logic;                                 -- Tone on or off
        phi_incr_i :  IN std_logic_vector(N_CUM - 1 downto 0);      -- LUT phi increment
        strobe_i   :  IN std_logic;                                 -- Reload audio sample

        dacdat_g_o :  out std_logic_vector(N_AUDIO - 1 downto 0)  -- Generated audio sample
    );
END COMPONENT;

--========     SIGNALS    ========-

  SIGNAL tb_reset_n:  std_logic;
  SIGNAL tb_clk:      std_logic;
  SIGNAL tb_wave_sq:  std_logic;
  SIGNAL tb_delta:    std_logic_vector(16 downto 0);
  SIGNAL tb_dacdat:   std_logic_vector(N_AUDIO - 1 downto 0);
  SIGNAL tb_note:     std_logic_vector(2 downto 0);
  SIGNAL tb_phi_incr: std_logic_vector(N_CUM - 1 downto 0);      -- LUT phi increment
  SIGNAL tb_strobe:   std_logic;
  SIGNAL tb_cic     : std_logic_vector(15 downto 0);

  CONSTANT CST_ONE 	: std_logic := '0';

  SIGNAL CLK_12M_HALFP:  time := 40ns;  -- Half Period of a 12,5MHz clock


BEGIN

    DUT: tuner_tone_by_count
    PORT MAP(
      clk     => tb_clk,
      reset_n => tb_reset_n, 
      wave_i  => tb_wave_sq,      
      
      note_o  => tb_note,      
      delta_o => tb_delta   

    );

    cicz: cic_top
    generic map(   RATE  => to_unsigned(5, 10),    -- Decimator
                ORDER => 1)                                   -- How many I and C ?
    PORT map(
        CLK             => tb_clk,
        RESET_N         => tb_reset_n,
        STROBE_IN       => tb_strobe,

        SIGNAL_IN       => tb_dacdat,
        SIGNAL_OUT      => tb_cic
    );

    inst_sq: square_gen
    PORT MAP(
      clk       =>  tb_clk,
      reset_n  => tb_reset_n,
      audio_i       => tb_cic,
      square_wave_o => tb_wave_sq
    );

    inst_dds: dds
    PORT MAP(
        clk         => tb_clk,
        reset_n     => tb_reset_n,

        tone_on_i  => CST_ONE,
        phi_incr_i => tb_phi_incr,
        strobe_i   => tb_strobe,

        dacdat_g_o => tb_dacdat
    );

-- Process of generating the 12,5MHz clock
    generate_clock: PROCESS
    BEGIN
        tb_clk <= '1';
        wait for CLK_12M_HALFP;
        tb_clk <= '0';
        wait for CLK_12M_HALFP;
    END PROCESS generate_clock;

-- Process of generating the strobe pulse
    generate_strobe: PROCESS
    BEGIN
        tb_strobe <= '0';
        wait for 128*2*2*CLK_12M_HALFP;     -- 2*2*clk=bclk    128*bclk = strobe pulse
        tb_strobe <= '1';
        wait for 2*2*CLK_12M_HALFP;
    END PROCESS generate_strobe;

    stimuli: PROCESS
    BEGIN
        --  STEP 0 -- INIT
        report "Initializing Stimuli Process:  pulse reset & tone constant";
        tb_phi_incr <= D3_RE;
        tb_reset_n <= '0';
        ---------------------------
        wait for 10*CLK_12M_HALFP;
        tb_reset_n <= '1';
        wait for 10*CLK_12M_HALFP;
        --  STEP 1 --  Playing the tone C0
        report "Playing the DO tone";
        wait for 25ms;

        tb_phi_incr <= E4_MI;

        wait for 25ms;

        assert false report "Simulation Finished! Success";

    END PROCESS stimuli;



END struct;