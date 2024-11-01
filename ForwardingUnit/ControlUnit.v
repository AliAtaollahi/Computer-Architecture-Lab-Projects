module ControlUnit (
    input [3:0] opcode,
    input [1:0] mode,
    input S_IN,
    output reg [3:0] EXE_CMD,
    output reg writeBackEn, MEM_R_en, MEM_W_EN, b, S
  );

`define MOV 4'b1101
`define MVN 4'b1111
`define ADD 4'b0100
`define ADC 4'b0101
`define SUB 4'b0010
`define SBC 4'b0110
`define AND 4'b0000
`define ORR 4'b1100
`define EOR 4'b0001
`define CMP 4'b1010
`define TST 4'b1000
`define LDR 4'b0100
`define STR 4'b0100

  always @(mode, opcode, S_IN)
  begin
    {EXE_CMD, writeBackEn, MEM_R_en, MEM_W_EN, b, S} = 9'b0;

    case(mode)
      2'b00:
      begin
        S = S_IN;
        case(opcode)
          `MOV:
          begin
            EXE_CMD = 4'b0001;
            writeBackEn = 1'b1;
          end

          `MVN:
          begin
            EXE_CMD = 4'b1001;
            writeBackEn = 1'b1;
          end

          `ADD:
          begin
            EXE_CMD = 4'b0010;
            writeBackEn = 1'b1;
          end

          `ADC:
          begin
            EXE_CMD = 4'b0011;
            writeBackEn = 1'b1;
          end

          `SUB:
          begin
            EXE_CMD = 4'b0100;
            writeBackEn = 1'b1;
          end

          `SBC:
          begin
            EXE_CMD = 4'b0101;
            writeBackEn = 1'b1;
          end

          `AND:
          begin
            EXE_CMD = 4'b0110;
            writeBackEn = 1'b1;
          end

          `ORR:
          begin
            EXE_CMD = 4'b0111;
            writeBackEn = 1'b1;
          end

          `EOR:
          begin
            EXE_CMD = 4'b1000;
            writeBackEn = 1'b1;
          end

          `CMP:
          begin
            EXE_CMD = 4'b0100;
          end

          `TST:
          begin
            EXE_CMD = 4'b0110;
          end

          default:
            EXE_CMD = 4'b0000;
        endcase
      end


      2'b01:
      begin
        EXE_CMD = 4'b0010;
        MEM_R_en = S_IN;
        MEM_W_EN = !S_IN;
        writeBackEn = S_IN;
      end


      2'b10:
      begin
        b = 1'b1;
      end

      default:;
    endcase

  end

endmodule
