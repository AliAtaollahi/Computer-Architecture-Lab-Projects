module ID_Stage_Reg (
    input clk, rst, freeze, flush,
    input WB_en_in, MEM_R_en_in, MEM_W_EN_IN, B_IN, S_IN, imm_IN,
    input [3:0] EXE_CMD_IN, Dest_in, Status_R_in,
    input [11:0] Shift_operand_IN,
    input [23:0] Signed_imm_24_IN,
    input [31:0] PC_IF_stage_Reg, Val_Rn_In, Val_Rm_In,
    input [3:0] src1_in, src2_in,

    output reg WB_en, MEM_R_en, MEM_W_EN, B, S, imm,
    output reg [3:0] EXE_CMD, Dest, Status_R_out,
    output reg [11:0] Shift_operand,
    output reg [23:0] Signed_imm_24,
    output reg [31:0] PC_out, Val_Rn, Val_Rm,
    output reg [3:0] src1_out, src2_out
  );

  always @(posedge clk, posedge rst)
  begin
    if (rst)
    begin
      PC_out <= 0;
      {WB_en, MEM_R_en, MEM_W_EN, B, S, EXE_CMD, Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24, Dest, Status_R_out, src1_out, src2_out} <= 126'b0;
    end
    else if (freeze)
    begin
      PC_out <= PC_out;
      {WB_en, MEM_R_en, MEM_W_EN, B, S, EXE_CMD, Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24, Dest, Status_R_out, src1_out, src2_out} <=
      {WB_en, MEM_R_en, MEM_W_EN, B, S, EXE_CMD, Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24, Dest, Status_R_out, src1_out, src2_out};
    end
    else if (flush)
    begin
      PC_out <= 0;
      {WB_en, MEM_R_en, MEM_W_EN, B, S, EXE_CMD, Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24, Dest, Status_R_out, src1_out, src2_out} <= 126'b0;
    end
    else
    begin
      PC_out <= PC_IF_stage_Reg;
      {WB_en, MEM_R_en, MEM_W_EN, B, S, EXE_CMD, Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24, Dest, Status_R_out, src1_out, src2_out} <=
      {WB_en_in, MEM_R_en_in, MEM_W_EN_IN, B_IN, S_IN, EXE_CMD_IN, Val_Rn_In, Val_Rm_In, imm_IN, Shift_operand_IN, Signed_imm_24_IN, Dest_in, Status_R_in, src1_in, src2_in};
    end
  end

endmodule
