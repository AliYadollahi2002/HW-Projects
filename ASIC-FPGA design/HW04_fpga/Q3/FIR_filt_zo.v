`timescale 1ns / 1ps
module FIR_filt_zo(
input [7:0] in,
input clk,
input [3:0] Coef_num,
input [1:0] Coef_Val,
input Coef_w_en,
output signed [11:0]out
    );
    reg [7:0]reg1 =0;
    reg [7:0]reg2 =0;
    reg [7:0]reg3 =0;
    reg [7:0]reg4 =0;
    reg [7:0]reg5 =0;
    reg [7:0]reg6 =0;
    reg [7:0]reg7 =0;
    reg [7:0]reg8 =0;
    reg [7:0]reg9 =0;
    reg [1:0] b0 , b1 , b2 , b3 , b4 , b5 , b6 , b7 , b8 , b9;
    wire [11:0]result_add1;
    wire signed [11:0] result_add2;
    wire signed [11:0] result_add3;
    wire signed[11:0] result_add4;
    wire signed[11:0] result_add5;
    wire signed[11:0] result_add6;
    wire signed[11:0] result_add7;
    wire signed[11:0] result_add8;
    wire signed[11:0] result_add9;
always @(posedge clk) begin
    reg1 <= in;
    reg2 <= reg1;
    reg3 <= reg2;
    reg4 <= reg3;
    reg5 <= reg4;
    reg6 <= reg5;
    reg7 <= reg6;
    reg8 <= reg7;
    reg9 <= reg8;
    if(Coef_w_en)begin
    
    case(Coef_num) 
    4'b0000: b0 <= Coef_Val;
    4'b0001: b1 <= Coef_Val;
    4'b0010: b2 <= Coef_Val;
    4'b0011: b3 <= Coef_Val;
    4'b0100: b4 <= Coef_Val;
    4'b0101: b5 <= Coef_Val;
    4'b0110: b6 <= Coef_Val;
    4'b0111: b7 <= Coef_Val;
    4'b1000: b8 <= Coef_Val;
    4'b1001: b9 <= Coef_Val;
    default: b0 <= 1;
    endcase
    //#display()
    end
end   
addersub a0(
    .A({4'b0 , in}),
    .B(8'b0),
    .op(b0),
    .result(result_add1)
); 
addersub a1(
    .A(result_add1),
    .B(reg1),
    .op(b1),
    .result(result_add2)
);
addersub a2(
    .A(result_add2),
    .B(reg2),
    .op(b2),
    .result(result_add3)
);
addersub a3(
    .A(result_add3),
    .B(reg3),
    .op(b3),
    .result(result_add4)
);
addersub a4(
    .A(result_add4),
    .B(reg4),
    .op(b4),
    .result(result_add5)
);
addersub a5(
    .A(result_add5),
    .B(reg5),
    .op(b5),
    .result(result_add6)
);
addersub a6(
    .A(result_add6),
    .B(reg6),
    .op(b6),
    .result(result_add7)
);
addersub a7(
    .A(result_add7),
    .B(reg7),
    .op(b7),
    .result(result_add8)
);
addersub a8(
    .A(result_add8),
    .B(reg8),
    .op(b8),
    .result(result_add9)
);
addersub a9(
    .A(result_add9),
    .B(reg9),
    .op(b9),
    .result(out)
);
   
endmodule
