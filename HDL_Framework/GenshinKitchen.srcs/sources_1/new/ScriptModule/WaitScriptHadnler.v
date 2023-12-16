`include "../ConstValue.vh"
`timescale 1ns / 1ps
module WaitScriptHandler(
input clk,en,
input [1:0] func,
input [2:0] signal,
input [7:0] i_num,
input [7:0] feedback,//反馈
output reg isFinished//输出这个条件是否被满足,1为满足，0为未满足
);

wire [3:0] state = feedback[5:2];
wire iF;

Wait u(clk, i_num, iF);

always @*
begin
    if(en)
    begin
        if(func == 2'b00)
        begin
            isFinished <= iF;
        end else if(func == 2'b01)
        begin
            isFinished <= 1'b0;
            if(state[signal] == 1'b1) begin
            isFinished <= 1'b1;
            end
        end else 
        begin
            isFinished <= 1'b1;
        end
    end
end


endmodule