`include "../ConstValue.vh"
`timescale 1ns / 1ps

module DesignedTop(
    input origin_clk,
    input clk,
    input rst_n,
    input [4:0] button,
    input [7:0] switches,
    output [7:0] led,
    output [7:0] led2,

    input [7:0] dataOut_bits,
    input dataOut_valid,
    
    input script_mode,
    output [7:0] pc,
    input [15:0] script,    
    
    output reg [7:0] dataIn_bits,
    input dataIn_ready
);
    wire [5:0] current_state;
    wire [7:0] manual_tx,module_rx;
    reg [7:0] next_out;
    reg new_state_activate=`unactivate_signal;
    assign module_rx=next_out;

    //手动模式例化
    reg dataIn_ready_rg=`activate_signal;
    wire [5:0] mt_next_state;
    wire manual_new_state_activate;
    reg [5:0] next_state;
    ManualTop mt(
      .switches(switches),
      .button(button),
      .clk(clk),
      .rst_n(rst_n),
      .rx(next_out),
      .available_for_next(1'b1),
      .state(current_state),
      .tx(manual_tx),
      .led(led),
      .led2(led2),
      .new_state(mt_next_state),
      .new_state_activation(manual_new_state_activate)
    );
    //脚本模式例化
    wire [5:0] script_new_state;
    wire sc_new_state_activate;
    wire [7:0] script_tx;

    reg script_en=`unactivate_signal;
    ScriptTop sp(
      .en(script_en),
      .rst_n(rst_n),
      .in(switches),
      .led(led),
      .led2(led2),

      .origin_clk(origin_clk),
      .clk(clk),

      .feedback(dataOut_bits),
      .feedback_valid(dataOut_valid),

      .pc(pc),
      .script(script),

      .target_machine(current_state),
      .new_target_machine(script_new_state),
      .new_target_machine_activate(sc_new_state_activate),

      .f_send_out(script_tx)

    );

    //判断当前是否为脚本模式
    wire current_script,switch_init;
    SwitchStateEncoder sse(
      .feedback(module_rx),
      .rst(~switches[`In_Switch_GameStart]),
      .script_mode(script_mode),
      .current_script(current_script),
      .switch_init(switch_init)
    );

    //存储当前state的寄存器
    TargetRegister trg(
      .next_state(next_state),
      .next_state_activation(new_state_activate),
      .clk(clk),
      .rst_n(rst_n),
      .state(current_state)
    );

    //时钟时块轮询，判断当前模式并传出对应的信号
    always @(posedge clk) begin
      if(current_script) begin
        //script mode
        script_en<=`activate_signal;
        dataIn_bits<=script_tx;
      end else begin
        //manual mode
        script_en<=`unactivate_signal;
        dataIn_bits<=manual_tx;
      end
    end
    
    

    //传入target machine
    always @(mt_next_state,script_new_state) begin
      if(current_script) begin
        next_state=script_new_state;
      end else begin
        next_state=mt_next_state;
      end
    end
    always @(next_state) begin
      if(manual_new_state_activate||sc_new_state_activate) begin
        new_state_activate=`activate_signal;
      end else begin
        new_state_activate=`unactivate_signal;
      end
    end
    always @(*) begin
      if(dataOut_valid) begin
        next_out={dataOut_bits[6:0],dataOut_bits[7]};
      end
    end

    //外部状态显示
    assign led[`Out_LED_Feedback]=next_out[`Receiver_Feedback_part];
    assign led[`Out_LED_CurrentScript]=current_script;
endmodule