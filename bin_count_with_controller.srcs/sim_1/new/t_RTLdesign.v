`timescale 1ns / 1ps
module t_RTLdesign;
reg start,clk,reset_b;
wire[3:0] A;
wire E,F;
//instaniate the design module//
RTLdesign M0(A,E,F,start,clk,reset_b);
//setting up stimulus//
initial #500 $finish;
initial 
begin
    reset_b=0;
    start=0;
    clk=0;
    #5 reset_b=1;start=1;
    repeat(48)  //32 repeat is 1 cycle for counting to d
    begin
        #5 clk=~clk;
    end
end
initial
$monitor("A=%b, E=%b, F=%b, time=%0d",A,E,F,$time);  
endmodule
