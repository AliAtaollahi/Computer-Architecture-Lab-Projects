module Memory (
    input clk, MEMwrite, MEMread,
    input[31:0] address, data,
    output[31:0] MEM_result
  );

  DataMemory data_mem(
             .clk(clk),
             .MEM_W_EN(MEMwrite),
             .MEM_R_en(MEMread),
             .address(address),
             .data(data),
             .out(MEM_result)
           );


endmodule
