`include "../ConstValue.vh"
`timescale 1ns / 1ps
//一段组合逻辑，解析jump脚本，依据状态分析下一条指令在哪一行
module JumpScriptHandler(
input clk,en,
input [1:0] func,
input [2:0] signal,
input [7:0] i_num,
input [7:0] feedback,//反馈
input feedback_valid,
output reg [7:0] next_line,//输出下一行是哪一行就行（比如1或6）
output reg activation=`unactivate_signal
);
wire [3:0] state = feedback[5:2];



parameter next_one = 8'd1;
parameter func_zero=0;
parameter func_one=1;

always @*
if(feedback_valid) begin//如果反馈不合法就不激活
activation=`activate_signal;
if(en & ~func[func_one]) begin
    //判断信号，如果信号满足就向下跳i_num行
    if(state[signal] == ~func[func_zero]) begin
        next_line = i_num;
    end else begin
        next_line = next_one;
    end
end else begin
    next_line = next_one;
end
end else begin
    activation=`unactivate_signal;
end
endmodule