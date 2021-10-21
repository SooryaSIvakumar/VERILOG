`timescale 1ns / 1ps

//________________________________________________________// 
//                Shift register module                   // 
//________________________________________________________// 

module Shift_reg_part (R1, data, SI_0, Shift_left, Load_regs, CLK, RST);

parameter R1_size = 8;

output reg [R1_size-1:0] R1;
input  [R1_size-1:0] data;
input SI_0, Shift_left, Load_regs; 
input CLK, RST;

assign SI_0 =1'b0;

always @(posedge CLK, negedge RST)
    if (RST == 0) R1 <= 0;
    else
    begin
        if(Load_regs) R1 <= data;
        else
            if(Shift_left)
                R1 <= {R1[R1_size -2: 0], SI_0} ;
    end
endmodule
