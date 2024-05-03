`timescale 1ns / 1ps
module my_mult2(
input wire[20:0] A,
input wire[20:0] B,
input wire clk,
output reg[44:0] result
    );
    reg[20:0] reg_A , reg_B;
    reg [41:0] temp;
    //assign temp = reg_A * reg_B ;
    //assign result_w = temp * 4'b0111;
    always @(posedge clk) begin
    reg_A <= A;
    reg_B <= B;
    temp <= reg_A * reg_B;
    result <= temp * 4'b0111;
    end
endmodule
