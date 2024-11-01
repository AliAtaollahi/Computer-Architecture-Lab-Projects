module IF_stage_Reg (
    input clk, rst, freeze, flush,
    input [31:0] PC_IF_stage_Reg, Instruction_in,
    output reg [31:0] PC_out, Ins
  );

  always @(posedge clk, posedge rst)
  begin
    if (rst)
    begin
      PC_out <= 0;
      Ins <= 0;
    end
    else if (flush)
    begin
      PC_out <= 0;
      Ins <= 0;
    end
    else if (~freeze)
    begin
      PC_out <= PC_IF_stage_Reg;
      Ins <= Instruction_in;
    end
  end

endmodule
