`timescale 1ns / 1ps

//________________________________________________________// 
//-------------------Main source file---------------------//
//Counts the number of ones presesnt in the given register//
//________________________________________________________//
module Count_Ones_main(count, Ready, data, Start, CLK, RST);

parameter R1_size = 8, R2_size = 4; //settting up sizes of the registers involved 

output [R2_size-1:0] count;
output Ready;

input [R1_size-1:0] data;
input Start, CLK, RST;

wire Load_regs, Shift_left, Incr_R2, Zero, E;

//Instantiating the Datapath module
Datapath_imp M1 (count, E, Zero, data, Load_regs, Shift_left, Incr_R2, CLK, RST);

//Instantiating the controller module
Controller_imp M0 (Ready, Load_regs, Shift_left, Incr_R2, Start, E, Zero, CLK, RST);



endmodule
