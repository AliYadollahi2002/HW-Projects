`timescale 1ns / 1ps
module FIR_zo_test();
reg clk = 1'b1;
   always @(clk)
      clk <= #10 ~clk;
reg[7:0] in , Coef_w_en;
reg [3:0] Coef_num;
reg [1:0] Coef_Val;
wire[11:0] out;
integer i;
initial begin
for(i = 0;i<10;i=i+1)begin
in = 0;
Coef_num = i;
if(i%3 == 0) Coef_Val <= 2'b01;
else if(i%3 == 1) Coef_Val <= 2'b11;
else Coef_Val <= 2'b00;

Coef_w_en = 1;
@(posedge clk);
end
Coef_w_en = 0;
//@(posedge clk);
for(i = 0;i<7;i=i+1)begin
if (i==0) in = 1;
else in = 0;
Coef_w_en = 0;
Coef_num = 0;
Coef_Val = 0;
@(posedge clk);
end
//$stop();
end

FIR_filt_zo uut(
.in(in),
.clk(clk),
.Coef_num(Coef_num),
.Coef_Val(Coef_Val),
.Coef_w_en(Coef_w_en),
.out(out)
);
endmodule
