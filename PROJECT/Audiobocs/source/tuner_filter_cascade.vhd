----------------------------------------
--    FILTER BANK
----------------------------------------
--  Choose the used filter
----------------------------------------
LIBRARY ieee;
    use ieee.std_logic_1164.all;
    use work.audio_filter_pkg.all;

----------------------------------------
--   ENTITY
----------------------------------------
ENTITY tuner_filter_cascade IS
    PORT(
        CLK         : IN std_logic;
        RESET_N     : IN std_logic;
        STROBE_I    : IN std_logic;
        SW_I        : IN std_logic;
        ADATA_I     : IN std_logic_vector(15 downto 0); 
  
        FDATA_O     : OUT std_logic_vector(15 downto 0)
    );
END tuner_filter_cascade;

----------------------------------------
--   ARCHITECTURE
----------------------------------------

ARCHITECTURE struct OF tuner_filter_cascade IS

    COMPONENT fir_core is
        generic(
            lut_fir : t_lut_fir := LUT_FIR_LPF_200Hz );  -- from audio_filter_pkg
        port(
            clk         	: in    std_logic;
            reset_n     	: in    std_logic;
            strobe_i		: in    std_logic; 					   -- indicates beginning of audio frame
            adata_i			: in	std_logic_vector(15 downto 0); --   audio  data input
            fdata_o			: out	std_logic_vector(15 downto 0)  -- filtered data output
        );
    END COMPONENT;

----------------------------------------
--   SIGNALS
----------------------------------------

    SIGNAL t_clock          : std_logic;
    SIGNAL t_reset          : std_logic;
    SIGNAL t_strobe         : std_logic;
    SIGNAL t_aud_high       : std_logic_vector(15 downto 0);
    SIGNAL t_aud_low        : std_logic_vector(15 downto 0);

----------------------------------------
--   BEGIN
----------------------------------------

BEGIN 

fir_high: fir_core
    GENERIC MAP(lut_fir => LUT_FIR_BPF_E4_v2 )  -- FILTER HIGHER STRINGS
    PORT MAP(      
            clk         => t_clock ,       	
            reset_n     => t_reset,
            strobe_i    => t_strobe,		
            adata_i     => ADATA_I,
            fdata_o	    => t_aud_high
    );

fir_low: fir_core
    GENERIC MAP(lut_fir => LUT_FIR_LPF_100Hz_v2 )  -- FILTER LOWER STRINGS
    PORT MAP(      
            clk         => t_clock ,       	
            reset_n     => t_reset,
            strobe_i    => t_strobe,		
            adata_i     => ADATA_I,
            fdata_o	    => t_aud_low
    );

t_clock     <= CLK;
t_reset     <= RESET_N;
t_strobe    <= STROBE_I;

----------------------------------------
---   OUTPUT SELECT  
----------------------------------------
selecting: PROCESS(all)
BEGIN
    CASE SW_I IS
        WHEN '0'    => FDATA_O <= t_aud_low;
        WHEN '1'    => FDATA_O <= t_aud_high;
        WHEN OTHERS => FDATA_O <= t_aud_low;
    END CASE;
END PROCESS selecting;

END struct;