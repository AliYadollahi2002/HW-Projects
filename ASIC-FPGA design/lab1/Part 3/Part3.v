// 8-bit Adder/Subtractor datapath

module Part3(SW, LEDR, LEDG, KEY, HEX7, HEX6, HEX5, HEX4, HEX1, HEX0);
	input [8:0] SW;
	input [1:0] KEY;
	output [6:0] HEX7, HEX6, HEX5, HEX4, HEX1, HEX0;
	output [7:0] LEDR;
	output [8:0] LEDG;

	/* Your code goes here */
	reg[7:0] A,N;
	reg[8:0] B;
	wire[7:0] C;
	//reg B_reg , A_reg , C_reg , S_reg;
	assign LEDR = C;
	//assign LEDR[7] = C[7];
	//assign LEDR[6] = C[6];
	//assign LEDR[5] = C[5];
	//assign LEDR[4] = C[4];
	//assign LEDR[3] = C[3];
	//assign LEDR[2] = C[2];
	//assign LEDR[1] = C[1];
	//assign LEDR[0] = C[0];
	//assign k = B;
	//assign C_w = C;
	hex7seg h1(.HX(A[7:4]),.SS(HEX7));
	hex7seg h2(.HX(A[3:0]),.SS(HEX6));
	hex7seg h3(.HX(B[7:4]),.SS(HEX5));
	hex7seg h4(.HX(B[3:0]),.SS(HEX4));
	hex7seg h5(.HX(C[7:4]),.SS(HEX1));
	hex7seg h6(.HX(C[3:0]),.SS(HEX0));
	assign LEDG[7:0] = A;
	//assign LEDG[8]=Cout;
	RippleCarryAdder r1(.Cin(0),.A(A),.B(B[7:0]),.S(C),.Cout(LEDG[8]),.SUB(B[8]));
	always @(posedge KEY[1],negedge KEY[0])begin
	if(KEY[0] == 0)begin
	B <= 9'b000000000;
	A <= 8'b00000000;
	N <= 8'b00000000;
	end
	else begin
	B <= SW;
	A <= C;
	N <= C;
	end
	end
	
	
	//Dff d1(.Q(B),.D(SW),.Clk(KEY[1]),.reset(KEY[0]));
	
	//Dff d2(.Q(A),.D(C),.Clk(KEY[1]),.reset(KEY[0]));
	//Dff d3(.Q(S),.D(C),.Clk(KEY[1]),.reset(KEY[0]));
	
	
	
	
	
	
endmodule

module RippleCarryAdder(Cin,A,B,S,Cout,SUB);
input Cin;
input[7:0] A;
input[7:0] B;
input SUB;
output[7:0] S;
output Cout;

wire[6:0] c;
wire[7:0] B_temp;
assign B_temp = (SUB == 0) ? B:((~B)+1);

fulladder f0(A[0],B_temp[0],Cin,S[0],c[0]);
fulladder f1(A[1],B_temp[1],c[0],S[1],c[1]);
fulladder f2(A[2],B_temp[2],c[1],S[2],c[2]);
fulladder f3(A[3],B_temp[3],c[2],S[3],c[3]);
fulladder f4(A[4],B_temp[4],c[3],S[4],c[4]);
fulladder f5(A[5],B_temp[5],c[4],S[5],c[5]);
fulladder f6(A[6],B_temp[6],c[5],S[6],c[6]);
fulladder f7(A[7],B_temp[7],c[6],S[7],Cout);

endmodule

module fulladder(a,b,ci,s,co);
input a;
input b;
input ci;
output s;
output co;

assign {co , s} = a+b+ci;


endmodule 

module hex7seg(HX,SS);
input[3:0] HX;
output reg[1:7] SS;
always@(HX)begin
case(HX)
4'b0000:SS = 7'b1000000;
4'b0001:SS = 7'b1111001;
4'b0010:SS = 7'b0100100;
4'b0011:SS = 7'b0110000;
4'b0100:SS = 7'b0011001;
4'b0101:SS = 7'b0010010;
4'b0110:SS = 7'b0100000;
4'b0111:SS = 7'b1111000;
4'b1000:SS = 7'b0000000;
4'b1001:SS = 7'b0011000;
4'b1010:SS = 7'b0001000;
4'b1011:SS = 7'b0000011;
4'b1100:SS = 7'b1000110;
4'b1101:SS = 7'b0100001;
4'b1110:SS = 7'b0000110;
4'b1111:SS = 7'b0001110;
default: SS = 7'b1111111; 

endcase
end
endmodule
