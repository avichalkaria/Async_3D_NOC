`timescale 1ns/1fs
import SystemVerilogCSP::*;
//Sample data_generator module
/* module data_generator (interface r);
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  logic [WIDTH-1:0] SendValue=0;
  always
  begin 
    //add a display here to see when this module starts its main loop
    $display("<>Entering data_gen block %m  %d",$time);		
    SendValue = $random() % (2**WIDTH);
    #FL;
    //Communication action Send is about to start
    $display("Start Sending in module %m.Send & Simulation time= %d >>>>Send Data %h", $time,SendValue);
    r.Send(SendValue);
    //Communication action Send is finished
    $display("<> Exiting data_gen module %m.Send & Simulation time= %d", $time);
  end
endmodule

//Sample data_bucket module
module data_bucket (interface r);
  parameter WIDTH = 8;
  parameter BL = 0; //ideal environment
  logic [WIDTH-1:0] ReceiveValue = 0;
  //Variables added for performance measurements
  real cycleCounter=0, //# of cycles = Total number of times a value is received
       timeOfReceive=0, //Simulation time of the latest Receive 
       cycleTime=0; // time difference between the last two receives
  real averageThroughput=0, averageCycleTime=0, sumOfCycleTimes=0;
  always
  begin
    $display("<>Entering data_bucket block %m  %d",$time);
    //Save the simulation time when Receive starts
    timeOfReceive = $time; 
    $display("Start receiving in module %m.Receive & Simulation time= %d", $time);
    r.Receive(ReceiveValue);
    $display("Finished receiving in module %m.Receive & Simulation time= %d", $time);
     #BL;
    cycleCounter += 1;		
    //Measuring throughput: calculate the number of Receives per unit of time  
    //CycleTime stores the time it takes from the begining to the end of the always block
    cycleTime = $time - timeOfReceive;
    averageThroughput = cycleCounter/$time;
    sumOfCycleTimes += cycleTime;
    averageCycleTime = sumOfCycleTimes / cycleCounter;
    $display("Execution cycle= %d, Cycle Time= %d, 
    Average CycleTime=%f, Average Throughput=%f", cycleCounter, cycleTime, 
    averageCycleTime, averageThroughput);
    $display("<> Exiting data_bucket module %m.Send & Simulation time= %d", $time);
  end
endmodule*/


module Arbiter (interface L1,interface L2,interface L3,interface R1);
parameter FL = 2;
parameter BL = 8;
parameter WIDTH = 8;

logic [WIDTH-1:0] Data1,Data2,Data3;
logic D1=0,D2=0,D3=0;  
always
begin
$display("::::Waiting for Recieve OP %m.Receive %t\n",$time);
fork
L1.Probe_wait_input(D1);
L2.Probe_wait_input(D2);
L3.Probe_wait_input(D3);
join_any
$display("::::Channel is Non Idle %m.Receive D1 %d, D2 %d, D3 %d\n",D1,D2,D3);
while(D3||D2||D1)
begin
if(~D3 & ~D2 & D1)
begin
#BL;
L1.Receive(Data1);
$display("1::Finished Receiving in module %m.Receive data = %h\n",Data1);
#FL;
R1.Send(Data1);
D1=0;
$display("1::Finished Sending in module %m.Send data = %h\n",Data1);
end
if(~D3 & D2 & ~D1)
begin
#BL;
L2.Receive(Data2);
$display("2::Finished Receiving in module %m.Receive data = %h\n",Data2);
#FL;
R1.Send(Data2);
D2=0;
$display("2::Finished Sending in module %m.Send data = %h\n",Data2);
end
if(D3 & ~D2 & ~D1)
begin
#BL;
L3.Receive(Data3);
$display("3::Finished Receiving in module %m.Receive data = %h\n",Data3);
#FL;
R1.Send(Data3);
D3=0;
$display("3::Finished Sending in module %m.Send data = %h\n",Data3);
end

if(~D3 & D2 & D1)
begin
#BL;
L1.Receive(Data1);
$display("4::Finished Receiving in module %m.Receive data = %h\n",Data1);
#FL;
R1.Send(Data1);
D1=0;
$display("4::Finished Sending in module %m.Send data = %h\n",Data1);
end
if(D3 & ~D2 & D1)
begin
#BL;
L3.Receive(Data3);
$display("5::Finished Receiving in module %m.Receive data = %h\n",Data3);
#FL;
R1.Send(Data3);
D3=0;
$display("5::Finished Sending in module %m.Send data = %h\n",Data3);
end
if(D3 & D2 & ~D1)
begin
#BL;
L2.Receive(Data2);
$display("6::Finished Receiving in module %m.Receive data = %h\n",Data2);
#FL;
R1.Send(Data2);
D2=0;
$display("6::Finished Sending in module %m.Send data = %h\n",Data2);
end
if(D3 & D2 & D1)
begin
#BL;
L2.Receive(Data2);
$display("7::Finished Receiving in module %m.Receive data = %h\n",Data2);
#FL;
R1.Send(Data2);
D2=0;
$display("7::Finished Sending in module %m.Send data = %h\n",Data2);
end
end
end

endmodule 

/*module arbiter_test;

  //Interface Vector instantiation: 4-phase bundled data channel
  Channel #(.hsProtocol(P1of2)) intf  [3:0] (); 
  
  //instantiate test circuit
  data_generator  #(.WIDTH(4),.FL(2)) dg(intf[0]);
  data_generator  #(.WIDTH(4),.FL(3)) dg1(intf[1]);
  data_generator  #(.WIDTH(4),.FL(3)) dg2(intf[2]);
  Arbiter         #(.WIDTH(4),.FL(1), .BL(1)) arb(intf[0],intf[1],intf[2],intf[3]);
  data_bucket #(.WIDTH(4)) db(intf[3]);

  initial 
     #100 $stop;
endmodule*/
