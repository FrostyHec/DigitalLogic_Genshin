`include "../ConstValue.vh"
`timescale 1ns / 1ps
module ScriptTop(
    input en,//开启
    //交互输入
    input [7:0] in,
    output [7:0] led,led2,
    //时钟
    input origin_clk,clk,

    //反馈信号
    input [7:0] feedback,
    input feedback_valid,
    

    //脚本
    output reg [7:0] pc=8'b0000_0000-2,
    input [15:0] script,

    //当前所处位置
    input [5:0] target_machine,
    output reg [5:0] new_target_machine,
    output reg new_target_machine_activate=1'b0,

    //输出信号到厨房
    output [7:0] f_send_out,


    //测试输出
    output reg illegal_code=1'b0
   ,output [2:0] op_code
);
//parameter cnt = 10;
wire step_by_step,step_in;
assign step_by_step=in[`In_Switch_StepMode];
assign step_in=in[`In_Switch_Step];//绑定input

//wire [2:0] op_code=script[2:0];
assign op_code=script[2:0];
wire [1:0] func=script[4:3];
wire [2:0] i_sign=script[7:5];
wire [7:0] i_num=script[15:8];

//模块调用
wire [7:0] game_state_tx;
wire game_state_activation;
wire game_state_has_next;

reg [7:0] send_out={`Sender_Data_Ignore,`Sender_Channel_Ignore};
assign f_send_out=send_out;
reg is_fixed=1'b0;
//wire is_fixed;
// ScriptFixer sf(
//     .prev_tx(send_out),
//     .feedback(feedback),
//     .target_machine(target_machine),
//     .tx(f_send_out),
//     .is_fixed(is_fixed)
// );

