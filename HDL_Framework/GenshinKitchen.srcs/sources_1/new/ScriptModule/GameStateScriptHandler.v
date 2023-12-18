`include "../ConstValue.vh"
`timescale 1ns / 1ps
module GameStateScriptHandler(
input clk,en,
input [1:0] func,
input [2:0] signal,
input [7:0] i_num,
input [5:0] targetState,
output reg [7:0] tx,
output reg activation,has_next
);
always @* begin
    if (en && signal == 3'b100) begin
        activation <= 1'b1;
        has_next <= 1'b0;
        tx <= {4'b0000, func, 2'b01};
    end else begin
        tx <= 8'b0000_0010;
        activation <= 1'b0;
        has_next <= 1'b0;
    end 
end
endmodule