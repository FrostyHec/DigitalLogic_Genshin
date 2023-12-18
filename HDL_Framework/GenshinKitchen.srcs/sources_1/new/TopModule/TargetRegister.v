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

//我希望它的功能是，当我给它传入一个新的state后，它把这个新的state赋给旧的
module TargetRegister(
input [5:0] next_state,
input next_state_activation,
input clk,
input rst_n,
output reg [5:0] state =`Targeting_Initial
    );
    always @(posedge clk) begin
        if(~rst_n) begin
            state <=`Targeting_Initial;
        end else if(next_state_activation) begin
            state <=next_state;
        end
    end
    // always @(posedge next_state) begin
    //     state<=next_state;
    // end
endmodule

