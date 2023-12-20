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
    input [7:0] pc,
    input [15:0] script,    
    
    output reg [7:0] dataIn_bits,
    input dataIn_ready,
    
    //fortest
    output [5:0] next_state,current_state,
    output  manual_new_state_activate,
    output reg new_state_activate=1'b0
);
    wire [7:0] manual_tx,module_rx,script_tx;
    //wire  manual_new_state;
    //reg  [7:0] next_in,
    reg [7:0] next_out;
    //wire [5:0] next_state,current_state;
    assign module_rx=next_out;

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
      .new_state(next_state),
      .new_state_activation(manual_new_state_activate)
    );
    //assign current_state=6'b000_001;
    TargetRegister trg(
      .next_state(next_state),
      .next_state_activation(new_state_activate),
      .clk(clk),
      .rst_n(1'b1),//maybe use signal from GSE
      .state(current_state)
    );

    //assign io_dataIn_bits=switches;
    always @(posedge clk) begin//output
      if(script_mode) begin
        //script module. 注意wait模块传入一个真实时钟
      end else begin
        //manual module.
        dataIn_bits<=manual_tx;
      end
    end
    //assign led2=next_out;
    //assign led[7]=dataOut_valid;
    always @(dataOut_valid) begin//input
      if(dataOut_valid) begin
        next_out=dataOut_bits;//可能需要改（校验数据合法性）
      end
    end

    always @(next_state) begin
      if(manual_new_state_activate) begin
        new_state_activate=1'b1;
      end else begin
        new_state_activate=1'b0;
      end
    end
endmodule