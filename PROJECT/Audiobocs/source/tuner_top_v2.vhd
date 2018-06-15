LIBRARY ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

------------------------------------------------
--     ENTITY       ----------------------------
------------------------------------------------

ENTITY tuner_top_v2 IS
    PORT(
        RESET_N, CLK :  IN std_logic;

        tuner_AUDIO_I      :  IN std_logic_vector(15 downto 0);

        tuner_STROBE_I      : IN std_logic;

        tuner_HEX0_O :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);  -- HEX0_N on the top level
        tuner_HEX1_O :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
        tuner_HEX2_O :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
        tuner_HEX3_O :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);

        tuner_LEDR_O :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0);  --LEDR_0 on the top level
        tuner_LEDG_O :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);

        tuner_debug:    OUT std_logic

  );
END tuner_top_v2;

------------------------------------------------
--     ARCHITECTURE ----------------------------
------------------------------------------------

ARCHITECTURE struct OF tuner_top_v2 IS

  COMPONENT tuner_filter_cascade IS
    PORT(
        CLK         : IN std_logic;
        RESET_N     : IN std_logic;
        STROBE_I    : IN std_logic;
        ADATA_I     : IN std_logic_vector(15 downto 0); 

        FDATA_400_O         : OUT std_logic_vector(15 downto 0);  -- Output after 400Hz LPF (HIGH)
        FDATA_400_200_O     : OUT std_logic_vector(15 downto 0);  -- Output after 400Hz->200 Hz LPF (MID)
        FDATA_400_200_100_O : OUT std_logic_vector(15 downto 0)   -- Output after 400Hz->200 Hz->100 Hz LPF (LOW)
    );
  END COMPONENT;

  COMPONENT tuner_select_freq IS
    PORT(
        clk, reset_n    :  IN STD_LOGIC;

        LOW_I   :  IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        MID_I   :  IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        HIGH_I  :  IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        CHOSEN_O:  OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
  END COMPONENT;

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

  COMPONENT tuner_visual IS
  PORT(
    TONE_I  :  IN  std_logic_vector(2 downto 0);
    DELTA_I :  IN  std_logic_vector(16 downto 0);

    HEX0_O :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);  -- HEX0_N on the top level
    HEX1_O :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
    HEX2_O :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
    HEX3_O :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);

    LEDR_O :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0);  --LEDR_0 on the top level
    LEDG_O :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

------------------------------------------------
--     SIGNALS     ----------------------------
------------------------------------------------

  SIGNAL t_square_wave  :  std_logic;
  SIGNAL t_note         :  std_logic_vector(2 downto 0);
  SIGNAL t_delta        :  std_logic_vector(16 downto 0);

  SIGNAL t_hex          :  std_logic_vector(27 downto 0);
  SIGNAL t_ledr         :  std_logic_vector(9 downto 0);
  SIGNAL t_ledg         :  std_logic_vector(7 downto 0);

  SIGNAL t_aud_100      :  std_logic_vector(15 downto 0);
  SIGNAL t_aud_200      :  std_logic_vector(15 downto 0);
  SIGNAL t_aud_400      :  std_logic_vector(15 downto 0);

  SIGNAL t_audio2square :  std_logic_vector(15 downto 0);

------------------------------------------------
--     BEGINNIG     ----------------------------
------------------------------------------------

BEGIN

fir_cascade: tuner_filter_cascade
  PORT MAP(
        CLK         => CLK,
        RESET_N     => RESET_N,
        STROBE_I    => tuner_STROBE_I,
        ADATA_I     => tuner_AUDIO_I,

        FDATA_400_O         => t_aud_400,
        FDATA_400_200_O     => t_aud_200,
        FDATA_400_200_100_O => t_aud_100
    );

selects: tuner_select_freq
    PORT MAP(
        clk         => CLK,
        reset_n     => RESET_N,

        LOW_I       => t_aud_100,
        MID_I       => t_aud_200,
        HIGH_I      => t_aud_400,

        CHOSEN_O    => t_audio2square
    );

sq_gen: square_gen
  PORT MAP(
      clk            => CLK,
      reset_n        => RESET_N,
      audio_i        => t_audio2square,
      square_wave_o  =>  t_square_wave
  );

tuner_count: tuner_tone_by_count
  PORT MAP(
      clk       => CLK,
      reset_n   => RESET_N,
      wave_i    => t_square_wave,
      note_o    => t_note,
      delta_o   => t_delta
  );

visual: tuner_visual
    PORT MAP(
        TONE_I  => t_note,
        DELTA_I => t_delta,

        HEX0_O  => t_hex(6 downto 0),
        HEX1_O  => t_hex(13 downto 7),
        HEX2_O  => t_hex(20 downto 14),
        HEX3_O  => t_hex(27 downto 21),

        LEDR_O  =>  t_ledr,
        LEDG_O  =>  t_ledg
    );

tuner_HEX0_O  <= t_hex(6 downto 0);
tuner_HEX1_O  <= t_hex(13 downto 7);
tuner_HEX2_O  <= t_hex(20 downto 14);
tuner_HEX3_O  <= t_hex(27 downto 21);

tuner_LEDR_O  <=  t_ledr;
tuner_LEDG_O  <=  t_ledg;

tuner_debug <= t_square_wave;

END struct;