module clock(
    input clk,rst,
    output reg clk_9600,
);
parameter period = 16;
reg [4:0] cnt;
always @(posedge clk, negedge rsn)
    begin
        if(!rsn) begin
            cnt <= 0;
            out <= 0;
        end
        else begin 
            if(cnt == (period >> 1) - 1)
            begin 
                out <= ~out;
                cnt <= 0;
            end
            else 
            cnt <= cnt + 1;
        end
    end

endmodule