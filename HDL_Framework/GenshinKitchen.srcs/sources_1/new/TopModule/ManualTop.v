
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

output [7:0] tx,
output [7:0] led,led2,
output reg[5:0] new_state,
output reg new_state_activation
    );
    reg prev_send;
    wire [5:0] tsm_next_state;
    wire [7:0] tse_tx,gs_tx,oe_tx;
    wire state_change_active,available_for_encoder,gamestate_activated,
    operation_activated;
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
    GameStateEncoder gs(
        .in({switches[`In_Switch_GameEnd],switches[`In_Switch_GameStart]}),
        .enable(1'b1),
        .clk(clk),
        .tx(gs_tx),
        .activation(gamestate_activated)
    );
    OperationEncoder op(
        .button(button),
        .enable(1'b1),
        .tx(oe_tx),
        .activation(operation_activated)
    );
    reg [7:0] prev_tx,ftx;
    ManualFliter mf(
        .prev_tx(ftx),
        .feedback(8'b0000_0101),//does rx has any bugs???????
        .target_machine(state),
        .tx(tx)
    );
    assign led=tx;
    always @(posedge clk) begin
        if(available_for_next) begin
            if(state_change_active) begin
                new_state<=tsm_next_state;
                new_state_activation<=1'b1;
            end else begin
                new_state_activation<=1'b0;
            end
            if(operation_activated) begin
                ftx<=oe_tx;
                prev_send<=1'b1;
            end 
            else if(state_change_active) begin
                ftx<=tse_tx;
                prev_tx<=tse_tx;
                prev_send<=1'b1;
            end 
            else if(gamestate_activated) begin
                ftx<=gs_tx;
                prev_tx<=gs_tx;
                prev_send<=1'b1;
            end 
            else begin
                ftx<=prev_tx;
            end 
        end
    end
endmodule