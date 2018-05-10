-------------------------------------------------------------------------------
--
-- Project     : Audio_Sythesizer
-- Description : FIR_core Block
--				Implementing FIR with convolution of taps and audio data input 
-------------------------------------------------------------------------------
--
-- Change History
-- Date       | Name     |Modification
--------------|----------|-------------------------------------------------------
-- 26.03.2018 | dqtm     | file created
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.audio_filter_pkg.all;

entity fir_core is
	generic(
		lut_fir : t_lut_fir := LUT_FIR_LPF_200Hz );  -- from audio_filter_pkg
    port(
		clk         	: in    std_logic;
		reset_n     	: in    std_logic;
		strobe_i		: in    std_logic; 					   -- indicates beginning of audio frame
		adata_i			: in	std_logic_vector(15 downto 0); --   audio  data input
		fdata_o			: out	std_logic_vector(15 downto 0)  -- filtered data output
      );
end entity;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture rtl of fir_core is
	
	-- SIGNALS DECLARATION
	TYPE t_fir_fsm IS (idle, tap_0, tap_x_waitrd, tap_x_mac, sample_rdy);
	SIGNAL fir_state, next_fir_state : t_fir_fsm;

	SIGNAL  tap_counter				: natural range 0 to N_LUT-1;		-- to count number of conv-iterations
	SIGNAL  next_tap_counter		: natural range 0 to N_LUT-1;		-- currently (255-1) = 254
	
	-- Buffers for audio-in/out
	SIGNAL 	adata_buf				: signed(15 downto 0);	-- fir input buffer
	SIGNAL 	next_adata_buf			: signed(15 downto 0);		

	SIGNAL 	fir_reg_o				: signed(15 downto 0);	-- fir output buffer
	SIGNAL 	next_fir_reg_o			: signed(15 downto 0);		
	
	-- signals for RAM block instantiations
	SIGNAL 	tap_we 					: std_logic;	-- tap_line write enable

	SIGNAL 	addr_offset 			: natural range 0 to N_LUT-1;	-- stores offset for circular_buffer addressing
	SIGNAL 	next_addr_offset 		: natural range 0 to N_LUT-1;	
	SIGNAL 	tap_addr 				: natural range 0 to N_LUT-1;	-- current address for tap_line

	SIGNAL 	tap_mac_2store 			: signed(N_RESOL_TAP-1 downto 0);	-- value to be stored in tap_line
	SIGNAL 	tap_data_o 				: std_logic_vector(N_RESOL_TAP-1 downto 0);	-- value read from tap_line
	
	-- COMPONENT DECLARATION
	COMPONENT single_port_ram 
		GENERIC(
			ADDR_NBR:		integer := N_LUT;   -- constants from audio_filter_pkg
			ADDR_WIDTH: 	integer := N_addr_LUT;
			DATA_WIDTH:		integer := N_RESOL_TAP    
		);
		PORT( clk	 	 	: IN    std_logic;						
			we				: IN	std_logic;		-- 1:write enabled / read every clk-cycle
			addr			: IN	std_logic_vector(ADDR_WIDTH-1 downto 0);	
			data_i			: IN 	std_logic_vector(DATA_WIDTH-1 downto 0);	
			data_o			: OUT	std_logic_vector(DATA_WIDTH-1 downto 0) -- available 1-clk after addr set
			);
	END COMPONENT single_port_ram;

	
