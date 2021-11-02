`timescale 1ns / 1ps
module fulaadr(
output S,C,
input x,y,z);
wire S1,C1,C2;
half_adder HA1(S1,C1,x,y);
half_adder HA2(S,C2,S1,z);
or G1(C,C1,C2);
endmodule
