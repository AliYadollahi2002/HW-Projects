module addersub 
(
    input signed [11:0] A,
    input [7:0] B,
    input wire[1:0] op,
    output signed [11 :0] result
);
assign result =  (op == 2'b00) ? A : (op == 2'b01) ? A + B : A - B;  
    
endmodule