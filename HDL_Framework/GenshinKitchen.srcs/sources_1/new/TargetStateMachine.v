
`include "ConstValue.vh"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/02 22:59:02
// Design Name: 
// Module Name: TargetStateMachine
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


module TargetStateMachine(
input [1:0] button,
input btn_en,
input clk,
input [5:0] state,
output reg [5:0] next_state,
output reg activation
    );
    reg [1:0] prev_button;
    always @(posedge clk) begin
        if(prev_button==button) activation<=1'b0;
        prev_button<=button;
    end
    always @(button) begin
        activation=1'b0;
        if(btn_en) begin //enable
            if(button[`Encoder_Btn_TargetUp]) begin
                next_state=state+1;
                activation=1'b1; 
            end else if(button[`Encoder_Btn_TargetDown]) begin
                next_state=state-1;
                activation=1'b1;
            end
            if(next_state>`Targeting_Max) begin
                next_state=`Targeting_Initial; 
            end else if(next_state<`Targeting_Initial) begin
                next_state=`Targeting_Max;
            end
        end
    end
endmodule
