
`include "../ConstValue.vh"
`timescale 1ns / 1ps
//手动模式的顶层模块
module ManualTop(
//按键和外部输入
input [7:0] switches,
input [4:0] button,
input clk,
input rst_n,
//反馈信号
input [7:0] rx,
input feedback_valid,
input available_for_next,
//targetMachine
input [5:0] state,

output [7:0] tx,
output [7:0] led,led2,
output reg [5:0] new_state,
output reg new_state_activation

    );
    //模块例化
    reg prev_send;
    wire [5:0] tsm_next_state;
    wire [7:0] tse_tx,gs_tx,oe_tx;
    wire state_change_active,available_for_encoder,gamestate_activated,operation_activated;
    //切换targetMachine模块
    TargetStateMachine tsm(
        .in({button[4],button[1]}),
        .en(1'b1),
        .clk(clk),
        .state(state),
        .next_state(tsm_next_state),
        .activation(available_for_encoder)
        );
    TargetStateEncoder tse(
        .state(tsm_next_state),
        .input_activate(available_for_encoder),
        .tx(tse_tx),
        .activation(state_change_active)
    );
    //开启/结束游戏功能
    GameStateEncoder gs(
        .in({switches[`In_Switch_GameEnd],switches[`In_Switch_GameStart]}),
        .enable(1'b1),
        .clk(clk),
        .rst_n(rst_n),
        .tx(gs_tx),
        .activation(gamestate_activated)
    );
    //GPIMT操作功能
    OperationEncoder op(
        .button({switches[3],button[0],switches[2],button[2],button[3]}),
        .enable(1'b1),
        .clk(clk),
        .rst_n(rst_n),
        .tx(oe_tx),
        .activation(operation_activated)
    );
    //脚本过滤器
    reg [7:0] prev_tx;
    reg [7:0] ftx;
    ManualFliter mf(
        .prev_tx(ftx),
        .feedback(rx),
        .feedback_valid(feedback_valid),
        .target_machine(state),
        .tx(tx)
    );
    //在每个时钟上升沿，判断哪个模块呗激活，发送该模块信号
    parameter counter_init=10'b0000_000_001;
    parameter counter_div=1;
    reg [9:0] prev_op_activated;
    always @(posedge clk) begin
        if(available_for_next) begin
            //如果targetMachine切换，激活activation以被外部register激活
            if(state_change_active) begin
                new_state<=tsm_next_state;
                new_state_activation<=`activate_signal;
            end else begin
                new_state_activation<=`unactivate_signal;
            end
            //判断激活的模块并发送信号
            if(operation_activated) begin//GPIMT激活
                ftx<=oe_tx;
                prev_op_activated<=counter_init;
            end 
            else if(prev_op_activated) begin 
                ftx<={`Sender_Data_Ignore,`Sender_Channel_Operate};
                prev_op_activated<=prev_op_activated+counter_div;
            end
            else if(state_change_active) begin //修改当前targetMachine
                ftx<=tse_tx;
                prev_tx<=tse_tx;
                prev_send<=`activate_signal;
            end 
            else if(gamestate_activated) begin//开启/结束游戏
                ftx<=gs_tx;
                prev_tx<=gs_tx;
                prev_send<=`activate_signal;
            end 
            else begin 
                ftx<=prev_tx;
            end 
        end
    end
endmodule