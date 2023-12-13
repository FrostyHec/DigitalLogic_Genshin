`include "../ConstValue.vh"
`timescale 1ns / 1ps
module JumpScriptHandler(
input clk,en,
input [1:0] func,
input [2:0] signal,
input [7:0] i_num,
input [7:0] feedback,//反馈
output [7:0] next_line//输出下一行是哪一行就行（比如1或6）
);

endmodule