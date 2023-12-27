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

module ScriptFixer(
input [7:0] prev_tx, feedback,
input [5:0] target_machine,
input dataOut_valid,
output reg [7:0] tx,
output reg is_fixed,
output reg [7:0] led=8'b0000_0000
    );
    parameter first = 2'b00;
    parameter second = 2'b01;
    parameter third = 2'b10;
    reg [1:0] fixing = first;
    wire channel=prev_tx[1:0];
    wire data=prev_tx[7:2];
    always @* begin
        if (prev_tx == {`Sender_Operation_Get,`Sender_Channel_Operate} && feedback[`Receiver_Feedback_HasItemInHand]) begin
            led[0]=1'b1;
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
            led[1]=1'b1;
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
            led[2]=1'b1;
            if (!feedback[`Receiver_Feedback_IsProcessing]) begin
                tx = {`Sender_Operation_Move, `Sender_Channel_Operate};
                fixing = second;
                is_fixed = 1'b1;
            end else begin
                tx = {`Sender_Operation_Get,`Sender_Channel_Operate};
                fixing = first;
                is_fixed = 1'b0;
            end
        end else begin
            led[3]=1'b1;
            tx=prev_tx;
            is_fixed = 1'b0;
        end
    end
endmodule


        // if(channel==`Sender_Channel_Operate) begin
        // case (data)
        //     `Sender_Operation_Get:begin
        //     if(dataOut_valid) begin
        //         if(feedback[`Receiver_Feedback_HasItemInHand]) begin
        //             led[0]=1'b1;
        //             case (fixing)
        //                 first: begin
        //                     tx = {`Game_Trash_bin, `Sender_Channel_TargetMachineChanged};
        //                     fixing = second;
        //                     is_fixed = 1'b1;
        //                 end
        //                 second: begin
        //                     tx = {`Sender_Operation_Throw,`Sender_Channel_Operate};
        //                     fixing = third;
        //                     is_fixed = 1'b1;
        //                 end
        //                 third: begin
        //                     tx = {target_machine, `Sender_Channel_TargetMachineChanged};
        //                     fixing = first;
        //                     is_fixed = 1'b0;
        //                 end
        //                 default: begin
        //                     //don't care
        //                     tx = prev_tx;
        //                     fixing=first;
        //                     is_fixed=1'b0;
        //                 end
        //             endcase
        //         end else if (!feedback[`Receiver_Feedback_IsProcessing]) begin
        //             led[1]=1'b1;
        //             tx = {`Sender_Operation_Move, `Sender_Channel_Operate};
        //             fixing = second;
        //             is_fixed = 1'b1;
        //         end else begin
        //             led[2]=1'b1;
        //             tx = {`Sender_Operation_Get,`Sender_Channel_Operate};
        //             fixing = first;
        //             is_fixed = 1'b0;
        //         end
        //     end else begin
        //             //等待dov
        //             tx = prev_tx;
        //             fixing=first;
        //             is_fixed=1'b1;
        //     end
        //     end 
        //     `Sender_Operation_Throw: begin
        //         if(target_machine != `Game_Table_1 &&
        //             target_machine != `Game_Table_2 &&
        //             target_machine != `Game_Table_3 && 
        //             target_machine != `Game_Table_4 && 
        //             target_machine != `Game_Trash_bin) begin 
        //                 case (fixing)
        //                     first:begin
        //                         tx = {`Game_Trash_bin, 2'b11};
        //                         fixing = second;
        //                         is_fixed = 1'b1;
        //                     end 
        //                     second: begin
        //                         tx = {`Sender_Operation_Throw,`Sender_Channel_Operate};
        //                         fixing = third;
        //                         is_fixed = 1'b1;
        //                     end
        //                     third: begin
        //                         tx = {target_machine, 2'b11};
        //                         fixing = first;
        //                         is_fixed = 1'b0;
        //                     end
        //                     default: begin
        //                         //don't care
        //                         tx = prev_tx;
        //                         fixing=first;
        //                         is_fixed=1'b0;
        //                     end
        //                 endcase
        //             end else begin
        //                 tx = prev_tx;
        //                 fixing=first;
        //                 is_fixed=1'b1;
        //             end
        //     end
        //     default: begin
        //         tx = prev_tx;
        //         fixing=first;
        //         is_fixed=1'b1;
        //     end
        // endcase
        // end else begin
        //         tx = prev_tx;
        //         fixing=first;
        //         is_fixed=1'b1;
        // end
