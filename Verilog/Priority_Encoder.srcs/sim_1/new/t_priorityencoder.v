`timescale 1ns / 1ps
module t_priorityencoder;
wire [1:0]encoded;
reg [3:0]in;
priorityencoder_4X1 M1(encoded,in);
initial begin
    $monitor("input = %b, output = %b",in,encoded);
    in = 4'b1000;
    #100 in = 4'b1111;
    #100 in = 4'b0001;
    #100 in = 4'b0100;
    #100 in = 4'b1100;
    #100 in = 4'b0010;
end
endmodule