`timescale 1ns / 1ps
//__________________________________________________________________________________________________________//
//                             UART Transmitter Inspired from nandland.com                                  //
//                             Setting BAUD rate to 115200 and clock to 5Mhz                                //
//__________________________________________________________________________________________________________//

module TRX                             //This is clocks used per bit obtained by Clock_freq/Baud_rate 
(
input RST,CLK,
input IN_DV,                                                //Input data valid bit 
input [7:0] IN_DATA,                                        //Input data 8 bit length 
output reg TX_LIVE,                                        //Output signal indicating Transmission is active
output reg TX_DONE,                                        //Output signal indicating Transmission is complete
output reg TX_DATA                                         //Transmitted Data
);

parameter CLKS_PER_BIT = 43;                               //This is clocks used per bit obtained by Clock_freq/Baud_rate 

//Defining different states
localparam IDLE  = 3'b000;
localparam START = 3'b001;
localparam SEND  = 3'b010;
localparam STOP  = 3'b011;
localparam CLR   = 3'b100;

//Setting up various containers used inside the module 

reg [2:0] state;                                          //Holds the current state of the machine
reg [2:0] bit_index;                                      //for iterating through data for transmission 
reg [$clog2(CLKS_PER_BIT):0] clk_count;                   //$clog2 is the log function with base 2, Here it gives the length for the clk counter
reg [7:0] DATA;                                           //Holds the Data that is to be transmitted

always@(posedge CLK or negedge RST)
begin
    //Chck for reset condition else continue 
    if (~RST)
    begin
        state <= IDLE;                       
        TX_DONE <= 1'b0;
    end
    
    else
    begin
        case (state)
        IDLE://IDLE state where there is no transmission is happening and constanty checks for the Datavalid signal to be activated
        begin
            TX_DATA <= 1'b1;
            TX_DONE <= 1'b0;
            clk_count <= 0;
            bit_index <= 3'b000;
            
            if(IN_DV <= 1'b1)
            begin
                TX_LIVE <= 1'b1;
                DATA <= IN_DATA;
                state <= START;
            end
            else
                state <= IDLE;
        end 
        
        
        START://START state initiates the UART protocol by pulling down TX_DATA to low for 1 bit
        begin
            TX_DATA <= 1'b0;
            
            if(clk_count < CLKS_PER_BIT-1)
            begin
                clk_count <= clk_count+1;
                state <= START;
            end
            else
            begin
                state <= SEND;
                clk_count <= 0;
            end
        end 
       
       
        SEND://SEND state is where the data is read and transmitted
        begin
            TX_DATA <= DATA[bit_index];
            
            if(clk_count < CLKS_PER_BIT-1)
            begin
                clk_count <= clk_count+1;
                state <= SEND;
            end
            else
            begin
                clk_count <= 0;
                if(bit_index  < 8)
                begin
                    bit_index <= bit_index+1;
                    state <= SEND;
                end
                else
                begin
                    bit_index <= 0;
                    state <= STOP;
                end
            end
        end 
          
          
        STOP://STOP state sends out the stop bit and resets the machine
        begin
            TX_DATA <= 1;
            
            if(clk_count < CLKS_PER_BIT-1)
            begin
                clk_count <= clk_count+1;
                state <= STOP;
            end
            else
            begin
                TX_DONE <= 1'b1;
                clk_count <= 0;
                TX_LIVE <= 0;
                state <= CLR;
            end
        end         
        
        CLR:
        begin
            TX_DONE <= 1'b0;
            state <= IDLE;
        end 
        
        
        default://Set default state to IDLE
            state <= IDLE;
        
            
        endcase
    end        
end           
   
endmodule
