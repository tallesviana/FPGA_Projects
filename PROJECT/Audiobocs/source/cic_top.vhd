------------------------------------------------
--     CIC BLOCK
------------------------------------------------
-- Actually, I do not if it is ok to overflow the
-- accumulator. I think it should be increasing 
-- the number of bits, every time the audio passes
-- through an accumlator
------------------------------------------------


library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

------------------------------------------------
--     ENTITY       ----------------------------
------------------------------------------------
entity cic_top is
    generic (   RATE : unsigned(9 downto 0) := to_unsigned(100, 10);    -- Decimator
                ORDER: natural := 5);                                   -- How many I and C ?
    PORT(
        CLK, RESET_N: in std_logic;
        STROBE_IN   : in std_logic;

        SIGNAL_IN   : in std_logic_vector(15 downto 0);
        SIGNAL_OUT  : out std_logic_vector(15 downto 0)
    );
end cic_top;

------------------------------------------------
--     ARCHITECTURE       ----------------------
------------------------------------------------
ARCHITECTURE struct OF cic_top is

    --   COMPONENTS ----
    COMPONENT cic_accumulator is
    port(
        clk, reset_n: in std_logic;
        strobe_in   : in std_logic;

        signal_in   : in std_logic_vector(15 downto 0);
        signal_out  : out std_logic_vector(15 downto 0)
    );
    end COMPONENT;

    COMPONENT cic_decimator is
    generic ( rate : unsigned(9 downto 0) := to_unsigned(100, 10));
    port(
        clk, reset_n: in std_logic;
        strobe_in   : in std_logic;
        strobe_dec_o    : out std_logic;
        signal_in   : in std_logic_vector(15 downto 0);
        signal_out  : out std_logic_vector(15 downto 0)
    );
    end COMPONENT;

    COMPONENT cic_comb is
    port(
        clk, reset_n: in std_logic;
        strobe_dec_i   : in std_logic;

        signal_in   : in std_logic_vector(15 downto 0);
        signal_out  : out std_logic_vector(15 downto 0)
    );
    end COMPONENT;

    ------------------------------------------------
    --     SIGNALS       ----------------------------
    ------------------------------------------------

    TYPE aux_acc IS ARRAY (0 TO ORDER) OF std_logic_vector(15 downto 0);
    TYPE aux_cmb IS ARRAY (0 TO ORDER) OF std_logic_vector(15 downto 0);
    SIGNAL audio_aux_acc : aux_acc;
    SIGNAL audio_aux_cmb : aux_cmb;
    SIGNAL t_strobe_dec : std_logic;

------------------------------------------------
--     BEGINNING       ----------------------------
------------------------------------------------
BEGIN

    -- ACCUMULATORS --
    Acc_gen:
        for i in 0 to ORDER-1 generate      --<  Generate ACC instances
        ACC: cic_accumulator
            port map(
                clk         => CLK,
                reset_n     => RESET_N,
                strobe_in   => STROBE_IN,

                signal_in   => audio_aux_acc(i),
                signal_out  => audio_aux_acc(i+1)
            );
        end generate;
    
    -- DECIMATOR --
    Deci: cic_decimator
        generic map ( rate => RATE)
        port map(
            clk             => CLK,
            reset_n         => RESET_N,
            strobe_in       => STROBE_IN,
            strobe_dec_o    => t_strobe_dec,
            signal_in       => audio_aux_acc(ORDER),
            signal_out      => audio_aux_cmb(0)
        );

    -- COMBS --
    Cmb_gen:
        for i in 0 to ORDER-1 generate      --< Generate COMB instances
        CMB: cic_comb
            port map(
                clk         => CLK,
                reset_n     => RESET_N,
                strobe_dec_i   => t_strobe_dec,

                signal_in   => audio_aux_cmb(i),
                signal_out  => audio_aux_cmb(i+1)
            );
        end generate;

------------------------------------------------
--     ASSIGMENTS   ----------------------------
------------------------------------------------
    audio_aux_acc(0) <= SIGNAL_IN;
    SIGNAL_OUT <= audio_aux_cmb(ORDER);

END struct;