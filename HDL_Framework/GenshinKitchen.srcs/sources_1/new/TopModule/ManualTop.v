
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


module ManualTop(
input [7:0] switches,
input [4:0] button,
input clk,
input [7:0] rx,

input available_for_next,
input [5:0] state,

output reg[7:0] tx,
output reg [7:0] led,led2,
output reg[5:0] new_state,
output reg new_state_activation
    );
    reg prev_send;
    wire [5:0] tsm_next_state;
    wire [7:0] tse_tx;
    wire state_change_active,available_for_encoder;
    TargetStateMachine tsm(
        .in({switches[`In_Switch_TargetUp],switches[`In_Switch_TargetDown]}),
        .en(1'b1),
        .clk(clk),
        .state(state),
        .next_state(tsm_next_state),
        .activation(available_for_encoder)
        );
    TargetStateEncoder tse(
        .state(tsm_next_state),
        .input_activate(available_for_encoder),
        .tx(tse_tx),
        .activation(state_change_active)
    );

    always @(posedge clk) begin
        if(available_for_next) begin
            if(state_change_active) begin
                new_state<=tsm_next_state;
                new_state_activation<=1'b1;
            end else begin
                new_state_activation<=1'b0;
            end
            if(state_change_active) begin
                tx<=tse_tx;
                prev_send<=1'b1;
            end 
            // else begin
            //     tx<={`Sender_Data_Ignore,`Sender_Channel_Ignore};
            // end
        end
    end
endmodule