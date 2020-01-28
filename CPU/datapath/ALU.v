`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:10:27 12/07/2016 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
	A,B,Op,C,Over
   );
	input[31:0]A,B;
	input[3:0]Op;
	output[31:0]C;
	output Over;
	
	assign C = 
		(Op==4'b0000) ? A :											//无操作
		(Op==4'b0001) ? A+B :										//无符号加
		(Op==4'b0010) ? A+B :										//加
		(Op==4'b0011) ? A-B :										//无符号减
		(Op==4'b0100) ? A-B :										//减
		(Op==4'b0101) ? A&B :										//与
		(Op==4'b0110) ? A|B :										//或
		(Op==4'b0111) ? ~(A|B) :									//或非
		(Op==4'b1000) ? A^B : 										//异或
		(Op==4'b1001) ? {31'b0,A<B} :								//无符号小于置位
		(Op==4'b1010) ? {31'b0,(A[31]==B[31])?A<B:~(A<B)} ://小于置位
		A;
		
	assign Over = 
		((Op==4'b0010)&&((!A[31]&&!B[31]&&C[31])||(A[31]&&B[31]&&!C[31])))||
		((Op==4'b0100)&&((!A[31]&&B[31]&&C[31])||(A[31]&&!B[31]&&!C[31])));

endmodule
