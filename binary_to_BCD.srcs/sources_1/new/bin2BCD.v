`timescale 1ns / 1ps
module bin2BCD(
output [4:0]BCD, input [3:0]binary);
wire not_B0,not_B1,not_B2,not_B3;
wire and_1,and_2,and_3,and_4,and_5,and_6;
//not gates
not NOT1(not_B0,binary[0]),
    NOT2(not_B1,binary[1]),
    NOT3(not_B2,binary[2]),
    NOT4(not_B3,binary[3]);
//and gates
and AND1(and_1,not_B1,binary[2],binary[3]),
    AND2(and_2,binary[1],not_B3),
    AND3(and_3,not_B3,binary[2]),
    AND4(and_4,binary[1],binary[2]),
    AND5(BCD[3],not_B1,binary[3],not_B2),
    AND6(and_5,binary[2],binary[3]),
    AND7(and_6,binary[3],binary[1]);
//or gates
or OR1(BCD[1],and_1,and_2),
   OR2(BCD[2],and_3,and_4),
   OR3(BCD[4],and_5,and_6);
//BCD[0]=binary[2]
assign BCD[0]=binary[0];
endmodule
