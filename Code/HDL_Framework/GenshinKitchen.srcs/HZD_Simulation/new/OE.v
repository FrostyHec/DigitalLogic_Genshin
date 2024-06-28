`timescale 1ns / 1ps

module OE(

);
reg [4:0] btn;
wire [7:0] tx;
wire activation;
OperationEncoder oe(
    .button(btn),
    .enable(1'b1),
    .tx(tx),
    .activation(activation)
);
initial begin
    btn=5'b000_00;
    #10 btn=5'b00001;
    #10 btn=5'b00010;
    #10 btn=5'b00100;
    #10 btn=5'b01000;
    #10 btn=5'b10000;
    #10 btn=5'b00111;
    #10;
    $finish;
end
endmodule