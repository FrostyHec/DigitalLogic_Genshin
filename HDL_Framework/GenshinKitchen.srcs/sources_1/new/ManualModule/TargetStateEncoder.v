`include "../ConstValue.vh"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/02 22:59:17
// Design Name: 
// Module Name: TargetStateEncoder
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


module TargetStateEncoder(
input [5:0] state,
input input_activate,
output reg [7:0] tx,
output reg activation
    );
    reg [5:0] sender_data;
    reg[1:0] sender_channel;  
    always @(input_activate) begin
        if(input_activate) begin
            sender_data=state;
            sender_channel=`Sender_Channel_TargetMachineChanged;
            activation=1'b1;
        end else begin
            sender_data=`Sender_Data_Ignore;
            sender_channel=`Sender_Channel_Ignore;
            activation=1'b0;    
        end
        tx={sender_data,sender_channel};
    end
endmodule
