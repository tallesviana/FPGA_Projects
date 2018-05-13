------------------------------------------
--  DDS - Direct Digital Synthesis
------------------------------------------
--   Runs using a LUT with a sin
------------------------------------------
-- 13/May - 1st Version tallesvv

LIBRARY ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.tone_gen_pkg.all;

--|||||||     ENTITY     |||||||--

ENTITY dds IS
    PORT(
        clk, reset_n: IN std_logic;

        tone_on_i  :  IN std_logic;                                 -- Tone on or off
        phi_incr_i :  IN std_logic_vector(N_CUM - 1 downto 0);      -- LUT phi increment
        strobe_i   :  IN std_logic;                                 -- Reload audio sample

        dacdat_g_o :  out std_logic_vector(N_AUDIO - 1 downto 0)  -- Generated audio sample
    );
END dds;

--||||||||    ARCHITECTURE   |||||||||--

ARCHITECTURE rtl OF dds IS

  SIGNAL count, next_count  :  unsigned(N_CUM - 1 downto 0) := to_unsigned(0, N_CUM);
  SIGNAL addr               :  integer range 0 to L-1;
  SIGNAL audio_out          :  std_logic_vector(N_AUDIO - 1 downto 0);

-- =========== BEGIN ============-
BEGIN

--============ COUNTER =============-
cumulator: PROCESS(tone_on_i, phi_incr_i, strobe_i, count, next_count)
BEGIN
    IF tone_on_i = '1' THEN
        IF strobe_i = '1' THEN
            next_count <= count + unsigned(phi_incr_i);
        ELSE
            next_count <= count;
        END IF;
    ELSE
        next_count <= (OTHERS => '0');
    END IF;
END PROCESS;


--============ FLIP FLOPS ===============
flip_flop: PROCESS(clk, reset_n, next_count)
    BEGIN
        IF reset_n = '0' THEN
            count <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            count <= next_count;
        END IF;
    END PROCESS;

--=========== LOOK UP TABLE =============

   audio_out <= std_logic_vector(to_signed(LUT(to_integer(count(N_CUM-1 downto N_CUM-N_ADDR_LUT_DDS))),N_AUDIO));

--========   CONCURRENT ASSIGNMENT OUT ========

  dacdat_g_o <= audio_out WHEN tone_on_i = '1' ELSE (OTHERS=>'0');

END rtl;

