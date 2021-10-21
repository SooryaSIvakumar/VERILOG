`timescale 1ns / 1ps

//________________________________________________________// 
//--------------------Control module----------------------//
//  Sets up control signals for controlling the Datapath  //
//________________________________________________________// 

module Controller_imp(Ready, Load_regs, Shift_left, Incr_R2, Start, E, Zero, CLK, RST);

output Ready;
output Load_regs, Shift_left, Incr_R2;

input Start, E, Zero;
input CLK, RST;

supply0 GND;
supply1 PWR;

parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11; //States of the controller 

wire Load_regs, Shift_left, Incr_R2;
wire G0, G1, D_in0, D_in1;
wire Zero_b = ~Zero;
wire E_b = ~E; 
wire [1:0] select = {G1,G0};
wire [0:3] Decoder_out;

assign Ready      = Decoder_out[0], 
       Incr_R2    = Decoder_out[1],
       Shift_left = Decoder_out[2];
 
 and (Load_regs, Ready, Start);
 
 
 //Instantiating MUX modules 
 MUX_4X1_part MUX1(D_in1, GND, Zero_b, PWR, E_b, select);
 MUX_4X1_part MUX0(D_in0, Start, GND, PWR, E, select);
 
 //DFF instantiation 
 D_FF_part DFF1(G1, D_in1, CLK, RST);
 D_FF_part DFF0(G0, D_in0, CLK, RST);
 
 //Decoder instantiation 
 Decoder_2X4_part DEC(Decoder_out, G1, G0, GND);

endmodule