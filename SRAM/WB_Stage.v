module WB_Stage (
    input clk, rst, MEM_R_en,
    input[31:0] address, MEM_result,

    output[31:0] WB_value
);

    Mux mux(
        .a(address),
        .b(MEM_result),
        .sel(MEM_R_en),
        .c(WB_value)
    );

endmodule