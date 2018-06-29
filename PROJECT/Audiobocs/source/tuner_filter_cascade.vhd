LIBRARY ieee;
    use ieee.std_logic_1164.all;
    use work.audio_filter_pkg.all;

ENTITY tuner_filter_cascade IS
    PORT(
        CLK         : IN std_logic;
        RESET_N     : IN std_logic;
        STROBE_I    : IN std_logic;
        ADATA_I     : IN std_logic_vector(15 downto 0); 

        FDATA_400_O         : OUT std_logic_vector(15 downto 0);  -- Output after 400Hz LPF (HIGH)
        FDATA_400_200_O     : OUT std_logic_vector(15 downto 0);  -- Output after 400Hz->200 Hz LPF (MID)
        FDATA_400_200_100_O : OUT std_logic_vector(15 downto 0)   -- Output after 400Hz->200 Hz->100 Hz LPF (LOW)
    );
END tuner_filter_cascade;

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

    SIGNAL t_clock          : std_logic;
    SIGNAL t_reset          : std_logic;
    SIGNAL t_strobe         : std_logic;
    SIGNAL t_aud_400_200    : std_logic_vector(15 downto 0);    --Signal between 400LPF and 200LPF
    SIGNAL t_aud_200_100    : std_logic_vector(15 downto 0);    --Signal between 200LPF and 100LPF
    SIGNAL t_aud_100        : std_logic_vector(15 downto 0);    --Signal after all filters

BEGIN 

fir_400: fir_core
    GENERIC MAP(lut_fir => LUT_FIR_BPF_E4_v2 )  -- Constant from audio_filter_pkg
    PORT MAP(      
            clk         => t_clock ,       	
            reset_n     => t_reset,
            strobe_i    => t_strobe,		
            adata_i     => ADATA_I,
            fdata_o	    => t_aud_400_200
    );

fir_200: fir_core
    GENERIC MAP(lut_fir => LUT_FIR_LPF_200Hz_v2 )  -- Constant from audio_filter_pkg
    PORT MAP(      
            clk         => t_clock ,       	
            reset_n     => t_reset,
            strobe_i    => t_strobe,		
            adata_i     => ADATA_I,
            fdata_o	    => t_aud_200_100
    );

fir_100: fir_core
    GENERIC MAP(lut_fir => LUT_FIR_LPF_100Hz_v2 )  -- Constant from audio_filter_pkg
    PORT MAP(      
            clk         => t_clock ,       	
            reset_n     => t_reset,
            strobe_i    => t_strobe,		
            adata_i     => ADATA_I,
            fdata_o	    => t_aud_100
    );

t_clock     <= CLK;
t_reset     <= RESET_N;
t_strobe    <= STROBE_I;

FDATA_400_O         <= t_aud_400_200;
FDATA_400_200_O     <= t_aud_200_100;
FDATA_400_200_100_O <= t_aud_100;

END struct;