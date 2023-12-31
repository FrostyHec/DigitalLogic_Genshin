`include "../ConstValue.vh"
`timescale 1ns / 1ps
module ScriptTop(
    input en,//开启
    input rst_n,
    //交互输入
    input [7:0] in,
    output [7:0] led,led2,
    //时钟
    input origin_clk,clk,

    //反馈信号
    input [7:0] feedback,
    input feedback_valid,
    

    //脚本
    output reg [7:0] pc=`Script_initialPC,
    input [15:0] script,

    //当前所处位置
    input [5:0] target_machine,
    output reg [5:0] new_target_machine,
    output reg new_target_machine_activate=`unactivate_signal,

    //输出信号到厨房
    output [7:0] f_send_out,


    //测试输出
    output reg illegal_code=`unactivate_signal,
    output [2:0] op_code
);
//绑定input按钮
wire step_by_step,step_in;
assign step_by_step=in[`In_Switch_StepMode];
assign step_in=in[`In_Switch_Step];

assign op_code=script[2:0];
wire [1:0] func=script[4:3];
wire [2:0] i_sign=script[7:5];
wire [7:0] i_num=script[15:8];


reg [7:0] send_out={`Sender_Data_Ignore,`Sender_Channel_Ignore};
assign f_send_out=send_out;
reg is_fixed=`unactivate_signal;

//模块调用
//解析GameStart/End语句
wire [7:0] game_state_tx;
wire game_state_activation;
wire game_state_has_next;
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
//解析Operation语句（GPIT）
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

);
//解析Jump语句
wire [7:0] jump_next_line;
wire jump_activation;
JumpScriptHandler js(
    .clk(clk),
    .en(1'b1),
    .func(func),
    .signal(i_sign),
    .i_num(i_num),
    .feedback(feedback),
    .feedback_valid(feedback_valid),
    .next_line(jump_next_line),
    .activation(jump_activation)
);
//解析Wait语句
wire wait_isFinished;
reg wait_enable=`unactivate_signal;
WaitScriptHandler ws(
    .clk(origin_clk),
    .en(wait_enable),
    .func(func),
    .signal(i_sign),
    .i_num(i_num),
    .feedback(feedback),
    .feedback_valid(feedback_valid),
    .isFinished(wait_isFinished)

);

//脚本轮询执行模块
parameter cnt=1;//test
parameter init_counter=0;
parameter counter_envoke=1;
parameter load_script =2'b11;
parameter analyze_script =2'b10;
parameter next_line_pc =2;

reg [15:0] counter=init_counter;
reg has_next=`unactivate_signal;
reg new_script=`unactivate_signal;
reg is_pressed=`unactivate_signal;

//状态机，分为三种状态，加载下一条脚本，分析当前脚本，发送数据，依据counter，脚本分析结果等进行判断
wire [1:0] state ={(counter==init_counter)&&feedback_valid,~has_next&&~is_fixed&&~new_script};
always @(posedge clk) begin
if(~rst_n) begin
    //reset至初始值
    pc<=`Script_initialPC;
    counter<=init_counter;
    has_next<=`unactivate_signal;
    new_script<=`unactivate_signal;
    is_pressed<=`unactivate_signal;
    new_target_machine<=`Targeting_Initial;
end else begin
    if(en) begin//需要enable
    //更新targetMachine
    if(new_state_activate) begin
        new_target_machine<=operation_new_state;
        new_target_machine_activate<=`activate_signal;
    end else begin
        new_target_machine<=target_machine;
        new_target_machine_activate<=`unactivate_signal;
    end
    case (state)
        load_script:begin 
        if(step_by_step) begin
            //单步调试模式下，如果当前是按着的，且之前没有按过（改过），就移动到下一行，标记本次按下已经执行（is_pressed)
            if(step_in) begin
                if(~is_pressed) begin
                    pc<=pc+next_line_pc;
                    new_script<=`activate_signal; 
                    is_pressed<=`activate_signal;
                end
             end else begin//置零
                 is_pressed<=`unactivate_signal;
             end
        end else begin
            //自动脚本模式：在加载脚本状态时直接加载脚本
            pc<=pc+next_line_pc;
            new_script<=`activate_signal;  
        end
        end 
        analyze_script:begin
        //解析脚本
        case (op_code)
            `Script_GameState: begin
                if(game_state_activation) begin
                    send_out<=game_state_tx;
                    has_next<=game_state_has_next;
                    new_script<=`unactivate_signal;
                    counter<=counter_envoke;//开始计数
                end else begin
                    illegal_code<=`activate_signal;
                end
            end 
            `Script_Operate: begin
                if(operation_activation) begin
                    send_out<=operation_tx;
                    has_next<=operation_has_next;
                    new_script<=`unactivate_signal;
                    counter<=counter_envoke;//开始计数
                end else begin
                    illegal_code<=`activate_signal;
                end
            end
            `Script_Jump: begin
                if(jump_activation) begin
                    pc<=pc+ next_line_pc*jump_next_line - next_line_pc;
                    has_next<=`unactivate_signal;
                    new_script<=`unactivate_signal;
                    counter<=init_counter;//不用发送
                end else begin
                    illegal_code<=`activate_signal;
                end
            end
            `Script_Wait: begin
                if(wait_isFinished) begin
                    wait_enable<=`unactivate_signal;
                end else begin
                    wait_enable<=`activate_signal;
                end
                has_next<=~wait_isFinished;
                new_script<=`unactivate_signal;
                counter<=init_counter;//不用发送
            end
            default: begin
                //不应该出现的状态，用于测试
                illegal_code<=`activate_signal;
            end
        endcase
        end
        default: begin
            if(counter>cnt) begin
                //信号发送完毕
                counter<=init_counter;
            end else if(counter>init_counter) begin
                //如果计数器已经开启（>0）,就一直++
                counter<=counter+1;
            end
        end
    endcase
    end
end
end



endmodule