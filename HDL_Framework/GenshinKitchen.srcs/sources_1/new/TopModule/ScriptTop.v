`include "../ConstValue.vh"
`timescale 1ns / 1ps

module ScriptTop(
input [7:0] in,
input script_mode,
input clk,
input [7:0] rx,

output reg [7:0] pc,
input [15:0] script,
input dataOut_valid,

input available_for_next,
input [5:0] state,

output reg [7:0] tx,
output [7:0] led,led2,
output reg[5:0] new_state,
output reg new_state_activation
);
wire mode=1'b1;//button per step or continutously run
reg send_message=1'b0,has_next=1'b1;
reg [31:0] send_counter;//这里用counter，考虑pulse
reg [1:0] func;
reg [2:0] signal;
reg [7:0] i_num;
wire [7:0] gs_out;
wire gs_activation;
GameStateScriptHandler gs(
    .clk(clk),
    .en(1'b1),
    .func(func),
    .signal(signal),
    .i_num(i_num),
    .targetState(state),
    .tx(gs_out),
    .activation(gs_activation)
);
always @(posedge clk) begin
    if(script_mode&&send_counter==0) begin//如果上一个信号发送完了且enable了就发送下一个信号
        if(mode) begin
            if(in[`In_Switch_StepMode]) begin
                send_message<=1'b1;
            end
        end else begin//auto mode
            send_message<=1'b1;
        end
    end
end
always @(*) begin
    if(send_counter>=1000) begin
        send_counter=0;
        send_message=1'b0;
    end
    if(send_message&dataOut_valid) begin//如果当前可以发送数据且接收到的脚本是合法的话
        if(~send_counter) begin //new signal
            if(~has_next) begin//has_next表示上一个模块是否需要输出多次，如果需要就先停留在这里，否则跳到下一条指令
                pc=pc+2;
            end

        end
        send_counter=send_counter+1;
    end 
end

endmodule