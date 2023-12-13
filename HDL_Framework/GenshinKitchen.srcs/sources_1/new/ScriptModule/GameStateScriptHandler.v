`include "../ConstValue.vh"
`timescale 1ns / 1ps
module GameStateScriptHandler(
input clk,en,
input [1:0] func,
input [2:0] signal,
input [7:0] i_num,
input [5:0] targetState,//以二进制编码的当前targetState
output [7:0] tx,
output activation,has_next
);

endmodule