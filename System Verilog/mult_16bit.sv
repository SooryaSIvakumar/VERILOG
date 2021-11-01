`timescale 1ns / 1ps

//____________________________________________________________________//
//            A simple 16 bit multiplier with testbench               //
//____________________________________________________________________//

module mult_16bit(
input [15:0] a, b,
output [31:0] product
    );
   
assign product = a*b;

endmodule

class Transaction;

randc bit [15:0] a;
randc bit [15:0] b;
bit [31:0] product;

endclass

class Generator;

Transaction t;
mailbox mbx;
integer i;
event done;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
for(i=0 ; i<20; i++) begin
t.randomize();
mbx.put(t);
$display("[GEN]: Data generated and sent to driver");
@(done);
#10;
end
endtask

endclass

interface intf_mult;

logic [15:0] a;
logic [15:0] b;
logic [31:0] product;

endinterface

class Driver;

Transaction t;
mailbox mbx;
virtual intf_mult vif;
event done;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t= new();
forever begin
mbx.get(t);
vif.a = t.a;
vif.b = t.b;
$display("[DRV] : Data received and sent to inteface");
->done;
#10;
end
endtask

endclass

class Monitor;

Transaction t;
mailbox mbx;
virtual intf_mult vif;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
forever begin 
t.a = vif.a;
t.b = vif.b;
t.product = vif.product;
mbx.put(t);
$display("[MON] : Received output from interface");
#10;
end 
endtask

endclass

class Scoreboard;

Transaction t;
mailbox mbx;
bit [31:0] refer;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
forever begin
mbx.get(t);
refer = t.a * t.b;

if (t.product == refer) 
$display ("[SCO] : Test passed");
else
$display ("[SCO] : Test failed");
#10;
end
endtask

endclass

class Environment;

Generator gen;
Driver drv;
Monitor mon;
Scoreboard sco;

mailbox mbxgd;
mailbox mbxms;

event donegd;

virtual intf_mult vif;

function new(mailbox mbxgd, mailbox mbxms);
this.mbxgd = mbxgd;
this.mbxms = mbxms;
gen = new(mbxgd);
drv = new(mbxgd);
mon = new(mbxms);
sco = new(mbxms);
endfunction

task main();
drv.vif = vif ;
mon.vif = vif ;
gen.done = donegd;
drv.done = donegd;

fork
gen.run();
drv.run();
mon.run();
sco.run();

join_any

endtask

endclass

module tb_mult();

Environment e;
mailbox mbxgd, mbxms;
intf_mult vif();
mult_16bit dut(vif.a, vif.b, vif.product);

initial begin
mbxgd = new();
mbxms = new();

e=new(mbxgd, mbxms);
e.vif = vif;
e.main();
#1000 $finish;
end

endmodule




