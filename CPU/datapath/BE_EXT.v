`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:49:19 12/07/2016 
// Design Name: 
// Module Name:    BE_EXT 
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
module BE_EXT(
	A,Op,BE
   );
	input[1:0]A;
	input[1:0]Op;
	output[3:0]BE;
	
	assign BE = 
		(Op==2'b01&&A==2'b00) ? 4'b0001 :
		(Op==2'b01&&A==2'b01) ? 4'b0010 :
		(Op==2'b01&&A==2'b10) ? 4'b0100 :
		(Op==2'b01&&A==2'b11) ? 4'b1000 :
		(Op==2'b10&&A[1]==2'b0) ? 4'b0011 :
		(Op==2'b10&&A[1]==2'b1) ? 4'b1100 :
		(Op==2'b11) ? 4'b1111 :
		4'b0000;
		

endmodule
