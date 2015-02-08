`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;
bit[31:0] Tx_CntA,Tx_CntB,Tx_CntC,Tx_CntD,Tx_CntE,Tx_CntF,Tx_CntG,Tx_CntH;
bit[31:0] Rx_CntA,Rx_CntB,Rx_CntC,Rx_CntD,Rx_CntE,Rx_CntF,Rx_CntG,Rx_CntH;
bit[31:0] global_Send_Cnt=0,global_Rx_Cnt=0;
module noc_complete();

parameter FL=2;
parameter BL=2;
parameter WIDTH = 12;
parameter LIMIT = 10000;


  Channel #(.WIDTH(12), .hsProtocol(P1of2)) intf  [55:0] (); 


  data_generator  #(.WIDTH(3'd7),.FL(10),.SEND_DATA(4'b0100),.SOURCE_ROUTER(3'b000),.LIMIT(LIMIT)) dg0(.r1(intf[40]));
  data_generator  #(.WIDTH(3'd7),.FL(11),.SEND_DATA(4'b0101),.SOURCE_ROUTER(3'b001),.LIMIT(LIMIT)) dg1(.r1(intf[41]));
  data_generator  #(.WIDTH(3'd7),.FL(12),.SEND_DATA(4'b0110),.SOURCE_ROUTER(3'b010),.LIMIT(LIMIT)) dg2(.r1(intf[42]));
  data_generator  #(.WIDTH(3'd7),.FL(13),.SEND_DATA(4'b0111),.SOURCE_ROUTER(3'b011),.LIMIT(LIMIT)) dg3(.r1(intf[43]));
  data_generator  #(.WIDTH(3'd7),.FL(14),.SEND_DATA(4'b1000),.SOURCE_ROUTER(3'b100),.LIMIT(LIMIT)) dg4(.r1(intf[44]));
  data_generator  #(.WIDTH(3'd7),.FL(15),.SEND_DATA(4'b1001),.SOURCE_ROUTER(3'b101),.LIMIT(LIMIT)) dg5(.r1(intf[45]));
  data_generator  #(.WIDTH(3'd7),.FL(16),.SEND_DATA(4'b1010),.SOURCE_ROUTER(3'b110),.LIMIT(LIMIT)) dg6(.r1(intf[46]));
  data_generator  #(.WIDTH(3'd7),.FL(17),.SEND_DATA(4'b1011),.SOURCE_ROUTER(3'b111),.LIMIT(LIMIT)) dg7(.r1(intf[47]));

  data_bucket #(.WIDTH(WIDTH)) db0(.l1(intf[48]));
  data_bucket #(.WIDTH(WIDTH)) db1(.l1(intf[49]));
  data_bucket #(.WIDTH(WIDTH)) db2(.l1(intf[50]));
  data_bucket #(.WIDTH(WIDTH)) db3(.l1(intf[51]));
  data_bucket #(.WIDTH(WIDTH)) db4(.l1(intf[52]));
  data_bucket #(.WIDTH(WIDTH)) db5(.l1(intf[53]));
  data_bucket #(.WIDTH(WIDTH)) db6(.l1(intf[54]));
  data_bucket #(.WIDTH(WIDTH)) db7(.l1(intf[55]));

 async_block #(.FL(FL), .BL(BL), .Block_ID(3'b000)) async_block_A (.dg(intf[40]), .up(intf[0]), .down(intf[32]) ,.db(intf[48]));
 async_block #(.FL(FL), .BL(BL), .Block_ID(3'b001)) async_block_B (.dg(intf[41]), .up(intf[1]), .down(intf[33]) ,.db(intf[49]));
 async_block #(.FL(FL), .BL(BL), .Block_ID(3'b010)) async_block_C (.dg(intf[42]), .up(intf[2]), .down(intf[34]) ,.db(intf[50]));
 async_block #(.FL(FL), .BL(BL), .Block_ID(3'b011)) async_block_D (.dg(intf[43]), .up(intf[3]), .down(intf[35]) ,.db(intf[51]));
 async_block #(.FL(FL), .BL(BL), .Block_ID(3'b100)) async_block_E (.dg(intf[44]), .up(intf[4]), .down(intf[36]) ,.db(intf[52]));
 async_block #(.FL(FL), .BL(BL), .Block_ID(3'b101)) async_block_F (.dg(intf[45]), .up(intf[5]), .down(intf[37]) ,.db(intf[53]));
 async_block #(.FL(FL), .BL(BL), .Block_ID(3'b110)) async_block_G (.dg(intf[46]), .up(intf[6]), .down(intf[38]) ,.db(intf[54]));
 async_block #(.FL(FL), .BL(BL), .Block_ID(3'b111)) async_block_H (.dg(intf[47]), .up(intf[7]), .down(intf[39]) ,.db(intf[55]));



  router_A #(.WIDTH(WIDTH),.FL(FL), .BL(BL),.SOURCE_ROUTER(3'b000)) router_A_inst(.async_block_send(intf[0]), .send_channel_right(intf[8]),  .send_channel_bottom(intf[24]),  .send_channel_left(intf[23]), .receive_channel_bottom(intf[29]), .receive_channel_right(intf[9]), .receive_channel_left(intf[22]),  .async_block_receive(intf[32]));
  router_B #(.WIDTH(WIDTH),.FL(FL), .BL(BL),.SOURCE_ROUTER(3'b001)) router_B_inst(.async_block_send(intf[1]), .send_channel_right(intf[10]), .send_channel_bottom(intf[25]),  .send_channel_left(intf[9]),  .receive_channel_bottom(intf[28]),   .receive_channel_right(intf[11]),  .receive_channel_left(intf[8]),   .async_block_receive(intf[33]));


  router_A #(.WIDTH(WIDTH),.FL(FL), .BL(BL),.SOURCE_ROUTER(3'b010)) router_C_inst(.async_block_send(intf[2]), .send_channel_right(intf[12]), .send_channel_bottom(intf[26]),  .send_channel_left(intf[11]), .receive_channel_bottom(intf[31]),  .receive_channel_right(intf[13]), .receive_channel_left(intf[10]),  .async_block_receive(intf[34]));
  router_B #(.WIDTH(WIDTH),.FL(FL), .BL(BL),.SOURCE_ROUTER(3'b011)) router_D_inst(.async_block_send(intf[3]), .send_channel_right(intf[14]), .send_channel_bottom(intf[27]),  .send_channel_left(intf[13]), .receive_channel_bottom(intf[30]),  .receive_channel_right(intf[15]), .receive_channel_left(intf[12]),  .async_block_receive(intf[35]));


  router_A #(.WIDTH(WIDTH),.FL(FL), .BL(BL),.SOURCE_ROUTER(3'b100)) router_E_inst(.async_block_send(intf[4]), .send_channel_right(intf[16]), .send_channel_bottom(intf[28]),  .send_channel_left(intf[15]), .receive_channel_bottom(intf[25]),  .receive_channel_right(intf[17]), .receive_channel_left(intf[14]),  .async_block_receive(intf[36]));
  router_B #(.WIDTH(WIDTH),.FL(FL), .BL(BL),.SOURCE_ROUTER(3'b101)) router_F_inst(.async_block_send(intf[5]), .send_channel_right(intf[18]), .send_channel_bottom(intf[29]),  .send_channel_left(intf[17]), .receive_channel_bottom(intf[24]),  .receive_channel_right(intf[19]), .receive_channel_left(intf[16]),  .async_block_receive(intf[37]));


  router_A #(.WIDTH(WIDTH),.FL(FL), .BL(BL),.SOURCE_ROUTER(3'b110)) router_G_inst(.async_block_send(intf[6]), .send_channel_right(intf[20]), .send_channel_bottom(intf[30]),  .send_channel_left(intf[19]), .receive_channel_bottom(intf[27]),  .receive_channel_right(intf[21]), .receive_channel_left(intf[18]),  .async_block_receive(intf[38]));
  router_B #(.WIDTH(WIDTH),.FL(FL), .BL(BL),.SOURCE_ROUTER(3'b111)) router_H_inst(.async_block_send(intf[7]), .send_channel_right(intf[22]), .send_channel_bottom(intf[31]),  .send_channel_left(intf[21]), .receive_channel_bottom(intf[26]),  .receive_channel_right(intf[23]), .receive_channel_left(intf[20]),  .async_block_receive(intf[39]));
   
///Data compare                                                                                                                                                                                                    
 always @(*)
begin
 if(Rx_CntA ==LIMIT & Rx_CntB ==LIMIT & Rx_CntC ==LIMIT & Rx_CntD ==LIMIT & Rx_CntE ==LIMIT & Rx_CntF ==LIMIT & Rx_CntG ==LIMIT & Rx_CntH ==LIMIT)
 begin   
  if(Rx_CntA!==Tx_CntA)
   $display("ERROR:: Number of Send Data packet by A is not equal to number of received data packet at Node A of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntA,Rx_CntA); 
   else 
   $display("Number of Send Data packet by A is equal to number of received data packet at Node A of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntA,Rx_CntA); 
   if(Rx_CntB!==Tx_CntB)
   $display("ERROR:: Number of Send Data packet by B is not equal to number of received data packet at Node B of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntB,Rx_CntB); 
   else 
   $display("Number of Send Data packet by B is equal to number of received data packet at Node B of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntB,Rx_CntB);
  if(Rx_CntC!==Tx_CntC)
   $display("ERROR:: Number of Send Data packet by C is not equal to number of received data packet at Node C of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntC,Rx_CntC); 
   else 
   $display("Number of Send Data packet by C is equal to number of received data packet at Node C of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntC,Rx_CntC); 
   if(Rx_CntD!==Tx_CntD)
   $display("ERROR:: Number of Send Data packet by D is not equal to number of received data packet at Node D of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntD,Rx_CntD); 
   else 
   $display("Number of Send Data packet by D is equal to number of received data packet at Node D of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntD,Rx_CntD);
  if(Rx_CntE!==Tx_CntE)
   $display("ERROR:: Number of Send Data packet by E is not equal to number of received data packet at Node E of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntE,Rx_CntE); 
   else 
   $display("Number of Send Data packet by E is equal to number of received data packet at Node E of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntE,Rx_CntE); 
   if(Rx_CntF!==Tx_CntF)
   $display("ERROR:: Number of Send Data packet by F is not equal to number of received data packet at Node F of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntF,Rx_CntF); 
   else 
   $display("Number of Send Data packet by F is equal to number of received data packet at Node F of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntF,Rx_CntF);
  if(Rx_CntG!==Tx_CntG)
   $display("ERROR:: Number of Send Data packet by G is not equal to number of received data packet at Node G of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntG,Rx_CntG); 
   else 
   $display("Number of Send Data packet by G is equal to number of received data packet at Node G of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntG,Rx_CntG); 
   if(Rx_CntH!==Tx_CntH)
   $display("ERROR:: Number of Send Data packet by H is not equal to number of received data packet at Node H of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntH,Rx_CntH); 
   else 
   $display("Number of Send Data packet by H is equal to number of received data packet at Node H of Send Data Packets %d and # of Recieved Data Packets %d\n",Tx_CntH,Rx_CntH);
 #5 $stop;
end
end 
endmodule 


module data_generator (interface r1);
  parameter WIDTH = 7;
  parameter FL = 1; //ideal environment
  parameter LIMIT = 100;
  parameter [3:0] SEND_DATA=0; //ideal environment
  parameter [2:0] SOURCE_ROUTER= 0;
  logic [WIDTH-1:0] SendValue=0;
  always
  begin 
    //add a display here to see when this module starts its main loop
//	$display("Start module data_generator %m and time is %d", $time);
#1;
    SendValue[2:0] = ($random() % (2**3));
    if(SendValue[2:0] == SOURCE_ROUTER)
      SendValue[2:0] = ~SendValue[2:0];
  if(SOURCE_ROUTER==3'h0)
   begin
  if(Tx_CntA<LIMIT)
   begin
   Tx_CntA=Tx_CntA+1;
    #FL;
    r1.Send({5'b0,SEND_DATA, SendValue[2:0]});
   $display("NOC .................and Tx_CntA  %d \n",Tx_CntA );
   end
   end
  if(SOURCE_ROUTER==3'h1)
   begin
  if(Tx_CntB<LIMIT)
   begin
   Tx_CntB=Tx_CntB+1;
    #FL;
    r1.Send({5'b0,SEND_DATA, SendValue[2:0]});
   $display("NOC .................and Tx_CntB  %d \n",Tx_CntB );
   end
   end
  if(SOURCE_ROUTER==3'h2)
   begin
  if(Tx_CntC<LIMIT)
   begin
   Tx_CntC=Tx_CntC+1;
    #FL;
    r1.Send({5'b0,SEND_DATA, SendValue[2:0]});
   $display("NOC .................and Tx_CntC  %d \n",Tx_CntC );
   end
   end
  if(SOURCE_ROUTER==3'h3)
   begin
  if(Tx_CntD<LIMIT)
   begin
   Tx_CntD=Tx_CntD+1;
    #FL;
    r1.Send({5'b0,SEND_DATA, SendValue[2:0]});
   $display("NOC .................and Tx_CntD  %d \n",Tx_CntD);
   end
   end
  if(SOURCE_ROUTER==3'h4)
   begin
  if(Tx_CntE<LIMIT)
   begin
   Tx_CntE=Tx_CntE+1;
    #FL;
    r1.Send({5'b0,SEND_DATA, SendValue[2:0]});
   $display("NOC .................and Tx_CntE  %d \n",Tx_CntE);
   end
   end
  if(SOURCE_ROUTER==3'h5)
   begin
  if(Tx_CntF<LIMIT)
   begin
   Tx_CntF=Tx_CntF+1;
    #FL;
    r1.Send({5'b0,SEND_DATA, SendValue[2:0]});
   $display("NOC .................and Tx_CntF  %d \n",Tx_CntF );
   end
   end
  if(SOURCE_ROUTER==3'h6)
   begin
  if(Tx_CntG<LIMIT)
   begin
   Tx_CntG=Tx_CntG+1;
    #FL;
    r1.Send({5'b0,SEND_DATA, SendValue[2:0]});
   $display("NOC .................and Tx_CntG  %d \n",Tx_CntG );
   end
   end
  if(SOURCE_ROUTER==3'h7)
   begin
  if(Tx_CntH<LIMIT)
   begin
   Tx_CntH=Tx_CntH+1;
    #FL;
    r1.Send({5'b0,SEND_DATA, SendValue[2:0]});
   $display("NOC .................and Tx_CntH  %d \n",Tx_CntH );
   end
   end
  end
endmodule

module data_bucket (interface l1);
  parameter WIDTH = 8;
  parameter BL = 0; //ideal environment
  logic [WIDTH-1:0] ReceiveValue = 0;
  //Variables added for performance measurements
//  real cycleCounter=0, //# of cycles = Total number of times a value is received
//       timeOfReceive=0, //Simulation time of the latest Receive 
//       cycleTime=0; // time difference between the last two receives
//  real averageThroughput=0, averageCycleTime=0, sumOfCycleTimes=0;
  always
  begin
    //Save the simulation time when Receive starts
//    timeOfReceive = $time; 
    l1.Receive(ReceiveValue);
//   global_Rx_Cnt=global_Rx_Cnt+1;
   // RXa_qu.push_front(ReceiveValue);
   case(ReceiveValue[6:3])
   4'b0100:begin Rx_CntA=Rx_CntA+1;   $display("Received Data %b with count Rx_CntA = %d \n",ReceiveValue,Rx_CntA ); end
   4'b0101:begin Rx_CntB=Rx_CntB+1;   $display("Received Data %b with count Rx_CntB = %d \n",ReceiveValue,Rx_CntB ); end
   4'b0110:begin Rx_CntC=Rx_CntC+1;   $display("Received Data %b with count Rx_CntC = %d \n",ReceiveValue,Rx_CntC ); end
   4'b0111:begin Rx_CntD=Rx_CntD+1;   $display("Received Data %b with count Rx_CntD = %d \n",ReceiveValue,Rx_CntD ); end
   4'b1000:begin Rx_CntE=Rx_CntE+1;   $display("Received Data %b with count Rx_CntE = %d \n",ReceiveValue,Rx_CntE ); end
   4'b1001:begin Rx_CntF=Rx_CntF+1;   $display("Received Data %b with count Rx_CntF = %d \n",ReceiveValue,Rx_CntF ); end
   4'b1010:begin Rx_CntG=Rx_CntG+1;   $display("Received Data %b with count Rx_CntG = %d \n",ReceiveValue,Rx_CntG ); end
   4'b1011:begin Rx_CntH=Rx_CntH+1;   $display("Received Data %b with count Rx_CntH = %d \n",ReceiveValue,Rx_CntH ); end
   default: $display("Incorrect data Received %d\n", ReceiveValue[6:3]); 
   endcase 

    //$display("Data Poped @ DB %b ",RXa_qu.pop_back() ); 
     #BL;
//    cycleCounter += 1;		
//    //Measuring throughput: calculate the number of Receives per unit of time  
//    //CycleTime stores the time it takes from the begining to the end of the always block
//    cycleTime = $time - timeOfReceive;
//    averageThroughput = cycleCounter/$time;
//    sumOfCycleTimes += cycleTime;
//    averageCycleTime = sumOfCycleTimes / cycleCounter;
  end
endmodule

