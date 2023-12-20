`timescale 1ns / 1ps

module ScriptTop(
input [7:0] switches,
input [4:0] button,
input clk,
input [7:0] rx,

input available_for_next,
input [5:0] state,

output [7:0] tx,
output [7:0] led,led2,
output reg[5:0] new_state,
output reg new_state_activation
);

endmodule