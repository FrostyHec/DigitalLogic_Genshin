`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/03 00:27:22
// Design Name: 
// Module Name: SimForReg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SimForReg(

    );
    wire  [5:0] state;
    reg [5:0] next_state;
    reg activation;
    TargetRegister t(.next_state(next_state),.next_state_activation(activation),
    .state(state));
    initial begin
        activation=1'b0;
        next_state=6'b000_000;
        repeat(10) begin
            activation=~activation;
            next_state=next_state+1;
            #10;
            end
            $finish;
    end
endmodule
