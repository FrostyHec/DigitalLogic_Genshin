module clk_div(
	input    clk,
	input    rst_n,
	output   div_clk
);
	
	parameter N = 651;
	
	reg   [3:0]  cnt; 
	reg       div_clk1;
	reg       div_clk2;
	
//--------------------cnt计数-------------------//
	always @(posedge clk or negedge rst_n)begin
		if(rst_n == 1'b0)begin
			cnt <= 0;
		end
		else if(cnt == (N-1))  //N-1
			cnt <= 0;
		else begin
			cnt <= cnt + 1;
		end
	end
	
//---------------上升沿(N-1)/2-1翻转-------------//
	always @(posedge clk or negedge rst_n)begin
		if(rst_n == 1'b0)begin
			div_clk1 <= 0;
		end
		else if(cnt == ((N-1)/2-1))begin  //(N-1)/2-1
			div_clk1 <= ~div_clk1;
		end
		else 
			div_clk1 <= div_clk1;
	end
	
//----------------下降沿(N-1)翻转-----------------//
	always @(negedge clk or negedge rst_n)begin
		if(rst_n == 1'b0)begin
			div_clk2 <= 0;
		end
		else if(cnt == (N-1))begin   //N-1
			div_clk2 <= ~div_clk2;
		end
		else 
			div_clk2 <= div_clk2;
	end
	
//----------------两个时钟做异或-----------------//
	assign div_clk = div_clk2 ^ div_clk1;

endmodule