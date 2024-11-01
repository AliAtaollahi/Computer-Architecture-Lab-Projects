module ID_Stage (
    input clk,rst, 
    //from IF Reg 
    input[31:0] Instruction, 
    //from WB stage 
    input[31:0] Result_WB, 
    input writeBackEn, 
    input[3:0] Dest_wb, 
    //from hazard detect module 
    input hazard, 
    //from Status Register 
    input[3:0] SR, 
    //to next stage 
    output WB_EN, MEM_R_EN, MEM_W_EN, B, S, 
    output[3:0] EXE_CMD, 
    output[31:0] Val_Rn, Val_Rm, 
    output imm, 
    output[11:0] Shift_operand, 
    output[23:0] Signed_imm_24, 
    output[3:0] Dest, 
    //to hazard detect module 
    output[3:0] src1, src2, 
    output Two_src 
);

    wire stop, WB_EN_CU, MEM_R_EN_CU, B_CU, S_CU;
    wire [3:0] EXE_CMD_CU;

    wire [3:0] cond = Instruction[31:28];
    wire [1:0] mode = Instruction[27:26];
    wire I = Instruction[25];
    wire [3:0] opcode = Instruction[24:21];
    wire S_in = Instruction[20];
    wire [3:0] Rn = Instruction[19:16];
    wire [3:0] Rd = Instruction[15:12];
    wire [3:0] Rm;
    assign Rm = MEM_W_EN ? Rd : Instruction[3:0];
    assign Shift_operand = Instruction[11:0];
    assign Signed_imm_24 = Instruction[23:0];

    ConditionCheck CC (
                    cond,
                    SR,
                    Is_Valid
                    );

    RegisterFile RF (
                    clk,
                    rst,
                    Dest_wb,
                    Rn,
                    Rm,
                    Result_WB,
                    writeBackEn,
                    Val_Rn,
                    Val_Rm
                );

    ControlUnit CU (
                mode,
                opcode,
                S_in,
                EXE_CMD_CU,
                MEM_R_EN_CU,
                MEM_W_EN_CU,
                WB_EN_CU,
                S_CU,
                B_CU
                );

    assign imm = I;
    assign Dest = Rd;
    assign stop = hazard || !Is_Valid;
    assign {EXE_CMD, WB_EN, MEM_R_EN, MEM_W_EN, B, S} = stop ? 9'b0 : {EXE_CMD_CU, WB_EN_CU, MEM_R_EN_CU, MEM_W_EN_CU, B_CU, S_CU};
    assign Two_src = MEM_W_EN || !I;

    // wire condition_check_result, or_output, s_in;
    // wire mem_r_en_output, mem_w_en_output, wb_en_output, s_output, b_output;

    // wire [1:0] mode;

    // wire [3:0]rn, rm, rd, register_file_src_2, cond, exe_cmd_ouput, op_code;

    // assign rm = Instruction[3:0];
    // assign rd = Instruction[15:12];
    // assign rn = Instruction[19:16];

    // assign src1 = rn;
    // assign src2 = register_file_src_2;

    // assign s_in = Instruction[20];
    // assign mode = Instruction[27:26];
    // assign op_code = Instruction[24:21];

    // assign imm = Instruction[25];
    // assign Dest = Instruction[15:12];
    // assign Shift_operand = Instruction[11:0];
    // assign Signed_imm_24 = Instruction[23:0];

    // assign cond = Instruction[31:28];
    // assign register_file_src_2 = MEM_W_EN ? rd : rm;
    // assign {EXE_CMD, MEM_R_EN, MEM_W_EN, WB_EN, S, B} = (~condition_check_result) ? 9'b000000000 :
    //        {exe_cmd_ouput, mem_r_en_output, mem_w_en_output, wb_en_output, s_output, b_output};

    // assign two_src = ((~Instruction[25]) || MEM_W_EN);

    // ConditionCheck conditioncheck(cond, sr, condition_check_result);  
    // RegisterFile register_file(clk, rst, rn, register_file_src_2, Dest_wb, Result_WB, WB_EN, Val_Rn, Val_Rm);
    // ControlUnit control_unit(mode, op_code, s_in, exe_cmd_ouput, mem_r_en_output, mem_w_en_output, wb_en_output, s_output,
    //                         b_output);
endmodule