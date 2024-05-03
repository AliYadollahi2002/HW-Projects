`timescale 1ns / 1ps
module FIR_filt(
input  [7:0]in,
input clk,
input [3:0] Coef_num,
input [7:0] Coef_Val,
input Coef_w_en,
output [19:0]out
    );
    reg[7:0] reg0 , reg1 , reg2 , reg3 , reg4 , reg5 , reg6 , reg7 , reg8 , reg9;
    wire[7:0] r0 , r1 , r2 , r3 , r4 , r5 , r6 , r7 , r8 , r9;
    reg [7:0] b0 , b1 , b2 , b3 , b4 , b5 , b6 , b7 , b8 , b9;
    wire [7:0] rb0 , rb1 , rb2 , rb3 , rb4 , rb5 , rb6 , rb7 , rb8 , rb9;
    reg start = 1;
    wire [15:0] mult_result0 ,mult_result1,mult_result2,mult_result3,mult_result4,mult_result5,mult_result6,mult_result7,mult_result8,mult_result9 ;
    wire [19:0]result_add1;
    wire [19:0] result_add2;
    wire [19:0] result_add3;
    wire [19:0] result_add4;
    wire [19:0] result_add5;
    wire [19:0] result_add6;
    wire [19:0] result_add7;
    wire [19:0] result_add8;
	 assign r0 = reg0;
    assign r1 = reg1;
    assign r2 = reg2;
    assign r3 = reg3;
    assign r4 = reg4;
    assign r5 = reg5;
    assign r6 = reg6;
    assign r7 = reg7;
    assign r8 = reg8;
    assign r9 = reg9;
    assign rb0 = b0;
    assign rb1 = b1;
    assign rb2 = b2;
    assign rb3 = b3;
    assign rb4 = b4;
    assign rb5 = b5;
    assign rb6 = b6;
    assign rb7 = b7;
    assign rb8 = b8;
    assign rb9 = b9;
    //multipications
    assign mult_result0 = r0 * rb0;
    assign mult_result1 = r1 * rb1;
    assign mult_result2 = r2 * rb2;
    assign mult_result3 = r3 * rb3;
    assign mult_result4 = r4 * rb4;
    assign mult_result5 = r5 * rb5;
    assign mult_result6 = r6 * rb6;
    assign mult_result7 = r7 * rb7;
    assign mult_result8 = r8 * rb8;
    assign mult_result9 = r9 * rb9;
    //sums
	 
    assign result_add1 = mult_result0 + mult_result1;
    assign  result_add2 = result_add1 + mult_result2;
    assign  result_add3 = result_add2 + mult_result3;
    assign  result_add4 = result_add3 + mult_result4;
    assign  result_add5 = result_add4 + mult_result5;
    assign  result_add6 = result_add5 + mult_result6;
    assign  result_add7 = result_add6 + mult_result7;
    assign  result_add8 = result_add7 + mult_result8;
    assign out = result_add8 + mult_result9;
    always @(posedge clk)begin
    reg0 <= in;
	 reg1 <= reg0;
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
   
endmodule
