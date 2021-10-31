//_________________________________________________________//
//   Creating testbench for a simple 8 bit and circuit     //
//_________________________________________________________//
module Top(
input [7:0] a, b,
output [7:0] y
    );
// module explaining the duntion of circuit this is Design under test (DUT)//
assign y = a & b;
endmodule

class Transaction;
//Transaction class holds all data that are handled within the testbench//
randc bit [7:0] a;
randc bit [7:0] b;
bit [7:0] y;
endclass

class Generator;
//Generator class generates Random stimuli that needs to be applied for the DUT using testbench//
Transaction t; 
mailbox mbx;   
event done;  //handshake drv and gen
integer i;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
for(i =0 ;i < 20; i++) begin
t.randomize();
mbx.put(t);
$display ("[GEN] : data sent to DRV");
@(done);
#10;
end 
endtask

endclass

interface intf_and();
//Gives the ports that are to be connected with the DUT//
logic [7:0] a;
logic [7:0] b;
logic [7:0] y;

endinterface

class Driver;
//Driver class sends the data to the ports of the DUT//
Transaction t;
mailbox mbx;
event done;
virtual intf_and vif;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t=new();
forever begin
mbx.get(t);
vif.a = t.a;
vif.b = t.b;
$display("[DRV] : trigger interface");
->done;
#10;
end
endtask

endclass

class Monitor;
// Monitor receives the output from the interface//
virtual intf_and vif;
mailbox mbx;
Transaction t;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
forever begin
t.a = vif.a;
t.b = vif.b;
t.y = vif.y;
mbx.put(t);
$display("[MON] : data sent to scoreboard");
#10;
end
endtask

endclass

class Scoreboard;
//Scoreboard verifies the obtained output with respect to the well defined output//
Transaction t;
mailbox mbx;
bit [7:0] temp;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
forever begin
mbx.get (t);
temp = t.a & t.b;
if(t.y == temp)
$display("[SCO] : Test passed");
else
$display("[SCO] : Test failed");
#10;
end
endtask

endclass

class Environment;
// Environment class connects all the other parts toghether and creates a flow of operation//
Generator gen;
Driver drv;
Monitor mon;
Scoreboard sco;

virtual intf_and vif;

mailbox mbxgd;
mailbox mbxms;

event gddone;

function new(mailbox mbxgd, mailbox mbxms);

this.mbxgd = mbxgd;
this.mbxms =mbxms;

gen = new(mbxgd);
drv = new(mbxgd);

mon = new(mbxms);
sco = new(mbxms);
endfunction

task run();
gen.done = gddone;
drv.done = gddone;

drv.vif = vif;
mon.vif = vif;

fork 
gen.run();
drv.run();
mon.run();
sco.run();
join_any
endtask

endclass

module Top_tb;
//This is the testbench where all the parts created earlier executed and their outputs are verified//
Environment env;

mailbox mbxgd, mbxms;

intf_and vif();

Top dut(vif.a, vif.b, vif.y);

initial begin
mbxgd = new();
mbxms = new();
env = new(mbxgd, mbxms);
env.vif = vif;
env.run();
#200 $finish;
end


endmodule
