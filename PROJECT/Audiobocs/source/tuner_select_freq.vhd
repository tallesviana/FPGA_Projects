LIBRARY ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

ENTITY tuner_select_freq IS
    PORT(
        clk, reset_n    :  IN STD_LOGIC;

        LOW_I   :  IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        MID_I   :  IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        HIGH_I  :  IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        CHOSEN_O:  OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END tuner_select_freq;

ARCHITECTURE rtl OF tuner_select_freq IS

    TYPE input_array IS ARRAY (0 to 2) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL inputs   : input_array   := (LOW_I, MID_I, HIGH_I);
    SIGNAL next_chosen, chosen : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

selecting: PROCESS(ALL)
    VARIABLE value : signed(15 downto 0);
    VARIABLE index : natural := 0;
BEGIN

    index   := 0;
    next_chosen <= chosen;
    value := abs(signed(inputs(0)));  --  <-- LOW filters chosen

    FOR I IN 1 to 2 LOOP            --  <-- Lopp to get absolute values
        IF abs(signed(inputs(I))) > value THEN
            index := I;
            value := abs(signed(inputs(I)));
        END IF;
    END LOOP;

    CASE index IS       -- Selecting which filter should be used
        WHEN 0 => next_chosen <= LOW_I;
        WHEN 1 => next_chosen <= MID_I;
        WHEN 2 => next_chosen <= HIGH_I;
        WHEN OTHERS => next_chosen <= (OTHERS => '0');
    END CASE;

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