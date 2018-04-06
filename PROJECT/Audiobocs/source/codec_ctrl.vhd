-------------------------------------------
--    CODEC CONTROLLER - WM8731  
--    Controls WM8731 functions   
--    03/04/18 - 1st Version - Talles Viana
--

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.reg_table_pkg.all;     -- Using the data package

--||||||   ENTITY   ||||||--

ENTITY codec_ctrl IS
    PORT(
        event_ctrl_i :  IN std_logic_vector(9 downto 0);
        init_i       :  in std_logic;
        write_done_i :  IN std_logic;
        ack_error_i  :  IN std_logic;
        clk    :  IN std_logic;
        reset_n      :  IN std_logic;

        write_o      :  OUT std_logic;
        write_data_o :  OUT std_logic_vector(15 downto 0)
    );
END codec_ctrl;

--||||||   ARCHITECTURE  ||||||--

ARCHITECTURE rtl OF codec_ctrl IS

    TYPE codec_state IS (IDLE, START_WRITE, WAIT_WRITE);    -- States of the CODEC Controller

    SIGNAL state, next_state :  codec_state;
    SIGNAL regcount, next_regcount :  integer range 0 to 9;


BEGIN

    -- PROCESS FOR COMB_INPUT FSM --

    fsm_drive: PROCESS (state, regcount, write_done_i, ack_error_i, event_ctrl_i, init_i)
    BEGIN
        next_state <= state;

        CASE state IS

            -- IDLE STATE --
            WHEN IDLE =>
        
                next_regcount <= 0;  -- Register counter reset
                write_o <= '0';

                IF init_i = '0' THEN        -- If KEY is pressed
                    -- Go to Next State
                    next_state <= START_WRITE;
                END IF;
            
            
            -- Load data, and start writing
            WHEN START_WRITE =>  

                write_data_o(15 downto 9) <= std_logic_vector(to_unsigned(regcount, 7));

                CASE event_ctrl_i IS        -- Select Functions
                    WHEN "0000000000" =>
                        write_data_o(8 downto 0) <= C_W8731_ANALOG_BYPASS(regcount);
                    WHEN "0000000001" =>
                        write_data_o(8 downto 0) <= C_W8731_ANALOG_MUTE_LEFT(regcount);
                    WHEN "0000000010" =>
                        write_data_o(8 downto 0) <= C_W8731_ANALOG_MUTE_RIGHT(regcount);
                    WHEN "0000000011" =>
                        write_data_o(8 downto 0) <= C_W8731_ANALOG_MUTE_BOTH(regcount);
                    WHEN "0000000100" =>
                        write_data_o(8 downto 0) <= C_W8731_ADC_DAC_0DB_48K(regcount);
                    WHEN OTHERS =>
                        write_data_o(8 downto 0) <= (OTHERS => '0');
                END CASE;           

                write_o <= '1';
                next_state <= WAIT_WRITE;

            
            -- Wait ACK_ERROR or WRITE_DONE
            WHEN WAIT_WRITE =>
                write_o <= '0';
                -- If ack_error, returns to IDLE
                IF (ack_error_i = '1') THEN
                    next_state <= IDLE;

                ELSIF (write_done_i = '1') THEN
                    -- If write_done: check if it is the last reg
                    IF regcount < 9 THEN
                        -- If not, load next data
                        next_regcount <= regcount + 1;
                        next_state <= START_WRITE;
                    ELSE
                        -- If so, go to IDLE
                        next_state <= IDLE;
                    END IF;
                END IF;
               
            WHEN OTHERS =>
                next_state <= IDLE;
                next_regcount <= 0;
        END CASE;
            

    END PROCESS;


    -- SEQUENTIAL LOGIC --

    flip_flops: PROCESS (clk, reset_n)
    BEGIN
        IF reset_n = '0' THEN
            regcount <= 0;
            state <= IDLE;
        ELSIF rising_edge(clk) THEN
            regcount <= next_regcount;
            state    <= next_state;
        END IF;
    END PROCESS;

END rtl;