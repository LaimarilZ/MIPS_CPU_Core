`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:52:40 12/08/2016 
// Design Name: 
// Module Name:    CPU 
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
module CPU(
	clk,clk2x,rst,
	PrRD,HWInt,
	PrWD,PrAddr,PrBE,PrWE
   );
	input clk,clk2x,rst;
	input[31:0]PrRD;
	input[7:2]HWInt;
	output[31:0]PrWD;
	output[31:2]PrAddr;
	output[3:0]PrBE;
	output PrWE;
	
///////////////////////////////////////////////////
//						Internal Signals					 //
///////////////////////////////////////////////////
//hazard control signals
	wire STALL;
	wire FWD_E_D_rs,FWD_E_D_rt,
		  FWD_M_D_rs,FWD_M_D_rt,
		  FWD_M_E_rs,FWD_M_E_rt,
		  FWD_W_E_rs,FWD_W_E_rt,
		  FWD_W_M_rt;
		  
//interrupt control signals
	wire[31:2]CP0_PC,EPC;
	wire IntReq;
	
//signals in F stage
	wire[31:2]PC_F;
	wire[31:0]instr_F;

//signals in D stage
	wire[31:0]instr_D,CMP_A,CMP_B,RD1_D,RD2_D,Wdata_D,
				 CP0_RD_D,CP0_Wdata_D;
	wire[31:2]next_PC,PC_D;
	wire[6:2]ExcCode_D;
	wire[4:0]Waddr_D;
	wire[3:0]ALU_Op_D;
	wire[2:0]CMP_Op_D,DataEXT_Op_D;
	wire[1:0]SFT_Op_D,MULDIV_Op_D,BE_Op_D;
	wire Jump_D,jr_D,Branch_D,WriteRt_D,Write31_D,lui_D,Link_D,LogicI_D,HiLo_D,Shift_D,MFHL_D,MTHL_D,Start_D,Store_D,Load_D,WriteReg_D,
		  BZ_D,B2_D,Itype_D,Rtype_D,SUV_D,
		  WriteAtE_D,WriteAtM_D,WriteAtW_D,
		  MULDIV_s_D,
		  mfc0_D,mtc0_D,eret_D,BD_D;

//signals in E stage
	wire[31:0]RD1_E1,RD1_E2,RD2_E1,RD2_E2,RD2_E3,ALU_out,SFT_out,Wdata_E1,Wdata_E2,imm_E,HI,LO,HILO_out,out_E,
				 CP0_RD_E,CP0_Wdata_E;
	wire[31:2]PC_E;
	wire[6:2]ExcCode_E1,ExcCode_E2;
	wire[4:0]s_E,SFT_s,RA1_E,RA2_E,RA3_E,Waddr_E;
	wire[3:0]ALU_Op_E;
	wire[2:0]DataEXT_Op_E;
	wire[1:0]SFT_Op_E,MULDIV_Op_E,BE_Op_E;
	wire lui_E,Link_E,HiLo_E,Shift_E,MFHL_E,MTHL_E,Start_E,
		  Store_E,Load_E,WriteReg_E,
		  BZ_E,B2_E,Itype_E,Rtype_E,SUV_E,
		  WriteAtE_E,WriteAtM_E,WriteAtW_E,
		  Busy,ALU_Over,
		  mfc0_E,mtc0_E,eret_E,BD_E;
	
//signals in M stage
	wire[31:0]RD2_M,DM_Wdata,DM_out,Wdata_M1,Wdata_M2,DataEXT_out,
				 CP0_RD_M,CP0_Wdata_M;
	wire[31:2]PC_M;
	wire[6:2]ExcCode_M1,ExcCode_M2;
	wire[4:0]RA1_M,RA2_M,RA3_M,Waddr_M;
	wire[3:0]BE;
	wire[2:0]DataEXT_Op_M;
	wire[1:0]BE_Op_M;
	wire Store_M,Load_M,WriteReg_M,WriteAtE_M,WriteAtM_M,WriteAtW_M,
		  mfc0_M,mtc0_M,eret_M,BD_M;
	
//signals in W stage
	wire[31:0]Wdata_W,
				 CP0_RD_W,CP0_Wdata_W;
	wire[31:2]PC_W;
	wire[6:2]ExcCode_W;
	wire[4:0]Waddr_W;
	wire WriteReg_W,WriteAtE_W,WriteAtM_W,WriteAtW_W,
		  mfc0_W,mtc0_W,eret_W,BD_W;
	
///////////////////////////////////////////////////
//						Hazard Controller					 //
///////////////////////////////////////////////////
	stall_controller stall_controller(
		//data-demand classify signals
		.BZ_D(BZ_D),
		.jr_D(jr_D),
		.B2_D(B2_D),
		.Itype_D(Itype_D),
		.MTHL_D(MTHL_D),
		.Rtype_D(Rtype_D),
		.SUV_D(SUV_D),
		.Store_D(Store_D),
		//data-produce classify signals
		.WriteAtM_E(WriteAtM_E),
		.WriteAtW_E(WriteAtW_E),
		.WriteAtW_M(WriteAtW_M),
		//status signals
		.WriteReg_E(WriteReg_E),
		.WriteReg_M(WriteReg_M),
		.Busy(Busy),
		.MULDIV_s_D(MULDIV_s_D),
		//register address
		.RA1_D(instr_D[25:21]),
		.RA2_D(instr_D[20:16]),
		.Waddr_E(Waddr_E),
		.Waddr_M(Waddr_M),
		//output signal
		.STALL(STALL)
	);
	
	forward_controller forward_controller(
		//data-demand classify signals
		.BZ_D(BZ_D),
		.jr_D(jr_D),
		.B2_D(B2_D),
		.Itype_E(Itype_E),
		.MTHL_E(MTHL_E),
		.Rtype_E(Rtype_E),
		.SUV_E(SUV_E),
		.Store_E(Store_E),
		.mtc0_E(mtc0_E),
		.Store_M(Store_M),
		.mtc0_M(mtc0_M),
		//write register signals
		.WriteReg_E(WriteReg_E),
		.WriteReg_M(WriteReg_M),
		.WriteReg_W(WriteReg_W),
		//register address
		.RA1_D(instr_D[25:21]),
		.RA2_D(instr_D[20:16]),
		.RA1_E(RA1_E),
		.RA2_E(RA2_E),
		.RA1_M(RA1_M),
		.RA2_M(RA2_M),
		.Waddr_E(Waddr_E),
		.Waddr_M(Waddr_M),
		.Waddr_W(Waddr_W),
		//forward control signals
		.FWD_E_D_rs(FWD_E_D_rs),
		.FWD_E_D_rt(FWD_E_D_rt),
		.FWD_M_D_rs(FWD_M_D_rs),
		.FWD_M_D_rt(FWD_M_D_rt),
		.FWD_M_E_rs(FWD_M_E_rs),
		.FWD_M_E_rt(FWD_M_E_rt),
		.FWD_W_E_rs(FWD_W_E_rs),
		.FWD_W_E_rt(FWD_W_E_rt),
		.FWD_W_M_rt(FWD_W_M_rt)
   );

///////////////////////////////////////////////////
//				instruction	Fetching stage				 //
///////////////////////////////////////////////////
	PC PC(
		.next_PC(next_PC),
		.clk(clk),
		.rst(rst),
		.out(PC_F),
		.EN(~STALL)
	);
	
	RAM_IM RAM_IM(
		.clka(clk2x),
		.wea(4'b0),
		.addra(PC_F[14:2]),
		.dina(32'b0),
		.douta(instr_F)
	);

///////////////////////////////////////////////////
//				instruction	Decoding stage				 //
///////////////////////////////////////////////////
	IF_ID IF_ID(
		.instr_in(instr_F),
		.PC_in(PC_F),
		.instr_out(instr_D),
		.PC_out(PC_D),
		.clk(clk),
		.EN(~STALL),
		.flush(IntReq||eret_D)
	);
	
	controller controller(
		.clk(clk),
		.opcode(instr_D[31:26]),
		.funct(instr_D[5:0]),
		.special(instr_D[20:16]),
		.rs(instr_D[25:21]),
		.Jump(Jump_D),
		.jr(jr_D),
		.Branch(Branch_D),
		.CMP_Op(CMP_Op_D),
		.WriteRt(WriteRt_D),
		.Write31(Write31_D),
		.lui(lui_D),
		.Link(Link_D),
		.LogicI(LogicI_D),
		.ALU_Op(ALU_Op_D),
		.SFT_Op(SFT_Op_D),
		.MULDIV_Op(MULDIV_Op_D),
		.HiLo(HiLo_D),
		.Shift(Shift_D),
		.MFHL(MFHL_D),
		.MTHL(MTHL_D),
		.Start(Start_D),
		.BE_Op(BE_Op_D),
		.Store(Store_D),
		.Load(Load_D),
		.DataEXT_Op(DataEXT_Op_D),
		.WriteReg(WriteReg_D),
		.BZ(BZ_D),
		.B2(B2_D),
		.Itype(Itype_D),
		.Rtype(Rtype_D),
		.SUV(SUV_D),
		.WriteAtE(WriteAtE_D),
		.WriteAtM(WriteAtM_D),
		.WriteAtW(WriteAtW_D),
		.MULDIV_s(MULDIV_s_D),
		.mtc0(mtc0_D),
		.mfc0(mfc0_D),
		.eret(eret_D),
		.BD(BD_D)
	);
	
	GPR GPR(
		.A1(instr_D[25:21]),
		.A2(instr_D[20:16]),
		.A3(Waddr_W),
		.WD(Wdata_W),
		.We(WriteReg_W),
		.Clk(clk),
		.Rst(rst),
		.RD1(RD1_D),
		.RD2(RD2_D)
	);
	
	mux_32b_2sig MUX_CMP_A(
		.A(Wdata_E1),
		.B(Wdata_M1),
		.C(RD1_D),
		.s1(FWD_E_D_rs),
		.s2(FWD_M_D_rs),
		.out(CMP_A)
	);
	
	mux_32b_3sig MUX_CMP_B(
		.A(Wdata_E1),
		.B(Wdata_M1),
		.C(32'b0),
		.D(RD2_D),
		.s1(FWD_E_D_rt),
		.s2(FWD_M_D_rt),
		.s3(BZ_D),
		.out(CMP_B)
	);
	
	CMP CMP(
		.A(CMP_A),
		.B(CMP_B),
		.Op(CMP_Op_D),
		.Br(CMP_out)
	);
	
	//需要处理D级异常的时候，将此处替换为多选器
	assign ExcCode_D = 0;
	
	NPC NPC(
		.branch(Branch_D),
		.cmp(CMP_out),
		.jump(Jump_D),
		.jr(jr_D),
		.IntReq(IntReq),
		.eret(eret_D),
		.imm_data(instr_D[25:0]),
		.PC(PC_F),
		.jr_addr(CMP_A),
		.EPC(EPC),
		.next_PC(next_PC)
	);
	
	mux_5b_2sig MUX_Waddr_D(
		.A(instr_D[20:16]),
		.B(5'b11111),
		.C(instr_D[15:11]),
		.s1(WriteRt_D),
		.s2(Write31_D),
		.out(Waddr_D)
	);
	
	mux_32b_2sig MUX_Wdata_D(
		.A({instr_D[15:0],16'b0}),
		.B({PC_D+30'd2,2'b0}),
		.C(32'b0),
		.s1(lui_D),
		.s2(Link_D),
		.out(Wdata_D)
	);
	
///////////////////////////////////////////////////
//						Executing stage					 //
///////////////////////////////////////////////////
	ID_EX ID_EX(
		//signals input
		.ALU_Op_in(ALU_Op_D),
		.DataEXT_Op_in(DataEXT_Op_D),
		.SFT_Op_in(SFT_Op_D),
		.MULDIV_Op_in(MULDIV_Op_D),
		.BE_Op_in(BE_Op_D),
		.lui_in(lui_D),
		.Link_in(Link_D),
		.HiLo_in(HiLo_D),
		.Shift_in(Shift_D),
		.MFHL_in(MFHL_D),
		.MTHL_in(MTHL_D),
		.Start_in(Start_D),
		.Store_in(Store_D),
		.Load_in(Load_D),
		.WriteReg_in(WriteReg_D),
		.BZ_in(BZ_D),
		.B2_in(B2_D),
		.Itype_in(Itype_D),
		.Rtype_in(Rtype_D),
		.SUV_in(SUV_D),
		.WriteAtE_in(WriteAtE_D),
		.WriteAtM_in(WriteAtM_D),
		.WriteAtW_in(WriteAtW_D),
		.eret_in(eret_D),
		.mfc0_in(mfc0_D),
		.mtc0_in(mtc0_D),
		.BD_in(BD_D),
		//data input
		.RD1_in(RD1_D),
		.RD2_in(RD2_D),
		.RA1_in(instr_D[25:21]),
		.RA2_in(instr_D[20:16]),
		.RA3_in(instr_D[15:11]),
		.Waddr_in(Waddr_D),
		.Wdata_in(Wdata_D),
		.imm_in(LogicI_D?{16'b0,instr_D[15:0]}:instr_D[15]?{-16'b1,instr_D[15:0]}:{16'b0,instr_D[15:0]}),
		.s_in(instr_D[10:6]),
		.PC_in(PC_D),
		.ExcCode_in(ExcCode_D),
		//signals output
		.ALU_Op_out(ALU_Op_E),
		.DataEXT_Op_out(DataEXT_Op_E),
		.SFT_Op_out(SFT_Op_E),
		.MULDIV_Op_out(MULDIV_Op_E),
		.BE_Op_out(BE_Op_E),
		.lui_out(lui_E),
		.Link_out(Link_E),
		.HiLo_out(HiLo_E),
		.Shift_out(Shift_E),
		.MFHL_out(MFHL_E),
		.MTHL_out(MTHL_E),
		.Start_out(Start_E),
		.Store_out(Store_E),
		.Load_out(Load_E),
		.WriteReg_out(WriteReg_E),
		.BZ_out(BZ_E),
		.B2_out(B2_E),
		.Itype_out(Itype_E),
		.Rtype_out(Rtype_E),
		.SUV_out(SUV_E),
		.WriteAtE_out(WriteAtE_E),
		.WriteAtM_out(WriteAtM_E),
		.WriteAtW_out(WriteAtW_E),
		.eret_out(eret_E),
		.mfc0_out(mfc0_E),
		.mtc0_out(mtc0_E),
		.BD_out(BD_E),
		//data output
		.RD1_out(RD1_E1),
		.RD2_out(RD2_E1),
		.RA1_out(RA1_E),
		.RA2_out(RA2_E),
		.RA3_out(RA3_E),
		.Waddr_out(Waddr_E),
		.Wdata_out(Wdata_E1),
		.imm_out(imm_E),
		.s_out(s_E),
		.PC_out(PC_E),
		.ExcCode_out(ExcCode_E1),
		//control signals
		.clk(clk),
		.flush(STALL||IntReq)
	);
	
	mux_32b_2sig MUX_RD1_E2(
		.A(Wdata_M1),
		.B(Wdata_W),
		.C(RD1_E1),
		.s1(FWD_M_E_rs),
		.s2(FWD_W_E_rs),
		.out(RD1_E2)
	);
	
	mux_32b_3sig MUX_RD2_E2(
		.A(imm_E),
		.B(Wdata_M1),
		.C(Wdata_W),
		.D(RD2_E1),
		.s1(Itype_E||Store_E),
		.s2(FWD_M_E_rt),
		.s3(FWD_W_E_rt),
		.out(RD2_E2)
	);
	
	mux_32b_1sig MUX_RD2_E3(
		.A(Wdata_W),
		.B(RD2_E1),
		.s1(FWD_W_E_rt),
		.out(RD2_E3)
	);
	
	ALU ALU(
		.A(RD1_E2),
		.B(RD2_E2),
		.Op(ALU_Op_E),
		.C(ALU_out),
		.Over(ALU_Over)
	);
	
	mux_5b_1sig MUX_SFT_s(
		.A(s_E),
		.B(RD1_E2[4:0]),
		.s1(SUV_E),
		.out(SFT_s)
	);
	
	SFT SFT(
		.in(RD2_E2),
		.s(SFT_s),
		.op(SFT_Op_E),
		.out(SFT_out)
	);
	
	MULDIV MULDIV(
		.Clk(clk),
		.Rst(rst),
		.D1(RD1_E2),
		.D2(RD2_E2),
		.HiLo(HiLo_E),
		.Op(MULDIV_Op_E),
		.Start(Start_E&&(~IntReq)),
		.We(MTHL_E),
		.Busy(Busy),
		.HI(HI),
		.LO(LO)
	);
	
	mux_32b_1sig MUX_HILO_out(
		.A(HI),
		.B(LO),
		.s1(HiLo_E),
		.out(HILO_out)
	);
	
	mux_32b_2sig MUX_out_E(
		.A(SFT_out),
		.B(HILO_out),
		.C(ALU_out),
		.s1(Shift_E),
		.s2(MFHL_E),
		.out(out_E)
	);
	
	mux_32b_1sig MUX_Wdata_E2(
		.A(Wdata_E1),
		.B(out_E),
		.s1(lui_E||Link_E),
		.out(Wdata_E2)
	);
	
	//添加其它异常的时候把此处替换为多选器
	assign ExcCode_E2 = ExcCode_E1;

///////////////////////////////////////////////////
//					Memmory accessing stage				 //
///////////////////////////////////////////////////
	EX_MEM EX_MEM(
		//signals input
		.DataEXT_Op_in(DataEXT_Op_E),
		.BE_Op_in(BE_Op_E),
		.Store_in(Store_E),
		.Load_in(Load_E),
		.WriteReg_in(WriteReg_E),
		.WriteAtE_in(WriteAtE_E),
		.WriteAtM_in(WriteAtM_E),
		.WriteAtW_in(WriteAtW_E),
		.eret_in(eret_E),
		.mfc0_in(mfc0_E),
		.mtc0_in(mtc0_E),
		.BD_in(BD_E),
		//data input
		.RD2_in(RD2_E3),
		.RA1_in(RA1_E),
		.RA2_in(RA2_E),
		.RA3_in(RA3_E),
		.Waddr_in(Waddr_E),
		.Wdata_in(Wdata_E2),
		.PC_in(PC_E),
		.ExcCode_in(ExcCode_E2),
		//signals output
		.DataEXT_Op_out(DataEXT_Op_M),
		.BE_Op_out(BE_Op_M),
		.Store_out(Store_M),
		.Load_out(Load_M),
		.WriteReg_out(WriteReg_M),
		.WriteAtE_out(WriteAtE_M),
		.WriteAtM_out(WriteAtM_M),
		.WriteAtW_out(WriteAtW_M),
		.eret_out(eret_M),
		.mfc0_out(mfc0_M),
		.mtc0_out(mtc0_M),
		.BD_out(BD_M),
		//data output
		.RD2_out(RD2_M),
		.RA1_out(RA1_M),
		.RA2_out(RA2_M),
		.RA3_out(RA3_M),
		.Waddr_out(Waddr_M),
		.Wdata_out(Wdata_M1),
		.PC_out(PC_M),
		.ExcCode_out(ExcCode_M1),
		//control signals
		.clk(clk),
		.flush(IntReq)
	);
	
	BE_EXT BE_EXT(
		.A(Wdata_M1[1:0]),
		.Op(BE_Op_M),
		.BE(BE)
	);
	
	mux_32b_1sig MUX_DM_Wdata(
		.A(Wdata_W),
		.B(RD2_M),
		.s1(FWD_W_M_rt),
		.out(DM_Wdata)
	);
	
	//I/O SOCKET
	assign PrBE = BE;
	assign PrWD = DM_Wdata;
	assign PrAddr = Wdata_M1[31:2];
	assign PrWE = Store_M&&(~IntReq);
	
	DataEXT DataEXT(
		.A(Wdata_M1[1:0]),
		.Din(PrRD),
		.Op(DataEXT_Op_M),
		.DOut(DataEXT_out)
	);
	
	//添加其它异常的时候把此处替换为多选器
	assign ExcCode_M2 = ExcCode_M1;
	
	mux_30b_2sig MUX_CP0_PC(
		.A(PC_W),
		.B(PC_E),
		.C(PC_M),
		.s1(BD_M),
		.s2(eret_W),
		.out(CP0_PC)
	);
	
	CP0 CP0(
		.clk(clk),
		.rst(rst),
		.A(RA3_M),
		.Din(DM_Wdata),
		.PC(CP0_PC),
		.ExcCode(ExcCode_M2),
		.HWInt(HWInt),
		.We(mtc0_M&&(~IntReq)),
		.BD(BD_M),
		.EXLSet(IntReq),
		.EXLClr(eret_M),
		.IntReq(IntReq),
		.EPC(EPC),
		.Dout(CP0_RD_M)
	);
	
	mux_32b_2sig MUX_Wdata_M2(
		.A(DataEXT_out),
		.B(CP0_RD_M),
		.C(Wdata_M1),
		.s1(Load_M),
		.s2(mfc0_M),
		.out(Wdata_M2)
	);

///////////////////////////////////////////////////
//						Writeback stage					 //
///////////////////////////////////////////////////
	MEM_WB MEM_WB(
		//signals input
		.WriteReg_in(WriteReg_M),
		.WriteAtE_in(WriteAtE_M),
		.WriteAtM_in(WriteAtM_M),
		.WriteAtW_in(WriteAtW_M),
		.eret_in(eret_M),
		.mfc0_in(mfc0_M),
		.mtc0_in(mtc0_M),
		.BD_in(BD_M),
		//data input
		.Waddr_in(Waddr_M),
		.Wdata_in(Wdata_M2),
		.PC_in(PC_M),
		.ExcCode_in(ExcCode_M2),
		.CP0_Wdata_in(CP0_Wdata_M),
		.CP0_RD_in(CP0_RD_M),
		//signals output
		.WriteReg_out(WriteReg_W),
		.WriteAtE_out(WriteAtE_W),
		.WriteAtM_out(WriteAtM_W),
		.WriteAtW_out(WriteAtW_W),
		.eret_out(eret_W),
		.mfc0_out(mfc0_W),
		.mtc0_out(mtc0_W),
		.BD_out(BD_W),
		//data output
		.Waddr_out(Waddr_W),
		.Wdata_out(Wdata_W),
		.PC_out(PC_W),
		.ExcCode_out(ExcCode_W),
		.CP0_Wdata_out(CP0_Wdata_W),
		.CP0_RD_out(CP0_RD_W),
		//control signals
		.clk(clk),
		.EN(~IntReq)
	);
	
endmodule
