`include "../ConstValue.vh"
`timescale 1ns / 1ps

module loadingLamp (
    input clk,rst_n,enable,
    output reg[7:0] loadingLamp
);
//隔多久闪一次
parameter p1 = 10000_0000;
//闪几次加1
parameter p2 = 20;
reg[2:0] state = 3'd0;
reg[31:0] counter1 = 1'b0;
reg[3:0] counter2 = 1'b0;
reg lamp = 1'b0;

always @(posedge clk, negedge rst_n)
begin
    if(enable)
    begin
        if(~rst_n)
        begin
            loadingLamp <= 8'd0;
            lamp <= 1'b0;
        end
        else
        begin
            //tb是正常的，但是就是不知道这样写上板之后会不会有别的影响，毕竟可能会影响到附近的reg
            //如果不行的话可能就只能按照state分类搞了
            //不知道这个存reg的机理是什么，如果是直接抹去获取不了的reg的话应该就没有问题
            loadingLamp[state-1] <= 1'b1;
            loadingLamp[state-2] <= 1'b1;
            loadingLamp[state-3] <= 1'b1;
            loadingLamp[state-4] <= 1'b1;
            loadingLamp[state-5] <= 1'b1;
            loadingLamp[state-6] <= 1'b1;
            loadingLamp[state-7] <= 1'b1;
            
            loadingLamp[state] <= lamp;
            
            loadingLamp[state+1] <= 1'b0;
            loadingLamp[state+2] <= 1'b0;
            loadingLamp[state+3] <= 1'b0;
            loadingLamp[state+4] <= 1'b0;
            loadingLamp[state+5] <= 1'b0;
            loadingLamp[state+6] <= 1'b0;
            loadingLamp[state+7] <= 1'b0;

            if(counter1 >= p1)
            begin
                lamp <= ~lamp;
                if(counter2 >= p2)
                begin
                    //这个也有可能会溢出，进而对reg外面的玩意造成影响
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
                counter1 = counter1 + 1;
            end
        end
    end
end

    
endmodule


