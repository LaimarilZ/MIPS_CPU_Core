`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:11:42 11/17/2016 
// Design Name: 
// Module Name:    IM 
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
module IM(
	addr,out
   );
	input[12:2]addr;
	output[31:0]out;
	
	reg[31:0]im[0:2047];
	integer i;
	
	initial begin
		for(i=0;i<2048;i=i+1) im[i]=0;
		$readmemh("code.txt",im,11'hc00);
		$readmemh("handler.txt",im,11'h1060);
	end
	
	assign out = im[addr];

endmodule
