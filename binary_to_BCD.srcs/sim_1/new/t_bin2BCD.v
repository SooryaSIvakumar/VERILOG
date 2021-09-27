`timescale 1ns / 1ps
module t_bin2BCD;
wire [4:0]BCD;
reg [3:0]bin;
bin2BCD M1(BCD,bin);
initial begin
    $monitor("input = %b, BCD = %b",bin,BCD);
    bin= 4'b0000;
    #100 bin=4'b1001;
    #100 bin=4'b1111;
    #100 bin=4'b1101;
    #100 bin=4'b0010;
end
endmodule
