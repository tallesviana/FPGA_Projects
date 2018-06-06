------------------------------------------------------
-- Generates a square wave from input
------------------------------------------------------
-- 27/05/18 - tallesvv - 1st version
------------------------------------------------------

LIBRARY ieee;
  use ieee.std_logic_1164.all;

ENTITY square_gen IS
  PORT(
      audio_i       :  IN  std_logic_vector(15 downto 0);
      square_wave_o :  OUT std_logic
  );
END square_gen;

ARCHITECTURE rtl OF square_gen IS
BEGIN

square_wave_o <= not(audio_i(audio_i'left));

END rtl;