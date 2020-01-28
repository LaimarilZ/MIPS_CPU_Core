`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:55:37 11/25/2016 
// Design Name: 
// Module Name:    MUX 
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
module mux_32b_1sig(
	A,B,
	s1,
	out
	);
	input[31:0]A,B;
	input s1;
	output[31:0]out;
	
	assign out = (s1) ? A : B;

endmodule

module mux_5b_1sig(
	A,B,
	s1,
	out
	);
	input[4:0]A,B;
	input s1;
	output[4:0]out;
	
	assign out = (s1) ? A : B;

endmodule

module mux_5b_2sig(
	A,B,C,
	s1,s2,
	out
   );
	input[4:0]A,B,C;
	input s1,s2;
	output[4:0]out;
	
	assign out = 
		(s1) ? A :
		(s2) ? B : C;

endmodule

module mux_32b_2sig(
	A,B,C,
	s1,s2,
	out
   );
	input[31:0]A,B,C;
	input s1,s2;
	output[31:0]out;
	
	assign out = 
		(s1) ? A :
		(s2) ? B : C;

endmodule

module mux_30b_2sig(
	A,B,C,
	s1,s2,
	out
	);
	input[31:2]A,B,C;
	input s1,s2;
	output[31:2]out;
	
	assign out = (s1) ? A :
					 (s2) ? B : C;

endmodule

module mux_32b_3sig(
	A,B,C,D,
	s1,s2,s3,
	out
   );
	input[31:0]A,B,C,D;
	input s1,s2,s3;
	output[31:0]out;
	
	assign out = 
		(s1) ? A :
		(s2) ? B : 
		(s3) ? C : D;

endmodule

module mux_32b_5sig(
	A,B,C,D,E,F,
	s1,s2,s3,s4,s5,
	out
   );
	input[31:0]A,B,C,D,E,F;
	input s1,s2,s3,s4,s5;
	output[31:0]out;
	
	assign out = 
		(s1) ? A :
		(s2) ? B : 
		(s3) ? C :
		(s4) ? D :
		(s5) ? E : F;

endmodule
