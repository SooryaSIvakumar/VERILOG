`timescale 1ns / 1ps
//________________________________________________________________________________________________________________________________//
//                                               64byte Cyclic FIFO buffer                                                        //
//________________________________________________________________________________________________________________________________//


module FIFO(
clk, rst, buf_in, buf_out, wr_en, rd_en, buf_empty, buf_full, counter
    );

input rst, clk, wr_en, rd_en;
input [7:0] buf_in;
output reg [7:0] buf_out;
output reg buf_empty, buf_full;
output reg [6:0] counter;

reg [3:0] rd_ptr, wr_ptr;
reg [7:0] buf_mem [63:0];

//First alwayws block sets the status flags of buffer beign empty or full//
always@(counter)
begin
    buf_empty = (counter == 0 );
    buf_full = (counter == 64);
end

//This block calculates the counter based on which the writing position or reading position can be found along with finding overflow or underflow//
always@(posedge clk or posedge rst)
begin
    if(rst)
        counter <= 0;
    else if((!buf_full && wr_en)&&(!buf_empty && rd_en))
        counter <= counter;
    else if(!buf_full && wr_en)
        counter <= counter+1;
    else if(!buf_empty && rd_en)
        counter <= counter-1;
    else
        counter <= counter;
end

//Here the output from the buffer is obtained from the buffer memory//
always@(posedge clk or posedge rst)
begin
    if(rst)
        buf_out <= 0;
    else
    begin
        if(rd_en && !buf_empty)
            buf_out <= buf_mem[rd_ptr];
        else
            buf_out <= buf_out;
    end 
end

//Here the buffer takes input according to the conditions satisfied//
always @(posedge clk)
begin
    if(wr_en && !buf_full)
        buf_mem[wr_ptr] <= buf_in;
    else
        buf_mem[wr_ptr] <= buf_mem[wr_ptr];
end


//This block manages the read and write pointer using which the buffer is accessed//
always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        wr_ptr <= 0;
        rd_ptr <= 0;
    end
    else
    begin
        if(!buf_full && wr_en)
            wr_ptr <= wr_ptr + 1;
        else
            wr_ptr <= wr_ptr;
        if(!buf_empty && rd_en)
            rd_ptr <= rd_ptr + 1;
        else
            rd_ptr <= rd_ptr;
    end
end

endmodule
