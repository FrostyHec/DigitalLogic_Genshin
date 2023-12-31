`include "../ConstValue.vh"
`timescale 1ns / 1ps

module loadingLamp (
    input clk,rst_n,enable,
    output [7:0] loadingLamp
);
//参数
parameter p1 = 10000_0000;//隔多久闪一次
parameter p2 = 20;//闪几次加1
parameter init=0;
parameter lamp_on=1'b1;
parameter lamp_of=1'b0;
//计数器
reg[2:0] state = init;
reg[31:0] counter1 = init;
reg[3:0] counter2 =init;
reg[23:0] l;
assign loadingLamp = l[15:7];
reg lamp = init;
//在每个时钟上升沿进行计数与led显示更新
always @(posedge clk, negedge rst_n)
begin
    if(enable)
    begin
        if(~rst_n)
        begin
            l <= 16'd0;
            lamp <= 1'b0;
        end
        else
        begin
            //完成了tb测试，loadingLamp是正常的
            //寄存器位移
            l[state] <= 1'b1;
            l[state+1] <= 1'b1;
            l[state+2] <= 1'b1;
            l[state+3] <= 1'b1;
            l[state+4] <= 1'b1;
            l[state+5] <= 1'b1;
            l[state+6] <= 1'b1;
            l[state+7] <= lamp;
        
            l[state+8] <= 1'b0;
            l[state+9] <= 1'b0;
            l[state+10] <= 1'b0;
            l[state+11] <= 1'b0;
            l[state+12] <= 1'b0;
            l[state+13] <= 1'b0;
            l[state+14] <= 1'b0;

            if(counter1 >= p1)
            begin
                lamp <= ~lamp;
                if(counter2 >= p2)
                begin
                    state <= state + 1;
                    counter2 <= 0;
                end
                else
                begin
                    counter2 <= counter2 + 1;
                end
            end
            else
            begin
                counter1 <= counter1 + 1;
            end
        end
    end
end

    
endmodule


