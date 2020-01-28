`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:58:13 11/17/2016 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
	branch,cmp,jump,jr,IntReq,eret,
	imm_data,PC,jr_addr,EPC,
	next_PC
   );
	input branch,cmp,jump,jr,IntReq,eret;
	input[25:0]imm_data;
	input[31:2]PC,EPC;
	input[31:0]jr_addr;
	output[31:2]next_PC;
	
	assign 
		next_PC = (IntReq) ? 30'h1060 :
					 (eret) ? EPC :
					 (jump) ? {PC[31:28],imm_data} :
					 (jr) ? jr_addr[31:2] :
					 (branch && cmp) ? ((imm_data[15]) ? PC+{-14'b1,imm_data[15:0]} : PC+{14'b0,imm_data[15:0]}) : PC+30'b1;
		
endmodule
