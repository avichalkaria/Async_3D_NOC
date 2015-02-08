`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module router_A(interface send_channel_bottom,interface send_channel_left,interface send_channel_right,interface receive_channel_bottom,interface receive_channel_left,interface receive_channel_right,interface async_block_send, interface async_block_receive);

parameter FL=1;
parameter BL=1;
parameter WIDTH = 12;
parameter [2:0] SOURCE_ROUTER= 0;

//Interface Vector instantiation: 4-phase bundled data channel
  Channel #(.hsProtocol(P1of2)) intf  [15:0] (); 

  //instantiation of blocks
  
  RL_async_router_A #(.WIDTH(WIDTH),.FL(FL), .BL(BL), .SOURCE_ROUTER(SOURCE_ROUTER)) rl_async_inst  ( .output_from_async_block(async_block_send),       .arbiter_input(intf[12]), .channel1(intf[0]), .channel2(intf[1]),  .channel3(intf[2]), .input_to_async_block(async_block_receive));
  RL_left           #(.WIDTH(WIDTH),.FL(FL), .BL(BL), .SOURCE_ROUTER(SOURCE_ROUTER)) rl_left_inst   ( .input_from_other_blocks(receive_channel_left),   .arbiter_input(intf[13]), .channel1(intf[3]), .channel2(intf[4]),  .channel3(intf[5]), .output_from_RL(send_channel_left));
  RL_bottom         #(.WIDTH(WIDTH),.FL(FL), .BL(BL), .SOURCE_ROUTER(SOURCE_ROUTER)) rl_bottom_inst ( .input_from_other_blocks(receive_channel_bottom), .arbiter_input(intf[14]), .channel1(intf[6]), .channel2(intf[7]),  .channel3(intf[8]), .output_from_RL(send_channel_bottom));
  RL_right          #(.WIDTH(WIDTH),.FL(FL), .BL(BL), .SOURCE_ROUTER(SOURCE_ROUTER)) rl_right_inst  ( .input_from_other_blocks(receive_channel_right),  .arbiter_input(intf[15]), .channel1(intf[9]),.channel2(intf[10]), .channel3(intf[11]), .output_from_RL(send_channel_right));


  Arbiter         #(.WIDTH(WIDTH),.FL(FL), .BL(BL)) arb_async (.L1(intf[5]),.L2(intf[8]),.L3(intf[11]), .R1(intf[12]));
  Arbiter         #(.WIDTH(WIDTH),.FL(FL), .BL(BL)) arb_left  (.L1(intf[2]),.L2(intf[7]), .L3(intf[10]),.R1(intf[13]));
  Arbiter         #(.WIDTH(WIDTH),.FL(FL), .BL(BL)) arb_bottom(.L1(intf[1]),.L2(intf[4]), .L3(intf[9]), .R1(intf[14]));
  Arbiter         #(.WIDTH(WIDTH),.FL(FL), .BL(BL)) arb_right (.L1(intf[0]),.L2(intf[3]), .L3(intf[6]), .R1(intf[15]));
   
endmodule 

/*module router_complete();

 parameter WIDTH = 12;
 parameter FL = 4; //ideal environment
 parameter BL=6;
 parameter [2:0] SOURCE_ROUTER= 0;

  Channel #(.hsProtocol(P1of2)) intf  [7:0] (); 

  data_generator  #(.FL(0)) dg0(.r1(intf[0]));
  data_generator  #(.FL(0)) dg1(.r1(intf[1]));
  data_generator  #(.FL(0)) dg2(.r1(intf[2]));
  data_generator  #(.FL(0)) dg3(.r1(intf[3]));
  router_A #(.WIDTH(WIDTH),.FL(FL), .BL(BL),.SOURCE_ROUTER(SOURCE_ROUTER)) router_A_inst( .send_channel_bottom(intf[4]), .send_channel_left(intf[5]), .send_channel_right(intf[6]), .receive_channel_bottom(intf[1]), .receive_channel_left(intf[2]), .receive_channel_right(intf[3]), .async_block_send(intf[0]),  .async_block_receive(intf[7]));
  data_bucket  db1(.l1(intf[4]));
  data_bucket  db2(.l1(intf[5]));
  data_bucket  db3(.l1(intf[6]));
  data_bucket  db4(.l1(intf[7]));

initial 
     #100 $stop;
endmodule

//Sample data_generator module
module data_generator (interface r1 );
  parameter WIDTH = 11;
  parameter FL = 0; //ideal environment
  logic [WIDTH-1:0] SendValue1=0;
  always
  begin 
    //add a display here to see when this module starts its main loop
    $display("Start time for %m block generating data = %d", $time);
    
      
    SendValue1[0] = 0;
    SendValue1[3:1] = ($random() % (2**3));

    SendValue1[WIDTH-1:4] = $random() % (2**7); //7'b0101111;// $random() % (2**WIDTH);
    #FL;
     
    //Communication action Send is about to start
    $display("Starting %m.Send @ %d", $time);
    r1.Send(SendValue1);
    //Communication action Send is finished
    $display("Finished %m.Send @ %d", $time);
  end
endmodule

//Sample data_bucket module
module data_bucket (interface l1 );
  parameter WIDTH = 11;
  parameter BL = 0; //ideal environment
  logic [WIDTH-1:0] ReceiveValue1 = 0;
  
  //Variables added for performance measurements
  real cycleCounter=0, //# of cycles = Total number of times a value is received
       timeOfReceive=0, //Simulation time of the latest Receive 
       cycleTime=0; // time difference between the last two receives
  real averageThroughput=0, averageCycleTime=0, sumOfCycleTimes=0;
  always
  begin
    $display("Start module %m and time is %d", $time);	
    
    //Save the simulation time when Receive starts
    timeOfReceive = $time;
    $display("Starting %m.Receive @ %d", $time);
    l1.Receive(ReceiveValue1);
    $display("Finished %m.Receive @ %d", $time);
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
    $display("End module data_bucket and time is %d", $time);
  end

endmodule*/

