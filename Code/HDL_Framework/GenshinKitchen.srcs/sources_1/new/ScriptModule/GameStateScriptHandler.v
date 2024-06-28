`include "../ConstValue.vh"
`timescale 1ns / 1ps
//这是用于分析game start/end脚本的模块
module GameStateScriptHandler(
input clk,en,
input [1:0] func,
input [2:0] signal,
input [7:0] i_num,
input [5:0] targetState,
output reg [7:0] tx,
output reg activation,has_next=`unactivate_signal
);
//一段组合逻辑，如果当脚本为start时，发出开始游戏。如果为end发出结束游戏，如果上述都不是不激活（脚本有误）
always @* begin
    if(en) begin
        if(func==`Script_GameState_Start) begin
            activation=`activate_signal;
            tx={`Sender_GameState_Start,`Sender_Channel_GameStateChanged};
        end else if(func==`Script_GameState_End) begin
            activation=`activate_signal;
            tx={`Sender_GameState_Stop,`Sender_Channel_GameStateChanged};
        end else begin
            activation=`unactivate_signal;
        end
    end
end
endmodule