LIBRARY ieee;
  use ieee.std_logic_1164.all;

ENTITY tuner IS
  PORT(
      RESET_N, CLK :  std_logic;

      AUDIO_I      :  std_logic_vector(15 downto 0);

      NOTE_O       :  std_logic_vector(2 downto 0);
      DELTA_O      :  std_logic_vector(16 downto 0)
  );
END tuner;

ARCHITECTURE struct OF tuner IS

  COMPONENT square_gen IS
  PORT(
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

  SIGNAL t_square_wave  :  std_logic;

BEGIN

sq_gen: square_gen
  PORT MAP(
      audio_i        => AUDIO_I,
      square_wave_o  =>  t_square_wave
  );

tuner_count: tuner_tone_by_count
  PORT MAP(
      clk       => CLK,
      reset_n   => RESET_N,
      wave_i    => t_square_wave,
      note_o    => NOTE_O,
      delta_o   => DELTA_O
  );

END struct;