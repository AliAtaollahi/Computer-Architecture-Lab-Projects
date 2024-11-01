module ConditionCheck (
    input [3:0] cond,
    input [3:0] SR,   // N Z C V
    output reg condition_check_result
  );

  always @ (cond, SR)
  case (cond)
    // Z set
    4'b0000:
      condition_check_result = SR[2];
    // Z clear
    4'b0001:
      condition_check_result = !SR[2];
    // C set
    4'b0010:
      condition_check_result = SR[1];
    // C clear
    4'b0011:
      condition_check_result = !SR[1];
    // N set
    4'b0100:
      condition_check_result = SR[3];
    // N clear
    4'b0101:
      condition_check_result = !SR[3];
    // V set
    4'b0110:
      condition_check_result = SR[0];
    // V clear
    4'b0111:
      condition_check_result = !SR[0];
    // C set and Z clear
    4'b1000:
      condition_check_result = SR[1] && !SR[2];
    // C clear or Z set
    4'b1001:
      condition_check_result = !SR[1] || SR[2];
    // N == V
    4'b1010:
      condition_check_result = SR[3] == SR[0];
    // N != V
    4'b1011:
      condition_check_result = SR[3] != SR[0];
    // Z==0, N==V
    4'b1100:
      condition_check_result = !SR[2] && (SR[3] == SR[0]);
    // Z==1, N!=V
    4'b1101:
      condition_check_result = SR[2] && (SR[3] != SR[0]);
    // Always
    4'b1110:
      condition_check_result = 1'b1;
    // Never
    4'b1111:
      condition_check_result = 1'b0;
  endcase

endmodule
