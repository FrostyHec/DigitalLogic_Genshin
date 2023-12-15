`include "../ConstValue.vh"
`timescale 1ns / 1ps
module JumpScriptHandler(
input clk,en,
input [1:0] func,
input [2:0] signal,
input [7:0] i_num,
input [7:0] feedback,//反馈
output reg [7:0] next_line//输出下一行是哪一行就行（比如1或6）
);

    wire [3:0] state = feedback[5:2];

    always @*
    if(en & ~func[1]) begin
        if(state[signal] == func[0]) begin
            next_line = i_num;
        end else begin
            next_line = 8'b0000_0001;
        end
    end else begin
        next_line = 8'b0000_0001;
    end

endmodule