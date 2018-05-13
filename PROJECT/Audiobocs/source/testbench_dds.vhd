LIBRARY ieee;
  use ieee.std_logic_1164.all;
  use work.tone_gen_pkg.all;
  use work.audio_filter_pkg.all;

ENTITY testbench_dds IS

END testbench_dds;

ARCHITECTURE struct OF testbench_dds IS

  -- ==========     COMPONENTS    ==============--

  COMPONENT dds IS
    PORT(
        clk, reset_n: IN std_logic;

        tone_on_i  :  IN std_logic;                                 -- Tone on or off
        phi_incr_i :  IN std_logic_vector(N_CUM - 1 downto 0);      -- LUT phi increment
        strobe_i   :  IN std_logic;                                 -- Reload audio sample

        dacdat_g_o :  out std_logic_vector(N_AUDIO - 1 downto 0)  -- Generated audio sample
    );
  END COMPONENT;

  COMPONENT fir_core is
	generic(
		lut_fir : t_lut_fir := LUT_FIR_LPF_200Hz );  -- from audio_filter_pkg
    port(
		clk         	: in    std_logic;
		reset_n     	: in    std_logic;
		strobe_i		: in    std_logic; 					   -- indicates beginning of audio frame
		adata_i			: in	std_logic_vector(15 downto 0); --   audio  data input
		fdata_o			: out	std_logic_vector(15 downto 0)  -- filtered data output
      );
  END COMPONENT;

  --========      SIGNALS    ===========-

  SIGNAL tb_reset_n    :  std_logic;
  SIGNAL tb_clk        :  std_logic;

  SIGNAL tb_tone_on    :  std_logic;
  SIGNAL tb_phi_incr   :  std_logic_vector(N_CUM - 1 downto 0);
  SIGNAL tb_strobe     :  std_logic;

  SIGNAL tb_audio2fir  :  std_logic_vector(N_AUDIO - 1 downto 0);
  SIGNAL tb_audio_out  :  std_logic_vector(N_AUDIO - 1 downto 0);

  SIGNAL CLK_12M_HALFP:  time := 40ns;  -- Half Period of a 12,5MHz clock

-- ============  BEGIN  ===============

BEGIN

    DUT: dds
    PORT MAP(
        clk        => tb_clk,
        reset_n    => tb_reset_n,
        tone_on_i  => tb_tone_on,
        phi_incr_i => tb_phi_incr,
        strobe_i   => tb_strobe,
        dacdat_g_o => tb_audio2fir
    );

    inst_fir: fir_core
    GENERIC MAP(lut_fir => LUT_FIR_LPF_400Hz)
    PORT MAP(
        clk        => tb_clk,
        reset_n    => tb_reset_n,
        strobe_i   => tb_strobe,
        adata_i    => tb_audio2fir,
        fdata_o    => tb_audio_out
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

    --    Stimuli Process
    stimuli: PROCESS
    BEGIN
        --  STEP 0 -- INIT
        report "Initializing Stimuli Process:  pulse reset & tone constant";
        tb_phi_incr <= C4_DO;
        tb_reset_n <= '0';
        tb_tone_on <= '0';
        ---------------------------
        wait for 10*CLK_12M_HALFP;
        tb_reset_n <= '1';
        wait for 10*CLK_12M_HALFP;
        --  STEP 1 --  Playing the tone C0
        report "Playing the DO tone";
        tb_tone_on <= '1';
        wait for 5ms;

        -- STEP 2 -- Playing the LA tone
        report "Playing the LA tone";
        tb_phi_incr <= A4_LA;
        wait for 5ms;

        -- STOP playing
        report "Release play tone command";
        tb_tone_on <= '0';
        wait for 1ms;

        -- Play again
        report "Playing the La tone again";
        tb_tone_on <= '1';
        wait for 5ms;

        assert false report "Simulation Finished! Success";

    END PROCESS stimuli;

END struct;

