`include "../ConstValue.vh"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/02 22:59:02
// Design Name: 
// Module Name: TargetStateMachine
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

//targetStateMachine模块用于判断Manual模式下用户是否进行了一次当前目标机器的切换
//如果切换了，则依据传入的state将state+-1传出，并激活一个时钟周期的activate
module TargetStateMachine(
input [1:0] in,
input en,
input clk,
input [5:0] state,
output reg [5:0] next_state,
output reg activation
    );
    parameter no_press = 2'b00;
    parameter target_up =1;
    parameter target_down=0;

    reg [1:0] prev_in;
    //确保激活一个时钟周期的active
    always @(posedge clk) begin
        if(prev_in==in|in==no_press) begin//当前信号与上个信号相同/当前没有输入激活
            activation<=`unactivate_signal;
        end
        else begin //当前信号不同于上个周期，发送一次脉冲
            activation<=`activate_signal;
        end
        prev_in<=in;
    end
    //切换targetMachine的组合逻辑
    always @(in) begin
        if(en&in!=no_press) begin //enable
            if(in[target_up]) begin
                next_state=state+1;
            end else if(in[target_down]) begin
                next_state=state-1;
            end
            //过滤targetMachine>20或<1
            if(next_state>`Targeting_Max) begin
                next_state=`Targeting_Initial; 
            end else if(next_state<`Targeting_Initial) begin
                next_state=`Targeting_Max;
            end
        end
    end
endmodule
