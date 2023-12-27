`include "../ConstValue.vh"
`timescale 1ns / 1ps
//此处如果enable�??0的话，输出将会为1（相当于直接跳过wait�??
module WaitScriptHandler(
input clk,en,feedback_valid,
input [1:0] func,
input [2:0] signal,
input [7:0] i_num,
input [7:0] feedback,//反馈
output reg isFinished = 1'b0//输出这个条件是否被满�??,1为满足，0为未满足

,output led
);

reg enable = 1'b0;
reg en_r;

wire [3:0] state = feedback[5:2];
wire iF;
//test
wire led2;
assign led=enable;

//等待i_num�??100ms，完事以后输出的iF就是1'b1
Wait u(clk, enable, i_num, iF,led2);
always @(*)
begin
    if(en)
    begin
        if(func == 2'b00)
        begin
            enable = 1'b1;
            isFinished = iF;
            if(iF & ~en_r)
            begin
                enable = 1'b0;
            end
        end else if((func == 2'b01)  & feedback_valid)
        begin
            if(state[signal] == 1'b1) 
            begin
                isFinished = 1'b1;
            end
            else
            begin
                isFinished = 1'b0;
            end
        end else 
        begin
            isFinished = 1'b1;
        end
    end
    else
    begin
        isFinished = 1'b0;
        if(en_r)
        begin
            enable = 1'b0;
        end
    end
end

always @(posedge clk) begin
    en_r <= en;
end


endmodule