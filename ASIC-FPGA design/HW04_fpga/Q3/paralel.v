module paralel (
input  [7:0]in0 , in1,
input clk,
input [3:0] Coef_num,
input [7:0] Coef_Val,
input Coef_w_en,
output [19:0]out0 , out1
);
// coefficients
reg [7:0] b0 , b1 , b2 , b3 , b4 , b5 , b6 , b7 , b8 , b9;
// registers for X[2k]
reg [7:0] ereg1 = 0;
reg [7:0] ereg2 = 0;
reg [7:0] ereg3 = 0;
reg [7:0] ereg4 = 0;
// wires for X[2k]
 wire [15:0] emult_up1 , emult_up2 , emult_up3 , emult_up4 , emult_up5;
 wire [15:0] emult_down1 , emult_down2 , emult_down3 , emult_down4 , emult_down5;
 wire [19:0] eadd_up1 , eadd_up2 , eadd_up3 , eadd_up4 , eadd_up5;
 wire [19:0] eadd_down1 , eadd_down2 , eadd_down3 , eadd_down4 , eadd_down5;
// registers for X[2k + 1]
reg [7:0] oreg1 = 0;
reg [7:0] oreg2 = 0;
reg [7:0] oreg3 = 0;
reg [7:0] oreg4 = 0;
reg [7:0] oreg5 = 0;
//wires for X[2k+1]
wire [15:0] omult_up1 , omult_up2 , omult_up3 , omult_up4 , omult_up5;
 wire [15:0] omult_down1 , omult_down2 , omult_down3 , omult_down4 , omult_down5;
  wire [19:0] oadd_up1 , oadd_up2 , oadd_up3 , oadd_up4 , oadd_up5;
 wire [19:0] oadd_down1 , oadd_down2 , oadd_down3 , oadd_down4 , oadd_down5;
// define the coefficients
always @(posedge clk) begin
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
    end
end
//the line for X[2k]
// we work with in0
// line :  up
//multipliers
assign emult_up1 = in0 * b0;
assign emult_up2 = ereg1 * b2;
assign  emult_up3 = ereg2 * b4;
assign emult_up4 = ereg3 * b6;
assign emult_up5 = ereg4 * b8;
//adders
assign eadd_up1 = emult_up1 + emult_up2;
assign eadd_up2 = emult_up3 + eadd_up1;
assign eadd_up3 = emult_up4 + eadd_up2;
assign eadd_up4 = emult_up5 + eadd_up3;
// line :  down
//multipliers
assign emult_down1 = in0 * b1;
assign emult_down2 = ereg1 * b3;
assign  emult_down3 = ereg2 * b5;
assign emult_down4 = ereg3 * b7;
assign emult_down5 = ereg4 * b9;
//adders
assign eadd_down1 = emult_down1 + emult_down2;
assign eadd_down2 = emult_down3 + eadd_down1;
assign eadd_down3 = emult_down4 + eadd_down2;
assign eadd_down4 = emult_down5 + eadd_down3;
//the line for X[2k + 1]
//we work with in1
//line : up
//multipliers
assign omult_up1 = oreg1 * b1;
assign omult_up2 = oreg2 * b3;
assign omult_up3 = oreg3 * b5;
assign omult_up4 = oreg4 * b7;
assign omult_up5 = oreg5 * b9;
//adders
assign oadd_up1 = omult_up1 + omult_up2;
assign oadd_up2 = oadd_up1 + omult_up3;
assign oadd_up3 = oadd_up2 + omult_up4;
assign oadd_up4 = oadd_up3 + omult_up5;
//line : down
//multipliers
assign omult_down1 = in1 * b0;
assign omult_down2 = oreg1 * b2;
assign omult_down3 = oreg2 * b4;
assign omult_down4 = oreg3 * b6;
assign omult_down5 = oreg4 * b8;
//adders
assign oadd_down1 = omult_down1 + omult_down2;
assign oadd_down2 = oadd_down1 + omult_down3;
assign oadd_down3 = oadd_down2 + omult_down4;
assign oadd_down4 = oadd_down3 + omult_down5;
//Final output
assign out0 = oadd_up4 + eadd_up4;
assign out1 = oadd_down4 + eadd_down4;


always @(posedge clk) begin
    //X[2k]
    ereg1 <= in0;
    ereg2 <= ereg1;
    ereg3 <= ereg2;
    ereg4 <= ereg3;
    //X[2k + 1]
    oreg1 <= in1;
    oreg2 <= oreg1;
    oreg3 <= oreg2;
    oreg4 <= oreg3;
    oreg5 <= oreg4;
end

    
endmodule