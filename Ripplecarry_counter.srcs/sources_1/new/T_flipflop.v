module T_flipflop(output q, input clk,reset);
wire d;
D_flipflop dff0(q,d,clk,reset);
not n1(d,q);
endmodule