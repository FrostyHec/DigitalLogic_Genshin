`timescale 1ns / 1ps
module SSE_Test(
    
);
reg [7:0] feedback;
reg script_mode;
wire current_script;
wire switch_init;
SwitchStateEncoder uut(
    .feedback(feedback),
    .rst(1'b1),
    .script_mode(script_mode),
    .current_script(current_script),
    .switch_init(switch_init)
);
initial begin
    feedback=8'b0000_0000;
    script_mode=1'b0;
    #10
    feedback=8'b0000_0010;
    script_mode=1'b1;
    #100
    script_mode=1'b0;
    #100;
    $finish;
end
endmodule