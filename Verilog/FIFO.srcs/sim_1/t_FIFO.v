`timescale 1ns / 1ps

//________________________________________________________________________________________________________________________________//
//                                      Test bench for 64byte Cyclic FIFO buffer                                                  //
//________________________________________________________________________________________________________________________________//
module t_FIFO;

wire [7:0] buf_out;
wire [6:0] counter;
wire buf_empty, buf_full;

reg [7:0] buf_in;
reg clk, rst, wr_en, rd_en;

//initializing module
FIFO M(clk, rst, buf_in, buf_out, wr_en, rd_en, buf_empty, buf_full, counter);

initial
   $monitor($time, ", FIFO INPUT: %b, FIFO OUTPUT: %b, OVERFLOW: %b, UNDERFLOW: %b, NO OF VALUES: %b", buf_in, buf_out, buf_full, buf_empty, counter);
    
    //Setting up clock
    initial 
    begin
        clk = 1'b0;
        forever #5 clk=~clk;
    end
    
    //providing inputs for simulation
    initial
    fork
        rst = 0;
        #5 rst = 1;
        #10 rst = 0;
        #15 wr_en = 1;
        #15 buf_in = 8'b01010111;
        #25 buf_in = 8'b11111111;
        #35 buf_in = 8'b00000000;
        #45 buf_in = 8'b11110000;
        #55 buf_in = 8'b00001111;
        #60 wr_en = 0;
        #65 rd_en = 1;
        #140 rd_en = 0;
        #150 rst = 1;
        #155 rst = 0;
    
    join
        
        
        
    initial #500 $finish;
endmodule
