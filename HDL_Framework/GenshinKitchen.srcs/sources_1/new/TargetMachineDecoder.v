`include "ConstValue.vh"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: ManualFliter
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

//用于判断target machine 的种类的
//其中，throwable 为1’b1 是桌子和垃圾桶， istable 为 1’b1 是桌子
module TargetMachineThrowable(
input [5:0] target_machine,
output reg throwable,
output istable
    );
    reg trash_bin;
    
    always @*
    begin
        if(target_machine == `Game_Trash_bin) begin
            trash_bin = 1'b1;
        end
        else begin
            trash_bin = 1'b0;
        end
    end

    assign istable = throwable & ~trash_bin;

    always @*
    begin
        case(target_machine)
            `Game_Table_1, `Game_Table_2, `Game_Table_3, `Game_Table_4, `Game_Trash_bin: throwable = 1'b1; //throwable
            default: throwable = 1'b0; //unthrowable
        endcase
    end
endmodule