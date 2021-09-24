`timescale 1ns / 1ps
module mux4X1(
output reg m_out,
input in0,in1,in2,in3,
input [0:1] sel);
always @(in0,in1,in2,in3,sel)
 case(sel)
  2'b00 : m_out=in0;
  2'b01 : m_out=in1;
  2'b10 : m_out=in2;
  2'b11 : m_out=in3;
  endcase
endmodule
