`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/27 23:55:24
// Design Name: 
// Module Name: SwitchesDebounce
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


module SwitchesDebounce(
input [4:0] button,
input [7:0] switches,
input clk,
input rst_n,
output [4:0] fix_button,
output [7:0] fix_switches
    );
    wire switches0,switches1,switches2,switches3,switches4,switches5,switches6,switches7;
    key_debounce s0(
        .clk(clk),
        .rst_n(rst_n),
        .key(switches[0]),
        .key_value(switches0)
    );
    key_debounce s1(
        .clk(clk),
        .rst_n(rst_n),
        .key(switches[1]),
        .key_value(switches1)
    );
    key_debounce s2(
        .clk(clk),
        .rst_n(rst_n),
        .key(switches[2]),
        .key_value(switches2)
    );
    key_debounce s3(
        .clk(clk),
        .rst_n(rst_n),
        .key(switches[3]),
        .key_value(switches3)
    );
    key_debounce s4(
        .clk(clk),
        .rst_n(rst_n),
        .key(switches[4]),
        .key_value(switches4)
    );
    key_debounce s5(
        .clk(clk),
        .rst_n(rst_n),
        .key(switches[5]),
        .key_value(switches5)
    );
    key_debounce s6(
        .clk(clk),
        .rst_n(rst_n),
        .key(switches[6]),
        .key_value(switches6)
    );
    key_debounce s7(
        .clk(clk),
        .rst_n(rst_n),
        .key(switches[7]),
        .key_value(switches7)
    );
    assign fix_button=button;
    assign fix_switches={switches7,switches6,switches5,switches4,switches3,switches2,switches1,switches0};
endmodule
