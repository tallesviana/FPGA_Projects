---------------------------------------------------------
--    I2S - AUDIO CONTROLLER
---------------------------------------------------------
-- 12/05/18 - tallesvv
---------------------------------------------------------
--
--  Basically it controls the I2S audio interface, routing 
--  the audio from DDS or ADCDAT to digital output
---------------------------------------------------------
--     FUNCTIONS
---------------------------------------------------------
--
--  SW0 - controls routing to FIR   0 - No FIR   1 - With FIR
--  SW1 - controls routing to output   0 - from ADC   0 - from DDS
--
---------------------------------------------------------


LIBRARY ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.audio_filter_pkg.all;

ENTITY audio_ctrl IS
    PORT(
        clk_12M      :  IN std_logic;
        reset_n_12M  :  IN std_logic;
        init_n   :  IN std_logic;

        sw_cfg_i :  IN std_logic_vector(1 downto 0);  -- Selects if data going to filter Datagen or DataADC
        
        strobe :  IN std_logic;

        ADCDAT_pl_i: IN std_logic_vector(15 downto 0);
        ADCDAT_pr_i: IN std_logic_vector(15 downto 0);

        DACDAT_gen_pl_i: IN std_logic_vector(15 downto 0);
        DACDAT_gen_pr_i: IN std_logic_vector(15 downto 0);


        DACDAT_pl_o: OUT std_logic_vector(15 downto 0);
        DACDAT_pr_o: OUT std_logic_vector(15 downto 0);

        init_o     : OUT std_logic
    );
END audio_ctrl;

ARCHITECTURE struct OF audio_ctrl IS

    TYPE t_mode IS (Gen_NoF, Gen_F, ADC_NoF, ADC_F);
    SIGNAL mode, next_mode  :  t_mode;

    SIGNAL dacdat_pl :  std_logic_vector(15 downto 0);
    SIGNAL dacdat_pr :  std_logic_vector(15 downto 0);

    SIGNAL dacdat_filter_i_l :  std_logic_vector(15 downto 0);
    SIGNAL dacdat_filter_i_r :  std_logic_vector(15 downto 0);
    SIGNAL dacdat_filter_o_l :  std_logic_vector(15 downto 0);
    SIGNAL dacdat_filter_o_r :  std_logic_vector(15 downto 0);


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
    end COMPONENT;

--=============   BEGIN  =================--
BEGIN

-- Combinational logic - Kinda FSM
modes: PROCESS(mode, next_mode, sw_cfg_i, init_n) 
BEGIN
    IF init_n = '0' THEN
        CASE sw_cfg_i IS
            WHEN "00" =>
                next_mode <= ADC_NoF;
            WHEN "01" =>
                next_mode <= Gen_NoF;
            WHEN "10" =>
                next_mode <= ADC_F;
            WHEN "11" =>
                next_mode <= Gen_F;
            WHEN OTHERS =>
                next_mode <= mode;
        END CASE;
    ELSE
        next_mode <= mode;
    END IF;
END PROCESS modes;

-- FLIP FLOPS to save mode
flip_flops: PROCESS(clk_12M, next_mode, reset_n_12M)
BEGIN
    IF reset_n_12M = '0' THEN
        mode <= ADC_NoF;
    ELSIF rising_edge(clk_12M) THEN
        mode <= next_mode;
    END IF;
END PROCESS flip_flops;

--  FIR  -   LEFT CHANNEL
filter_l: fir_core
    GENERIC MAP(lut_fir => LUT_FIR_LPF_1k6Hz )  -- from audio_filter_pkg)
    PORT MAP(      
            clk => clk_12M ,       	
            reset_n => reset_n_12M,     	
            strobe_i => strobe,		
            adata_i  => dacdat_filter_i_l,			
            fdata_o	 =>	dacdat_filter_o_l	
    );

--  FIR  -    RIGHT CHANNEL
filter_r: fir_core
    GENERIC MAP(lut_fir => LUT_FIR_LPF_1k6Hz)
    PORT MAP(    
            clk => clk_12M ,       	
            reset_n => reset_n_12M,     	
            strobe_i => strobe,		
            adata_i  => dacdat_filter_i_r,			
            fdata_o	 =>	dacdat_filter_o_r	
    );

-- Concurrent Statements - Audio Routing
choose_path: PROCESS(ALL)
BEGIN
    CASE mode IS
        WHEN ADC_NoF  =>
            DACDAT_pl_o <= ADCDAT_pl_i;
            DACDAT_pr_o <= ADCDAT_pr_i;
            dacdat_filter_i_l <= (OTHERS=>'0');
            dacdat_filter_i_r <= (OTHERS=>'0');
        WHEN Gen_NoF =>
            DACDAT_pl_o <= DACDAT_gen_pl_i;
            DACDAT_pr_o <= DACDAT_gen_pr_i;
            dacdat_filter_i_l <= (OTHERS=>'0');
            dacdat_filter_i_r <= (OTHERS=>'0');
        WHEN ADC_F =>
            DACDAT_pl_o <= dacdat_filter_o_l;
            DACDAT_pr_o <= dacdat_filter_o_r;
            dacdat_filter_i_l <= ADCDAT_pl_i;
            dacdat_filter_i_r <= ADCDAT_pr_i;
        WHEN Gen_F =>
            DACDAT_pl_o <= dacdat_filter_o_l;
            DACDAT_pr_o <= dacdat_filter_o_r;
            dacdat_filter_i_l <= DACDAT_gen_pl_i;
            dacdat_filter_i_r <= DACDAT_gen_pr_i;
        WHEN OTHERS =>
            DACDAT_pl_o <= ADCDAT_pl_i;
            DACDAT_pr_o <= ADCDAT_pr_i;
            dacdat_filter_i_l <= (OTHERS=>'0');
            dacdat_filter_i_r <= (OTHERS=>'0');
    END CASE;
END PROCESS choose_path;

init_o <= init_n;


END struct;