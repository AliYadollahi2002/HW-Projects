`timescale 1ns / 1ps
module my_mult3(
input wire[20:0] A,
input wire[20:0] B,
input wire clk,
output reg[44:0] result,
output reg done
    );
    reg[20:0] reg_A , reg_B;
    reg [44:0] shift_A;
    reg[2:0] counter = 3'b000; 
    //assign temp = reg_A * reg_B ;
    //assign result_w = temp * 4'b0111;
    always @(posedge clk) begin
        counter <= counter + 1;
    case (counter)
        3'b000:begin
            reg_A <= A;
            reg_B <= B;
            done <= 0;
        end 
        3'b001:begin
            shift_A <= reg_A * reg_B;
            result <= 44'h0;
        end
        3'b101:begin
            done <= 1;
            counter <= 0;
        end
        default: begin
            shift_A <= shift_A<<1;
            result <= result + shift_A;
        end
    endcase
    end
endmodule