LIBRARY ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

ENTITY tuner_visual IS
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
END tuner_visual;

ARCHITECTURE rtl OF tuner_visual IS

-- Signals & Constants Declaration
  CONSTANT note_bar   : std_logic_vector(27 downto 0):= "1000000_1000000_1000000_1000000";
	CONSTANT note_E2 		: std_logic_vector(27 downto 0):= "0000000_1111001_1011011_0000000";
  CONSTANT note_A2 		: std_logic_vector(27 downto 0):= "0000000_1110111_1011011_0000000";
	CONSTANT note_D3 		: std_logic_vector(27 downto 0):= "0000000_1011110_1001111_0000000";
  CONSTANT note_G3 		: std_logic_vector(27 downto 0):= "0000000_0111101_1001111_0000000";
  CONSTANT note_B3 		: std_logic_vector(27 downto 0):= "0000000_1111100_1001111_0000000";
  CONSTANT note_E4 		: std_logic_vector(27 downto 0):= "0000000_1111001_1100110_0000000"; 

  SIGNAL ledg_value      :   std_logic_vector(7 downto 0);
  SIGNAL ledr_diff_value :   unsigned(9 downto 0);
  SIGNAL tuned_value:   unsigned(9 downto 0) := "0000110000";  -- Gonna shift this value, depends on delta!
  SIGNAL hex_seg    :   std_logic_vector(27 downto 0);

BEGIN

  -- GETS NOTE - AND DISPLAYS ON 7SEG
  tone: PROCESS(ALL)
    BEGIN 
      CASE TONE_I IS
        WHEN "001" =>   hex_seg <= note_E2;
        WHEN "010" =>   hex_seg <= note_A2;
        WHEN "011" =>   hex_seg <= note_D3;
        WHEN "100" =>   hex_seg <= note_G3;
        WHEN "101" =>   hex_seg <= note_B3;
        WHEN "110" =>   hex_seg <= note_E4;
        WHEN OTHERS =>  hex_seg <= note_bar;
      END CASE;
    END PROCESS;

  --  GETS THE DELTA - AND SHOW IN THE LEDS
  delta: PROCESS(ALL)
    variable diff : natural;
    BEGIN

      IF abs(signed(DELTA_I)) > 6340 THEN
        diff := 5;
      ELSIF abs(signed(DELTA_I)) > 3125 THEN
        diff := 4;
      ELSIF abs(signed(DELTA_I)) > 1250 THEN
        diff := 3;
      ELSIF abs(signed(DELTA_I)) > 500 THEN
        diff := 2;
      ELSIF abs(signed(DELTA_I)) > 200 THEN
        diff := 1;
      ELSE
        diff := 0;
        ledg_value <= (OTHERS => '1');  -- TUNED !!!
      END IF;

      CASE DELTA_I(DELTA_I'left) IS    -- Checking if positive or negative
        WHEN '1' => -- Negative -- Means that my count is greater than the real note
          ledr_diff_value <= shift_left(tuned_value, diff);
        WHEN '0' =>
          ledr_diff_value <= shift_right(tuned_value, diff);
        WHEN OTHERS =>
          ledr_diff_value <= (OTHERS => '0');
      END CASE;

    END PROCESS;

    -- CONCURRENT ASSIGNMENTS --
    HEX0_O <= not(hex_seg(6 downto 0));
    HEX1_O <= not(hex_seg(13 downto 7));
    HEX2_O <= not(hex_seg(20 downto 14));
    HEX3_O <= not(hex_seg(27 downto 21));

    LEDR_O <= ledr_diff_value;
    LEDG_O <= ledg_value;

END rtl;