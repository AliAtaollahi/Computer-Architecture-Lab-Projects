module IF_Stage (
    input clk, rst, freeze, Branch_taken,
    input [31:0] Branch_Address,
    output [31:0] PC_ID_Stage_Reg, Ins
  );

  wire [31:0] PC_reg_in;
  reg  [31:0] PC_reg_out;

  Mux mux (
        PC_ID_Stage_Reg,
        Branch_Address,
        Branch_taken,
        PC_reg_in
      );

  Adder pcAdder (
          PC_reg_out,
          4,
          PC_ID_Stage_Reg
        );

  Instrucrion_Memory instruction_mem (
            PC_reg_out,
            Ins
          );

  always @(posedge clk, posedge rst)
  begin
    if (rst)
      PC_reg_out <= 0;
    else if (~freeze)
      PC_reg_out <= PC_reg_in;
  end

endmodule
