module Sram_CT(
    input clk, rst,
    input wr_en, rd_en,
    input[31:0] address,
    input [31:0] writeData,

    output[31:0] readData,

    output reg ready,

    inout [15:0]SRAM_DQ,
    output [17:0]SRAM_ADDR,
    output reg SRAM_UB_N,
    output reg SRAM_LB_N,
    output reg SRAM_WE_N,
    output reg SRAM_CE_N,
    output reg SRAM_OE_N
  );

  reg [2:0] ps, ns;
  reg [17:0]addr;
  reg [15:0]W_D_O_16;
  reg [31:0]R_D_32;

  parameter [2 : 0] IDLE = 3'b0;
  parameter [2 : 0] WRITE_1 = 3'b001;
  parameter [2 : 0] WRITE_2 = 3'b010;
  parameter [2 : 0] WRITE_END = 3'b101;
  parameter [2 : 0] READ_1 = 3'b001;
  parameter [2 : 0] READ_2 = 3'b010;
  parameter [2 : 0] READ_3 = 3'b011;
  parameter [2 : 0] READ_END = 3'b101;


  assign SRAM_DQ = (SRAM_WE_N == 0) ? W_D_O_16 : 16'bzzzzzzzzzzzzzzzz;
  assign SRAM_ADDR = addr;
  assign readData = R_D_32;

  always@(posedge clk,posedge rst)
  begin
    if(rst)
      ps <= IDLE;
    else
      ps <= ns;
  end

  always@(ps,wr_en,rd_en)
  begin
    if(ps == WRITE_END || ps == READ_END)
      ns = IDLE;
    else if(wr_en|rd_en)
      ns = ps + 1;
    else
      ns = IDLE;
  end

  always@(ps,wr_en,rd_en,writeData)
  begin
    {SRAM_WE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N, ready} = 6'b100000;
    if(wr_en)
    case(ps)
      IDLE:
      begin
        ready=~(wr_en|rd_en);
      end
      WRITE_1:
      begin
        W_D_O_16 = writeData[15:0];
        addr = (address[17:0] - 32'd1024) >> 1;
        SRAM_WE_N = 1'b0;
      end
      WRITE_2:
      begin
        W_D_O_16 = writeData[31:16];
        addr = ((address[17:0] - 32'd1024) >> 1) + 1;
        SRAM_WE_N = 1'b0;
      end
      WRITE_END:
      begin
        ready=1'b1;
      end
    endcase
    else if(rd_en)
    case(ps)
      IDLE:
      begin
        ready=~(wr_en|rd_en);
      end
      READ_1:
      begin
        addr = (address[17:0] - 32'd1024) >> 1;
      end
      READ_2:
      begin
        R_D_32[15:0] = SRAM_DQ;
        addr = ((address[17:0] - 32'd1024) >> 1) + 1;
      end
      READ_3:
      begin
        R_D_32[31:16] = SRAM_DQ;
      end
      READ_END:
      begin
        ready = 1'b1;
      end
    endcase
    else
    case(ps)
      IDLE:
      begin
        ready = 1'b1;
      end
    endcase
  end

endmodule