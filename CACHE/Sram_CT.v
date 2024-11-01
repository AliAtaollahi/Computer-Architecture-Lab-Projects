module Sram_CT(
    input clk, rst,
    input wr_en, rd_en,
    input[31:0] address,
    input [31:0] write_data,

    output reg [63:0] read_data,

    output reg ready,

    inout [15:0] SRAM_DQ,
    output reg [17:0] SRAM_ADDR,
    output reg SRAM_UB_N,
    output reg SRAM_LB_N,
    output reg SRAM_WE_N,
    output reg SRAM_CE_N,
    output reg SRAM_OE_N
  );
    wire [31:0] memAddr;
    wire [17:0] sramLowAddr, sramHighAddr, sramUpLowAddess, sramUpHighAddess;
    wire [17:0] sramLowAddrWrite, sramHighAddrWrite;
    reg [15:0] dq;
    reg [2:0] ns, ps;

    assign {SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N} = 4'd0;

    assign memAddr = address - 32'd1024;

    assign sramLowAddr = {memAddr[18:3], 2'd0};
    assign sramHighAddr = sramLowAddr + 18'd1;
    assign sramUpLowAddess = sramLowAddr + 18'd2;
    assign sramUpHighAddess = sramLowAddr + 18'd3;

    assign sramLowAddrWrite = {memAddr[18:2], 1'b0};
    assign sramHighAddrWrite = sramLowAddrWrite + 18'd1;

    assign SRAM_DQ = wr_en ? dq : 16'bz;

    localparam Idle = 3'd0, DataLow = 3'd1, DataHigh = 3'd2, DataUpLow = 3'd3, DataUpHigh = 3'd4, Done = 3'd5;

    always @(ps, wr_en, rd_en) begin
        case (ps)
            Idle: ns = (wr_en == 1'b1 || rd_en == 1'b1) ? DataLow : Idle;
            DataLow: ns = DataHigh;
            DataHigh: ns = DataUpLow;
            DataUpLow: ns = DataUpHigh;
            DataUpHigh: ns = Done;
            Done: ns = Idle;
        endcase
    end

    always @(*) begin
        SRAM_ADDR = 18'b0;
        SRAM_WE_N = 1'b1;
        ready = 1'b0;

        case (ps)
            Idle: ready = ~(wr_en | rd_en);
            DataLow: begin
                SRAM_WE_N = ~wr_en;
                if (rd_en) begin
                    SRAM_ADDR = sramLowAddr;
                    read_data[15:0] <= SRAM_DQ;
                end
                else if (wr_en) begin
                    SRAM_ADDR = sramLowAddrWrite;
                    dq = write_data[15:0];
                end
            end
            DataHigh: begin
                SRAM_WE_N = ~wr_en;
                if (rd_en) begin
                    read_data[31:16] <= SRAM_DQ;
                    SRAM_ADDR = sramHighAddr;
                end
                else if (wr_en) begin
                    SRAM_ADDR = sramHighAddrWrite;
                    dq = write_data[31:16];
                end
            end
            DataUpLow: begin
                SRAM_WE_N = 1'b1;
                if (rd_en) begin
                    read_data[47:32] <= SRAM_DQ;
                    SRAM_ADDR = sramUpLowAddess;
                end
            end
            DataUpHigh: begin
                SRAM_WE_N = 1'b1;
                if (rd_en) begin
                    read_data[63:48] <= SRAM_DQ;
                    SRAM_ADDR = sramUpHighAddess;
                end
            end
            Done: ready = 1'b1;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ps <= Idle;
        end
        else begin 
            ps <= ns;
        end
    end
endmodule