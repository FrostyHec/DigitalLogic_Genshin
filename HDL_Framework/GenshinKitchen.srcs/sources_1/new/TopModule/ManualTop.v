
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
input [6:0] button,
output [7:0] led,
input clk,
input rx,
output tx
    );
    wire [4:0] b=switches[4:0];
    wire w;
    OperationEncoder c(.button(b),.enable(1'b1),.tx(tx),.activation(w));
endmodule