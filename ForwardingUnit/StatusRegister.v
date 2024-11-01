module StatusRegister (
    input clk, rst,
    input [3:0] status_in,
    input S,
    output reg [3:0] status_out
  );

  always @(negedge clk, posedge rst)
  begin
    if (rst)
      status_out <= 0;
    else if (S)
      status_out <= status_in;
  end

endmodule
