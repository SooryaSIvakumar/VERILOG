`timescale 1ns / 1ps
//__________________________________________________________________________________________//
//Sequential multiplier with 3 states controlling the multiplier action using one hot design//
//__________________________________________________________________________________________//

module ASMD_mult(Product,Ready,Multiplicand,Multiplier,Start,clk,rst);
parameter dp_width = 5;  //set to width of datapath (or) the multiplier and multiplicand configurable to needs

//Deafault I/O ports
output [2*dp_width-1:0] Product;
output                  Ready;
input [dp_width-1:0]    Multiplier,Multiplicand;
input                   Start,clk,rst;

//Setting up other parameters to be used
parameter BC_size=3; //size of bit counter set according to the length of Multiplier
parameter S_idle = 3'b001,//Setting up values for each state
          S_add  = 3'b010,
          S_shift= 3'b100;
reg [2:0]          state,next_state; //containers for holding state values
reg [dp_width-1:0] A,B,Q;
reg                C;
reg [BC_size-1:0]  P;
reg                Load_regs,Decr_p,Add_regs,Shift_regs;

//Setting up combinational logics
assign Product = {A,Q};
wire Zero      = (P==0);
wire Ready     = (state==S_idle);

//CONTROL UNIT

//Reset chck loop
always @(posedge clk, negedge rst)
if(~rst) state<= S_idle; else state <= next_state;

//setting up Controls for status signals
always @(state,Start,Q[0],Zero) 
begin
    next_state = S_idle;
    Load_regs  = 0;
    Decr_p     = 0;
    Add_regs   = 0;
    Shift_regs = 0;
    case(state)
    S_idle : begin
                if(Start)
                begin 
                    next_state = S_add;
                    Load_regs  = 1; 
                end
             end
    S_add  : begin 
                next_state        = S_shift;
                Decr_p            = 1;
                if(Q[0]) Add_regs = 1;
             end
    S_shift: begin
                Shift_regs          = 1;
                if(Zero) next_state = S_idle;
                else next_state     = S_add;
             end
 //   default: next_state = S_idle;
    endcase
end

//Datapath block setting up all reg values
always @(posedge clk)
begin
 if(Load_regs) 
 begin
    P <= dp_width;
    A <= 0;
    C <= 0;
    B <= Multiplicand;
    Q <= Multiplier;
 end
 if(Add_regs)
    {C,A} <= A+B;
 if(Shift_regs)
    {C,A,Q} <= {C,A,Q} >> 1;
 if(Decr_p)
    P <= P-1;
end


endmodule
