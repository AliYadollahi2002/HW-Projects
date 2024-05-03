`timescale 1ns / 1ps
module mult_T ();
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
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
    end
end
my_mult3 uut(
.A(A),
.B(B),
.clk(clk),
.result(result),
.done(done)
);
    
endmodule