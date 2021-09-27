`timescale 1ns / 1ps
module priorityencoder_4X1(
output [1:0]encout,input [3:0]in);
wire not_I2,and_1;

not G2(not_I2,in[2]);
and G1(and_1,not_I2,in[1]);
or G3(encout[1],in[3],in[2]),
   G4(encout[0],and_1,in[3]);
endmodule
