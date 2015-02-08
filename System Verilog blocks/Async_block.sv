`timescale 1ns/100ps


import SystemVerilogCSP::*;
// Asynchronous Blocks
module async_block (interface dg, interface up, interface down,interface db);

parameter FL = 1;
parameter BL = 1;
parameter Block_ID = 0;

reg [11:0] data_tb;
//input transmit;

reg d1, d2, d3, d4, d5, d6, d7, p1, p2, p4, p8;
reg [11:0] transmit_data, receive_data, corrected_data;
reg resend=0, erroneous_address=0, single_bit_error=0, double_bit_error=0;
reg [6:0] decoded_data = 7'b0; 
reg [3:0] error_position=0;

reg flag1=0, flag2=0;

reg a=0, p=0, r1=0, r2=0, r3=0, r4=0, r5=0, r6=0, r7=0, r8=0, r9=0, r10=0, r11=0, rp=0, crp=0, cp1=0, cp2=0, cp4=0, cp8=0;
// Splitting data into bits
//assign d1 = data_tb[6];
//assign d2 = data_tb[5];
//assign d3 = data_tb[4];
//assign d4 = data_tb[3];
//assign d5 = data_tb[2];
//assign d6 = data_tb[1];
//assign d7 = data_tb[0];
//
//// Calculating Parity bits p1, p2, p4 & p8
//assign p1 = d1 + d2 + d4 + d5 + d7;    // 1101101
//assign p2 = d1 + d3 + d4 + d6 + d7;    // 1011011
//assign p4 = d2 + d3 + d4;              // 0111000  
//assign p8 = d5 + d6 + d7;              // 0000111
//
//assign p = d1 + d2 + d3 + d4 + d5 + d6 + d7 + p1 + p2 + p4 + p8;
//assign transmit_data = {p1, p2, d1, p4, d2, d3, d4, p8, d5, d6, d7, p};

always
begin
#BL;

dg.Probe_check_input(a);
if(a)
  begin
	dg.Receive(data_tb);

        d1 = data_tb[6];
        d2 = data_tb[5];
        d3 = data_tb[4];
        d4 = data_tb[3];
        d5 = data_tb[2];
        d6 = data_tb[1];
        d7 = data_tb[0];
       
       // Calculating Parity bits p1, p2, p4 & p8
        p1 = d1 + d2 + d4 + d5 + d7;    // 1101101
        p2 = d1 + d3 + d4 + d6 + d7;    // 1011011
        p4 = d2 + d3 + d4;              // 0111000  
        p8 = d5 + d6 + d7;              // 0000111
       
        p = d1 + d2 + d3 + d4 + d5 + d6 + d7 + p1 + p2 + p4 + p8;
        transmit_data = {p1, p2, d1, p4, d2, d3, d4, p8, d5, d6, d7, p};

	#FL;
	up.Send(transmit_data);
  $display("At time %d, Block %d transmitted Raw Data %b encoded as %b", $time, Block_ID, data_tb, transmit_data);	
  end
if (resend)
  begin
	#FL;
  $display("At time %d, Block %d re-transmitted corrected Data encoded as %b", $time, Block_ID, corrected_data);	
	up.Send(corrected_data);
	flag2 = ~flag2;
  end
end


always
begin
	#BL;
	if (resend)
	begin
	wait (flag1!=flag2);
	flag1 = flag2;   // or flag1 = ~flag1
	end
       $display("Receiving");
        down.Receive(receive_data);
       $display("Received");
        
	r1 = receive_data[11];
	r2 = receive_data[10];
	r3 = receive_data[9];
	r4 = receive_data[8];
	r5 = receive_data[7];
	r6 = receive_data[6];
	r7 = receive_data[5];
	r8 = receive_data[4];
	r9 = receive_data[3];
	r10 = receive_data[2];
	r11 = receive_data[1];
	rp = receive_data[0];

	cp1 = r1 + r3 + r5 + r7 + r9  +r11;	
	cp2 = r2 + r3 + r6 + r7 + r10 + r11;	
	cp4 = r4 + r5 + r6 + r7;	
	cp8 = r8 + r9 + r10 + r11;

        crp = rp + r1 + r2 + r3 + r4 + r5 + r6 + r7 + r8 + r9 + r10 + r11;

	case ({crp, cp8, cp4, cp2, cp1}) 
	5'b00000: decoded_data = { r3,  r5,  r6,  r7,  r9,  r10,  r11}; // Error Free
	5'b10001: decoded_data = { r3,  r5,  r6,  r7,  r9,  r10,  r11}; // p1 was in error
	5'b10010: decoded_data = { r3,  r5,  r6,  r7,  r9,  r10,  r11}; // p2 was in error
	5'b10011: decoded_data = {~r3,  r5,  r6,  r7,  r9,  r10,  r11}; // d1 was in error

	5'b10100: decoded_data = { r3,  r5,  r6,  r7,  r9,  r10,  r11}; // p3 was in error
	5'b10101: decoded_data = { r3, ~r5,  r6,  r7,  r9,  r10,  r11}; // d2 was in error
	5'b10110: decoded_data = { r3,  r5, ~r6,  r7,  r9,  r10,  r11}; // d3 was in error;
	5'b10111: decoded_data = { r3,  r5,  r6, ~r7,  r9,  r10,  r11}; // d4 was in error;

	5'b11000: decoded_data = { r3,  r5,  r6,  r7,  r9,  r10,  r11}; // p4 was in error;
	5'b11001: decoded_data = { r3,  r5,  r6,  r7, ~r9,  r10,  r11}; // d5 was in error;
	5'b11010: decoded_data = { r3,  r5,  r6,  r7,  r9, ~r10,  r11}; // d6 was in error;
	5'b11011: decoded_data = { r3,  r5,  r6,  r7,  r9,  r10, ~r11}; // d7 was in error;
  
        default: decoded_data = {r3,  r5,  r6,  r7,  r9,  r10,  r11}; // Error Free
        endcase

	assign single_bit_error = (cp1 | cp2 | cp4 | cp8) & crp;
	assign double_bit_error = (cp1 | cp2 | cp4 | cp8) & ~crp;

	assign erroneous_address = ({cp8, cp4, cp2, cp1} == 4'b1001) || ({cp8, cp4, cp2, cp1} == 4'b1010) || ({cp8, cp4, cp2, cp1} == 4'b1101);
	assign resend = single_bit_error & erroneous_address;

	assign error_position = {cp8, cp4, cp2, cp1};

	if (!single_bit_error & ~double_bit_error)
          $display("At time %d, Block %d received Encoded data %b decoded as %b with no error", $time, Block_ID, receive_data, decoded_data);	
	else if (single_bit_error)
          $display("At time %d, Block %d received Encoded data %b decoded as %b with single bit error at position %b", $time, Block_ID, receive_data, decoded_data, error_position);	
	else if (double_bit_error)
         $display("At time %d, Block %d received Encoded data %d with more than single bit errors", $time, Block_ID, receive_data);	

	if (~double_bit_error & ~erroneous_address)
	db.Send({5'b0, decoded_data});


end


always @ (*)
begin
	if ({cp8, cp4, cp2, cp1} == 4'b1001)
	corrected_data = {receive_data[11:4], ~r9, receive_data[2:0]};
	else if ({cp8, cp4, cp2, cp1} == 4'b1010)
	corrected_data = {receive_data[11:3], ~r10, receive_data[1:0]};
	else if ({cp8, cp4, cp2, cp1} == 4'b1011)
	corrected_data = {receive_data[11:2], ~r11, receive_data[0]};
end



endmodule


//Sample data_generator module
//module data_generator (interface r);
//  parameter WIDTH = 7;
//  parameter FL = 1; //ideal environment
//  parameter [2:0] SOURCE_ROUTER= 0;
//  logic [WIDTH-1:0] SendValue=0;
//  always
//  begin 
//    //add a display here to see when this module starts its main loop
////	$display("Start module data_generator %m and time is %d", $time);	
//    SendValue[2:0] = ($random() % (2**3));
//    if(SendValue[2:0] == SOURCE_ROUTER)
//      
//      SendValue[2:0] = ~SendValue[2:0];
//    SendValue[WIDTH-1:3] = $random() % (2**(WIDTH-3)); //7'b0101111;// $random() % (2**WIDTH);
//  
//    #FL;
//    //Communication action Send is about to start
//    //$display("Starting %m.Send @ %d", $time);
////    $display("Start sending from module data_gen %m at Simulation time = %d", $time);	
//    r.Send({5'b0, SendValue});
////    $display("Finish sending from module data_gen %m at Simulation time = %d", $time);	
//    //Communication action Send is finished
//    //$display("Finished %m.Send @ %d", $time);
//  end
//endmodule




//module async_block_tester();
//
//  //Interface Vector instantiation: 4-phase bundled data channel
//  Channel #(.WIDTH(12), .hsProtocol(P1of2)) intf[3:0] (); 
//  
//  //instantiate test circuit
//  data_generator #(.FL(FL), .WIDTH(7), .SOURCE_ROUTER(Block_ID))  dg1(intf[0]);
//  data_generator   dg2(intf[1]);
//
//  async_block a1 (intf[0], intf[2], intf[3]);
//  async_block a2 (intf[1], intf[3], intf[2]);
//
//
//
////  copy #(.WIDTH(1), .FL(2), .BL(6)) copy1(intf0[0], intf0[1], intf0[2]);
////  data_bucket #(.WIDTH(2)) db2(intf[2]);
//
//  initial 
//     #100 $stop;
//
//endmodule
