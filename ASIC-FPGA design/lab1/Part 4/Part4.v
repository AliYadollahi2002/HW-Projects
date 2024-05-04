// BCD Counter

module Part4(CLOCK_50, KEY, HEX2, HEX1, HEX0);
	input CLOCK_50;
	input [0:0] KEY;
	output [6:0] HEX2, HEX1, HEX0;

	reg [25:0] counter;
	reg [3:0] first, second, third;

	initial begin
		counter = 0;
		first = 0;
		second = 0;
		third = 0;
	end

	hex7seg h1  (.HX(first), .SS(HEX0));
	hex7seg h2(.HX(second), .SS(HEX1));
	hex7seg h3(.HX(third), .SS(HEX2));

	always @(posedge CLOCK_50) begin
		if (KEY == 0) begin
			counter <= 0;
			first <= 0;
			second <= 0;
			third <= 0;
		end
		else begin
		if (counter == 50000000) begin
			if (first == 4'b1001) begin
				if (second == 4'b1001) begin
					if (third == 4'b1001) begin
						first <= 0;
						second <= 0;
						third <= 0;
					end
					else begin
						first <= 0;
						second <= 0;
						third <= third + 1;
					end
				end
				else begin
					first <= 0;
					second <= second + 1;
				end
			end
			else begin
				first <= first + 1;
			end
			counter <= 0;
		end
		else counter <= counter + 1;
		end
	end
	
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
