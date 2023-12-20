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


module OperationEncoder(
input [4:0] button,
input enable,
output reg [7:0] tx,
output reg activation
    );
always @(*) begin
    if (enable) begin
        activation = 1'b1;
        casex(button)
            `oe_get: tx={`Sender_Operation_Get,`Sender_Channel_Operate};
            `oe_put: tx={`Sender_Operation_Put,`Sender_Channel_Operate};
            `oe_int: tx={`Sender_Operation_Interact,`Sender_Channel_Operate};
            `oe_mov: tx={`Sender_Operation_Move,`Sender_Channel_Operate};
            `oe_thr: tx={`Sender_Operation_Throw,`Sender_Channel_Operate};
            default: begin 
                tx={`Sender_Data_Ignore,`Sender_Channel_Operate};
                activation=1'b0;
            end
        endcase
    end else begin 
        tx = {`Sender_Data_Ignore,`Sender_Channel_Operate};
        activation = 1'b0;
    end
end
endmodule
