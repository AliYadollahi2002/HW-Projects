// Adder

module Part1(SW, LEDR, LEDG);
	input [8:0] SW;
	output [8:0] LEDR;
	output [4:0] LEDG;
	
	wire [2:0]c;

	/* Your code goes here */
	assign LEDR[0] = SW[0];
	assign LEDR[1] = SW[1];
	assign LEDR[2] = SW[2];
	assign LEDR[3] = SW[3];
	assign LEDR[4] = SW[4];
	assign LEDR[5] = SW[5];
	assign LEDR[6] = SW[6];
	assign LEDR[7] = SW[7];
	assign LEDR[8] = SW[8];
	fulladder f0(SW[4],SW[0],SW[8],LEDG[0],c[0]);
	fulladder f1(SW[5],SW[1],c[0],LEDG[1],c[1]);
	fulladder f2(SW[6],SW[2],c[1],LEDG[2],c[2]);
	fulladder f3(SW[7],SW[3],c[2],LEDG[3],LEDG[4]);

	endmodule

module fulladder(a,b,ci,s,co);
input a;
input b;
input ci;
output s;
output co;

assign {co , s} = a+b+ci;


endmodule
	