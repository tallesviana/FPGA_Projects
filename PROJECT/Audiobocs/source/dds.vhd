------------------------------------------
--  DDS - Direct Digital Synthesis
------------------------------------------
--   Runs using a LUT with a sin
------------------------------------------
-- 13/May - 1st Version tallesvv
-- Introduced workaround because the tone was higher
------------------------------------------

LIBRARY ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.tone_gen_pkg.all;

------------------------------------------------------
-->>>>>>>>>>>      ENTITY DECLARATION   <<<<<<<<<<<<<<
------------------------------------------------------

ENTITY dds IS
    PORT(
        clk, reset_n: IN std_logic;

        tone_on_i  :  IN std_logic;                                 -- Tone on or off
        phi_incr_i :  IN std_logic_vector(N_CUM - 1 downto 0);      -- LUT phi increment
        strobe_i   :  IN std_logic;                                 -- Reload audio sample

        dacdat_g_o :  out std_logic_vector(N_AUDIO - 1 downto 0)  -- Generated audio sample
    );
END dds;

------------------------------------------------------
-->>>>>>>>>>>>>     ARCHITECTURE   <<<<<<<<<<<<<<<<<<<
------------------------------------------------------

ARCHITECTURE rtl OF dds IS

  SIGNAL workaround, next_workaround          : boolean;    -- REMOVE LATER

  SIGNAL count, next_count  :  unsigned(N_CUM - 1 downto 0) := to_unsigned(0, N_CUM);
  SIGNAL addr               :  integer range 0 to L-1;
  SIGNAL audio_out          :  std_logic_vector(N_AUDIO - 1 downto 0);

------------------------------------------------------
-->>>>>>>>>>>      BEGIN OF ARCHITEC   <<<<<<<<<<<<<<
------------------------------------------------------
BEGIN

--============ COUNTER =============-
cumulator: PROCESS(next_workaround, workaround, tone_on_i, phi_incr_i, strobe_i, count, next_count)
BEGIN
    IF tone_on_i = '0' THEN
        IF strobe_i = '1' and workaround = false THEN
            next_count <= count + unsigned(phi_incr_i);
			next_workaround <= true;
        ELSE
            next_count <= count;
			next_workaround <= false;
        END IF;
    ELSE
        next_count <= (OTHERS => '0');
        next_workaround <= false;
    END IF;
END PROCESS;


--============ FLIP FLOPS ===============
flip_flop: PROCESS(clk, reset_n, next_count)
    BEGIN
        IF reset_n = '0' THEN
            count <= (OTHERS => '0');
			workaround <= false;
        ELSIF rising_edge(clk) THEN
            count <= next_count;
			workaround <= next_workaround;
        END IF;
    END PROCESS;

--=========== LOOK UP TABLE =============

   audio_out <= std_logic_vector(to_signed(LUT(to_integer(count(N_CUM-1 downto N_CUM-N_ADDR_LUT_DDS))),N_AUDIO));

--========   CONCURRENT ASSIGNMENT OUT ========

  dacdat_g_o <= audio_out WHEN tone_on_i = '0' ELSE (OTHERS=>'0');

END rtl;

