module Sram(
    input clk,
    input rst, 
    input wr_en,
    input rd_en,
    input[31:0] address,
    input[31:0] writedata,

    output[31:0] read_data,
    output ready,

    inout[15:0] SRAM_DQ,
    output[17:0] SRAM_ADDR,
    output SRAM_WE_N,
    output SRAM_UB_N,
    output SRAM_LB_N,
    output SRAM_CE_N,
    output SRAM_OE_N
);
    reg [15:0] memory[0:511];
    always@(posedge clk)
    begin
        if(~SRAM_WE_N)
            memory[SRAM_ADDR] = SRAM_DQ;    
    end

    assign #5 SRAM_DQ = SRAM_WE_N ? memory[SRAM_ADDR] : 16'bz;
endmodule