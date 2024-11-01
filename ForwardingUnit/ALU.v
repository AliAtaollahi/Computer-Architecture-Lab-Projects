module ALU (
    input[31:0] input1, input2,
    input carry_in,
    input[3:0] command,

    output reg[31:0] out,
    output reg carry_out, V,
	output N, Z
);

    always @ (*) begin
        out = 32'b0;
        carry_out = 1'b0;
        case (command) 
            4'b0001: out = input2;
            4'b1001: out = ~input2;
            4'b0010: {carry_out, out} = input1 + input2;
            4'b0011: {carry_out, out} = input1 + input2 + carry_in;
            4'b0100: {carry_out, out} = input1 - input2;
            4'b0101: {carry_out, out} = input1 - input2 - 1 + carry_in;  
            4'b0110: out = input1 & input2;
            4'b0111: out = input1 | input2;
            4'b1000: out = input1 ^ input2;
            default: {carry_out, out} = 33'b0;
        endcase
    end

    assign N = out[31];
    assign Z = (out == 32'b0);

    always @(*) begin
        V = 1'b0;
        case (command)
            4'b0010: V = (input1[31] & input2[31] & (~N)) || ( (~input1[31]) & (~input2[31]) & N);
            4'b0011: V = (input1[31] & input2[31] & (~N)) || ( (~input1[31]) & (~input2[31]) & N);
            4'b0100: V = (input1[31] & (~input2[31]) & (~N)) || ( (~input1[31]) & input2[31] & N);
            4'b0101: V = (input1[31] & (~input2[31]) & (~N)) || ( (~input1[31]) & input2[31] & N);
            default: V = 1'b0;
        endcase
    end

endmodule