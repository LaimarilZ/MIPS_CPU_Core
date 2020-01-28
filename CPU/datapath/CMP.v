`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:00:01 12/07/2016 
// Design Name: 
// Module Name:    CMP 
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
module CMP(
	A,B,Op,Br
   );
	input[31:0]A,B;
	input[2:0]Op;
	output Br;
	
	assign Br = 
		(Op==3'b001) ? (A[31]==B[31]) ? A<B : ~(A<B) :
		(Op==3'b010) ? (A[31]==B[31]) ? A<=B : ~(A<=B) :
		(Op==3'b011) ? A==B :
		(Op==3'b100) ? A!=B :
		(Op==3'b101) ? (A[31]==B[31]) ? A>=B : ~(A>=B) :
		(Op==3'b110) ? (A[31]==B[31]) ? A>B : ~(A>B) :
		1'b0;

endmodule
