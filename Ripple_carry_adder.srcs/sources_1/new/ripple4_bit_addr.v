`timescale 1ns / 1ps
module ripple4_bit_addr(
output [3:0]sum,output C4,
input [3:0] A,B,input C0);
wire C1,C2,C3;
fulaadr A1(sum[0],C1,A[0],B[0],C0),
        A2(sum[1],C2,A[1],B[1],C1),
        A3(sum[2],C3,A[2],B[2],C2),
        A4(sum[3],C4,A[3],B[3],C3);
endmodule
