`include "../ConstValue.vh"
`timescale 1ns / 1ps
//用于判断当前是否为脚本模式
module SwitchStateEncoder(
    //传入信号
    input [7:0] feedback,
    input rst,
    input script_mode,
    output reg current_script=1'b0,
    output reg switch_init=1'b0
);
// reg switch_init=1'b0;
always @(*) begin
    if(~rst) begin
        switch_init=1'b0;
        current_script=1'b0;
    end else begin
        if(feedback[1:0]==`Receiver_Channel_Script) begin
            switch_init=1'b1;
        end
        if(~script_mode&switch_init) begin
            //等待脚本加载完成
            current_script=1'b1;
        end 
    end
end

endmodule