`include "../ConstValue.vh"
`timescale 1ns / 1ps
module ActionScriptHandler(
input clk,en,
input [1:0] func,
input [2:0] signal,
input [7:0] i_num,
input [5:0] target_machine,
input [7:0] feedback,
input feedback_valid,
output reg [7:0] tx,
output reg activation, has_next,
output reg [5:0] new_state,
output reg new_state_activate=1'b0
);
wire [5:0] will_machine=i_num[5:0];
always @* begin
    new_state_activate=1'b0;
    if (en&feedback_valid) begin//
        if (target_machine==will_machine) begin
            if(feedback[`Receiver_Feedback_InfrontTargetMachine]) begin
                activation = 1'b1;
                has_next = 1'b0;
                case (func)
                    `Script_Operate_Get: begin
                        tx = {`Sender_Operation_Get,`Sender_Channel_Operate};
                    end
                    `Script_Operate_Put: begin
                        tx = {`Sender_Operation_Put,`Sender_Channel_Operate};
                    end
                    `Script_Operate_Interact: begin
                        tx = {`Sender_Operation_Interact,`Sender_Channel_Operate};
                    end
                    `Script_Operate_Throw: begin
                        tx = {`Sender_Operation_Throw,`Sender_Channel_Operate};
                    end
                    default: begin
                        activation=1'b0;
                    end
                endcase 
            end else begin
                activation = 1'b1;
                has_next = 1'b1;
                tx = {`Sender_Operation_Move,`Sender_Channel_Operate}; 
            end
        end else begin
            activation = 1'b1;
            has_next = 1'b1;
            tx = {will_machine, `Sender_Channel_TargetMachineChanged};
            new_state=will_machine;
            new_state_activate=1'b1;
        end
    end else begin
        activation=1'b0;
    end
end
endmodule