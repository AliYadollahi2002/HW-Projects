module FIR_filt_pip (
input  [7:0] in,
input clk,
input [3:0] Coef_num,
input [7:0] Coef_Val,
input Coef_w_en,
output reg  [19:0]out
);
reg [7:0] reg0 , reg1 , reg2 , reg3 , reg4 , reg5 , reg6 , reg7 , reg8 , reg9;
reg[7:0] reg_pu1 , reg_pu2 , reg_pu3 , reg_pu4 , reg_pu5 , reg_pu6 , reg_pu7 , reg_pu8;
reg [7:0] b0 , b1 , b2 , b3 , b4 , b5 , b6 , b7 , b8 , b9;
reg [7:0] rb0 , rb1 , rb2 , rb3 , rb4 , rb5 , rb6 , rb7 , rb8 , rb9 ;
reg [15:0] mult_result0 ,mult_result1,mult_result2,mult_result3,mult_result4,mult_result5,mult_result6,mult_result7,mult_result8,mult_result9 ;
reg [19:0]result_add1;
reg [19:0] result_add2;
reg [19:0] result_add3;
reg [19:0] result_add4;
reg [19:0] result_add5;
reg [19:0] result_add6;
reg [19:0] result_add7;
reg [19:0] result_add8;
 always @(posedge clk)begin
    rb0 <= b0;
    rb1 <= b1;
    rb2 <= b2;
    rb3 <= b3;
    rb4 <= b4;
    rb5 <= b5;
    rb6 <= b6;
    rb7 <= b7;
    rb8 <= b8;
    rb9 <= b9;
    reg0 <= in;
    reg1 <= reg0;
    reg_pu1 <= reg1;
    reg2 <= reg_pu1;
    reg_pu2 <= reg2;
    reg3 <= reg_pu2;
    reg_pu3 <= reg3;
    reg4 <= reg_pu3;
    reg_pu4 <= reg4;
    reg5 <= reg_pu4;
    reg_pu5 <= reg5;
    reg6 <= reg_pu5;
    reg_pu6 <= reg6;
    reg7 <= reg_pu6;
    reg_pu7 <= reg7;
    reg8 <= reg_pu7;
    reg_pu8 <= reg8;
    reg9 <= reg_pu8;
    //pipe line of multipliers
    mult_result0 <= reg0 * rb0;
    mult_result1 <= reg1 * rb1;
    mult_result2 <= reg2 * rb2;
    mult_result3 <= reg3 * rb3;
    mult_result4 <= reg4 * rb4;
    mult_result5 <= reg5 * rb5;
    mult_result6 <= reg6 * rb6;
    mult_result7 <= reg7 * rb7;
    mult_result8 <= reg8 * rb8;
    mult_result9 <= reg9 * rb9;
    //pipe line of adders
    result_add1 <= mult_result0 + mult_result1;
    result_add2 <= result_add1 + mult_result2;
    result_add3 <= result_add2 + mult_result3;
    result_add4 <= result_add3 + mult_result4;
    result_add5 <= result_add4 + mult_result5;
    result_add6 <= result_add5 + mult_result6;
    result_add7 <= result_add6 + mult_result7;
    result_add8 <= result_add7 + mult_result8;
    out <= result_add8 + mult_result9;
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