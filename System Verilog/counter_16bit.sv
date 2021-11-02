`timescale 1ns / 1ps
//_______________________________________________________________________//
//                  16-bit counter with SV testbench                     //
//_______________________________________________________________________//
module counter_16bit(

input clk, rst, up, load,
input [15:0] loadin,
output reg [15:0] dout
    );

always @(posedge clk)
begin
if (rst ==1)
    dout <= 16'b0000000000000000;
else if (load == 1)
    dout <= loadin;
else
    begin
    if(up == 1)
        dout <= dout+1;
    else
        dout <= dout-1;
    end 
end

endmodule

class Transaction;

randc bit [15:0] loadin;
bit [15:0] dout;

endclass

class Generator;

Transaction t;
mailbox mbx;
event done;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
t.randomize();
mbx.put(t);
$display("[GEN] : Data sent to driver");
@(done);
endtask

endclass

interface intf_count();

logic clk, rst, up, load;
logic [15:0] loadin;
logic [15:0] dout;

endinterface

class Driver;

mailbox mbx;
event done;
Transaction t;
virtual intf_count vif;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
forever begin
mbx.get(t);
vif.loadin = t.loadin;
$display("[DRV] : Data sent to interface");
->done;
@(posedge vif.clk);
end
endtask

endclass

class Monitor;

virtual intf_count vif;
mailbox mbx;
Transaction t;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
forever begin
t.loadin = vif.loadin;
t.dout = vif.dout;
mbx.put(t);
$display("[MON] : Data received from interface and sent to Scoreboard");
@(posedge vif.clk);
end
endtask

endclass

class Scoreboard;

Transaction t;
mailbox mbx;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
forever begin
mbx.get(t);
$display("[SCO] : Data received"); 
//Results can be checked on the waveform chart
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

virtual intf_count vif;

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
gen.run();
drv.run();
mon.run();
sco.run();

join_any
endtask

endclass

module tb_counter();

Environment env;
intf_count vif();
mailbox mbxgd, mbxms;

counter_16bit dut(vif.clk, vif.rst, vif.up, vif.load, vif.loadin, vif.dout);

always #5 vif.clk = ~vif.clk;

initial begin

vif.clk = 0;
vif.rst = 0;
vif.load = 0;
vif.up = 0;
#30;
vif.rst = 1;
#100;
vif.rst = 0;
vif.up = 1;
#100;
vif.load = 1;
vif.up = 0;
#100;
vif.load = 0;
#100;

end

initial begin

mbxgd = new();
mbxms = new();

env = new(mbxgd,mbxms);
env.vif = vif;
env.main();
#500;
$finish;
end

endmodule
