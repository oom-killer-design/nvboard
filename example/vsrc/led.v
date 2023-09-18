module led(
  input clk,
  input rst,
  input [15:0] sw,
  output [15:0] ledr
);

  always @(posedge clk) begin

  end

/*sw[0]功能选择;
 * a 输入
 * b 输入
 * c 进位输入
 * result 结果输出
 * overflow输出
 * zero输出
 * carry 进位输出
 */
 add_sub_4 my_add_sub_4(
    .sub_or_add(sw[0]),
    .a(sw[7:4]),
    .b(sw[11:8]),
    .result(ledr[3:0]),
    .overflow(ledr[4]),
    .zero(ledr[5]),
    .carry(ledr[6])
  );

/*
  encode83 my_encode83(
    .x(sw[7:0]),
    .en(sw[8]),
    .y(ledr[2:0]),
    .f(ledr[4])
  );
*/

endmodule
