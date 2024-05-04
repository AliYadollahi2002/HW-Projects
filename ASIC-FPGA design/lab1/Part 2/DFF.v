module DFF(Q,D,Clk,rst);
input[7:0] D;
input Clk;
input rst;
output reg[7:0] Q;
always@(posedge Clk,negedge rst)
if(!rst) Q<= 8'b00000000;
else Q<= D;
endmodule