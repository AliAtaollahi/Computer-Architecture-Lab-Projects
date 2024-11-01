module TB_DE2 ();

  reg clk, rst;
  wire [15:0] SRAM_DQ;
  wire [17:0] SRAM_ADDR;
  wire SRAM_WE_N;
  wire SRAM_UB_N;
  wire SRAM_LB_N;
  wire SRAM_CE_N;
  wire SRAM_OE_N;

  ARM arm (
        .clk(clk),
        .rst(rst)
      /*  .SRAM_DQ(SRAM_DQ),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_UB_N(SRAM_UB_N),
        .SRAM_LB_N(SRAM_LB_N),
        .SRAM_CE_N(SRAM_CE_N),
        .SRAM_OE_N(SRAM_OE_N) */
      );

  initial
  begin
    clk = 1;
    repeat (1200)
    begin
      #50;
      clk = ~clk;
    end
  end

  initial
  begin
    rst = 0;
    #20 rst = 1;
    #10 rst = 0;
  end

endmodule
