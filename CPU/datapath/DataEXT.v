`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:32:18 12/08/2016 
// Design Name: 
// Module Name:    DataEXT 
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
module DataEXT(
	A,Din,Op,DOut
   );
	input[1:0]A;
	input[31:0]Din;
	input[2:0]Op;
	output[31:0]DOut;
	
	assign DOut = 
		(Op==3'b001&&A==2'b00) ? {24'b0,Din[7:0]} :
		(Op==3'b001&&A==2'b01) ? {24'b0,Din[15:8]} :
		(Op==3'b001&&A==2'b10) ? {24'b0,Din[23:16]} :
		(Op==3'b001&&A==2'b11) ? {24'b0,Din[31:24]} :
		(Op==3'b010&&A==2'b00) ? Din[7] ? {-24'b1,Din[7:0]} : {24'b0,Din[7:0]} :
		(Op==3'b010&&A==2'b01) ? Din[15] ? {-24'b1,Din[15:8]} : {24'b0,Din[15:8]} :
		(Op==3'b010&&A==2'b10) ? Din[23] ? {-24'b1,Din[23:16]} : {24'b0,Din[23:16]} :
		(Op==3'b010&&A==2'b11) ? Din[31] ? {-24'b1,Din[31:24]} : {24'b0,Din[31:24]} :
		(Op==3'b011&&A[1]==1'b0) ? {16'b0,Din[15:0]} :
		(Op==3'b011&&A[1]==1'b1) ? {16'b0,Din[31:16]} :
		(Op==3'b100&&A[1]==1'b0) ? Din[15] ? {-16'b1,Din[15:0]} : {16'b0,Din[15:0]} :
		(Op==3'b100&&A[1]==1'b1) ? Din[31] ? {-16'b1,Din[31:16]} : {16'b0,Din[31:16]} :
		Din;


endmodule
