module num2 (
    input[11:0] Shift_operand,
    input[31:0] RM_value,
    input imm, mem,
    output reg[31:0] Val2
);

    wire[7:0] immed_8 = Shift_operand[7:0];
    wire[3:0] rotate_imm = Shift_operand[11:8];
    wire[4:0] shift_imm = Shift_operand[11:7];
    wire[1:0] shift = Shift_operand[6:5];
    reg[63:0] temp_64;

    always @ (imm, shift, Shift_operand, RM_value) begin
        temp_64 = 64'b0;
        Val2 = 32'b0;
        if (mem)
            Val2 = { {20{Shift_operand[11]}}, Shift_operand };
        else if (imm) begin
            temp_64[39:32] = immed_8;
            temp_64 = temp_64 >> (2*rotate_imm);
            Val2 = temp_64[31:0] | temp_64[63:32];
        end else begin
            temp_64[63:32] = RM_value;
            if (shift == 2'b11) begin
                temp_64[63:32] = RM_value;
                temp_64 = temp_64 >> shift_imm;
                Val2 = temp_64[31:0] | temp_64[63:32];
            end else if (shift == 2'b01) 
                Val2 = RM_value >> shift_imm;
			else if (shift == 2'b10) 
                Val2 = RM_value >>> shift_imm;
            else 
                Val2 = RM_value << shift_imm; 
        end
    end

endmodule