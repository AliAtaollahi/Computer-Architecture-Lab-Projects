module EXE_Stage (
    input clk, rst,
    input[3:0] EXE_CMD,
    input MEM_R_en, MEM_W_en,
    input[31:0] PC_ID_Stage_Reg,
    input[31:0] Val_Rm_in, Val_Rn, ALU_res_f, WB_val_f,
    input imm,
    input[11:0] Shift_operand,
    input[23:0] Signed_imm_24,
    input[3:0] status_IN,
    input [1:0] sel_src1, sel_src2,

    output[31:0] address, Branch_Address, Val_Rm_out,
    output[3:0] status
  );
  wire [31:0] ALU_src_1, Val2_src;

  wire[31:0] Signed_imm_32 = { {6{Signed_imm_24[23]}}, Signed_imm_24, 2'b00};
  wire mem = MEM_R_en || MEM_W_en;
  wire[31:0] Val2;

  assign ALU_src_1 = (sel_src1 == 2'b00) ? Val_Rn :
         (sel_src1 == 2'b01) ? ALU_res_f:
         (sel_src1 == 2'b10) ? WB_val_f:
         Val_Rn;

  assign Val2_src = (sel_src2 == 2'b00) ? Val_Rm_in :
         (sel_src2 == 2'b01) ? ALU_res_f:
         (sel_src2 == 2'b10) ? WB_val_f:
         Val_Rm_in;

  assign Val_Rm_out = Val2_src;

  num2 num2_(
                     .Shift_operand(Shift_operand),
                     .RM_value(Val2_src),
                     .imm(imm),
                     .mem(mem),
                     .Val2(Val2)
                   );

  ALU alu(
        .input1(ALU_src_1),
        .input2(Val2),
        .carry_in(status_IN[1]),
        .command(EXE_CMD),
        .out(address),
        .carry_out(status[1]),
        .V(status[0]),
        .Z(status[2]),
        .N(status[3])
      );

  Adder adder(
          .a(PC_ID_Stage_Reg),
          .b(Signed_imm_32),
          .res(Branch_Address)
        );

endmodule
