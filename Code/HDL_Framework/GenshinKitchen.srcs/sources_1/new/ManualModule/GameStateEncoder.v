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

//GameStateEncoder用于解析Manual模式下拨动开关执行的开始/结束游戏操作
module GameStateEncoder(
input [1:0] in,
input enable,
input clk,
input rst_n,
output reg [7:0] tx,
output reg activation=`unactivate_signal
    );
reg [7:0] prev_tx={`Sender_Data_Ignore,`Sender_Channel_Ignore};
//由于GameState需要在执行一次开启/结束游戏操作后，仅在下一个时钟上升沿发送一次脉冲信号
//因此需要一个时序逻辑：比较当前信号和上一个时钟周期信号是否有区别，
//如有则开启activation置1脉冲一次，如无则置零，最后存储其当前信号至FF中
always @(posedge clk) begin
    if(~rst_n) begin
        activation<=`unactivate_signal;
        prev_tx<={`Sender_Data_Ignore,`Sender_Channel_Ignore};
    end else begin
        prev_tx<=tx;
        if(prev_tx==tx) begin
            activation<=`unactivate_signal;
        end else begin
            activation<=`activate_signal;
        end
    end
end
//tx是一段组合逻辑，依据当前拨码开关状态求出输出的tx信号
always @(in) begin
    if(enable) begin
        case (in)
            `gst_st: tx={`Sender_GameState_Start,`Sender_Channel_GameStateChanged};
            `gst_ed: tx={`Sender_GameState_Stop,`Sender_Channel_GameStateChanged};
            default: begin
                tx={`Sender_Channel_Ignore,`Sender_Channel_Ignore};
            end
        endcase
    end
end

endmodule