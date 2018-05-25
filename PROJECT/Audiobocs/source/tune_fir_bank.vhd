-------------------------------------------------------
---------------    BANK OF FILTERS   ------------------
-------------------------------------------------------
--
--     Outputs the same signal passing through
--     different BPF.
--     E2, A2, D3, G3, B3 and E4
-------------------------------------------------------
-- 25/05 - tallesvv - 1st version
-------------------------------------------------------

LIBRARY ieee;
  use ieee.std_logic_1164.all;

------------------------------------------------------
-->>>>>>>>>>>      ENTITY DECLARATION   <<<<<<<<<<<<<<
------------------------------------------------------

ENTITY tune_fir_bank IS
  PORT(
      clk      :  IN std_logic;
      reset_n  :  IN std_logic;
      strobe_i :  IN std_logic;
      adata_i  :  IN std_logic_vector(15 downto 0);

      fdata_e2_o  :  OUT std_logic_vector(15 downto 0);
      fdata_a2_o  :  OUT std_logic_vector(15 downto 0);
      fdata_d3_o  :  OUT std_logic_vector(15 downto 0);
      fdata_g3_o  :  OUT std_logic_vector(15 downto 0);
      fdata_b3_o  :  OUT std_logic_vector(15 downto 0);
      fdata_e4_o  :  OUT std_logic_vector(15 downto 0)

  );
END tune_fir_bank;

------------------------------------------------------
-->>>>>>>>>>>      ARCHITECTURE         <<<<<<<<<<<<<<
------------------------------------------------------

ARCHITECTURE struct OF tune_fir_bank IS

------------------------------------------------------
-->>>>>>>>>>>      COMPONENTS USED      <<<<<<<<<<<<<<
------------------------------------------------------

COMPONENT fir_core IS
	GENERIC(
		lut_fir : t_lut_fir := LUT_FIR_LPF_200Hz );  -- from audio_filter_pkg
    PORT(
		clk         	: in    std_logic;
		reset_n     	: in    std_logic;
		strobe_i		: in    std_logic; 					   -- indicates beginning of audio frame
		adata_i			: in	std_logic_vector(15 downto 0); --   audio  data input
		fdata_o			: out	std_logic_vector(15 downto 0)  -- filtered data output
      );
END COMPONENT;

------------------------------------------------------
-->>>>>>>>>>>      SIGNAL DECLARATION   <<<<<<<<<<<<<<
------------------------------------------------------

  SIGNAL t_clock_12_5  :  std_logic;
  SIGNAL t_reset_n     :  std_logic;
  SIGNAL t_strobe      :  std_logic;
  SIGNAL t_audio_in    :  std_logic_vector(15 downto 0);

BEGIN 

FIR_E2: fir_core
    GENERIC MAP( lut_fir => LUT_FIR_BPF_E2 )
    PORT MAP(
        clk      => t_clock_12_5,
        reset_n  => t_reset_n,
        strobe_i => t_strobe,
        adata_i  => t_audio_in,
        fdata_o  => fdata_e2_o
    );

FIR_A2: fir_core
    GENERIC MAP( lut_fir => LUT_FIR_BPF_A2 )
    PORT MAP(
        clk      => t_clock_12_5,
        reset_n  => t_reset_n,
        strobe_i => t_strobe,
        adata_i  => t_audio_in,
        fdata_o  => fdata_a2_o
    );

FIR_D3: fir_core
    GENERIC MAP( lut_fir => LUT_FIR_BPF_D3 )
    PORT MAP(
        clk      => t_clock_12_5,
        reset_n  => t_reset_n,
        strobe_i => t_strobe,
        adata_i  => t_audio_in,
        fdata_o  => fdata_d3_o
    );

FIR_G3: fir_core
    GENERIC MAP( lut_fir => LUT_FIR_BPF_G3 )
    PORT MAP(
        clk      => t_clock_12_5,
        reset_n  => t_reset_n,
        strobe_i => t_strobe,
        adata_i  => t_audio_in,
        fdata_o  => fdata_g3_o
    );

FIR_B3: fir_core
    GENERIC MAP( lut_fir => LUT_FIR_BPF_B3 )
    PORT MAP(
        clk      => t_clock_12_5,
        reset_n  => t_reset_n,
        strobe_i => t_strobe,
        adata_i  => t_audio_in,
        fdata_o  => fdata_b3_o
    );

FIR_E4: fir_core
    GENERIC MAP( lut_fir => LUT_FIR_BPF_E4 )
    PORT MAP(
        clk      => t_clock_12_5,
        reset_n  => t_reset_n,
        strobe_i => t_strobe,
        adata_i  => t_audio_in,
        fdata_o  => fdata_e4_o
    );

-- Concurrent assignemnts --

t_clock_12_5 <= clk;
t_reset_n    <= reset_n;
t_strobe     <= strobe_i;
t_audio_in   <= adata_i;

END struct;