module DelayClock(
    input clk,
    output reg out=1'b0
);
reg[31:0] counter=0;
always @(posedge clk) begin
    if (counter >= 325) begin//650 slow for 651 try 16 or 256
        counter <= 0;
        out <= ~out;
    end else begin
        counter <= counter + 1;
    end
end

endmodule
