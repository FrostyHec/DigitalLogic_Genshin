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


module Sim_TSE(
    );
    reg [5:0] state;
    reg input_activate;
    wire [7:0] tx;
    wire activation;
    TargetStateEncoder t(.state(state),.input_activate(input_activate),
    .tx(tx),.activation(activation));
    initial begin
        state=6'b000_001;
        input_activate=1'b1;
        repeat(10) begin
            #10
            input_activate=~input_activate;
            state=state+1;
        end
        $finish;
    end
endmodule