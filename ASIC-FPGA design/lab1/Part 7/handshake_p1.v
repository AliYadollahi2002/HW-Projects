module handshake_p1(input clock, reset,
					input [3:0] ps2_data, input ts,
					output reg [3:0] leds);

// Your code goes here...
always@(posedge clock)begin
	if(reset) begin
		leds <= 4'b0000;
	end
	else if(ts)begin
		leds <= ps2_data;
	end
	//else leds <= 4'b0000;
end

endmodule
