library verilog;
use verilog.vl_types.all;
entity UART_RX_vlg_sample_tst is
    port(
        CLOCK_50        : in     vl_logic;
        GPIO_1          : in     vl_logic_vector(1 downto 1);
        KEY             : in     vl_logic_vector(0 downto 0);
        sampler_tx      : out    vl_logic
    );
end UART_RX_vlg_sample_tst;
