module Memory (
    input clk, rst, WB_en,
    input MEM_W_EN, MEM_R_EN,
    input[31:0] ALU_res, ST_val,
    output[31:0] mem_out,
    output WB_en_out,
    output ready,
    inout[15:0] SRAM_DQ,
    output[17:0] SRAM_ADDR,
    output SRAM_WE_N,
    output SRAM_UB_N,
    output SRAM_LB_N,
    output SRAM_CE_N,
    output SRAM_OE_N
  );

  DataMemory data_mem(
             .clk(clk),
             .rst(rst),
             .MEM_W_en(MEM_W_EN),
             .MEM_R_en(MEM_R_EN),
             .address(ALU_res),
             .data(ST_val),
             .out(mem_out)
           );

assign WB_en_out = ready ? WB_en : 1'b0;

          Sram_CT sram_ct (
                    .clk(clk),
                    .rst(rst),
                    .wr_en(MEM_W_EN),
                    .rd_en(MEM_R_EN),
                    .address(ALU_res),
                    .writeData(ST_val),

                    .readData(mem_out),
                    .ready(ready),
                    .SRAM_DQ(SRAM_DQ),
                    .SRAM_ADDR(SRAM_ADDR),
                    .SRAM_WE_N(SRAM_WE_N),
                    .SRAM_UB_N(SRAM_UB_N),
                    .SRAM_LB_N(SRAM_LB_N),
                    .SRAM_CE_N(SRAM_CE_N),
                    .SRAM_OE_N(SRAM_OE_N)
                  );



endmodule
