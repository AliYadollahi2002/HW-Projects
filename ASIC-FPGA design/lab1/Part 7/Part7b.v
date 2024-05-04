module Part7b(	input CLOCK_50, input [0:0] KEY, input [4:0] SW,
				input AUD_BCLK, AUD_DACLRCK, output AUD_DACDAT, AUD_XCK,
				inout I2C_SDAT, output I2C_SCLK, output [0:0] LEDR);

wire [3:0] sound_code;
wire data_rq, data_rd;

////////////////////////////////////////////////////////////////////
// Dear 241 students, this is the first time you will be using
// other modules in your own design.  This looks intimidating at
// first, but you will learn a lot in the process!
//
// Please follow the lab handout and follow the comments to understand
// what to do.
//
// Good luck! =)
////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////
// PART7b
//
// and data_rd to switches and data_rq to the LED.
// 
// You should be able to hear some noise after sending the proper
// data codes. Show off your new musical talent.
//
// DO NOT TOUCH: "CLOCK_50, !KEY[0], AUD_BCLK, AUD_DACLRCK, AUD_DACDAT, AUD_XCK, I2C_SDAT, I2C_SCLK"
//
///////////////////////////////////////////////////////////////////
synthesizer s(	CLOCK_50, !KEY[0], AUD_BCLK, AUD_DACLRCK, AUD_DACDAT, AUD_XCK, I2C_SDAT, I2C_SCLK,
				sound_code, data_rq, data_rd);

// Connections for connecting switches to the synthesizer
//assign sound_code = ((data_rd==1)&(data_rq==1))?SW[3:0]:4'b0;
assign sound_code = (data_rq == 1) ?  SW[3:0] : 4'b0000;
assign data_rd = SW[4];
assign LEDR[0] = data_rq;

endmodule
