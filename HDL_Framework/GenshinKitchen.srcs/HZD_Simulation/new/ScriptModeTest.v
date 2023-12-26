`timescale 1ns / 1ps

module  ScriptModeTest(
    
);
    reg clk=1'b0;
    reg [4:0] button;
    reg [7:0] switches;
    reg [7:0] dataOut_bits;
    reg dataOut_valid,dataIn_ready=1'b0;
    wire [7:0] dataIn_bits;

    wire [5:0] next_state,current_state;
    wire sc_new_state,new_state_activate;
    wire illegal_code_in_script;
    wire [2:0] op_code;
    reg script_mode;
    wire [7:0] pc;
    reg [15:0] script;
    initial begin
        forever begin
            #5 clk=~clk;
        end
    end
    //test
    DesignedTop dt(
        .clk(clk),
        .button(button),
        .switches(switches),
        .dataOut_bits(dataOut_bits),
        .dataOut_valid(dataOut_valid),
        .dataIn_ready(dataIn_ready),
        .dataIn_bits(dataIn_bits),

        .current_state(current_state),
        .sc_new_state_activate(sc_new_state),

        .pc(pc),
        .script(script),
        .script_mode(script_mode),
        //test
        .illegal_code_in_script(illegal_code_in_script)
        ,.op_code(op_code)
    );
    initial begin
        button=5'b00_000;
        switches=8'b0001_0000;
        dataOut_bits=8'b0_000000_1;
        dataOut_valid=1'b1;
        script_mode=1'b1;
        repeat(3) begin
            switches[7]=1'b1;#20;
            switches[7]=1'b0;#20;//应该输出信号
        end
        //step by step
        // script_mode=1'b0;
        // #50;
        // switches=8'b0011_0000;
        // script=16'b0000_0000_000_01_100;
        // #100;
        // switches=8'b0001_0000;
        // #100;
        // switches=8'b0011_0000;
        // script=16'b0000_0000_000_10_100;
        // #50;
        // switches=8'b0001_0000;

        // #100;
        // switches=8'b0011_0000;
        // script=16'b0000_0000_000_01_100;

        // switches=8'b1000_0000;#200;
        // switches=8'b0000_0000;#100;
        // switches=8'b1000_0000;#100;

        // //operate
        //  script_mode=1'b0;
        // #50;
        // dataOut_bits=8'b1_00_1100_0;
        // switches=8'b0011_0000;
        // script=16'b0001_0000_000_00_001;
        // #200;
        // switches=8'b0001_0000;
        // #100;
        // dataOut_bits=8'b1_00_1101_0;

        // switches=8'b0011_0000;
        // switches=8'b0000_0000;
        // script_mode=1'b0;
        // dataOut_bits=8'b1_00_1100_0;
        // script=16'b0001_0000_000_00_001;

        //script_mode=1'b0;
        //switches=8'b0000_0000;
        //dataOut_bits=8'b1_00_1101_0;
        //script=16'b0000_0000_000_01_011;
        // #100;
        // dataOut_valid=1'b0;
        // dataOut_bits=8'b1_00_1101_0;
        // #100;
        // dataOut_valid=1'b1;
        //script=16'b0000_1000_000_00_001;


        // #50
        // script_mode=1'b0;
        // switches=8'b0011_0000;
        // script=16'b0001_0000_000_00_001;

        //operate
        script_mode=1'b0;
        #50;
        dataOut_bits=8'b00_1100_01;
        switches=8'b0011_0000;
        script=16'b0001_0000_000_00_001;
        #200;
        switches=8'b0001_0000;
        #100;
        dataOut_bits=8'b00_1101_01;
        #8000
        $finish;
    end
endmodule