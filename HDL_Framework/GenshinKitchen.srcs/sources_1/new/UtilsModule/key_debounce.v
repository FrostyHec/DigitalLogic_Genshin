module key_debounce(
input clk,
input rst_n,
input key,
output reg key_flag,
output reg key_value
);
//爬的网上的代码，自己稍微修改了一下

parameter period = 1000000;
reg [31:0] delay_cnt;
reg key_reg;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        delay_cnt <= 32'd0;
        key_reg <= 1'b1;
    end
    else
    begin
        if(key_reg != key)
            delay_cnt <= period;
        else
        begin
            if(delay_cnt > 20'd0)
                delay_cnt <= delay_cnt-1'b1;
            else
                delay_cnt <= delay_cnt;
        end
        key_reg<=key;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        key_flag <= 1'b0;
        key_value <= 1'b0;
    end
    else
    begin
        if(delay_cnt == 20'd1)
        begin
            key_value <= key;
            key_flag <= 1'b1;
        end
        else
        begin
            key_flag <= 1'b0;
            key_value <= key_value;
        end
    end
end

endmodule