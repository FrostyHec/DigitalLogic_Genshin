
`include "../ConstValue.vh"
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
input [1:0] in,
input en,
input clk,
input [5:0] state,
output reg [5:0] next_state,
output reg activation
    );
    parameter no_press = 2'b00;
    parameter target_up =1;
    parameter target_down=0;

    reg [1:0] prev_in;
    always @(posedge clk) begin//reg
        prev_in<=in;
    end
    always @(in) begin
        if(en&&in!=no_press) begin //enable
            if(in[target_up]) begin
                next_state=state+1;
            end else if(in[target_down]) begin
                next_state=state-1;
            end
            if(next_state>`Targeting_Max) begin
                next_state=`Targeting_Initial; 
            end else if(next_state<`Targeting_Initial) begin
                next_state=`Targeting_Max;
            end
        end
    end
    always @(posedge clk) begin
        if(prev_in==in||in==no_press) activation=1'b0;
        else activation=1'b1;
    end
endmodule
