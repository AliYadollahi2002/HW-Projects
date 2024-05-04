// a sequence detector FSM using one-hot encoding. 
// SW0 is the active low synchronous reset, SW1 is the w input, and KEY0 is the clock.
// The z output appears on LEDG0, and the state FFs appear on LEDR8..0
module Part5 (SW, KEY, LEDG, LEDR);
	input [1:0] SW;
	input  [0:0]KEY;
	output  [0:0]LEDG;
	output [8:0] LEDR;

	wire Clock, Resetn, w, z;

	assign Clock = KEY[0];
	assign Resetn = SW[0];
	assign w = SW[1];
	//next state
	wire [8:0] Y;
	//current state
	reg [8:0] y;
	reg rst;
	
	//determine next state
	assign Y[0] = (1'b0);
	assign Y[1] = ((!w)*(!y[1])*(!y[2])*(!y[3])*(!y[4])*(((y[0])*(!y[5])*(!y[6])*(!y[7])*(!y[8]))+((!y[0])*(y[5])*(!y[6])*(!y[7])*(!y[8]))+((!y[0])*(!y[5])*(y[6])*(!y[7])*(!y[8]))+((!y[0])*(!y[5])*(!y[6])*(y[7])*(!y[8]))+((!y[0])*(!y[5])*(!y[6])*(!y[7])*(y[8]))));
	assign Y[2] = ((!y[0])*(y[1])*(!y[2])*(!y[3])*(!y[4])*(!y[5])*(!y[6])*(!y[7])*(!y[8])*(!w));
	assign Y[3] = ((!y[0])*(!y[1])*(y[2])*(!y[3])*(!y[4])*(!y[5])*(!y[6])*(!y[7])*(!y[8])*(!w));
	assign Y[4] = ((!w)*(!y[0])*(!y[1])*(!y[2])*(!y[5])*(!y[6])*(!y[7])*(!y[8])*(((!y[3])*(y[4]))+((y[3])*(!y[4]))));
	assign Y[5] = ((w)*(!y[5])*(!y[6])*(!y[7])*(!y[8])*(((y[0])*(!y[1])*(!y[2])*(!y[3])*(!y[4]))+((!y[0])*(y[1])*(!y[2])*(!y[3])*(!y[4]))+((!y[0])*(!y[1])*(y[2])*(!y[3])*(!y[4]))+((!y[0])*(!y[1])*(!y[2])*(y[3])*(!y[4]))+((!y[0])*(!y[1])*(!y[2])*(!y[3])*(y[4]))));
   assign Y[6] = ((!y[0])*(!y[1])*(!y[2])*(!y[3])*(!y[4])*(y[5])*(!y[6])*(!y[7])*(!y[8])*(w));
   assign Y[7] = ((!y[0])*(!y[1])*(!y[2])*(!y[3])*(!y[4])*(!y[5])*(y[6])*(!y[7])*(!y[8])*(w));
   assign Y[8] = ((w)*(!y[0])*(!y[1])*(!y[2])*(!y[3])*(!y[4])*(!y[5])*(!y[6])*(((!y[7])*(y[8]))+((y[7])*(!y[8]))));
	


	/* Your code goes here */

	assign LEDG[0] = ((!y[0])*(!y[1])*(!y[2])*(!y[3])*(!y[5])*(!y[6])*(!y[7])*(((!y[4])*(y[8]))+((y[4])*(!y[8]))));
	assign LEDR[8:0] = y;
	//assign LEDG[0] = z;

    always@(posedge Clock)begin
        //y <= Y;
        if(Resetn == 0) y <= 9'b000000001;
        else y <= Y ;
    end

endmodule
