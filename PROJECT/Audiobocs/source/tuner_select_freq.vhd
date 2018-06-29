LIBRARY ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

ENTITY tuner_select_freq IS
    PORT(
        clk, reset_n    :  IN STD_LOGIC;

        sw_choice       :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        LOW_I   :  IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        MID_I   :  IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        HIGH_I  :  IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        CHOSEN_O:  OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END tuner_select_freq;

ARCHITECTURE rtl OF tuner_select_freq IS
    
    SIGNAL next_chosen, chosen : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

selecting: PROCESS(ALL)
BEGIN
    next_chosen <= chosen;

    IF sw_choice(0) = '1' THEN
        next_chosen <= LOW_I;
    ELSIF sw_choice(1) = '1' THEN
        next_chosen <= MID_I;
    ELSIF sw_choice(2) = '1' THEN
        next_chosen <= HIGH_I;
    ELSE
        next_chosen <= (OTHERS => '1');
    END IF;

END PROCESS selecting;

ff: PROCESS(ALL)
BEGIN
    IF reset_n = '0' THEN
        chosen <= LOW_I;
    ELSIF rising_edge(clk) THEN
        chosen <= next_chosen;
    END iF;
END PROCESS ff;

CHOSEN_O <= chosen;

END rtl;