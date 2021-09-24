`timescale 1ns / 1ps
module t_ripple4_bit_addr;
wire [0:3]summation;
wire Carry;
reg [0:3] A,B;
reg car;

ripple4_bit_addr M6(summation, Carry,A,B,car);

initial begin
A=4'b0000;B=4'b0001;car=1'b0;
#100 A=4'b1111;B=4'b1000;car=1'b0;
end
initial
$monitor("%b", summation);
endmodule

