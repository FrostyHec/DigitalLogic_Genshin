
`timescale 1ns / 1ps
module WaitSim(

);
wire wait_isFinished;
reg wait_enable=1'b0;
reg clk=1'b0;
reg [1:0] func;
reg [2:0] i_sign;
reg [7:0] i_num;
reg [7:0] feedback;
reg feedback_valid;
WaitScriptHandler ws(
    .clk(clk),
    .en(wait_enable),
    .func(func),
    .signal(signal),
    .i_num(i_num),
    .feedback(feedback),
    .feedback_valid(feedback_valid),
    .isFinished(wait_isFinished)
);
    initial begin
        forever begin
            #5 clk=~clk;
        end
    end
initial begin
    func=2'b01;
    i_sign=3'b000;
    i_num=8'b000_00000;
    feedback=8'b00_1100_01;//信号不合法
    feedback_valid=1'b0;
    #50
    feedback=8'b00_1100_01;//不在机子前面
    feedback_valid=1'b1;
    #50
    feedback_valid=1'b0;
    #50
    feedback=8'b00_1101_01;//在机子前面
    #50
    feedback_valid=1'b1;
    #100;
    $finish;
end
endmodule