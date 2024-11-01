module Instrucrion_Memory (
    input [31:0] pc,
    output [31:0] inst
  );

  reg [31:0] mem[0:48];

  initial
  begin
    mem[0]  = 32'b1110_00_1_1101_0_0000_0000_000000010100; //MOV
    mem[1]  = 32'b1110_00_1_1101_0_0000_0001_101000000001; //MOV
    mem[2]  = 32'b1110_00_1_1101_0_0000_0010_000100000011; //MOV
    mem[3]  = 32'b1110_00_0_0100_1_0010_0011_000000000010; //ADDS
    mem[4]  = 32'b1110_00_0_0101_0_0000_0100_000000000000; //ADC
    mem[5]  = 32'b1110_00_0_0010_0_0100_0101_000100000100; //SUB
    mem[6]  = 32'b1110_00_0_0110_0_0000_0110_000010100000; //SBC
    mem[7]  = 32'b1110_00_0_1100_0_0101_0111_000101000010; //ORR
    mem[8]  = 32'b1110_00_0_0000_0_0111_1000_000000000011; //AND
    mem[9]  = 32'b1110_00_0_1111_0_0000_1001_000000000110; //MVN
    mem[10] = 32'b1110_00_0_0001_0_0100_1010_000000000101; //EOR
    mem[11] = 32'b1110_00_0_1010_1_1000_0000_000000000110; //CMP
    mem[12] = 32'b0001_00_0_0100_0_0001_0001_000000000001; //ADDNE
    mem[13] = 32'b1110_00_0_1000_1_1001_0000_000000001000; //TST
    mem[14] = 32'b0000_00_0_0100_0_0010_0010_000000000010; //ADDEQ
    mem[15] = 32'b1110_00_1_1101_0_0000_0000_101100000001; //MOV
    mem[16] = 32'b1110_01_0_0100_0_0000_0001_000000000000; //STR
    mem[17] = 32'b1110_01_0_0100_1_0000_1011_000000000000; //LDR
    mem[18] = 32'b1110_01_0_0100_0_0000_0010_000000000100; //STR
    mem[19] = 32'b1110_01_0_0100_0_0000_0011_000000001000; //STR
    mem[20] = 32'b1110_01_0_0100_0_0000_0100_000000001101; //STR
    mem[21] = 32'b1110_01_0_0100_0_0000_0101_000000010000; //STR
    mem[22] = 32'b1110_01_0_0100_0_0000_0110_000000010100; //STR
    mem[23] = 32'b1110_01_0_0100_1_0000_1010_000000000100; //LDR
    mem[24] = 32'b1110_01_0_0100_0_0000_0111_000000011000; //STR
    mem[25] = 32'b1110_00_1_1101_0_0000_0001_000000000100; //MOV
    mem[26] = 32'b1110_00_1_1101_0_0000_0010_000000000000; //MOV
    mem[27] = 32'b1110_00_1_1101_0_0000_0011_000000000000; //MOV
    mem[28] = 32'b1110_00_0_0100_0_0000_0100_000100000011; //ADD
    mem[29] = 32'b1110_01_0_0100_1_0100_0101_000000000000; //LDR
    mem[30] = 32'b1110_01_0_0100_1_0100_0110_000000000100; //LDR
    mem[31] = 32'b1110_00_0_1010_1_0101_0000_000000000110; //CMP
    mem[32] = 32'b1100_01_0_0100_0_0100_0110_000000000000; //STRGT
    mem[33] = 32'b1100_01_0_0100_0_0100_0101_000000000100; //STRGT
    mem[34] = 32'b1110_00_1_0100_0_0011_0011_000000000001; //ADD
    mem[35] = 32'b1110_00_1_1010_1_0011_0000_000000000011; //CMP
    mem[36] = 32'b1011_10_1_0_111111111111111111110111 ; //BLT
    mem[37] = 32'b1110_00_1_0100_0_0010_0010_000000000001; //ADD
    mem[38] = 32'b1110_00_0_1010_1_0010_0000_000000000001; //CMP
    mem[39] = 32'b1011_10_1_0_111111111111111111110011 ; //BLT
    mem[40] = 32'b1110_01_0_0100_1_0000_0001_000000000000; //LDR
    mem[41] = 32'b1110_01_0_0100_1_0000_0010_000000000100; //LDR
    mem[42] = 32'b1110_01_0_0100_1_0000_0011_000000001000; //LDR
    mem[43] = 32'b1110_01_0_0100_1_0000_0100_000000001100; //LDR
    mem[44] = 32'b1110_01_0_0100_1_0000_0101_000000010000; //LDR
    mem[45] = 32'b1110_01_0_0100_1_0000_0110_000000010100; //LDR
    mem[46] = 32'b1110_00_0_0_000000000000000000000000 ; 
    mem[47] = 32'b1110_10_1_0_111111111111111111111111 ; //B
    mem[48] = 32'b1110_00_0_0_000000000000000000000000 ; 
  end

  assign inst = mem[pc>>2];

endmodule
