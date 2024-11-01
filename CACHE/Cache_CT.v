module Cache_CT (
    input clk, rst,
    input rd_en, wr_en,
    input [31:0] addr,
    input [31:0] wr_data,
    input sram_rdy,
    input [63:0] sram_rd_data,
    output [31:0] rd_data,
    output rdy,
    output sram_wr_en, sram_rd_en
);

    reg [31:0] w0_first [0:63], w0_second [0:63], w1_first  [0:63], w1_second [0:63];
    reg [9:0] w0_tag [0:63], w1_tag [0:63];
    reg [63:0] w0_valid, w1_valid, index_lru;

    wire [2:0] offset;
    wire [5:0] index;
    wire [9:0] tag, tag_w0, tag_w1;
    wire [31:0] data_w0, data_w1, data, rd_data_q;

    assign offset = addr[2:0];
    assign index = addr[8:3];
    assign tag = addr[18:9];

    wire valid_w0, valid_w1, hit, hit_w0, hit_w1;

    always @(posedge clk) begin
        if (hit_w0 && wr_en) begin
            index_lru[index] = 1'b1;
            w0_valid[index] = 1'b0;
        end
        else if (hit_w1 && wr_en) begin
            index_lru[index] = 1'b0;
            w1_valid[index] = 1'b0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w1_valid = 64'd0;
            index_lru = 64'd0;
            w0_valid = 64'd0;
        end
    end

    always @(posedge clk) begin
        if (hit && rd_en) begin
            index_lru[index] = hit_w1;
        end
        else if (rd_en) begin
            if (sram_rdy) begin
                if (index_lru[index] == 1'b0) begin
                    index_lru[index] = 1'b1;
                    {w1_second[index], w1_first[index]} = sram_rd_data;
                    w1_tag[index] = tag;
                    w1_valid[index] = 1'b1;
                end
                else begin
                    {w0_second[index], w0_first[index]} = sram_rd_data;
                    w0_valid[index] = 1'b1;
                    index_lru[index] = 1'b0;
                    w0_tag[index] = tag;
                end
            end
        end
    end

    assign tag_w0 = w0_tag[index];
    assign tag_w1 = w1_tag[index];
    assign data_w0 = (offset[2] == 1'b0) ? w0_first[index] : w0_second[index];
    assign data_w1 = (offset[2] == 1'b0) ? w1_first[index] : w1_second[index];
    assign valid_w0 = w0_valid[index];
    assign valid_w1 = w1_valid[index];

    assign hit = hit_w0 | hit_w1;
    assign hit_w0 = (tag_w0 == tag && valid_w0 == 1'b1);
    assign hit_w1 = (tag_w1 == tag && valid_w1 == 1'b1);

    assign rd_data_q = hit ? data :
                       sram_rdy ? (offset[2] == 1'b0 ? sram_rd_data[31:0] : sram_rd_data[63:32]) : 32'bz;
    assign data = hit_w0 ? data_w0 :
                  hit_w1 ? data_w1 : 32'dz;
    assign sram_rd_en = ~hit & rd_en;
    assign sram_wr_en = wr_en;
    assign rd_data = rd_en ? rd_data_q : 32'bz;
    assign rdy = sram_rdy;


endmodule
