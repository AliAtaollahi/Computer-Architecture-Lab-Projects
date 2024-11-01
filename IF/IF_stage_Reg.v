
module IF_stage_Reg (
    input clk, rst, freeze, flush,
    input[31:0] PC_IF_stage, Instruction_in,
    output reg [31:0] PC_IF_stage_Reg, Instruction
);
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            PC_IF_stage_Reg <= 32'd0;
            Instruction <= 32'b11100000000000000000000000000000;
        end else if (!freeze) begin
            if (flush) begin
                PC_IF_stage_Reg <= 32'd0;
                Instruction <= 32'b11100000000000000000000000000000;
            end else begin Instruction <= Instruction_in; PC_IF_stage_Reg <= PC_IF_stage; end
        end
    end

    
endmodule