LIBRARY ieee;
use ieee.std_logic_1164.all;

LIBRARY work;  -- Able to see the other components

------------------------------------------------------
-->>>>>>>>>>>      ENTITY DECLARATION   <<<<<<<<<<<<<<
------------------------------------------------------

ENTITY audio_synth_top IS
    PORT(
        CLOCK_50 :  IN std_logic;
        KEY      :  IN std_logic_vector(3 downto 0);
        SW       :  IN std_logic_vector(9 downto 0);
        AUD_XCK  :  OUT std_logic;
        I2C_SCLK :  OUT std_logic;
        I2C_SDAT :  INOUT std_logic
    );
END audio_synth_top;

------------------------------------------------------
-->>>>>>>>>>>      COMPONENTS USED      <<<<<<<<<<<<<<
------------------------------------------------------

ARCHITECTURE top OF audio_synth_top IS

COMPONENT codec_ctrl IS
    PORT(
        event_ctrl_i :  IN std_logic_vector(9 downto 0);
        init_i       :  in std_logic;
        write_done_i :  IN std_logic;
        ack_error_i  :  IN std_logic;
        clk          :  IN std_logic;
        reset_n      :  IN std_logic;

        write_o      :  OUT std_logic;
        write_data_o :  OUT std_logic_vector(15 downto 0)
    );
END COMPONENT;

COMPONENT i2c_master is
        port(
            clk         : in    std_logic;
            reset_n     : in    std_logic;

            write_i     : in    std_logic;
			write_data_i: in	std_logic_vector(15 downto 0);
			
			sda_io		: inout	std_logic;
			scl_o		: out   std_logic;
			
			write_done_o: out	std_logic;
			ack_error_o	: out	std_logic
        );
end COMPONENT;

COMPONENT clock_div IS
    PORT(
        clk_fast_i :  IN std_logic;
        clk_slow_o :  OUT std_logic
    );
END COMPONENT;

COMPONENT sync_block IS
    PORT(
        async_i:  IN std_logic;
        clk:      IN std_logic;

        syncd_o:   OUT std_logic
    );
END COMPONENT;

------------------------------------------------------
-->>>>>>>>>>>      SIGNAL DECLARATION   <<<<<<<<<<<<<<
------------------------------------------------------

SIGNAL t_clock_50   :  std_logic;  -- Input clock - 50MHz
SIGNAL t_clock_12_5 :  std_logic;  -- Sys clock   - 12,5MHz
SIGNAL t_key        :  std_logic_vector(3 downto 0);  -- Input keys
SIGNAL t_sw         :  std_logic_vector(9 downto 0);  -- Input toggle switches

SIGNAL t_reset_syncd:  std_logic;  -- Key signals after syncing - RESET
SIGNAL t_init_syncd :  std_logic;  -- INIT

SIGNAL t_write_done :  std_logic;  -- Feedback signals
SIGNAL t_ack_error  :  std_logic;

SIGNAL t_write      : std_logic;  -- Signals from Codec Ctrl to I2C Master
SIGNAL t_data2write : std_logic_vector(15 downto 0);

SIGNAL t_i2c_sclk   : std_logic;  -- Output signals from I2C Master

------------------------------------------------------
-->>>>>>>>>>>      BEGIN OF ARCHITEC   <<<<<<<<<<<<<<
------------------------------------------------------

BEGIN


clk_div_1: clock_div
    PORT MAP(
        clk_fast_i => t_clock_50,
        clk_slow_o => t_clock_12_5
    );

reset_sync: sync_block
    PORT MAP(
        async_i => t_key(0),
        clk     => t_clock_12_5,
        syncd_o => t_reset_syncd
    );

init_sync: sync_block
    PORT MAP(
        async_i => t_key(1),
        clk     => t_clock_12_5,
        syncd_o => t_init_syncd
    );

codec: codec_ctrl
    PORT MAP(
        event_ctrl_i => t_sw,
        init_i       => t_init_syncd,
        write_done_i => t_write_done,
        ack_error_i  => t_ack_error,
        clk          => t_clock_12_5,
        reset_n      => t_reset_syncd,
        write_o      => t_write,
        write_data_o => t_data2write
    );

master: i2c_master
    PORT MAP(
        clk         => t_clock_12_5,
        reset_n     => t_reset_syncd,

        write_i     => t_write,
        write_data_i=> t_data2write,
        
        sda_io		=> I2C_SDAT,  -- Connected I2C SDA directly
        scl_o		=> t_i2c_sclk,
        
        write_done_o=> t_write_done,
        ack_error_o	=> t_ack_error
    );

t_clock_50 <= CLOCK_50;
t_key      <= KEY;
t_sw       <= SW;
AUD_XCK    <= t_clock_12_5;
I2C_SCLK   <= t_i2c_sclk;

END top;
