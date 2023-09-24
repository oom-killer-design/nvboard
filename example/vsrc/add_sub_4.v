module add_sub_4(sub_or_add, a, b, result, overflow, zero, carry);
    input sub_or_add;
    input [3:0] a;
    input [3:0] b;

    output [3:0] result;
    output overflow;
    output zero;
    output carry;

    /*计算b的补码;注意运算的优先级;*/
    wire bit[3:0] b1 = ({4{sub_or_add}} ^ b) + {3'b000, sub_or_add};
    
    assign {carry, result} = a + b1;
    assign overflow = (a[3] == b1[3]) && (result [3] !=  a[3]);
    assign zero = ~(| result);

    always @(posedge sub_or_add or a or b) begin
        $display("op:%x a:%x, b:%x, b1:%x, result:%x, overflow:%x, zero:%x, carry:%x",
        sub_or_add, a, b, b1[3:0], result, overflow, zero, carry);
    end

endmodule

/*
* a b or and nand xor s c
* 0 0 0   0   1    0  0 0
* 0 1 1   0   1    1  1 0
* 1 0 1   0   1    1  1 0
* 1 1 1   1   0    0  0 1
*/
module half_adder(a, b, s, c);
    input a;
    input b;
    output s;
    output c;

    assign s = a ^ b;
    assign c = a & b;
endmodule

/*利用2个半加器实现1个全加器;*/
module full_adder(a, b, cin, s, c);
    input a;
    input b;
    input cin;

    output s;
    output c;

    reg tmp_c1 = 0;
    reg tmp_c2 = 0;
    reg tmp_s = 0;

    half_adder my_half_adder1(
        .a(a),
        .b(b),
        .s(tmp_s),
        .c(tmp_c1)
    );

    half_adder my_half_adder2(
        .a(tmp_s),
        .b(cin),
        .s(s),
        .c(tmp_c2)
    );

    assign c = tmp_c1 | tmp_c2;
endmodule

/*
* 利用全加器实现加法器;
*/
module adder_v1 (a, b, cin, s, c);
    input [3:0]a;
    input [3:0]b;
    input cin;
    output [3:0]s;
    output c;
    wire [3:0]tmp_c;

    full_adder adder0(a[0], b[0], cin, s[0], tmp_c[0]);
    full_adder adder1(a[1], b[1], tmp_c[0], s[1], tmp_c[1]);
    full_adder adder2(a[2], b[2], tmp_c[1], s[2], tmp_c[2]);
    full_adder adder3(a[3], b[3], tmp_c[2], s[3], tmp_c[3]);

    assign c = tmp_c[3];

endmodule

/*
* 并行加法器,数据宽度为4;
*   s[1] = a[1] ^ b[1] ^ tmp_c[0];
*   tmp_c[i] = (a[i]&b[i]) | ((a[i] ^ b[i]) & tmp_c[i-1]);
*/
module adder_v2 (a, b, cin, s, c);
    input [3:0]a;
    input [3:0]b;
    input cin;
    output [3:0]s;
    output c;

    assign s[0] = a[0] ^ b[0] ^ cin;
    assign s[1] = a[1] ^ b[1] ^ (a[0]&b[0] | ((a[0] ^ b[0]) & cin));
    assign s[2] = a[2] ^ b[2] ^ ((a[1]&b[1]) | ((a[1] ^ b[1]) & (a[0]&b[0] | ((a[0] ^ b[0]) & cin))));
    assign s[3] = a[3] ^ b[3] ^ ((a[2]&b[2]) | ((a[2] ^ b[2]) & ((a[1]&b[1]) | ((a[1] ^ b[1]) & (a[0]&b[0] | ((a[0] ^ b[0]) & cin))))));
    assign c = ((a[3]&b[3]) | ((a[3] ^ b[3]) & ((a[2]&b[2]) | ((a[2] ^ b[2]) & ((a[1]&b[1]) | ((a[1] ^ b[1]) & (a[0]&b[0] | ((a[0] ^ b[0]) & cin))))))));

endmodule

/*
* 选择实现加法器,只需要在初始时计算，后序计算加法时直接使用;
* TODO:check generate or initial;
*/
module adder_v3 #(N = 4) (a, b, cin, s, c);
    input [N-1:0]a;
    input [N-1:0]b;
    input cin;
    output [N-1:0]s;
    output c;

    reg [N:0] rdata[1:0][(1<<N)-1:0][(1<<N)-1:0];
    genvar i,j,k;

    /*初始化rdata;*/
    generate
        for (i= 0; i < 2; i = i + 1) begin
             for (j = 0; j < (1<<N); j = j + 1) begin
                for (k = 0; k < (1<<N); k = k + 1) begin
                    assign rdata[i][j][k] = i + j + k;
                end
            end
        end
    endgenerate

    assign {c, s} = rdata[cin][a][b];
endmodule
