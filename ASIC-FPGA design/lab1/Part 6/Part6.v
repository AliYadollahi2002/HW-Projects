// a sequence detector FSM. 
// SW1 is the active low synchronous reset, SW0 is the w input, and KEY0 is the clock.
// The z output appears on LEDG0, and the state FFs appear on LEDR3..0
module Part6 (SW, KEY, LEDG, LEDR);
	input [2:0] SW;
	input  [0:0]KEY;
	output  [0:0]LEDG;
	output [3:0] LEDR;

	wire Clock, Resetn, w, z;

	assign Clock = KEY[0];
	assign Resetn = SW[0];
	assign w = SW[1];
	assign wait_done = SW[2];

	/* Your code goes here */
	reg[3:0] y_Q,Y_D;
	reg out;
	parameter A=4'b0000,B=4'b0001,C=4'b0010,D=4'b0011,E=4'b0100,F=4'b0101,G=4'b0110,H=4'b0111,I=4'b1000,Wait=4'b1001;
	always@(w,y_Q)begin
	begin:state_table
	case(y_Q)
	A:if(!w)Y_D = B;
	else Y_D = F;
	B:if(!w)Y_D = C;
	else Y_D = F;
	C:if(!w)Y_D = D;
	else Y_D = F;
	D:if(!w)Y_D = E;
	else Y_D = F;
	E:if(!w)Y_D = Wait;
	else Y_D = F;
	F:if(!w)Y_D = B;
	else Y_D = G;
	G:if(!w)Y_D = B;
	else Y_D = H;
	H:if(!w)Y_D = B;
	else Y_D = I;
	I:if(!w)Y_D = B;
	else Y_D = Wait;
	Wait:if(wait_done) Y_D = A;
	else Y_D = Wait;
	endcase
	end//state_table
	end
	always@(posedge Clock)
	begin:state_FFs
	if(Resetn==0) y_Q <= A;
	else y_Q <= Y_D;
	end//state_FFs

	assign z = ((Y_D==F)||(Y_D==Wait));
	assign LEDR[3:0] = y_Q;
	assign LEDG[0] = z;
endmodule
