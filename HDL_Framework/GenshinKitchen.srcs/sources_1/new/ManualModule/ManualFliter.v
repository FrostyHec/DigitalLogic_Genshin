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


//用于检测是否合法，可以检测：
//1.操作合法性
//2.编码合法性（one-hot）
//3.target machine合法性
module ManualFliter(
input [7:0] prev_tx,feedback,
input feedback_valid,
input [5:0] target_machine,
output reg [7:0] tx
    );
    parameter get = 2;
    parameter put = 3;
    parameter interact = 4;
    parameter move = 5;
    parameter throw = 6;

    wire[5:0] operation = prev_tx[7:2];
    wire[1:0] feedback_channel = feedback[1:0];
    wire[1:0] prev_tx_channel = prev_tx[1:0];
    wire throwable,istable;
    wire[5:0] target_machine_prex = prev_tx[7:2];

    TargetMachineThrowable target_machine_throwable(
        .target_machine(target_machine),
        .throwable(throwable),
        .istable(istable)
    );
//Signal Filter
    always @*
    begin
    if(prev_tx_channel == `Sender_Channel_Operate) begin
        if(prev_tx=={`Sender_Data_Ignore,`Sender_Channel_Operate}) begin
            tx={`Sender_Data_Ignore,`Sender_Channel_Operate};
        end
        else if(feedback_channel == `Receiver_Channel_FeedBack) begin
            
            //prevent illegal interaction while moving
            if(~feedback[`Receiver_Feedback_InfrontTargetMachine] && ~prev_tx[throw] && ~prev_tx[move]) begin
                tx={`Sender_Data_Ignore,`Sender_Channel_Ignore};
            end 

            //prevent unreasonable access to item interactions
            // get
            else if(operation == `Sender_Operation_Get) begin
                if(feedback[`Receiver_Feedback_MachineHasItem] && ~feedback[`Receiver_Feedback_HasItemInHand]) begin
                    tx=prev_tx;
                end
                else begin
                    tx={`Sender_Data_Ignore,`Sender_Channel_Ignore};
                end
            end 
            // put
            else if(operation == `Sender_Operation_Put) begin
                if (//~istable && ~feedback[`Receiver_Feedback_MachineHasItem] && 
                feedback[`Receiver_Feedback_HasItemInHand]) begin
                    tx=prev_tx;
                end
                else begin
                    tx={`Sender_Data_Ignore,`Sender_Channel_Ignore};
                end
            end

            // prevent unreasonable throwing of ingredients
            else if(operation == `Sender_Operation_Throw) begin
                if(~throwable) begin
                    tx={`Sender_Data_Ignore,`Sender_Channel_Ignore};
                end
                else begin
                    tx=prev_tx;
                end
            end

            // ensure that the operation signal is One Hot encoded
            else if((prev_tx[get] + prev_tx[put] + prev_tx[interact] + prev_tx[move] + prev_tx[throw]) != 1) begin
                tx={`Sender_Data_Ignore,`Sender_Channel_Ignore};
            end
            else begin
                tx=prev_tx;
            end

        end else begin
            tx=prev_tx;
        end
    end else if(prev_tx_channel == `Sender_Channel_TargetMachineChanged) begin
        // prevent illeagal target machine
        if(target_machine_prex > `max_target_number) begin 
            tx={`Sender_Data_Ignore,`Sender_Channel_Ignore};
        end else begin
            tx=prev_tx;
        end

    end else begin
        tx=prev_tx;
    end
    end

endmodule