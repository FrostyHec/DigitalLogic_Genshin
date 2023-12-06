`include "ConstValue.vh"
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


module ManualFliter(
input [7:0] prev_tx,feedback,
input [5:0] target_machine,
output reg [7:0] tx
    );
    wire[1:0] feedback_channel = feedback[1:0];
    wire[1:0] prev_tx_channel = prev_tx[1:0];
    wire throwable,istable;

    TargetMachineThrowable target_machine_throwable(
        .target_machine(target_machine),
        .throwable(throwable),
        .istable(istable)
    );

    always @*
    begin
    if(prev_tx_channel == `Sender_Channel_Operate) begin
        if(feedback_channel == `Receiver_Channel_FeedBack) begin
            
            //prevent illegal interaction while moving
            if(feedback[`Receiver_Feedback_InfrontTargetMachine] | prev_tx[6] | prev_tx[5] == 1'b0) begin
                tx={`Sender_Data_Ignore,`Sender_Channel_Ignore};
            end 

            //prevent unreasonable access to item interactions
            // get
            else if(prev_tx[7:2] == `Sender_Operation_Get) begin
                if(feedback[`Receiver_Feedback_MachineHasItem] == 1'b1) begin
                    tx=prev_tx;
                end
                else begin
                    tx={`Sender_Data_Ignore,`Sender_Channel_Ignore};
                end
            end 
            // put
            else if(prev_tx[7:2] == `Sender_Operation_Put) begin
                if(~istable & ~feedback[`Receiver_Feedback_MachineHasItem] & feedback[`Receiver_Feedback_HasItemInHand] == 1'b1) begin
                    tx=prev_tx;
                end
                else begin
                    tx={`Sender_Data_Ignore,`Sender_Channel_Ignore};
                end
            end

            // prevent unreasonable throwing of ingredients
            else if(prev_tx[7:2] == `Sender_Operation_Throw) begin
                if(throwable == 1'b0) begin
                    tx={`Sender_Data_Ignore,`Sender_Channel_Ignore};
                end
                else begin
                    tx=prev_tx;
                end
            end

            // ensure that the operation signal is One Hot encoded
            else if(prev_tx[6] + prev_tx[5] + prev_tx[4] + prev_tx[3] + prev_tx[2] == 1) begin
                tx=prev_tx;
            end
            else begin
                tx={`Sender_Data_Ignore,`Sender_Channel_Ignore};
            end

        end else begin
            tx={`Sender_Data_Ignore,`Sender_Channel_Ignore};
        end
    end else if(prev_tx_channel == `Sender_Channel_TargetMachineChanged) begin
        // prevent illeagal target machine(AB+ACD+ACE)
        if(prev_tx[7] | prev_tx[6] & (prev_tx[5] | prev_tx[4] & (prev_tx[3] | prev_tx[2])) == 1'b1) begin //到时候看看这里的判断要不要改一下
            tx={`Sender_Data_Ignore,`Sender_Channel_Ignore};
        end else begin
            tx=prev_tx;
        end

    end else begin
        tx=prev_tx;
    end
    end

endmodule
