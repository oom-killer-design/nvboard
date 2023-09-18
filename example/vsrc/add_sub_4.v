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