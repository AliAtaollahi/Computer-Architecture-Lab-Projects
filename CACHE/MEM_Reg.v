module MEM_Reg (
    input clk, rst, freeze, WB_en_in, MEM_R_en_in,
    input[31:0] ALU_result_in, Mem_read_value_in,
    input[3:0] Dest_in, 

    output reg WB_en, MEM_R_en, 
    output reg[31:0] address, MEM_result,
    output reg[3:0] Dest

);

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            Dest <= 0;
            WB_en <= 0;
            MEM_R_en <= 0;
            address <= 0;
            MEM_result <= 0;
        end else if(~freeze) begin
            WB_en <= WB_en_in;
            MEM_R_en <= MEM_R_en_in;
            Dest <= Dest_in;
            address <= ALU_result_in;
            MEM_result <= Mem_read_value_in;
        end
    end

endmodule