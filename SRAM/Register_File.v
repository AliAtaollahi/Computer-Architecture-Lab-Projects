module Register_File (
    input clk, rst,
    input [3:0] Dest_wb, src_1, src_2,
    input [31:0] dest_wb,
    input WB_WB_EN,
    output [31:0] Val_Rn, Val_Rm
  );

  reg [31:0] RegFile [0:14];

  integer i;

  initial
  begin
    for (i = 0; i < 15 ; i = i + 1 )
      RegFile[i] = i;
  end

  assign Val_Rn = RegFile[src_1];
  assign Val_Rm = RegFile[src_2];

  always @(negedge clk, posedge rst)
  begin
    if (rst)
      for (i = 0; i < 15 ; i = i + 1 )
        RegFile[i] <= i;
    else if (WB_WB_EN)
      RegFile[Dest_wb] <= dest_wb;
  end

endmodule
