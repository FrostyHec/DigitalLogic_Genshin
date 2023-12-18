`include "../ConstValue.vh"
`timescale 1ns / 1ps
module Wait(
input clk,
input [7:0] i_num,
output reg isFinished//输出这个条件是否被满足,1为满足，0为未满足
);

parameter period = 1000_0000; //100ms(不是很确定哇)
reg [31:0] cnt;
reg [7:0] i;

always @(posedge clk)
begin
    isFinished <= 1'b0;
    if(cnt == (period >> 1) - 1)
    begin 
        if(i == 8'd0)
        begin
            isFinished <= 1'b1;
        end else
        begin
            i <= i-1;
        end
        cnt <= 0;
    end
    else 
    begin
        cnt <= cnt + 1;
    end
end


endmodule