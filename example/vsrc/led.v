module led(
  input clk,
  input rst,
  input [15:0] sw,
  output [15:0] ledr
);

adder_v1 my_adder_v1(
  .a(sw[11:8]),
  .b(sw[7:4]),
  .cin(0),
  .s(ledr[3:0]),
  .c(ledr[4])
);

adder_v2 my_adder_v2(
  .a(sw[11:8]),
  .b(sw[7:4]),
  .cin(0),
  .s(ledr[8:5]),
  .c(ledr[9])
);

adder_v3 my_adder_v3(
  .a(sw[11:8]),
  .b(sw[7:4]),
  .cin(0),
  .s(ledr[13:10]),
  .c(ledr[14])
);

endmodule
