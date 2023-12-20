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


module GameStateEncoder(
input [1:0] in,
input enable,
input clk,
output reg [7:0] tx,
output reg activation
    );
reg [7:0] prev_tx;
always @(posedge clk) begin
    if(prev_tx==tx) begin
        activation<=1'b0;
    end else begin
        activation<=1'b1;
    end
    prev_tx<=tx;
end
always @(in) begin
    if(enable) begin
        case (in)
            `gst_st: tx={`Sender_GameState_Start,`Sender_Channel_GameStateChanged};
            `gst_ed: tx={`Sender_GameState_Stop,`Sender_Channel_GameStateChanged};
            default: begin
                tx={`Sender_Channel_Ignore,`Sender_Channel_Ignore};
            end
        endcase
    end
end

endmodule