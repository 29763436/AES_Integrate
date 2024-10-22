library verilog;
use verilog.vl_types.all;
entity AES_top_vlg_check_tst is
    port(
        \out\           : in     vl_logic_vector(127 downto 0);
        ready           : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end AES_top_vlg_check_tst;
