module Forwarding_unit (input forward_en,
                        input [3:0] src1, 
                        input [3:0] src2,
                        input [3:0] WB_dest, 
                        input [3:0] MEM_dest,
                        input WB_WB_en, 
                        input MEM_WB_en,
                        output reg [1:0] sel_src1, 
                        output reg [1:0] sel_src2
                        );


  always @(forward_en, src1, src2, MEM_WB_en, MEM_dest, WB_WB_en, WB_dest)
  begin
    sel_src1 = 2'b00;
    if (forward_en)
    begin
      if (MEM_WB_en && (src1 == MEM_dest))
      begin
        sel_src1 = 2'b01;
      end
      else if (WB_WB_en && (src1 == WB_dest))
      begin
        sel_src1 = 2'b10;
      end
      else
      begin
        sel_src1 = 2'b00;
      end
    end
  end

  always @(forward_en, src1, src2, MEM_WB_en, MEM_dest, WB_WB_en, WB_dest)
  begin
    sel_src2 = 2'b00;
    if (forward_en)
    begin
      if (MEM_WB_en && (src2 == MEM_dest))
      begin
        sel_src2 = 2'b01;
      end
      else if (WB_WB_en && (src2 == WB_dest))
      begin
        sel_src2 = 2'b10;
      end
      else
      begin
        sel_src2 = 2'b00;
      end
    end
  end

endmodule
