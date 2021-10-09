`timescale 1ns / 1ps
module t_signalop;
wire [1:0] HWY_SIG,CNTRY_SIG;
reg CAR_ON_CNTRY_ROAD, CLOCK, CLEAR;

signalop SC(HWY_SIG,CNTRY_SIG,CAR_ON_CNTRY_ROAD,CLOCK,CLEAR);

initial
    $monitor("Highway RD status = %b, Country RD status = %b, Incoming car = %b", HWY_SIG, CNTRY_SIG, CAR_ON_CNTRY_ROAD);
    
    //CLOCK setup
    initial
    begin
    CLOCK = `FALSE;
    forever #5 CLOCK = ~CLOCK;
    end
    
    //CLEAR chck
    initial
    begin
    CLEAR = `TRUE;
    repeat(5) @(negedge CLOCK);
    CLEAR = `FALSE;
    end
    
    //stimulus 
    initial 
    begin
    CAR_ON_CNTRY_ROAD = `FALSE;
    repeat(20) @(negedge CLOCK);
    CAR_ON_CNTRY_ROAD = `TRUE;
    repeat(10) @(negedge CLOCK);
    CAR_ON_CNTRY_ROAD = `FALSE;
    repeat(20) @(negedge CLOCK);
    CAR_ON_CNTRY_ROAD = `TRUE;
    repeat(10) @(negedge CLOCK);
    CAR_ON_CNTRY_ROAD = `FALSE;
    repeat(20) @(negedge CLOCK);
    CAR_ON_CNTRY_ROAD = `TRUE;
    repeat(10) @(negedge CLOCK);
    CAR_ON_CNTRY_ROAD = `FALSE;
    repeat(10) @(negedge CLOCK);
    $stop;
    end
endmodule
