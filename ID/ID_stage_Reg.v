module ID_Stage_Reg (
    input clk, rst, freeze, flush,
    input WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN,
    input B_IN,S_IN,
    input[3:0] EXE_CMD_IN, SR,
    input [31:0] PC_IF_stage_Reg,
    input[31:0] Val_Rn_IN, Val_Rm_IN,
    input imm_IN,
    input[11:0] Shift_operand_IN,
    input[23:0] Signed_imm_24_IN,
    input[3:0] Dest_IN,
    output reg WB_EN, MEM_R_EN, MEM_W_EN, B, S,
    output reg[3:0] EXE_CMD, Status_R_out,
    output reg[31:0] PC_ID_Stage_Reg,
    output reg[31:0] Val_Rn, Val_Rm,
    output reg imm,
    output reg[11:0] Shift_operand,
    output reg[23:0] Signed_imm_24,
    output reg[3:0] Dest
);

  always @(posedge clk, posedge rst)
  begin
    if (rst)
    begin
      PC_ID_Stage_Reg <= 0;
      {WB_EN, MEM_R_EN, MEM_W_EN, B, S, EXE_CMD, Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24, Dest, Status_R_out} <= 118'b0;
    end
    else if (freeze)
    begin
      PC_ID_Stage_Reg <= PC_ID_Stage_Reg;
      {WB_EN, MEM_R_EN, MEM_W_EN, B, S, EXE_CMD, Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24, Dest, Status_R_out} <=
      {WB_EN, MEM_R_EN, MEM_W_EN, B, S, EXE_CMD, Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24, Dest, Status_R_out};
    end
    else if (flush)
    begin
      PC_ID_Stage_Reg <= 0;
      {WB_EN, MEM_R_EN, MEM_W_EN, B, S, EXE_CMD, Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24, Dest, Status_R_out} <= 118'b0;
    end
    else
    begin
      PC_ID_Stage_Reg <= PC_IF_stage_Reg;
      {WB_EN, MEM_R_EN, MEM_W_EN, B, S, EXE_CMD, Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24, Dest, Status_R_out} <=
      {WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN, B_IN, S_IN, EXE_CMD_IN, Val_Rn_IN, Val_Rm_IN, imm_IN, Shift_operand_IN, Signed_imm_24_IN, Dest_IN, SR};
    end
  end

endmodule