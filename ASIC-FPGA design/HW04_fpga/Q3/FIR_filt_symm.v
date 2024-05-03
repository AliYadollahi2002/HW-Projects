`timescale 1ns / 1ps
module FIR_filt_symm(
input  [7:0]in,
input clk,
input [3:0] Coef_num,
input [7:0] Coef_Val,
input Coef_w_en,
output [19:0]out
    );
    wire [19:0] result_add0 , result_add1 , result_add2 , result_add3;
    wire [15:0] result_mult0 , result_mult1 , result_mult2 , result_mult3 , result_mult4;
    wire [19:0] result_add4;
    wire [19:0] result_add5;
    wire [19:0] result_add6;
    //wire [8:0] 
    reg[7:0] reg1 =0;
    reg[7:0]  reg2 =0;
    reg[7:0]  reg3 =0;
    reg[7:0]  reg4 =0;
    reg[7:0]  reg5 =0;
    reg[7:0]  reg6 =0;
    reg[7:0]  reg7 =0;
    reg[7:0]  reg8 =0;
    reg [7:0] b0 , b1 , b2 , b3 , b4 , b5 , b6 , b7 , b8 , b9;
    assign result_add0 = in + reg8;
    assign result_add1 = reg1 + reg7;
    assign result_add2 = reg2 + reg6;
    assign result_add3 = reg3 + reg5;
    assign result_mult0 = b0 * result_add0;
    assign result_mult1 = b1 * result_add1;
    assign result_mult2 = b2 * result_add2;
    assign result_mult3 = b3 * result_add3;
    assign result_mult4 = b4 * reg4;
    assign result_add4 = result_mult4 + result_mult3;
    assign result_add5 = result_add4 + result_mult2;
    assign result_add6 = result_add5 + result_mult1;
    assign out = result_add6 + result_mult0;
    always @(posedge clk)begin
    reg1 <= in;
    reg2 <= reg1;
    reg3 <= reg2;
    reg4 <= reg3;
    reg5 <= reg4;
    reg6 <= reg5;
    reg7 <= reg6;
    reg8 <= reg7;
    if(Coef_w_en)begin
    case(Coef_num) 
    4'b0000 :begin
        b0 <= Coef_Val;
        b8 <= Coef_Val;
    end 
    4'b0001:begin
        b1 <= Coef_Val;
        b7 <= Coef_Val;
    end
    4'b0010:begin
        b2 <= Coef_Val;
        b6 <= Coef_Val; 
    end
    4'b0011:begin
        b3 <= Coef_Val;
        b5 <= Coef_Val; 
    end
    4'b0100:begin
        b4 <= Coef_Val;
    end
    4'b0101 :begin
        b0 <= Coef_Val;
        b8 <= Coef_Val;
    end 
    4'b0110:begin
        b1 <= Coef_Val;
        b7 <= Coef_Val;
    end
    4'b0111:begin
        b2 <= Coef_Val;
        b6 <= Coef_Val; 
    end
    4'b1000:begin
        b3 <= Coef_Val;
        b5 <= Coef_Val; 
    end
    default: b0 <= 1;
    endcase
    end
    end
endmodule
