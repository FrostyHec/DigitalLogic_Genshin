`include "../ConstValue.vh"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/02 22:16:05
// Design Name: 
// Module Name: ManualFliter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//operationEncoder用于解析Manual模式下按下按钮所执行的GPIMT操作
module OperationEncoder(
input [4:0] button,
input enable,clk,rst_n,
output reg [7:0] tx,
output reg activation=`unactivate_signal
    );
//一段组合逻辑，在启动且并非清零的状态依据用户按下按钮的状况发出指令
always @(*) begin
    if (enable&&rst_n) begin
        activation = `activate_signal;
        case(button)
            `oe_get: tx={`Sender_Operation_Get,`Sender_Channel_Operate};
            `oe_put: tx={`Sender_Operation_Put,`Sender_Channel_Operate};
            `oe_int: tx={`Sender_Operation_Interact,`Sender_Channel_Operate};
            `oe_mov: tx={`Sender_Operation_Move,`Sender_Channel_Operate};
            `oe_thr: tx={`Sender_Operation_Throw,`Sender_Channel_Operate};
            default: begin
                tx={`Sender_Data_Ignore,`Sender_Channel_Operate};  
                activation=`unactivate_signal;
            end 
        endcase
    end else begin 
        tx = {`Sender_Data_Ignore,`Sender_Channel_Operate};//清零
        activation = `unactivate_signal;
    end
end
endmodule
