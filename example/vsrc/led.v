module led(
  input clk,
  input rst,
  input [15:0] sw,
  output [15:0] ledr
);

  always @(posedge clk) begin

  end

  encode83 my_encode83(
    .x(sw[7:0]),
    .en(sw[8]),
    .y(ledr[2:0]),
    .f(ledr[4])
  );

endmodule
