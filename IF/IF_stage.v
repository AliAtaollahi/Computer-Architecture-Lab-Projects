
module IF_stage (
    input clk, rst, freeze, Branch_taken,
    input[31:0] Branch_Address,
    output [31:0] PC_IF_stage, Instruction
);
    wire[31:0] PC_PC, mux_out;

    PC pc_( 
        clk, rst, 
        mux_out, 
        freeze, 
        PC_PC
    );

    Instrucrion_Memory im(
        PC_PC,
        Instruction
    );

    reg temp_Branch_taken = 1'b0;
    assign PC_IF_stage = PC_PC + 4;
    assign mux_out = temp_Branch_taken ? PC_IF_stage : Branch_Address;
endmodule