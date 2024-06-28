`timescale 1ns / 1ps
module GSSM_sim(
    
);
reg clk=1'b0;
reg [1:0] func;
reg [2:0] signal;
reg [7:0] i_num;
reg [5:0] target_machine;
wire [7:0] tx;
wire activation,has_next;
GameStateScriptHandler handler(
    .clk(clk),
    .en(1'b1),
    .func(func),
    .i_num(i_num),
    .targetState(target_machine),
    .tx(tx),
    .activation(activation),
    .has_next(has_next)
);
    initial begin
        forever begin
            #5 clk=~clk;
        end
    end
initial begin
    #10;
    func=2'b01;
    #100
    func=2'b10;
    #100
    $finish;
end
endmodule