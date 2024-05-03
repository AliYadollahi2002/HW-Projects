`timescale 1ns / 1ps
module mult1_T ();
reg clk = 1'b1;
   always @(clk)
      clk <= #10 ~clk;
integer i;
reg [20:0] A , B;
wire done;
wire [44:0] result;
initial begin
    for (i = 0;i < 5 ;i = i+1 ) begin
        A = 2 + i;
        B = 10 + i;
        @(posedge clk);
    end
end
my_mult1 uut(
.A(A),
.B(B),
.clk(clk),
.result(result),
.done(done)
);
/*
my_mult2 uut(
.A(A),
.B(B),
.clk(clk),
.result(result),
.done(done)
);
*/
    
endmodule