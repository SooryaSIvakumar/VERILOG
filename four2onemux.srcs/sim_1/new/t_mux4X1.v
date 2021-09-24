`timescale 1ns / 1ps
module t_mux4X1;
wire selout;
reg A,B,C,D;
reg [0:1]selection;
mux4X1 obj(selout,A,B,C,D,selection);
initial
begin  
$monitor("A=%b, B=%b,C=%b,D=%b,out=%b,select=%b",A,B,C,D,selout,selection);
 A=1'b1;B=1'b0;C=1'b0;D=1'b0;selection=2'b00;
 #100 A=1'b0;B=1'b1;C=1'b0;D=1'b0;selection=2'b01;
 #100 A=1'b0;B=1'b0;C=1'b1;D=1'b0;selection=2'b10;
 #100 A=1'b0;B=1'b0;C=1'b0;D=1'b1;selection=2'b11;
 end
endmodule
