`include "ConstValue.vh"
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


module GameStateEncoder(
input clk,
input switch_start,
input enable,
output reg [7:0] tx,
output reg activation
    );
reg pre_switch = 1'b0;
always @(posedge clk) begin
    if (enable) begin
        activation <= 1'b1;
        if (pre_switch != switch_start) begin
            if (switch_start) tx <= 8'b00000101;
            else tx <= 8'b00001001;
        end
    end else begin 
        activation <= 1'b0;
        tx <= 8'b00000001;
    end
end
endmodule