`timescale 1ns / 1ps
module oct2bin(
output [2:0]bin,input [7:0]oct);
//using assign
assign bin[0] = oct[4]|oct[5]|oct[6]|oct[7];
assign bin[1] = oct[2]|oct[3]|oct[6]|oct[7];
assign bin[2] = oct[1]|oct[3]|oct[5]|oct[7];

endmodule
