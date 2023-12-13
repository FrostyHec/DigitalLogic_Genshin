`include "../ConstValue.vh"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/02 22:16:05
// Design Name: 
// Module Name: ManualFliter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OperationEncoder(
input [4:0] button,
input enable,
output reg [7:0] tx,
output reg activation
    );
always @* begin
    if (enable) begin
        activation <= 1'b1;
        casex(button)
            5'bxxxx0 : tx <= 8'b0000_0110;
            5'bxxx0x : tx <= 8'b0000_1010;
            5'bxx0xx : tx <= 8'b0001_0010;
            5'bx0xxx : tx <= 8'b0010_0010;
            5'b0xxxx : tx <= 8'b0100_0010;
            default : tx <= 8'b0000_0010; 
        endcase
    end else begin 
        tx <= 8'b0000_0010;
        activation <= 1'b0;
    end
end
endmodule