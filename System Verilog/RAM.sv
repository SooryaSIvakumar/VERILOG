`timescale 1ns / 1ps
//_____________________________________________________________________________________//
//          RAM with a word length of 8 bits and 64 depth with its test bench          //
//_____________________________________________________________________________________//

module RAM(
input clk,rst,wr,
input [7:0] datain,
input [5:0] addr,
output reg [7:0] dout
    );

reg [7:0] mem [64];
integer i;

always@(posedge clk)
begin
if(rst == 1)
    for(i=0; i<64; i++)
    mem[i] <= 0;
else
begin
   if(wr == 1)
    mem[addr] <= datain;
   else 
    dout <= mem[addr];
end 
end  

endmodule

//_____________________________________________________________________________________//
//             Transaction class holds all data involving the testbench                // 
//_____________________________________________________________________________________//

class Transaction;

rand bit [7:0] datain;
rand bit [5:0] addr;
bit [7:0] dout;
bit wr;

endclass

//_____________________________________________________________________________________//
//       Generator class to generate stimuli for testing the Dessign under test        //
//_____________________________________________________________________________________//

class Generator;

Transaction t;
mailbox mbx;
event done;
integer i;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
for(i=0; i<50; i++) begin
t.randomize;
mbx.put(t);
$display("[GEN]: Stimulus generated and sent to Driver");
@(done);
end
endtask

endclass

//_____________________________________________________________________________________//
//        Creating a interface through which the Design under test is connected        //
//_____________________________________________________________________________________//

interface intf_RAM();

logic [7:0] datain;
logic [5:0] addr;
logic [7:0] dout;
logic wr, clk, rst;

endinterface

//_____________________________________________________________________________________//
//           Driver receives the generated data and applies them to the DUT            //
//_____________________________________________________________________________________//

class Driver;

Transaction t;
mailbox mbx;
virtual intf_RAM vif;
event done;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
forever begin
mbx.get(t);
vif.datain = t.datain;
vif.addr = t.addr;
$display("[DRV] : Stimuli received and applied to interface");
->done;
@(posedge vif.clk);
end
endtask

endclass

//_____________________________________________________________________________________//
//  Monitor Receives the ouput from the DUT and send it to Scoreboard for verification //
//_____________________________________________________________________________________//

class Monitor;

Transaction t;
mailbox mbx;
virtual intf_RAM vif;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
forever begin
t.wr = vif.wr;
t.datain = vif.datain;
t.dout = vif.dout;
t.addr = vif.addr;
mbx.put(t);
$display("[MON] : Received data from interface and sent it to Scoreboard");
@(posedge vif.clk);
end
endtask

endclass

//_____________________________________________________________________________________//
// Scoreboard receives the output data from monitor and verifies it eith reference data//
//_____________________________________________________________________________________//

class Scoreboard;

Transaction t;
Transaction tarr[256]; //initializing a container to store array of data
mailbox mbx;

function new(mailbox mbx);
this.mbx = mbx;
endfunction

task run();
t = new();
forever 
begin
mbx.get(t);

if(t.wr == 1) 
    begin
    if(tarr[t.addr] == null) 
        begin
        tarr[t.addr] = new();
        tarr[t.addr] = t;
        $display("[SCO] : Data stored successfully");
        end
    end
else 
    begin
    if(tarr[t.addr] == null) 
        if(t.dout == 0)
        $display("[SCO] : Data reading is successful");
        else
        $display("[SCO] : Data reading failed"); 
    else
        if(t.dout == tarr[t.addr].datain)
        $display("[SCO] : Data reading is successful");
        else
        $display("[SCO] : Data reading failed");
     end
end
endtask

endclass

//_____________________________________________________________________________________//
//      Environment connects all other classes and enables them to work together       //
//_____________________________________________________________________________________//

class Environment;

mailbox mbxgd;
mailbox mbxms;

Generator gen;
Driver drv;
Monitor mon;
Scoreboard sco;

virtual intf_RAM vif;

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

//_____________________________________________________________________________________//
//   Testbench is used to tun the test on DUT by calling all the tasks created before  //
//_____________________________________________________________________________________//

module tb_RAM;

Environment env;
intf_RAM vif();
mailbox mbxgd, mbxms;

RAM dut(vif.clk, vif.rst, vif.wr, vif.datain, vif.addr, vif.dout);

always #5 vif.clk = ~ vif.clk;

initial begin
vif.clk = 0;
vif.rst = 1;
vif.wr = 1;
#50;
vif.wr = 1;
vif.rst =0;
#300;
vif.wr = 0;
#200;
vif.rst = 0;
#50;

end

initial begin
mbxgd = new();
mbxms = new();

env = new(mbxgd, mbxms);
env.vif = vif;
env.main();
#600;
$finish;
end

endmodule