GameStateScriptHandler gs(
    .en(1'b1),
    .func(func),
    .signal(i_sign),
    .i_num(i_num),
    .targetState(target_machine),
    .tx(game_state_tx),
    .activation(game_state_activation),
    .has_next(game_state_has_next)
);
wire [7:0] operation_tx;
wire operation_activation;
wire operation_has_next;
wire [5:0] operation_new_state;
wire new_state_activate;
ActionScriptHandler as(
    .en(1'b1),
    .func(func),
    .signal(i_sign),
    .i_num(i_num),
    .target_machine(target_machine),
    .feedback(feedback),
    .feedback_valid(feedback_valid),
    .tx(operation_tx),
    .activation(operation_activation),
    .has_next(operation_has_next),
    .new_state(operation_new_state),
    .new_state_activate(new_state_activate)

    //,.led(led[7])
);
wire [7:0] jump_next_line;
JumpScriptHandler js(
    .clk(clk),
    .en(1'b1),
    .func(func),
    .signal(i_sign),
    .i_num(i_num),
    .feedback(feedback),
    .next_line(jump_next_line)
);
wire wait_isFinished;
reg wait_enable=1'b0;
WaitScriptHandler ws(
    .clk(origin_clk),
    .en(wait_enable),
    .func(func),
    .signal(i_sign),
    .i_num(i_num),
    .feedback(feedback),//2:0,7:3
    .feedback_valid(feedback_valid),
    .isFinished(wait_isFinished)

    //,.led(led2[0])
);


parameter cnt=1;//000;
parameter init_counter=0;
reg [15:0] counter=init_counter;//1'd0;//if ==0 no sending
reg has_next=1'b0;
reg new_script=1'b0;
reg is_pressed=1'b0;
//test
//assign led[7]=step_by_step;
//assign led[6]=step_in;
//assign led[2:0]=op_code;
//assign led[4:3]=func;
//assign led[5]=new_script;
//assign led[0]=has_pressed;
//assign led=script[7:0];
reg on=1'b0;//??????????????????????????????????????????????????????????????????//
//assign led[4]=on;
//assign led[2]=has_next;
wire [1:0] state ={(counter==init_counter)&&feedback_valid,~has_next&&~is_fixed&&~new_script};//feedback是否满足？
//assign led[1:0]=state;
always @(posedge clk) begin
    if(en) begin//需要enable
    //获取下一条信号的条件：如果没有在发送数据，且输入的feedback是合法的（newscript防止反复下一条）
    //且可以切换至下一条数据时，切换至下一条数据
    //需要在后面更新targetMachine，这里就更新一个
    if(new_state_activate) begin
        new_target_machine<=operation_new_state;
        new_target_machine_activate<=1'b1;
    end else begin
        new_target_machine<=target_machine;
        new_target_machine_activate<=1'b0;
    end
    case (state)
        2'b11:begin //单步调试存在问题
        if(step_by_step) begin
            if(step_in) begin//我操初始的时候很可能跳到2而跳过第一行，注意开reg判断一下初始情况
                if(~is_pressed) begin
                    pc<=pc+2;//单点模式下，如果当前是按着的，且之前没有按过（改过），就移动到下一行，标记本次按下已经执行（has_pressed)
                    new_script<=1'b1; 
                    is_pressed<=1'b1;
                end
             end else begin//置零
                 is_pressed<=1'b0;
             end
        end else begin
            pc<=pc+2;
            new_script<=1'b1;  
        end
        end 
        2'b10:begin
        //模块轮询
        case (op_code)
            `Script_GameState: begin
                if(game_state_activation) begin
                    send_out<=game_state_tx;
                    has_next<=game_state_has_next;
                    new_script<=1'b0;
                    counter<=1;//开始计数
                end else begin
                    illegal_code<=1'b1;
                end
            end 
            `Script_Operate: begin
                if(operation_activation) begin
                    send_out<=operation_tx;
                    has_next<=operation_has_next;
                    new_script<=1'b0;
                    counter<=1;//开始计数
                end else begin
                    illegal_code<=1'b1;
                end
            end
            `Script_Jump: begin
                pc<=pc+2*jump_next_line-2;
                has_next<=1'b0;
                new_script<=1'b0;
                counter<=0;//不用计数
            end
            `Script_Wait: begin
                if(wait_isFinished) begin
                    wait_enable<=1'b0;
                end else begin
                    wait_enable<=1'b1;
                end
                has_next<=~wait_isFinished;
                new_script<=1'b0;
                counter<=0;//不用计数
            end
            //其他状态
            default: begin//不应该出现这个状态，亮灯下
                illegal_code<=1'b1;
            end
        endcase
        end
        default: begin
            if(counter>cnt) begin//信号发送完毕
                counter<=init_counter;
                on<=1'b0;
            end else if(counter>init_counter) begin//如果计数器已经开启（>0）,就一直++
                counter<=counter+1;
                on<=1'b1;
            end
        end
    endcase
    // if(counter==0&feedback_valid&~has_next&~new_script) begin//切换至下一条
    //     if(step_by_step) begin
    //         //if(step_in&~is_pressed) begin//我操初始的时候很可能跳到2而跳过第一行，注意开reg判断一下初始情况
    //             pc<=pc+2;//单点模式下，如果当前是按着的，且之前没有按过（改过），就移动到下一行，标记本次按下已经执行（has_pressed)
    //             new_script<=1'b1; 
    //             is_pressed<=1'b1;
    //         // end else begin//置零
    //         //     is_pressed<=1'b0;
    //         // end
    //         // // if(step_in) begin//我操初始的时候很可能跳到2而跳过第一行，注意开reg判断一下初始情况
    //         // //     pc<=pc+2;//单点模式下，如果当前是按着的，且之前没有按过（改过），就移动到下一行，标记本次按下已经执行（has_pressed)
    //         // //     new_script<=1'b1; 
    //         // //     is_pressed<=1'b1;
    //         // // end 
    //     end else 
    //     begin
    //         pc<=pc+2;
    //         new_script<=1'b1;  
    //     end
    // end else if (counter==0&feedback_valid) begin
    //     //分析数据的条件：首先没有在发送数据，且feedback合法
    //     new_script<=1'b0;
    //     //模块轮询
    //     case (op_code)
    //         `Script_GameState: begin
    //             if(game_state_activation) begin
    //                 send_out<=game_state_tx;
    //                 has_next<=game_state_has_next;
    //             end else begin
    //                 illegal_code<=1'b1;
    //             end
    //         end 
    //         //其他状态
    //         default: begin//不应该出现这个状态，亮灯下
    //             illegal_code<=1'b1;
    //         end
    //     endcase

    //     counter<=1;//开始计数
    // end else begin
    //     if(counter>cnt) begin//信号发送完毕
    //         counter<=0;
    //     end else if(counter>0) begin//如果计数器已经开启（>0）,就一直++
    //         counter<=counter+1;
    //     end
    // end
    end
end



endmodule