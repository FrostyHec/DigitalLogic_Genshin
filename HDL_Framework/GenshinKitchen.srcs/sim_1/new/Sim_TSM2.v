`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/03 18:12:26
// Design Name: 
// Module Name: Sim_TSM
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


module Sim_TSM2(

    );
    reg clk=1'b0,en=1'b1;
    reg [1:0] in;
    reg [5:0] state=6'b000_000;
    wire [5:0] next_state;
    wire activation;
    TargetStateMachine tsm(
        .in(in),
        .en(en),
        .clk(clk),
        .state(state),
        .next_state(next_state),
        .activation(activation)
    );
    initial begin
        forever begin
            #5 clk=~clk;
        end
    end
    initial begin
        repeat(30) begin
             in=2'b00;#20;
             in=2'b10;#80;
        end
        $finish;
    end
endmodule
