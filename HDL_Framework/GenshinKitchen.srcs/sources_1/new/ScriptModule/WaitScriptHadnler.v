`include "../ConstValue.vh"
`timescale 1ns / 1ps
module WaitScriptHandler(
input clk,en,
input [1:0] func,
input [2:0] signal,
input [7:0] i_num,
input [7:0] feedback,//反馈
output isFinished//输出这个条件是否被满足即可
);

endmodule