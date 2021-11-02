`timescale 1ns / 1ps

//________________________________________________________________________________// 
//--------------------------------Test bench--------------------------------------//
//Running the Count_Ones_MAIN module through testbench for finding possible errors//
//________________________________________________________________________________// 
module t_Count_Ones_main;

parameter R1_size = 8, R2_size = 4;

//wire [R2_size-1:0] R2;
wire [R2_size-1:0] count;
wire Ready;
wire [1:0] state;

reg [R1_size-1:0] data;
reg Start, CLK, RST;

assign state = {count1.M0.G1, count1.M0.G0};

//Calling the design under test
Count_Ones_main count1(count, Ready, data, Start, CLK, RST);
//setting simulation end time
initial #650 $finish;

//setting up clock
initial begin
CLK = 0;
#5 forever #5 CLK = ~CLK;
end

//applying stimulus
initial 

fork
#1 RST = 1;
#3 RST = 0;
#4 RST = 1;
#27 RST = 0;
#29 RST = 1;
#355 RST = 0;
#365 RST = 1;
#4 data = 8'hff;
#145 data = 8'haa;
#25 Start = 1;
#35 Start = 0;
#55 Start = 1;
#65 Start = 0;
#395 Start = 1;
#405 Start = 0;


join

endmodule