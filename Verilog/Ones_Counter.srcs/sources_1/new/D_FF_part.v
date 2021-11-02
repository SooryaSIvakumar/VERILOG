`timescale 1ns / 1ps

//________________________________________________________// 
//                  D flip flop module                    // 
//________________________________________________________// 

module D_FF_part(
output reg Q,
input D, CLK, RST);

always @(posedge CLK, negedge RST)
if (RST == 0) Q <= 1'b0;
else Q <= D;

endmodule