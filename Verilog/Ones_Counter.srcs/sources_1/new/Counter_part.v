`timescale 1ns / 1ps

//________________________________________________________// 
//                    Counter module                      // 
//________________________________________________________// 

module Counter_part (R2, Load_regs, Incr_R2, CLK, RST);

parameter R2_size = 4;

output reg [R2_size-1:0] R2;
input Load_regs, Incr_R2;
input CLK, RST;

always @(posedge CLK, negedge RST)
if (RST == 0) R2 <= 0;
else 
    if(Load_regs) R2 <= {R2_size{1'b1}};
    else
        if(Incr_R2 == 1) R2 <= R2+1;
endmodule
