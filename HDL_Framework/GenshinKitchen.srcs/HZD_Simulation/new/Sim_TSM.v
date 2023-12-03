`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/03 00:13:48
// Design Name: 
// Module Name: FeedbackLED
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


module Sim_TSM(
    );
    reg [1:0] button;
    reg btn_en;
    reg [5:0] state;
    wire [5:0] next_state;
    wire activation;
    TargetStateMachine tsm(.button(button),.btn_en(btn_en),.state(state)
    ,.next_state(next_state),.activation(activation));
    initial begin
        button=2'b10;
        state=6'b000_001;
        btn_en=1'b1;
        repeat(25) begin
            #5 button=2'b00;
            #5 button=2'b10;
            state=next_state;
        end
        repeat(25) begin
            #5 button=2'b00;
            #5 button=2'b01;
            state=next_state;
        end
        $finish;
    end
endmodule