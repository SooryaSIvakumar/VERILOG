`timescale 1ns / 1ps

//________________________________________________________// 
//-------------------Datapath module----------------------//
//     Sets up values of Register and provides output     //
//________________________________________________________// 

module Datapath_imp (count, E, Zero, data, Load_regs, Shift_left, Incr_R2, CLK, RST);

parameter R1_size = 8, R2_size = 4;

output [R2_size-1:0] count;
output E; 
output wire Zero;

input [R1_size-1:0] data;
input Load_regs, Shift_left, Incr_R2, CLK, RST;

wire [R1_size-1:0] R1;
//wire w1;

supply0 GND;
supply1 PWR;

assign Zero = (R1 == 0);

//instantiating Shift register module 
Shift_reg_part SR (R1, data, GND, Shift_left, Load_regs, CLK, RST);

//instantiating Counter module 
Counter_part CNT (count, Load_regs, Incr_R2, CLK, RST);

//instantiating D flipflop 
D_FF_part DFF(E, w1, CLK, RST);

and (w1, R1[R1_size-1], Shift_left);

endmodule