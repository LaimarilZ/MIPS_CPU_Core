`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:40:04 11/17/2016 
// Design Name: 
// Module Name:    PC 
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
module PC(
	next_PC,clk,rst,out,EN
   );
	input[31:2]next_PC;
	input clk,rst,EN;
	output[31:2]out;
	
	reg[31:2]PC;
	
	initial PC <= 30'hc00;
	
	always @(posedge clk or posedge rst)begin
		if(rst)begin
			PC <= 30'hc00;
		end
		else if(EN)begin
			PC <= next_PC;
		end
	end
		
	assign out = PC;
endmodule
