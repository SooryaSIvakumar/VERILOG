`timescale 1ns / 1ps

//_____________________________________//
//Designing a conuter with a controller//
//_____________________________________//
module RTLdesign(
output[3:0]A, output E,F,
input start,clk,reset_b);
//instantiating controller and datapath modules//
controller M0(set_E,clr_E,set_F,clr_A_F,incr_A,A[2],A[3],start,clk,reset_b);
datapath M1(A,E,F,set_E,clr_E,set_F,clr_A_F,incr_A,clk);
endmodule

//_____________________________________//
//    controller for the counter       //
//_____________________________________//
module controller(output reg set_E,clr_E,set_F,clr_A_F,incr_A, 
input A2,A3,start,clk,reset_b);
reg[1:0] state,next_state;
parameter s_idle=2'b00,s_1=2'b01,s_2=2'b11; //setting up different states
//reset chcking always block
always@(posedge clk, negedge reset_b)
if(reset_b ==0) state<=s_idle;
else state <= next_state;
//next_state setting always block
always@(state,start,A2,A3)
begin
    next_state=s_idle;
    case(state)
    s_idle : if(start)next_state=s_1;else next_state=s_idle;
    s_1    : if(A2&A3)next_state=s_2;else next_state=s_1;
    s_2    : next_state=s_idle;
    default: next_state=s_idle;
    endcase
 end
 //always block for setting up control signals
always@(state,start,A2)
begin
set_E=0;
set_F=0;
clr_A_F=0;
clr_E=0;
incr_A=0;
case(state)
    s_idle:if(start)clr_A_F=1;
    s_1   :begin 
              incr_A=1;
              if(A2) set_E=1 ; else clr_E=1;
           end
    s_2   :set_F=1;
endcase
end
endmodule

//___________________________________________________________________//
//datapath module acting on the controlsignals from controller module//
//___________________________________________________________________//
module datapath(output reg[3:0] A, output reg E,F, input set_E,clr_E,set_F,clr_A_F,incr_A,clk);
//using always block for setting register operations
always@(posedge clk)
begin
if(set_E) E<=1;
if(clr_E) E<=0;
if(set_F) F<=1;
if(clr_A_F) begin A<=0;F<=0;end
if(incr_A) A<=A+1;
end
endmodule

