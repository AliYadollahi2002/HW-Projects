`timescale 1ns / 1ps
module FIR_test();
reg clk = 1'b1;
   always @(clk)
      clk <= #10 ~clk;
reg  Coef_w_en;
reg [7:0] in;
reg [3:0] Coef_num;
reg [7:0] Coef_Val;
wire[19:0] out;
integer i;
initial begin
for(i = 0;i<10;i=i+1)begin
in = 0;
Coef_num = i;
Coef_Val = i+1;
Coef_w_en = 1;
@(posedge clk);
end
Coef_w_en = 0;
//@(posedge clk);
for(i = 0;i<7;i=i+1)begin
if (i==0 || i==1)begin
    in = 8'b00000001;
end 
else begin
   in = 8'b0; 
end 
Coef_w_en = 0;
Coef_num = 0;
Coef_Val = 0;
@(posedge clk);
end
//$stop();
end

FIR_filt fir(
.in(in),
.clk(clk),
.Coef_num(Coef_num),
.Coef_Val(Coef_Val),
.Coef_w_en(Coef_w_en),
.out(out)
);
/*
FIR_filt_symm fir(
.in(in),
.clk(clk),
.Coef_num(Coef_num),
.Coef_Val(Coef_Val),
.Coef_w_en(Coef_w_en),
.out(out)
);
*/
/*
FIR_filt_pip  fir(
.in(in),
.clk(clk),
.Coef_num(Coef_num),
.Coef_Val(Coef_Val),
.Coef_w_en(Coef_w_en),
.out(out)
);
*/
/*
sharing   fir(
.in(in),
.clk(clk),
.Coef_num(Coef_num),
.Coef_Val(Coef_Val),
.Coef_w_en(Coef_w_en),
.out(out)
);
*/
endmodule
