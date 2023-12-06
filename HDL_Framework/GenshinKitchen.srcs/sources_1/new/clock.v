module clock(
    input clk,rst,
    output reg out,
);
parameter period = 651;
reg [31:0] cnt;
always @(posedge clk, negedge rst)
    begin
        if(!rst) begin
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