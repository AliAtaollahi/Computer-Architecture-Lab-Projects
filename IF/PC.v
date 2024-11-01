module PC ( 
    input clk, rst, 
    input[31:0] Branch_Address, 
    input freeze, 
    output reg [31:0] PC_PC
);
  
    always @ (posedge clk, posedge rst) begin
        if (rst) 
            PC_PC <= 32'b0;
        else begin
            if(!freeze) PC_PC <= Branch_Address;
        end
    end

endmodule
