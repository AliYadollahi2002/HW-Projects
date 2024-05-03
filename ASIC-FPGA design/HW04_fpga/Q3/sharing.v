module sharing (
input  [7:0]in,
input clk,
input [3:0] Coef_num,
input [7:0] Coef_Val,
input Coef_w_en,
output reg[19:0]out 
);
reg[7:0] reg0 = 0 ; 
reg[7:0] reg1 = 0 ;
reg[7:0] reg2 = 0 ;
reg[7:0] reg3 = 0 ;
reg[7:0] reg4 = 0 ;
reg[7:0] reg5 = 0 ;
reg[7:0] reg6 = 0 ;
reg[7:0] reg7 = 0 ;
reg[7:0] reg8 = 0 ;
reg[7:0] reg9 = 0 ;
reg[3:0] state;
reg [7:0] b0 , b1 , b2 , b3 , b4 , b5 , b6 , b7 , b8 , b9;
wire [19:0] accum; // accumulates multiplier products
reg [19:0] accumsum = 0;
wire [19:0] multout; // multiplier product
reg [7:0] multdat;
reg [7:0] multcoeff;

assign multout =(state==0)?20'b0:multcoeff * multdat;
// clearing and loading accumulator
assign accum = (state==0)?20'b0:accumsum;

always @(posedge clk) begin
    accumsum <= accum + multout;
    if(Coef_w_en)begin
    case(Coef_num) 
    4'b0000: b0 <= Coef_Val;
    4'b0001: b1 <= Coef_Val;
    4'b0010: b2 <= Coef_Val;
    4'b0011: b3 <= Coef_Val;
    4'b0100: b4 <= Coef_Val;
    4'b0101: b5 <= Coef_Val;
    4'b0110: b6 <= Coef_Val;
    4'b0111: b7 <= Coef_Val;
    4'b1000: b8 <= Coef_Val;
    4'b1001: b9 <= Coef_Val;
    default: b0 <= 1;
    endcase
    //#display()
    end
end
always @ (posedge clk) begin
if(Coef_w_en) state <= 0;
else begin
case(state)
0: begin // load new data
     reg0 <= in;
	reg1 <= reg0;
    reg2 <= reg1;
    reg3 <= reg2;
    reg4 <= reg3;
    reg5 <= reg4;
    reg6 <= reg5;
    reg7 <= reg6;
    reg8 <= reg7;
    reg9 <= reg8;
multdat <= in; 
multcoeff <= b0;
state <= 1;
out <= accumsum;
end
1: begin // A*X[0] is done, load B*X[1]
multdat <= reg1;
 multcoeff <= b1;
state <= 2;
end
2: begin // B*X[1] is done, load C*X[2]
multdat <= reg2; 
multcoeff <= b2;
state <= 3;
end
3: begin // C*X[2] is done, load output
multdat <= reg3; 
multcoeff <= b3;
state <= 4;
end
4: begin // C*X[2] is done, load output
multdat <= reg4; 
multcoeff <= b4;
state <= 5;
end
5: begin // C*X[2] is done, load output
multdat <= reg5; 
multcoeff <= b5;
state <= 6;
end
6: begin // C*X[2] is done, load output
multdat <= reg6; 
multcoeff <= b6;
state <= 7;
end
7: begin // C*X[2] is done, load output
multdat <= reg7; 
multcoeff <= b7;
state <= 8;
end
8: begin // C*X[2] is done, load output
multdat <= reg8; 
multcoeff <= b8;
state <= 9;
end
9: begin // C*X[2] is done, load output
multdat <= reg9; 
multcoeff <= b9;
state <= 10;
end
10: state <= 0;
default
state <= 0;
endcase
end
end
endmodule