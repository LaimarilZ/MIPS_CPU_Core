`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:20:45 11/17/2016 
// Design Name: 
// Module Name:    GPR 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module GPR(
	A1,A2,A3,WD,We,Clk,Rst,
	RD1,RD2
   );
	input[4:0]A1,A2,A3;
	input[31:0]WD;
	input We,Clk,Rst;
	output[31:0]RD1,RD2;
	//internal variables
	reg[31:0]RF[31:1];
	integer i;
	//initialize
	initial for(i=1;i<32;i=i+1) RF[i] <= 0;
	//read
	assign RD1 = (A1==0) ? 0 : (A1==A3) ? WD : RF[A1];
	assign RD2 = (A2==0) ? 0 : (A2==A3) ? WD : RF[A2];
	//write & reset
	always @(negedge Clk or posedge Rst) begin
		if(Rst)
			for(i=1;i<32;i=i+1) RF[i] <= 0;
		else if(We&&A3!=5'b0)begin
			$display("$%d <= %x", A3, WD);
			RF[A3] <= WD;
		end
	end
		
endmodule
