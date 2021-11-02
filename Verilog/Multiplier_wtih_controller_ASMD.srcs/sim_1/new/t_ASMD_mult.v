`timescale 1ns / 1ps
module t_ASMD_mult;
parameter dp_width=5;
wire [2*dp_width-1:0] Product;
wire                  Ready;
reg  [dp_width-1:0]   Multiplicand,Multiplier;
reg                   Start,clk,rst;

//Instantiate design module 
ASMD_mult M0(Product, Ready, Multiplicand, Multiplier, Start, clk, rst);

//Generate stimulus 
initial #200 $finish;
initial 
begin 
    Start = 0;
    rst   = 0;
    #2 Start = 1;rst= 1;
    Multiplicand = 5'b10111; Multiplier = 5'b10011;
    #10 Start = 0 ;
end

initial
begin
    clk = 0;
    repeat(26) #5 clk = ~clk;
end

//Display results
always @(posedge clk)
    $strobe ("C=%b, A=%b, Q=%b, B=%b, P=%b,ZERO= %b, time=%0d", M0.C,M0.A,M0.Q,M0.B,M0.P,M0.Zero,$time);

endmodule
