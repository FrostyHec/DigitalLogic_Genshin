`include "../ConstValue.vh"
`timescale 1ns / 1ps
module Wait(
input clk, en,
input [7:0] i_num,
output reg isFinished//输出这个条件是否被满足,1为满足，0为未满足

,output reg led=1'b0//???????????????????????????????????
);

parameter period = 100; //100ms(不是很确定哇)
reg [31:0] cnt=1'd0;
reg [7:0] i = 8'd0;

always @(posedge clk)
begin
    if(~en)
    begin
        cnt <= 0;
        i = 8'd0;
        isFinished <= 1'b0;
    end
    else
    begin
        if(cnt >= (period >> 1) - 1)
        begin 
            if(i >= i_num)
            begin
                led<=1'b0;
                isFinished <= 1'b1;
                i <= 8'd0;
            end else
            begin
                
                i <= i+1;
                isFinished <= 1'b0;
            end
            cnt <= 0;
        end
        else 
        begin
            led<=1'b1;
            isFinished <= 1'b0;
            cnt <= cnt + 1;
        end
    end
end


endmodule