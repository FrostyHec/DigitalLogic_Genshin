`include "../ConstValue.vh"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/02 23:01:17
// Design Name: 
// Module Name: TargetRegister
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

//依据传入的state在下个时钟周期对state进行更新
module TargetRegister(
input [5:0] next_state,
input next_state_activation,
input clk,
input rst_n,
output reg [5:0] state =`Targeting_Initial
    );
    always @(posedge clk) begin
        if(~rst_n) begin//rst时置为初始状态
            state <=`Targeting_Initial;
        end else if(next_state_activation) begin
            state <=next_state;//更新激活则更新state
        end
    end
endmodule

