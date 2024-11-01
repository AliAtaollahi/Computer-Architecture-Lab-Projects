module TB_DE2 ();

  reg clk, rst;
  wire L;
  ARM arm (
        .clk(clk),
        .rst(rst),
        .L(L)
      );

  initial
  begin
    clk = 1;
    repeat (600)
    begin
      #50;
      clk = ~clk;
    end
  end

  initial
  begin
    rst = 0;
    #20 rst = 1;
    #10 rst = 0;
    #1000 $Stop; 
  end

endmodule
