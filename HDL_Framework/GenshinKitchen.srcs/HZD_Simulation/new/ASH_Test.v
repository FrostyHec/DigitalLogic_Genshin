`timescale 1ns / 1ps

module ASH_Test(

);
wire [7:0] operation_tx;
wire operation_activation;
wire operation_has_next;
wire [5:0] operation_new_state;
reg [1:0] func;
reg [2:0] i_sign;
reg [7:0] i_num;
reg [7:0] feedback;
reg feedback_valid;
reg [5:0] state;
ActionScriptHandler as(
    .en(1'b1),
    .func(func),
    .signal(i_sign),
    .i_num(i_num),
    .feedback(feedback),
    .feedback_valid(feedback_valid),
    .tx(operation_tx),
    .activation(operation_activation),
    .has_next(operation_has_next),

    .new_state(operation_new_state),
    .target_machine(state)
);
initial begin
    func=2'b00;
    i_sign=3'b000;
    i_num=8'b000_01000;
    state=5'b000_00;
    feedback=8'b00_1100_01;//信号不合法
    feedback_valid=1'b0;
    #50
    feedback=8'b00_1100_01;//不在机子前面
    feedback_valid=1'b1;
    #50
    state=5'b010_00;
    #50
    feedback=8'b00_1101_01;//在机子前面
    #100;
    $finish;
end
endmodule