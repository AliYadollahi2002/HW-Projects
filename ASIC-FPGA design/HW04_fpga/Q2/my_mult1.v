`timescale 1ns / 1ps
module my_mult1(
input wire[20:0] A,
input wire[20:0] B,
input wire clk,
output reg[44:0] result
    );
    reg[20:0] reg_A , reg_B;
    wire [44:0] temp;
    wire [44:0] result_w;
    assign temp = reg_A * reg_B ;
    assign result_w = temp * 4'b0111;
    always @(posedge clk) begin
    reg_A <= A;
    reg_B <= B;
    result <= result_w;
    end
endmodule
