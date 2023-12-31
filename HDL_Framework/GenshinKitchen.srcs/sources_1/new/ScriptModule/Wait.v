`include "../ConstValue.vh"
`timescale 1ns / 1ps
//等待指定的xx*100ms
module Wait(
input clk, en,
input [7:0] i_num,
//输出是否等待结束
output reg isFinished
);
//模块所需参数
parameter period = 2000_000_0; //100ms周期
parameter init_i=8'd0;
parameter init_cnt=0;
parameter div=1;
parameter dec=1;
parameter finished_true =1'b1;
parameter finished_false =1'b0;


reg [31:0] cnt=init_cnt;//每100ms完成一次cnt计数
reg [7:0] i = init_i;//已经完成的100ms个数
//时钟周期计数
always @(posedge clk)
begin
    if(~en)
    begin
        //在未激活时保持初始状态
        cnt <= init_cnt;
        i <= init_i;
        isFinished <= finished_false;
    end
    else
    begin
        //在每个时钟周期进行计数直至时间抵达
        if(cnt >= (period >> dec) - div)
        begin
            //100ms结束 
            if(i >= i_num)//计时结束
            begin
                isFinished <= finished_true;
                i <= init_i;
            end else
            begin
                //下一个100ms
                i <= i+div;
            end
            cnt <= init_cnt;
        end
        else 
        begin
            //100ms未结束
            cnt <= cnt + div;
        end
    end
end


endmodule