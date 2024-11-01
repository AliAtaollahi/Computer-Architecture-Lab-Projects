module Instrucrion_Memory (
    input [31:0] pc,
    output reg [31:0] inst
);
    wire [31:0] adr;
    assign adr = {pc[31:2], 2'b00}; // Align address to the word boundary

    always @(adr) begin
        case (adr)
            32'd0:   inst = 32'b1110_00_1_1101_0_0000_0000_000000010100;
            32'd4:   inst = 32'b1110_00_1_1101_0_0000_0001_101000000001;
            32'd8:   inst = 32'b1110_00_1_1101_0_0000_0010_000100000011;
            32'd12:  inst = 32'b1110_00_0_0100_1_0010_0011_000000000010;
            32'd16:  inst = 32'b1110_00_0_0101_0_0000_0100_000000000000;
            32'd20:  inst = 32'b1110_00_0_0010_0_0100_0101_000100000100;
            32'd24:  inst = 32'b1110_00_0_0110_0_0000_0110_000010100000;
            32'd28:  inst = 32'b1110_00_0_1100_0_0101_0111_000101000010;
            32'd32:  inst = 32'b1110_00_0_0000_0_0111_1000_000000000011;
            32'd36:  inst = 32'b1110_00_0_1111_0_0000_1001_000000000110;
            32'd40:  inst = 32'b1110_00_0_0001_0_0100_1010_000000000101;
            32'd44:  inst = 32'b1110_00_0_1010_1_1000_0000_000000000110;
            32'd48:  inst = 32'b0001_00_0_0100_0_0001_0001_000000000001;
            32'd52:  inst = 32'b1110_00_0_1000_1_1001_0000_000000001000;
            default: inst = 32'd0;
        endcase
    end
endmodule