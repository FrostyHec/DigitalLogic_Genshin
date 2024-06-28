`include "../ConstValue.vh"
`timescale 1ns / 1ps
//wait模块用于处理wait指令，如果wait已经满足，则isFinish设置为1，反之设置为0
module WaitScriptHandler(
//原始时钟与enable
input clk,en,
//脚本信息
input [1:0] func,
input [2:0] signal,
input [7:0] i_num,
//反馈信号
input [7:0] feedback,
input feedback_valid,
//输出是否wait完了
output reg isFinished = `unactivate_signal
);
//获取反馈信息
wire [3:0] state = feedback[5:2];
wire iF;
reg enable = `unactivate_signal;
reg en_r;

//等待i_num==100ms，完事以后输出的iF就是1'b1
Wait u(clk, enable, i_num, iF);
always @(*)
begin
    if(en)
    begin
        if(func == `Script_Wait_WaitTime)
        //wait语句使用Wait模块进行时钟计时
        begin
            enable = `activate_signal;
            isFinished = iF;
            if(iF & ~en_r)
            begin
                enable = `unactivate_signal;
            end
        end else if((func == `Script_Wait_WaitUntil)  & feedback_valid)
        //waitUntil语句判断是否抵达信号
        begin
            if(state[signal] == `activate_signal) 
            //如果当前状态满足则满足则输出完成，否则输出不完成
            begin
                isFinished = `activate_signal;
            end
            else
            begin
                isFinished = `unactivate_signal;
            end
        end else 
        begin
            isFinished = `activate_signal;
        end
    end
    else
    begin
        isFinished = `unactivate_signal;//将isFinished置为原状态
        if(en_r)
        begin
            enable = `unactivate_signal;
        end
    end
end
always @(posedge clk) begin
    en_r <= en;
end


endmodule