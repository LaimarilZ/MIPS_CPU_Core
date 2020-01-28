`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:44:51 12/09/2016 
// Design Name: 
// Module Name:    EX_MEM 
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
module EX_MEM(
	//signals input
	DataEXT_Op_in,BE_Op_in,
	Store_in,Load_in,WriteReg_in,
	WriteAtE_in,WriteAtM_in,WriteAtW_in,
	eret_in,mfc0_in,mtc0_in,BD_in,
	//data input
	RD2_in,RA1_in,RA2_in,RA3_in,Waddr_in,Wdata_in,
	PC_in,ExcCode_in,CP0_Wdata_in,CP0_RD_in,
	//signals output
	DataEXT_Op_out,BE_Op_out,
	Store_out,Load_out,WriteReg_out,
	WriteAtE_out,WriteAtM_out,WriteAtW_out,
	eret_out,mfc0_out,mtc0_out,BD_out,
	//data output
	RD2_out,RA1_out,RA2_out,RA3_out,Waddr_out,Wdata_out,
	PC_out,ExcCode_out,CP0_Wdata_out,CP0_RD_out,
	//control signals
	clk,flush
   );
	input clk,flush;
	input[31:0]RD2_in,Wdata_in,CP0_Wdata_in,CP0_RD_in;
	input[31:2]PC_in;
	input[6:2]ExcCode_in;
	input[4:0]RA1_in,RA2_in,RA3_in,Waddr_in;
	input[2:0]DataEXT_Op_in;
	input[1:0]BE_Op_in;
	input Store_in,Load_in,WriteReg_in,
			WriteAtE_in,WriteAtM_in,WriteAtW_in,
			eret_in,mfc0_in,mtc0_in,BD_in;
	output reg[31:0]RD2_out,Wdata_out,CP0_Wdata_out,CP0_RD_out;
	output reg[31:2]PC_out;
	output reg[6:2]ExcCode_out;
	output reg[4:0]RA1_out,RA2_out,RA3_out,Waddr_out;
	output reg[2:0]DataEXT_Op_out;
	output reg[1:0]BE_Op_out;
	output reg Store_out,Load_out,WriteReg_out,
				  WriteAtE_out,WriteAtM_out,WriteAtW_out,
				  eret_out,mfc0_out,mtc0_out,BD_out;

	initial begin
		DataEXT_Op_out <= 0;
		BE_Op_out <= 0;
		Store_out <= 0;
		Load_out <= 0;
		WriteReg_out <= 0;
		WriteAtE_out <= 0;
		WriteAtM_out <= 0;
		WriteAtW_out <= 0;
		RD2_out <= 0;
		RA1_out <= 0;
		RA2_out <= 0;
		RA3_out <= 0;
		Waddr_out <= 0;
		Wdata_out <= 0;
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
		if(flush)begin
			DataEXT_Op_out <= 0;
			BE_Op_out <= 0;
			Store_out <= 0;
			Load_out <= 0;
			WriteReg_out <= 0;
			WriteAtE_out <= 0;
			WriteAtM_out <= 0;
			WriteAtW_out <= 0;
			RD2_out <= 0;
			RA1_out <= 0;
			RA2_out <= 0;
			RA3_out <= 0;
			Waddr_out <= 0;
			Wdata_out <= 0;
			PC_out <= 32'hc00;
			ExcCode_out <= 0;
			eret_out <= 0;
			mfc0_out <= 0;
			mtc0_out <= 0;
			CP0_Wdata_out <= 0;
			CP0_RD_out <= 0;
			BD_out <= 0;
		end
		else begin
			DataEXT_Op_out <= DataEXT_Op_in;
			BE_Op_out <= BE_Op_in;
			Store_out <= Store_in;
			Load_out <= Load_in;
			WriteReg_out <= WriteReg_in;
			WriteAtE_out <= WriteAtE_in;
			WriteAtM_out <= WriteAtM_in;
			WriteAtW_out <= WriteAtW_in;
			RD2_out <= RD2_in;
			RA1_out <= RA1_in;
			RA2_out <= RA2_in;
			RA3_out <= RA3_in;
			Waddr_out <= Waddr_in;
			Wdata_out <= Wdata_in;
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
