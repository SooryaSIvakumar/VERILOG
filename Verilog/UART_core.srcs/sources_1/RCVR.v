`timescale 1ns / 10ps
//__________________________________________________________________________________________________________//
//                             UART Receiver Inspired from nandland.com                                     //
//                             Setting BAUD rate to 115200 and clock to 1Mhz                                //
//__________________________________________________________________________________________________________//
module RCVR
#(parameter CLKS_PER_BIT = 43)                                 //This is clocks used per bit obtained by Clock_freq/Baud_rate 
(
input RST,CLK,    
input DATA_IN,                                                 //Incoming Data
output reg RX_DV,                                              //RX data valid signal
output reg [7:0] RX_OUT                                        //Received Data
    );
    
//parameter CLKS_PER_BIT = 217;                               //This is clocks used per bit obtained by Clock_freq/Baud_rate 

//Defining different states
localparam IDLE  = 3'b000;
localparam START = 3'b001;
localparam CATCH = 3'b010;
localparam STOP  = 3'b011;
localparam CLR   = 3'b100;

//Setting up Variables used inside module 
reg [$clog2(CLKS_PER_BIT):0] clk_count;
reg [2:0] bit_index;
reg [2:0] state;

always@(posedge CLK or negedge RST)
begin
    if(~RST)
    begin
        state <= IDLE;
        RX_DV <= 0;
    end
    
    else
    begin
        case(state)
        IDLE://Machine is set in DILE state and constantly checks for the start bit
        begin
            clk_count <= 0;
            bit_index <= 0;
            
            if(DATA_IN == 1'b0)
                state <= START;
            else
                state <= IDLE;
        end 
        
        
        START://Rechecks the received Start bit and samples it at the middle and pushes the machine to CATCH to receive data
        begin
            if(clk_count == (CLKS_PER_BIT-1)/2)                        //Sampling at the middle of the signal
            begin
                if(DATA_IN == 1'b0)
                begin
                    clk_count <= 0;
                    state <= CATCH;
                end
                else
                    state <= IDLE;
            end
            else
            begin
                clk_count <= clk_count+1;
                state <= START;
            end
        end
            
        CATCH://Receives Data sent to the machine
        begin
            if(clk_count < CLKS_PER_BIT-1)
            begin
                clk_count <= clk_count+1;
                state <= CATCH;
            end
            else
            begin
                clk_count <= 0;
                RX_OUT[bit_index] <= DATA_IN;
                
                if(bit_index < 7)
                begin
                    bit_index <= bit_index+1;
                    state <= CATCH;
                end
                else
                begin
                    state <= STOP;
                    bit_index <= 0;
                end
            end
        end
        
        
        STOP://Ends the Data receive after the stop bit
        begin
            if(clk_count < CLKS_PER_BIT-1)
            begin
                clk_count <= clk_count+1;
                state <= STOP;
            end
            else
            begin
                RX_DV <= 1;
                clk_count <= 0;
                state <= CLR;
            end
        end    
        
        
        CLR://Clears all the data back to default
        begin
            RX_DV <= 0;
            state <= IDLE;
        end
        
        
        default://puts state back to IDLE incase of default
            state <= IDLE;
            
            
        endcase
    end
end

endmodule
