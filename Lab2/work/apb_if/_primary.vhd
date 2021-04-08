library verilog;
use verilog.vl_types.all;
entity apb_if is
    generic(
        APB_ADDR_WIDTH  : integer := 16;
        APB_DATA_WIDTH  : integer := 32
    );
    port(
        PClk            : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of APB_ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of APB_DATA_WIDTH : constant is 1;
end apb_if;
