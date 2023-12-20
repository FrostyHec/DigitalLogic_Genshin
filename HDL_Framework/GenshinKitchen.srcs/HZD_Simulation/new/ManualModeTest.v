`timescale 1ns / 1ps

module ManualModeTest(
    
);
    reg clk=1'b0;
    reg [4:0] button;
    reg [7:0] switches;
    reg [7:0] dataOut_bits;
    reg dataOut_valid,dataIn_ready=1'b0;
    wire [7:0] dataIn_bits;

    wire [5:0] next_state,current_state;
    wire manual_new_state,new_state_activate;
    initial begin
        forever begin
            #5 clk=~clk;
        end
    end
    DesignedTop dt(
        .clk(clk),
        .button(button),
        .switches(switches),
        .dataOut_bits(dataOut_bits),
        .dataOut_valid(dataOut_valid),
        .dataIn_ready(dataIn_ready),
        .dataIn_bits(dataIn_bits),
        .next_state(next_state),.current_state(current_state),
        .manual_new_state_activate(manual_new_state),
        .new_state_activate(new_state_activate)
    );
    initial begin
        button=5'b00_000;
        switches=8'b0000_0000;
        dataOut_bits=8'b0000_0000;
        dataOut_valid=1'b1;
        repeat(2) begin
            switches[7]=1'b1;#20;
            switches[7]=1'b0;#20;//应该输出信号
        end
        #20 button=5'b000_01;
        #20 button=5'b000_10;
        repeat(2) begin
            switches[7]=1'b1;#20;
            switches[7]=1'b0;#20;//应该输出信号
        end
        #20 switches[0]=1'b1;
        #20 switches[0]=1'b0;
        #20;
        $finish;
    end
endmodule