`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

//Sample data_generator module
/*module data_generator (interface r1 );
  parameter WIDTH = 11;
  parameter FL = 0; //ideal environment
  logic [WIDTH-1:0] SendValue1=0;
  always
  begin 
    //add a display here to see when this module starts its main loop
    $display("Start time for %m block generating data = %d", $time);
    
      
    SendValue1[0] = 0;
    SendValue1[3:1] = ($random() % (2**3));

    SendValue1[10:4] = $random() % (2**7); //7'b0101111;// $random() % (2**WIDTH);
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

module RL_async_router_B( interface output_from_async_block, interface arbiter_input,interface channel1,interface channel2,interface channel3,interface input_to_async_block  );
parameter FL=4;
parameter BL=6;
parameter WIDTH = 11;
parameter [2:0] SOURCE_ROUTER= 0;
logic [2:0] dest_router_number;
logic [WIDTH-1:0] channel_data;

logic [2:0] diff=0;
logic [WIDTH-1:0] arbiter_data = 0;
logic [1:0] channel_no;

always 
begin

  // receive source router value
   
  output_from_async_block.Receive(channel_data);

  
  dest_router_number = channel_data[3:1];
 
   
 // if (dest_router_number>SOURCE_ROUTER)
    diff = dest_router_number - SOURCE_ROUTER;
  //else
    //difference = SOURCE_ROUTER - dest_router_number;

   if ((diff == 3'd1) || (diff == 3'd6))
 	begin
          #FL;
          channel1.Send(channel_data);
	end
   else if ((diff == 3'd2) || (diff == 3'd3) || (diff == 3'd5))
 	begin
          #FL;
          channel2.Send(channel_data);
	end
   else if ((diff == 3'd4) || (diff == 3'd7))
 	begin
          #FL;
          channel3.Send(channel_data);
	end



// case (difference)
// 1: 
//     begin
//     channel_no = 2'b01;
//     #FL;
//     channel1.Send(channel_data);
//     end
// 2: 
//     begin
//     channel_no = 2'b10;
//      #FL;
//     channel2.Send(channel_data);
//     end
// 3: 
//     begin
//     channel_no = 2'b10;
//      #FL;
//     channel2.Send(channel_data);
//     end
//4:
//     begin
//     channel_no = 2'b11;
//      #FL;
//     channel3.Send(channel_data);
//     end
// 5: 
//     begin
//     channel_no = 2'b10;
//      #FL;
//     channel2.Send(channel_data);
//     end
// 6: 
//     begin
//     channel_no = 2'b01;
//      #FL;
//     channel1.Send(channel_data);
//     end
// 7: 
//     begin
//     channel_no = 2'b11;
//     #FL;
//     channel3.Send(channel_data);
//     end
//endcase




#BL;
end//always

always 
begin

  arbiter_input.Receive(arbiter_data);
#FL;
  input_to_async_block.Send(arbiter_data);
#BL;
end

endmodule


/*module rl_block;

 //Interface Vector instantiation: 4-phase bundled data channel
  Channel #(.hsProtocol(P1of2)) intf  [5:0] (); 
  
  data_generator  dg1(.r1(intf[0]));
  data_generator  dg2(.r1(intf[1]));
  RL_async_router_A router( .output_from_async_block(intf[0]), .arbiter_input(intf[1]), .channel1(intf[2]), .channel2(intf[3]),.channel3(intf[4]), .input_to_async_block(intf[5]));
  data_bucket  db1(.l1(intf[2]));
  data_bucket  db2(.l1(intf[3]));
  data_bucket  db3(.l1(intf[4]));
  data_bucket  db4(.l1(intf[5]));


  initial 
     #1000 $stop;
endmodule
*/
