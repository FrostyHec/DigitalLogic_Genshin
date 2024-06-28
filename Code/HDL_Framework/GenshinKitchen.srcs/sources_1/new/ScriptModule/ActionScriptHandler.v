`include "../ConstValue.vh"
`timescale 1ns / 1ps
//这个模块用于解析Action脚本指令
module ActionScriptHandler(
input clk,en,
//脚本信息
input [1:0] func,
input [2:0] signal,
input [7:0] i_num,
//当前机器信息
input [5:0] target_machine,
//反馈信息
input [7:0] feedback,
input feedback_valid,
//输出操作信号与当前脚本是否执行完成
output reg [7:0] tx,
output reg activation, has_next,
//是否改变当前机器位置
output reg [5:0] new_state,
output reg new_state_activate=`unactivate_signal
);
//目标机器
wire [5:0] will_machine=i_num[5:0];
always @* begin
    new_state_activate=`unactivate_signal;
    //没enable或feedback无效，该模块不激活
    if (en&feedback_valid) begin
        //当前机器为目标机器，是则GPIMT，否则target
        if (target_machine==will_machine) begin
            if(feedback[`Receiver_Feedback_InfrontTargetMachine]) begin
                activation = `activate_signal;
                has_next = `unactivate_signal;
                case (func)//GPIT
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
                    end//test_fine
                    default: begin
                        activation=`unactivate_signal;
                    end
                endcase
            end else begin
                if(func==`Script_Operate_Throw) begin//Throw不需要先move
                    activation = `activate_signal;
                    has_next = `unactivate_signal;
                    tx = {`Sender_Operation_Throw,`Sender_Channel_Operate};
                end else begin//Move
                    activation = `activate_signal;
                    has_next = `activate_signal;
                    tx = {`Sender_Operation_Move,`Sender_Channel_Operate};  
                end
            end
        end else begin
                activation = `activate_signal;
                has_next = `activate_signal;
                tx = {will_machine, `Sender_Channel_TargetMachineChanged};
                new_state=will_machine;
                new_state_activate=`activate_signal;
        end
    end else begin
        activation=`unactivate_signal;
    end
end
endmodule