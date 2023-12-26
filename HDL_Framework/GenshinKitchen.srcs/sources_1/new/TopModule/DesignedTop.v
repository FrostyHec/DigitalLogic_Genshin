`include "../ConstValue.vh"
`timescale 1ns / 1ps

module DesignedTop(
    input origin_clk,
    input clk,
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
    input dataIn_ready,//unused
    
    //fortest
    output [5:0] current_state,
    output  manual_new_state_activate,sc_new_state_activate,
    output reg new_state_activate=1'b0,
    output illegal_code_in_script

    //test
    ,output [2:0] op_code

);

    wire [7:0] manual_tx,module_rx;
    //wire  manual_new_state;
    //reg  [7:0] next_in,
    reg [7:0] next_out;
    //wire [5:0] next_state,current_state;
    assign module_rx=next_out;
    reg dataIn_ready_rg=1'b1;
    wire [5:0] mt_next_state;
    reg [5:0] next_state;
    ManualTop mt(
      .switches(switches),
      .button(button),
      .clk(clk),
      .rx(next_out),
      .available_for_next(1'b1),
      .state(current_state),
      .tx(manual_tx),
      .led(led),
      .led2(led2),
      .new_state(mt_next_state),
      .new_state_activation(manual_new_state_activate)
    );

    wire [5:0] script_new_state;
    wire script_new_state_activate;
    wire [7:0] script_tx;
    wire illegal_code;
    assign illegal_code_in_script=illegal_code;

    reg script_en=1'b0;
    ScriptTop sp(
      .en(script_en),
      .in(switches),
      .led(led),

      .origin_clk(origin_clk),
      .clk(clk),

      .feedback(dataOut_bits),
      .feedback_valid(dataOut_valid),

      .pc(pc),
      .script(script),

      .target_machine(current_state),
      .new_target_machine(script_new_state),
      .new_target_machine_activate(sc_new_state_activate),

      .send_out(script_tx),
      .illegal_code(illegal_code)

      //test
      ,.op_code(op_code)
    );

    wire current_script,switch_init;
    //assign led[7]=current_script;
    SwitchStateEncoder sse(
      .feedback(module_rx),
      .rst(~switches[`In_Switch_GameStart]),
      .script_mode(script_mode),
      .current_script(current_script),
      .switch_init(switch_init)
    );


    TargetRegister trg(
      .next_state(next_state),
      .next_state_activation(new_state_activate),
      .clk(clk),
      .rst_n(1'b1),//maybe use signal from GSE
      .state(current_state)
    );

    //assign led[7]=dataOut_valid;
    //assign io_dataIn_bits=switches;
    always @(posedge clk) begin//output
      if(current_script) begin
        //script module. 注意wait模块传入�??个真实时�??
        script_en<=1'b1;
        dataIn_bits<=script_tx;
      end else begin
        //manual module.
        script_en<=1'b0;
        dataIn_bits<=manual_tx;
      end
    end
    
    

    //传入ST: 1. next_out作为dataOut_bits
    //ST�??要：enable判断�??启（外部切换
    //传入状�??
    always @(mt_next_state,script_new_state) begin
      if(current_script) begin
        next_state=script_new_state;
      end else begin
        next_state=mt_next_state;
      end
    end

    always @(*) begin
      if(dataOut_valid) begin
        next_out={dataOut_bits[6:0],dataOut_bits[7]};//可能�??要改（校验数据合法�?�）,there's bugs so using this assgin
      end
    end
    always @(next_state) begin
      if(manual_new_state_activate||sc_new_state_activate) begin
        new_state_activate=1'b1;
      end else begin
        new_state_activate=1'b0;
      end
    end

    //led
    assign led2=dataOut_valid;
    //assign led[1]=dataOut_valid;
    //assign led[0]=illegal_code;
    //assign led[6:0]=dataIn_bits[6:0];
    //assign led=dataIn_bits;
    // assign led[0]=current_script;
    // assign led[1]=switch_init;
endmodule