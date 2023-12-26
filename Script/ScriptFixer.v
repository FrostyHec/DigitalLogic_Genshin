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

module StriptFixer(
input [7:0] prev_tx, feedback,
input [5:0] target_machine,
output reg [7:0] tx,
output is_fixed
    );
    parameter first = 2'b00;
    parameter second = 2'b01;
    parameter third = 2'b10;
    reg [1:0] fixing = first;
    always @* begin
        if (prev_tx == {`Sender_Operation_Get,`Sender_Channel_Operate} && feedback[`Receiver_Feedback_HasItemInHand]) begin
            if (fixing == first) begin
                tx = {`Game_Trash_bin, 2'b11};
                fixing = second;
                is_fixed = 1'b1;
            end else if (fixing == first) begin
                tx = {`Sender_Operation_Throw,`Sender_Channel_Operate};
                fixing = third;
                is_fixed = 1'b1;
            end else if (fixing == second) begin
                tx = {target_machine, 2'b11};
                fixing = first;
                is_fixed = 1'b0;
            end
        end else if (prev_tx == {`Sender_Operation_Throw,`Sender_Channel_Operate} && 
                    target_machine != `Game_Table_1 &&
                    target_machine != `Game_Table_2 &&
                    target_machine != `Game_Table_3 && 
                    target_machine != `Game_Table_4 && 
                    target_machine != `Game_Trash_bin) begin
            if (fixing == first) begin
                tx = {`Game_Trash_bin, 2'b11};
                fixing = second;
                is_fixed = 1'b1;
            end else if (fixing == first) begin
                tx = {`Sender_Operation_Throw,`Sender_Channel_Operate};
                fixing = third;
                is_fixed = 1'b1;
            end else if (fixing == second) begin
                tx = {target_machine, 2'b11};
                fixing = first;
                is_fixed = 1'b0;
            end
        end else if (prev_tx == {`Sender_Operation_Get,`Sender_Channel_Operate}) begin
            if (!feedback[`Receiver_Feedback_IsProcessing]) begin
                tx = {`Sender_Operation_Move, `Sender_Channel_Operate};
                fixing = second;
                is_fixed = 1'b1;
            end else begin
                tx = {`Sender_Operation_Get,`Sender_Channel_Operate};
                fixing = first;
                is_fixed = 1'b0;
            end
        end else 
            is_fixed = 1'b0;
    end
endmodule
