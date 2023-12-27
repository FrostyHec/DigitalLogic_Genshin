`include "../ConstValue.vh"
`timescale 1ns / 1ps
//这里只涉及组合逻辑，因此始终是无用的
//对于enable，如果enable为0的话就直接跳过Jump这一条，也就是说，直接执行下一条
module JumpScriptHandler(
input clk,en,
input [1:0] func,
input [2:0] signal,
input [7:0] i_num,
input [7:0] feedback,//反馈
input feedback_valid,
output reg [7:0] next_line,//输出下一行是哪一行就行（比如1或6）
output reg activation=1'b0
);

wire [3:0] state = feedback[5:2];

always @*
if(feedback_valid) begin
activation=1'b1;
if(en & ~func[1]) begin
    if(state[signal] == ~func[0]) begin
        next_line = i_num;
    end else begin
        next_line = 8'd1;
    end
end else begin
    next_line = 8'd1;
end
end else begin
    activation=1'b0;
end
endmodule