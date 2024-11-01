
module ARM (
    input clk, 
    input rst,
	  output L
 );

  wire Branch_taken;
  wire [31:0] branchAddr, PC_IF, inst_IF;

  wire wb_en_ID, mem_r_en_ID, mem_w_en_ID, b_ID, s_ID, imm_ID, hazard;
  wire[3:0] exe_cmd_ID, dest_ID;
  assign L = wb_en_ID ^ mem_r_en_ID;
  wire[31:0] val_rn_ID, val_rm_ID, PC_ID, inst_ID;
  wire[11:0] shift_operand_ID;
  wire[23:0] signed_imm_24_ID;
  wire two_src, use_src1;

  wire wb_en_EXE, mem_r_en_EXE, mem_w_en_EXE, s_EXE, imm_EXE;
  wire[3:0] exe_cmd_EXE, dest_EXE, src1_ID, src2_ID, src1_EXE, src2_EXE;
  wire [1:0] sel_src1, sel_src2;
  wire[31:0] val_rn_EXE, val_rm_EXE, PC_EXE, ALU_res_EXE, val_rm_EXE_out;
  wire[11:0] shift_operand_EXE;
  wire[23:0] signed_imm_24_EXE;

  wire wb_en_MEM, mem_r_en_MEM, mem_w_en_MEM;
  wire[31:0] ALU_res_MEM, val_rm_MEM, mem_out_MEM;


  wire[3:0] Dest_MEM;

  wire[31:0] WB_value;
  wire[3:0] Dest_wb;

  wire[31:0] inst_EXE;
  wire[31:0] PC_MEM, inst_MEM;
  wire[31:0] PC_FINAL, inst_FINAL;

  wire WB_EN_WB, MEM_R_EN_WB;
  wire[31:0] ALU_res_WB, mem_out_WB;

  wire[3:0] status_EXE_in, status_EXE_out, status_ID;

  // assign Branch_taken = SW & rst;
  StatusRegister status_register (
                   .clk(clk),
                   .rst(rst),
                   .status_in(status_EXE_out),
                   .S(s_EXE),
                   .status_out(status_ID)
                 );


  IF_Stage if_stage (
             .clk(clk),
             .rst(rst),
             .freeze(hazard),
             .Branch_taken(Branch_taken),
             .Branch_Address(branchAddr),
             .PC_ID_Stage_Reg(PC_IF),
             .Ins(inst_IF)
           );

  IF_stage_Reg if_reg (
           .clk(clk),
           .rst(rst),
           .freeze(hazard),
           .flush(Branch_taken),
           .PC_IF_stage_Reg(PC_IF),
           .Instruction_in(inst_IF),
           .PC_out(PC_ID),
           .Ins(inst_ID)
         );

  HazardDetector hazard_unit(
                   .src1(src1_ID),
                   .src2(src2_ID),
                   .Exe_Dest(dest_EXE),
                   .Exe_WB_EN(wb_en_EXE),
                   .Mem_Dest(Dest_MEM),
                   .Mem_WB_EN(wb_en_MEM),
                   .Two_src(two_src),
                   .use_src1(use_src1),
                   .hazard_Detected(hazard),
                   .forward_mode(1'b0),
                   .Exe_Mem_R_EN(mem_r_en_EXE)
                 );

  ID_Stage id_stage (
             .clk(clk),
             .rst(rst),
             .hazard(hazard),
             .WB_WB_EN(WB_EN_WB),
             .Dest_wb(Dest_wb),
             .dest_wb(WB_value),
             .SR(status_ID),
             .Ins(inst_ID),

             .writeBackEn(wb_en_ID),
             .MEM_R_en(mem_r_en_ID),
             .MEM_W_EN(mem_w_en_ID),
             .b(b_ID),
             .S(s_ID),
             .Two_src(two_src),
             .use_src1(use_src1),
             .imm(imm_ID),
             .EXE_CMD(exe_cmd_ID),
             .Dest(dest_ID),
             .Shift_operand(shift_operand_ID),
             .signed_imm_24(signed_imm_24_ID),
             .Val_Rn(val_rn_ID),
             .Val_Rm(val_rm_ID),
             .src1(src1_ID),
             .src2(src2_ID)
           );

  ID_Stage_Reg id_reg (
           .clk(clk),
           .rst(rst),
           .freeze(1'b0),
           .flush(Branch_taken),
           .WB_en_in(wb_en_ID),
           .MEM_R_en_in(mem_r_en_ID),
           .MEM_W_EN_IN(mem_w_en_ID),
           .B_IN(b_ID),
           .S_IN(s_ID),
           .EXE_CMD_IN(exe_cmd_ID),
           .PC_IF_stage_Reg(PC_ID),
           .Val_Rn_In(val_rn_ID),
           .Val_Rm_In(val_rm_ID),
           .imm_IN(imm_ID),
           .Shift_operand_IN(shift_operand_ID),
           .Signed_imm_24_IN(signed_imm_24_ID),
           .Dest_in(dest_ID),
           .Status_R_in(status_ID),
           .src1_in(src1_ID),
           .src2_in(src2_ID),

           .WB_en(wb_en_EXE),
           .MEM_R_en(mem_r_en_EXE),
           .MEM_W_EN(mem_w_en_EXE),
           .B(Branch_taken),
           .S(s_EXE),
           .EXE_CMD(exe_cmd_EXE),
           .PC_out(PC_EXE),
           .Val_Rn(val_rn_EXE),
           .Val_Rm(val_rm_EXE),
           .imm(imm_EXE),
           .Shift_operand(shift_operand_EXE),
           .Signed_imm_24(signed_imm_24_EXE),
           .Dest(dest_EXE),
           .Status_R_out(status_EXE_in),
           .src1_out(src1_EXE),
           .src2_out(src2_EXE)
         );

  EXE_Stage exe_stage(
              .clk(clk),
              .rst(rst),
              .EXE_CMD(exe_cmd_EXE),
              .MEM_R_en(mem_r_en_EXE),
              .MEM_W_EN(mem_w_en_EXE),
              .PC_ID_Stage_Reg(PC_EXE),
              .Val_Rm_in(val_rm_EXE),
              .Val_Rn(val_rn_EXE),
              .ALU_res_f(ALU_res_MEM),
              .WB_val_f(WB_value),
              .imm(imm_EXE),
              .Shift_operand(shift_operand_EXE),
              .Signed_imm_24(signed_imm_24_EXE),
              .status_IN(status_EXE_in),
              .sel_src1(sel_src1),
              .sel_src2(sel_src2),

              .address(ALU_res_EXE),
              .Branch_Address(branchAddr),
              .Val_Rm_out(val_rm_EXE_out),
              .status(status_EXE_out)
            );

  EXE_Reg exe_reg(
            .clk(clk),
            .rst(rst),
            .WB_en_in(wb_en_EXE),
            .MEM_R_en_in(mem_r_en_EXE),
            .MEM_W_EN_IN(mem_w_en_EXE),
            .ALU_result_in(ALU_res_EXE),
            .ST_val_in(val_rm_EXE_out),
            .Dest_in(dest_EXE),

            .WB_en(wb_en_MEM),
            .MEM_W_EN(mem_w_en_MEM),
            .MEM_R_en(mem_r_en_MEM),
            .address(ALU_res_MEM),
            .data(val_rm_MEM),
            .Dest(Dest_MEM)

          );

  Memory mem_stage(
              .clk(clk),
              .MEMwrite(mem_w_en_MEM),
              .MEMread(mem_r_en_MEM),
              .address(ALU_res_MEM),
              .data(val_rm_MEM),

              .MEM_result(mem_out_MEM)
            );

  MEM_Reg mem_reg(
            .clk(clk),
            .rst(rst),
            .WB_en_in(wb_en_MEM),
            .MEM_R_en_in(mem_r_en_MEM),
            .ALU_result_in(ALU_res_MEM),
            .Mem_read_value_in(mem_out_MEM),
            .Dest_in(Dest_MEM),

            .WB_en(WB_EN_WB),
            .MEM_R_en(MEM_R_EN_WB),
            .address(ALU_res_WB),
            .MEM_result(mem_out_WB),
            .Dest(Dest_wb)
          );

  Forwarding_unit FU (
                   .forward_en(1'b0),
                   .src1(src1_EXE),
                   .src2(src2_EXE),
                   .MEM_WB_en(wb_en_MEM),
                   .MEM_dest(Dest_MEM),
                   .WB_WB_en(WB_EN_WB),
                   .WB_dest(Dest_wb),
                   
                   .sel_src1(sel_src1),
                   .sel_src2(sel_src2)
                 );

  WB_Stage wb_stage(
             .clk(clk),
             .rst(rst),
             .MEM_R_en(MEM_R_EN_WB),
             .address(ALU_res_WB),
             .MEM_result(mem_out_WB),

             .WB_value(WB_value)
           );


endmodule
