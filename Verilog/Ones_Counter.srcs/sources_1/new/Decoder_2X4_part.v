`timescale 1ns / 1ps

//________________________________________________________// 
//                 2X4 Decoder module                     //
//________________________________________________________// 

module Decoder_2X4_part(
output [0:3] D,
input A,B,enable);

assign D[0] = !A && !B && !enable,
       D[1] = !A && B && !enable,
       D[2] = A && !B && !enable,
       D[3] = A && B && !enable;

endmodule
