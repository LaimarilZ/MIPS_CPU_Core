`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:58:47 12/09/2016 
// Design Name: 
// Module Name:    MEM_WB 
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
module MEM_WB(
	//signals input
	WriteReg_in,
	WriteAtE_in,WriteAtM_in,WriteAtW_in,
	eret_in,mfc0_in,mtc0_in,BD_in,
	//data input
	Waddr_in,Wdata_in,
	PC_in,ExcCode_in,CP0_Wdata_in,CP0_RD_in,
	//signals output
	WriteReg_out,
	WriteAtE_out,WriteAtM_out,WriteAtW_out,
	eret_out,mfc0_out,mtc0_out,BD_out,
	//data output
	Waddr_out,Wdata_out,
	PC_out,ExcCode_out,CP0_Wdata_out,CP0_RD_out,
	//control signals
	clk,EN
   );
	input clk,EN;
	input[31:0]Wdata_in,CP0_Wdata_in,CP0_RD_in;
	input[31:2]PC_in;
	input[6:2]ExcCode_in;
	input[4:0]Waddr_in;
	input WriteReg_in,WriteAtE_in,WriteAtM_in,WriteAtW_in,
			eret_in,mfc0_in,mtc0_in,BD_in;
	output reg[31:0]Wdata_out,CP0_Wdata_out,CP0_RD_out;
	output reg[31:2]PC_out;
	output reg[6:2]ExcCode_out;
	output reg[4:0]Waddr_out;
	output reg WriteReg_out,WriteAtE_out,WriteAtM_out,WriteAtW_out,
				  eret_out,mfc0_out,mtc0_out,BD_out;
	
	initial begin
		Wdata_out <= 0;
		Waddr_out <= 0;
		WriteReg_out <= 0;
		WriteAtE_out <= 0;
		WriteAtM_out <= 0;
		WriteAtW_out <= 0;
		PC_out <= 32'hc00;
		ExcCode_out <= 0;
		eret_out <= 0;
		mfc0_out <= 0;
		mtc0_out <= 0;
		CP0_Wdata_out <= 0;
		CP0_RD_out <= 0;
		BD_out <= 0;
	end
	
	always @(posedge clk)begin
		if(EN)begin
			Wdata_out <= Wdata_in;
			Waddr_out <= Waddr_in;
			WriteReg_out <= WriteReg_in;
			WriteAtE_out <= WriteAtE_in;
			WriteAtM_out <= WriteAtM_in;
			WriteAtW_out <= WriteAtW_in;
			PC_out <= PC_in;
			ExcCode_out <= ExcCode_in;
			eret_out <= eret_in;
			mfc0_out <= mfc0_in;
			mtc0_out <= mtc0_in;
			CP0_Wdata_out <= CP0_Wdata_in;
			CP0_RD_out <= CP0_RD_in;
			BD_out <= BD_in;
		end
	end
endmodule
