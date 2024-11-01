module EXE_Reg (
    input clk, rst, freeze, WB_en_in, MEM_R_en_in, MEM_W_en_in, 
    input[31:0] ALU_result_in, ST_val_in,
    input[3:0] Dest_in, 

    output reg WB_en, MEM_R_en, MEM_W_en,
    output reg[31:0] address, data, 
    output reg[3:0] Dest
);

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            address <= 32'b0; 
            data <= 32'b0;
            Dest <= 4'b0;
            WB_en <= 1'b0; 
            MEM_R_en <= 1'b0; 
            MEM_W_en <= 1'b0;
        end else if (~freeze) begin
            address <= ALU_result_in; 
            data <= ST_val_in;
            Dest <= Dest_in;
            WB_en <= WB_en_in; 
            MEM_R_en <= MEM_R_en_in; 
            MEM_W_en <= MEM_W_en_in;            
        end
    end

endmodule