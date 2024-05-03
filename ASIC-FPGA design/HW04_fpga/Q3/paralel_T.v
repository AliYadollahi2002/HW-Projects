`timescale 1ns / 1ps
module paralel_T ();
reg clk = 1'b1;
   always @(clk)
      clk <= #10 ~clk;
reg  Coef_w_en;
reg [7:0] in0 , in1;
reg [3:0] Coef_num;
reg [7:0] Coef_Val;
wire[19:0] out0 , out1;
integer i;
initial begin
for(i = 0;i<10;i=i+1)begin
in0 = 0;
in1 = 0;
Coef_num = i;
Coef_Val = i+1;
Coef_w_en = 1;
@(posedge clk);
end
Coef_w_en = 0;

for(i = 0;i<11;i=i+2)begin
if (i==0)begin
    in0 = 8'b00000001;
    in1 = 8'b00000001;
end 
else begin
   in0 = 8'b0; 
   in1 = 8'b0;
end 

Coef_w_en = 0;
Coef_num = 0;
Coef_Val = 0;
@(posedge clk);
end
//$stop();
end
paralel uut(
.in0(in0),
.in1(in1),
.clk(clk),
.Coef_num(Coef_num),
.Coef_Val(Coef_Val),
.Coef_w_en(Coef_w_en),
.out0(out0),
.out1(out1)
);

endmodule