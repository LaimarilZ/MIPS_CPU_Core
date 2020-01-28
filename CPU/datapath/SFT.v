`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:38:50 12/08/2016 
// Design Name: 
// Module Name:    SFT 
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
module SFT(
	in,s,op,out
   );
	input[31:0]in;
	input[4:0]s;
	input[1:0]op;
	output[31:0]out;
	
	assign out = 
		(op==2'b01) ? in << s :
		(op==2'b10) ? in >> s :
		(op==2'b11) ? in[31] ? ~((~in)>>s) : in >> s
		: 0;


endmodule
