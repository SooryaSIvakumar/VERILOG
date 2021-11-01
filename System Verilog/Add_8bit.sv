`timescale 1ns / 1ps
//_______________________________________________________//
//       Creating a testbench for simple 8 bit Adder     //
//_______________________________________________________//

module ADD_8bit(
input [7:0] a,b,
output [8:0] sum
    );
    
assign sum =a+b;

endmodule

class Transaction;

randc bit [7:0] a;
randc bit [7:0] b;
bit [8:0] sum;

endclass

class Generator;

Transaction t;
mailbox mbx;
event done;
integer i;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task main();
t = new();
for (i=0; i<20; i++) begin
t.randomize();
mbx.put(t);
$display("[GEN] : data sent to driver");
@(done);
#10;
end
endtask

endclass

interface intf_add;

logic [7:0] a;
logic [7:0] b;
logic [8:0] sum;

endinterface

class Driver;

Transaction t;
mailbox mbx;
event done;
virtual intf_add vif;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task main();
t = new();
forever begin
mbx.get(t);
vif.a = t.a;
vif.b = t.b;
$display("[DRV] : Interfave is triggered");
->done;
#10;
end
endtask

endclass

class Monitor;

Transaction t;
mailbox mbx;
virtual intf_add vif;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task main();
t= new();
forever begin
t.a = vif.a;
t.b = vif.b;
t.sum = vif.sum;
mbx.put(t);
$display("[MON] : data sent to scoreboard");
#10;
end
endtask

endclass

class Scoreboard;

Transaction t;
mailbox mbx;
bit [8:0] temp;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task main();
t = new();
forever begin
mbx.get(t);
temp = t.a + t.b;

if (t.sum == temp)
$display("[SCO]:Test passed");
else
$display("[SCO]:Test failed");
#10;
end
endtask

endclass

class Environment;

mailbox mbxgd;
mailbox mbxms;

Generator gen;
Driver drv;
Monitor mon;
Scoreboard sco;

virtual intf_add vif;

event donegd;

function new(mailbox mbxgd, mailbox mbxms);
this.mbxgd = mbxgd;
this.mbxms = mbxms;
gen = new(mbxgd);
drv = new(mbxgd);
mon = new(mbxms);
sco = new(mbxms);
endfunction

task main();
drv.vif = vif;
mon.vif = vif;
gen.done = donegd;
drv.done = donegd;

fork
gen.main();
drv.main();
mon.main();
sco.main();

join_any
endtask

endclass

module tb_add();

Environment e;
mailbox mbxgd, mbxms;
intf_add vif();
ADD_8bit dut(vif.a,vif.b,vif.sum);

initial begin
mbxgd = new();
mbxms = new();

e = new(mbxgd, mbxms);
e.vif = vif;
e.main();
#500;
$finish;
end

endmodule