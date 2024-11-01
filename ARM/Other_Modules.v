module Mux (
    input [31:0] a, b,
    input sel,
    output [31:0] c
  );

  assign c = (sel ? b : a);

endmodule


module Adder (
    input  [31:0] a, b,
    output [31:0] res
  );

  assign res = a + b;

endmodule
