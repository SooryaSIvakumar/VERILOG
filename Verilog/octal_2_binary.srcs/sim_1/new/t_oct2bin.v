`timescale 1ns / 1ps
module t_oct2bin;
wire [2:0]binout;
reg [7:0]octin;
oct2bin M1(binout,octin);
initial begin
$monitor ("input =%b, output=%b",octin,binout);
octin = 8'b10000000;
#50 octin = 8'b01000000;
#50 octin = 8'b00100000;
#50 octin = 8'b00010000;
#50 octin = 8'b00001000;
#50 octin = 8'b00000100;
#50 octin = 8'b00000010;
#50 octin = 8'b00000001;
#50 $finish;
end
endmodule
