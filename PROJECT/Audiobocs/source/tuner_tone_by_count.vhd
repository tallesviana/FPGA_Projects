LIBRARY ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

ENTITY tuner_tone_by_count IS
  PORT(
      clk, reset_n  :  IN std_logic;
      wave_i        :  IN std_logic;
      
      note_o        :  OUT std_logic_vector(2 downto 0);
      delta_o       :  OUT std_logic_vector(16 downto 0)
  );
END tuner_tone_by_count;

ARCHITECTURE rtl OF tuner_tone_by_count IS

  TYPE notes IS (E2, A2, D3, G3, B3, E4);
  TYPE clk_num IS ARRAY (0 to 5) of natural;
  CONSTANT CLK_COUNT  :  clk_num := (75840, 56818, 42575, 31888, 25314, 18962); -- E2, A2, D3, G3, B3, E4

  SIGNAL count_clk, next_count_clk  :  unsigned(16 downto 0) := to_unsigned(0, 17); -- Can count from G1 up to..
  SIGNAL count_mean, next_count_mean  : unsigned(16 downto 0) := to_unsigned(0, 17);
  SIGNAL chosen_note, next_chosen_note : notes;

  SIGNAL flag_count_on : std_logic;

BEGIN

-- COUNTER PROCESS  -  COUNTING NUMBER OF CLOCKS
count_high: PROCESS(ALL)
BEGIN
    IF wave_i = '1' THEN
        flag_count_on <= '1';
        next_count_clk <= count_clk + 1;
        next_count_mean <= count_mean;
    ELSIF flag_count_on = '1' THEN
        flag_count_on <= '0';
        next_count_clk <= count_clk;
        --next_count_mean <= (count_clk + count_mean)/2;   -- Average
        next_count_mean <= count_clk;
    ELSE
        flag_count_on <= '0';
        next_count_clk <= (OTHERS => '0');
        next_count_mean <= count_mean;
    END IF;
END PROCESS count_high;

-- CHECKING NOTE - CHECKS NEAREST TONE
check_note: PROCESS(ALL)
    VARIABLE delta : signed(16 downto 0);    --  !!!!!   The output max delta possible is 9511; 
    VARIABLE index : natural := 0;
BEGIN
    delta := abs(signed(CLK_COUNT(0) - count_mean));
    next_chosen_note <= E2;
    index := 0;
    FOR I in 1 to 5 LOOP
        IF abs(signed(CLK_COUNT(I)-count_mean)) < delta THEN
            delta := abs(signed(CLK_COUNT(I)-count_mean));
            index := I;
        END IF;
    END LOOP;

    CASE index IS
        WHEN 1 =>  next_chosen_note <= A2;
        WHEN 2 =>  next_chosen_note <= D3;
        WHEN 3 =>  next_chosen_note <= G3;
        WHEN 4 =>  next_chosen_note <= B3;
        WHEN 5 =>  next_chosen_note <= E4;
        WHEN OTHERS =>  next_chosen_note <= E2;
    END CASE;
END PROCESS check_note;

-- FLIP-FLOPS
flip_flops: PROCESS(clk, reset_n)
BEGIN
    IF reset_n = '0' THEN
        count_clk <= (OTHERS => '0');
        count_mean <= (OTHERS => '0');
        chosen_note <= E2;
    ELSIF rising_edge(clk) THEN
        count_clk <= next_count_clk;
        count_mean <= next_count_mean;
        chosen_note <= next_chosen_note;
    END IF;
END PROCESS flip_flops;

-- OUTPUT ASSIGNMENTS
note_n_delta: PROCESS(ALL)
BEGIN
    CASE chosen_note IS
        WHEN E2 =>
            note_o  <= "001";
            delta_o <= std_logic_vector(signed(CLK_COUNT(0) - count_mean));
        WHEN A2 =>
            note_o <= "010";
            delta_o <= std_logic_vector(signed(CLK_COUNT(1) - count_mean));
        WHEN D3 =>
            note_o <= "011";
            delta_o <= std_logic_vector(signed(CLK_COUNT(2) - count_mean));
        WHEN G3 =>
            note_o <= "100";
            delta_o <= std_logic_vector(signed(CLK_COUNT(3) - count_mean));
        WHEN B3 =>
            note_o <= "101";
            delta_o <= std_logic_vector(signed(CLK_COUNT(4) - count_mean));
        WHEN E4 =>
            note_o <= "110";
            delta_o <= std_logic_vector(signed(CLK_COUNT(5) - count_mean));
        WHEN OTHERS =>
            note_o <= "000";
            delta_o <= (OTHERS => '0');
    END CASE;
END PROCESS note_n_delta;

END rtl;