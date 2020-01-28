`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:21:14 12/09/2016 
// Design Name: 
// Module Name:    ID_EX 
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
module ID_EX(
	//signals input
	ALU_Op_in,DataEXT_Op_in,SFT_Op_in,MULDIV_Op_in,BE_Op_in,
	lui_in,Link_in,HiLo_in,Shift_in,MFHL_in,MTHL_in,Start_in,Store_in,Load_in,WriteReg_in,
	BZ_in,B2_in,Itype_in,Rtype_in,SUV_in,
	WriteAtE_in,WriteAtM_in,WriteAtW_in,
	eret_in,mfc0_in,mtc0_in,BD_in,
	//data input
	RD1_in,RD2_in,RA1_in,RA2_in,RA3_in,Waddr_in,Wdata_in,imm_in,s_in,
	PC_in,ExcCode_in,
	CP0_Wdata_in,CP0_RD_in,
	//signals output
	ALU_Op_out,DataEXT_Op_out,SFT_Op_out,MULDIV_Op_out,BE_Op_out,
	lui_out,Link_out,HiLo_out,Shift_out,MFHL_out,MTHL_out,Start_out,Store_out,Load_out,WriteReg_out,
	BZ_out,B2_out,Itype_out,Rtype_out,SUV_out,
	WriteAtE_out,WriteAtM_out,WriteAtW_out,
	eret_out,mfc0_out,mtc0_out,BD_out,
	//data output
	RD1_out,RD2_out,RA1_out,RA2_out,RA3_out,Waddr_out,Wdata_out,imm_out,s_out,
	PC_out,ExcCode_out,
	CP0_Wdata_out,CP0_RD_out,
	//control signals
	clk,flush
   );
	input clk,flush;
	input[31:0]RD1_in,RD2_in,Wdata_in,imm_in,CP0_Wdata_in,CP0_RD_in;
	input[31:2]PC_in;
	input[6:2]ExcCode_in;
	input[4:0]RA1_in,RA2_in,RA3_in,Waddr_in,s_in;
	input[3:0]ALU_Op_in;
	input[2:0]DataEXT_Op_in;
	input[1:0]SFT_Op_in,MULDIV_Op_in,BE_Op_in;
	input lui_in,Link_in,HiLo_in,Shift_in,MFHL_in,MTHL_in,Start_in,Store_in,Load_in,WriteReg_in,
			BZ_in,B2_in,Itype_in,Rtype_in,SUV_in,
			WriteAtE_in,WriteAtM_in,WriteAtW_in,
			eret_in,mfc0_in,mtc0_in,BD_in;
	output reg[31:0]RD1_out,RD2_out,Wdata_out,imm_out,CP0_Wdata_out,CP0_RD_out;
	output reg[31:2]PC_out;
	output reg[6:2]ExcCode_out;
	output reg[4:0]RA1_out,RA2_out,RA3_out,Waddr_out,s_out;
	output reg[3:0]ALU_Op_out;
	output reg[2:0]DataEXT_Op_out;
	output reg[1:0]SFT_Op_out,MULDIV_Op_out,BE_Op_out;
	output reg lui_out,Link_out,HiLo_out,Shift_out,MFHL_out,MTHL_out,Start_out,Store_out,Load_out,WriteReg_out,
				  BZ_out,B2_out,Itype_out,Rtype_out,SUV_out,
				  WriteAtE_out,WriteAtM_out,WriteAtW_out,
				  eret_out,mfc0_out,mtc0_out,BD_out;
	
	initial begin
		ALU_Op_out <= 0;
		DataEXT_Op_out <= 0;
		SFT_Op_out <= 0;
		MULDIV_Op_out <= 0;
		BE_Op_out <= 0;
		lui_out <= 0;
		Link_out <= 0;
		HiLo_out <= 0;
		Shift_out <= 0;
		MFHL_out <= 0;
		MTHL_out <= 0;
		Start_out <= 0;
		Store_out <= 0;
		Load_out <= 0;
		WriteReg_out <= 0;
		BZ_out <= 0;
		B2_out <= 0;
		Itype_out <= 0;
		Rtype_out <= 0;
		SUV_out <= 0;
		WriteAtE_out <= 0;
		WriteAtM_out <= 0;
		WriteAtW_out <= 0;
		RD1_out <= 0;
		RD2_out <= 0;
		RA1_out <= 0;
		RA2_out <= 0;
		RA3_out <= 0;
		Waddr_out <= 0;
		Wdata_out <= 0;
		imm_out <= 0;
		s_out <= 0;
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
			ALU_Op_out <= 0;
			DataEXT_Op_out <= 0;
			SFT_Op_out <= 0;
			MULDIV_Op_out <= 0;
			BE_Op_out <= 0;
			lui_out <= 0;
			Link_out <= 0;
			HiLo_out <= 0;
			Shift_out <= 0;
			MFHL_out <= 0;
			MTHL_out <= 0;
			Start_out <= 0;
			Store_out <= 0;
			Load_out <= 0;
			WriteReg_out <= 0;
			BZ_out <= 0;
			B2_out <= 0;
			Itype_out <= 0;
			Rtype_out <= 0;
			SUV_out <= 0;
			WriteAtE_out <= 0;
			WriteAtM_out <= 0;
			WriteAtW_out <= 0;
			RD1_out <= 0;
			RD2_out <= 0;
			RA1_out <= 0;
			RA2_out <= 0;
			RA3_out <= 0;
			Waddr_out <= 0;
			Wdata_out <= 0;
			imm_out <= 0;
			s_out <= 0;
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
			ALU_Op_out <= ALU_Op_in;
			DataEXT_Op_out <= DataEXT_Op_in;
			SFT_Op_out <= SFT_Op_in;
			MULDIV_Op_out <= MULDIV_Op_in;
			BE_Op_out <= BE_Op_in;
			lui_out <= lui_in;
			Link_out <= Link_in;
			HiLo_out <= HiLo_in;
			Shift_out <= Shift_in;
			MFHL_out <= MFHL_in;
			MTHL_out <= MTHL_in;
			Start_out <= Start_in;
			Store_out <= Store_in;
			Load_out <= Load_in;
			WriteReg_out <= WriteReg_in;
			BZ_out <= BZ_in;
			B2_out <= B2_in;
			Itype_out <= Itype_in;
			Rtype_out <= Rtype_in;
			SUV_out <= SUV_in;
			WriteAtE_out <= WriteAtE_in;
			WriteAtM_out <= WriteAtM_in;
			WriteAtW_out <= WriteAtW_in;
			RD1_out <= RD1_in;
			RD2_out <= RD2_in;
			RA1_out <= RA1_in;
			RA2_out <= RA2_in;
			RA3_out <= RA3_in;
			Waddr_out <= Waddr_in;
			Wdata_out <= Wdata_in;
			imm_out <= imm_in;
			s_out <= s_in;
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
