module led(
  input clk,
  input rst,
  input [15:0] sw,
  output [15:0] ledr
);

  reg [1:0] y;
  reg [1:0] x0;
  reg [1:0] x1;
  reg [1:0] x2;
  reg [1:0] x3;
  reg [1:0] f;

  always @(posedge clk) begin
    assign y  = {sw[1], sw[0]};
    assign x0 = {sw[3], sw[2]};
    assign x1 = {sw[5], sw[4]};
    assign x2 = {sw[7], sw[6]};
    assign x3 = {sw[9], sw[8]};
  end

  mux41 my_mux41(
      .y(y),
      .x0(x0),
      .x1(x1),
      .x2(x2),
      .x3(x3),
      .f(f)
  );

  assign ledr[1:0] = f[1:0];

endmodule
