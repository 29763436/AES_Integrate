library verilog;
use verilog.vl_types.all;
entity AES_top_vlg_sample_tst is
    port(
        CLK             : in     vl_logic;
        \in\            : in     vl_logic_vector(127 downto 0);
        key             : in     vl_logic_vector(127 downto 0);
        reset           : in     vl_logic;
        start           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end AES_top_vlg_sample_tst;
