`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:10:50 12/09/2016 
// Design Name: 
// Module Name:    IF_ID 
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
module IF_ID(
	instr_in,PC_in,
	instr_out,PC_out,
	EN,clk,flush
   );
	input[31:0]instr_in;
	input[31:2]PC_in;
	input EN,clk,flush;
	output reg[31:0]instr_out;
	output reg[31:2]PC_out;
	
	initial begin
		instr_out <= 0;
		PC_out <= 32'hc00;
	end
	
	always@(posedge clk)
		if(flush) begin
			instr_out <= 0;
			PC_out <= 32'hc00;
		end
		else if(EN)begin
			instr_out <= instr_in;
			PC_out <= PC_in;
		end

endmodule
