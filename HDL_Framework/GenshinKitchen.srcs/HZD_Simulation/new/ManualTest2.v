`timescale 1ns / 1ps

module ManualTest2(
    
);
    reg clk=1'b0;
    reg [4:0] button;
    reg [7:0] switches;
    reg [7:0] rx;
    wire [7:0] manual_out;

    reg [5:0] current_state;
    wire [5:0] next_state;
    wire manual_new_state;
    initial begin
        forever begin
            #5 clk=~clk;
        end
    end
    ManualTop mt(
      .switches(switches),
      .button(button),
      .clk(clk),
      .rx(rx),
      .available_for_next(1'b1),
      .state(current_state),
      .tx(manual_out),
      .new_state(next_state),
      .new_state_activation(manual_new_state)
    );
    initial begin
        button=5'b00_000;
        switches=8'b0000_0000;
        rx=8'b0000_0000;
        current_state=8'b0000_0000;
        #10;
        while (30) begin
            switches[7]=1'b1;#100;
            switches[7]=1'b0;#100;//应该输出信号
            current_state=next_state;
        end
        $finish;
    end

endmodule