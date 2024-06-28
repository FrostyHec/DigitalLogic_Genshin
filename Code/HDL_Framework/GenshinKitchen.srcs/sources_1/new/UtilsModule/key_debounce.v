`include "../ConstValue.vh"
`timescale 1ns / 1ps


//returns：
//key_flag：当前时钟周期key_value是否发生改变
//key_value：（消抖后）当前时钟周期下按键的值
module key_debounce(
input clk,
input rst_n,
input key,
output reg key_flag,
output reg key_value
);

//指定判断的时钟周期
parameter period = 5000;
parameter init=0;
parameter key_true=1'b1;
parameter div=1;
parameter key_false=1'b0;

//消抖模块的延时计数
reg [31:0] delay_cnt;
reg key_reg;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        delay_cnt <= init;
        key_reg <= key_true;
    end
    else
    begin
        if(key_reg != key)
            delay_cnt <= period;
        else
        begin
            if(delay_cnt > init)
                delay_cnt <= delay_cnt-div;
            else
                delay_cnt <= delay_cnt;
        end
        key_reg<=key;
    end
end
//在每个上升沿更新按键状态数据
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)//rst重置
    begin
        key_flag <= key_false;
        key_value <= key_false;
    end
    else
    begin
        if(delay_cnt == init)
        begin
            //完成计数输出稳定数据
            key_value <= key;
            key_flag <= key_true;
        end
        else
        begin
            //当前按键状态不稳定，保持上一按键状态
            key_flag <= key_false;
            key_value <= key_value;
        end
    end
end

endmodule