BEGIN
-----------------------------------------------------------------------
-- INSTANTIATION MEM_BLOCKS
-----------------------------------------------------------------------
	tap_line : single_port_ram
	PORT MAP(
		clk		=>  clk,
		we		=>	tap_we,
		addr	=>	std_logic_vector(to_unsigned(tap_addr,N_addr_LUT)),
		data_i	=>	std_logic_vector(tap_mac_2store),		-- from calculation buffer
		data_o	=>	tap_data_o
	);


	-----------------------------------------------------------------------
    -- REGISTER PROCESS
    -----------------------------------------------------------------------
	flip_flops : PROCESS(clk, reset_n)
	BEGIN	
		IF reset_n = '0' THEN
			fir_state	<= idle;
			tap_counter <= 0;
			adata_buf	<= (OTHERS => '0');
			fir_reg_o	<= (OTHERS => '0');
			addr_offset <= 0;
			
		ELSIF rising_edge(clk) THEN
			fir_state	<= next_fir_state;
			tap_counter <= next_tap_counter; 
			adata_buf	<= next_adata_buf;
			fir_reg_o	<= next_fir_reg_o;	
			addr_offset <= next_addr_offset; 

		END IF;
	END PROCESS flip_flops;		

	
	-----------------------------------------------------------------------
    -- COMB-LOGIC PROCESS for FSM
    -----------------------------------------------------------------------
	fsm_comb: PROCESS(all)
		VARIABLE aux_signed : signed(N_RESOL_TAP-1 downto 0); 

	BEGIN
		-- Default Statements: keep current value
			next_fir_state	 <= fir_state;
			next_tap_counter <= tap_counter; 
			next_adata_buf	 <= adata_buf;
			next_fir_reg_o	 <= fir_reg_o;	
			next_addr_offset <= addr_offset; 
			tap_we 	   		 <= '0';		-- defautl is read-only access to RAM
			tap_addr		 <= (addr_offset+tap_counter) mod N_LUT; -- for value in range [0;N_LUT-1]=[0;254]
			tap_mac_2store	 <= (OTHERS => '0');  -- dummy filtered value
			
		CASE fir_state IS
			WHEN idle =>
				-- wait for strobe pulse, to start next conv-loop (once per audio frame)otherwise follow to init_ram
				IF (strobe_i = '1') THEN
					next_fir_state	 <= tap_0;
					next_tap_counter <= 0;
					next_adata_buf	 <= signed(adata_i);   -- buffer audio-input (expect valid-data at same time as strobe pulse)
				END IF; 

			WHEN tap_0 =>
				next_fir_state	 <= tap_x_waitrd;
				next_tap_counter <= tap_counter + 1;
				tap_we 	   		 <= '1';
				
				-- index for LUT must be integer type
				tap_mac_2store	 <= adata_buf * lut_fir(tap_counter) ; --check width result
				
			WHEN tap_x_waitrd =>  -- only need to split mac if timing critical
				next_fir_state	 <= tap_x_mac;

			WHEN tap_x_mac =>
				IF (tap_counter >= (N_LUT-1)) THEN -- until 254
					next_fir_state	 <= sample_rdy;
					next_tap_counter <= 0;
				ELSE
					next_fir_state	 <= tap_x_waitrd;
					next_tap_counter <= tap_counter + 1;
				END IF;
				tap_we 	   		 <= '1';
				tap_mac_2store	 <= signed(tap_data_o) + ( adata_buf * LUT_FIR(tap_counter) ) ;

			WHEN sample_rdy =>
				next_fir_state	 <=   idle;
				-- need conversion here cause arith-shift only possible with signed
				aux_signed		 :=   shift_right(signed(tap_data_o),16); -- will take 16 MSBs, later can decide to add gain (to be tuned later)
				next_fir_reg_o 	 <=   aux_signed(15 downto 0);
				IF (addr_offset > 0) THEN
					next_addr_offset <= addr_offset - 1;
				ELSE
					next_addr_offset <= (N_LUT-1); -- jump 255, and go to 254
				END IF;
				
			WHEN OTHERS =>
				next_fir_state	 <=   idle;

		END CASE;
	END PROCESS fsm_comb;

    
    -----------------------------------------------------------------------
    -- CONCURRENT ASSIGNMENTS (for outputs)
    -----------------------------------------------------------------------
	fdata_o <= std_logic_vector(fir_reg_o);
	
end architecture;
