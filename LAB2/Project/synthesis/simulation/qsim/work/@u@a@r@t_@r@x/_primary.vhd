library verilog;
use verilog.vl_types.all;
entity UART_RX is
    port(
        HEX0            : out    vl_logic_vector(6 downto 0);
        CLOCK_50        : in     vl_logic;
        KEY             : in     vl_logic_vector(0 downto 0);
        GPIO_1          : in     vl_logic_vector(1 downto 1);
        HEX1            : out    vl_logic_vector(6 downto 0);
        LEDR            : out    vl_logic_vector(0 downto 0)
    );
end UART_RX;
