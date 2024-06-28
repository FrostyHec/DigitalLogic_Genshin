`include "../ConstValue.vh"
//偶数时钟分频计数器
module DelayClock(
    input clk,
    output reg out=1'b0
);
//参数
parameter init=0;
parameter div=1;

//计数环节
reg[31:0] counter=init;
always @(posedge clk) begin
    if (counter >= `Counter_Div) begin
        //完成计数，这里Counter_Div为325，分频为153374hz
        counter <= init;
        out <= ~out;
    end else begin
        //继续计数
        counter <= counter + div;
    end
end

endmodule
