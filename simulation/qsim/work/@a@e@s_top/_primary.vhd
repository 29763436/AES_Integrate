library verilog;
use verilog.vl_types.all;
entity AES_top is
    port(
        CLK             : in     vl_logic;
        reset           : in     vl_logic;
        start           : in     vl_logic;
        \in\            : in     vl_logic_vector(127 downto 0);
        key             : in     vl_logic_vector(127 downto 0);
        \out\           : out    vl_logic_vector(127 downto 0);
        ready           : out    vl_logic
    );
end AES_top;
