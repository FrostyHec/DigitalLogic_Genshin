`include "../ConstValue.vh"
`timescale 1ns / 1ps
module ActionScriptHandler(
input clk,en,
input [1:0] func,
input [2:0] signal,
input [7:0] i_num,
input [5:0] targetState,
output reg [7:0] tx,
output reg activation, has_next
);
always @* begin
    if (en && signal == 3'b001) begin
        if (targetState == i_num[5:0]) begin
            activation <= 1'b1;
            has_next <= 1'b0;
            if (func == 2'b00) 
              tx <= 8'b0000_0110;
            else if (func == 2'b01)
                tx <= 8'b0000_1010;
            else if (func == 2'b10)
                tx <= 8'b0001_0010;
            else tx <= 8'b0100_0010;
        end else begin
            activation <= 1'b1;
            has_next <= 1'b1;
            tx <= {i_num[5:0], 2'b11};
        end
    end else begin
        tx <= 8'b0000_0010;
        activation <= 1'b0;
    end 
end
endmodule