`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:33:34 12/09/2016 
// Design Name: 
// Module Name:    forward_controller 
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
`define DMD_rs_D_fwd (BZ_D||jr_D||B2_D)
`define DMD_rt_D_fwd (B2_D)
`define DMD_rs_E_fwd (Itype_E||MTHL_E||Rtype_E||Store_E)
`define DMD_rt_E_fwd (Rtype_E||SUV_E||Store_E||mtc0_E)
`define DMD_rt_M_fwd (Store_M||mtc0_M)
module forward_controller(
	//data-demand classify signals
	BZ_D,jr_D,B2_D,
	Itype_E,MTHL_E,Rtype_E,SUV_E,Store_E,mtc0_E,
	Store_M,mtc0_M,
	//write register signals
	WriteReg_E,WriteReg_M,WriteReg_W,
	//register address
	RA1_D,RA2_D,RA1_E,RA2_E,RA1_M,RA2_M,
	Waddr_E,Waddr_M,Waddr_W,
	//forward control signals
	FWD_E_D_rs,FWD_E_D_rt,
	FWD_M_D_rs,FWD_M_D_rt,
	FWD_M_E_rs,FWD_M_E_rt,
	FWD_W_E_rs,FWD_W_E_rt,
	FWD_W_M_rt
   );
	input BZ_D,jr_D,B2_D,
			Itype_E,MTHL_E,Rtype_E,SUV_E,Store_E,mtc0_E,
			Store_M,mtc0_M,
			WriteReg_E,WriteReg_M,WriteReg_W;
	input[4:0]RA1_D,RA2_D,RA1_E,RA2_E,RA1_M,RA2_M,
				 Waddr_E,Waddr_M,Waddr_W;
	output FWD_E_D_rs,FWD_E_D_rt,
			 FWD_M_D_rs,FWD_M_D_rt,
		 	 FWD_M_E_rs,FWD_M_E_rt,
		 	 FWD_W_E_rs,FWD_W_E_rt,
			 FWD_W_M_rt;
	
	assign FWD_E_D_rs = (`DMD_rs_D_fwd&&WriteReg_E&&(RA1_D==Waddr_E)&&Waddr_E!=0);
	assign FWD_E_D_rt = (`DMD_rt_D_fwd&&WriteReg_E&&(RA2_D==Waddr_E)&&Waddr_E!=0);
	assign FWD_M_D_rs = (`DMD_rs_D_fwd&&WriteReg_M&&(RA1_D==Waddr_M)&&Waddr_M!=0);
	assign FWD_M_D_rt = (`DMD_rt_D_fwd&&WriteReg_M&&(RA2_D==Waddr_M)&&Waddr_M!=0);
	assign FWD_M_E_rs = (`DMD_rs_E_fwd&&WriteReg_M&&(RA1_E==Waddr_M)&&Waddr_M!=0);
	assign FWD_M_E_rt = (`DMD_rt_E_fwd&&WriteReg_M&&(RA2_E==Waddr_M)&&Waddr_M!=0);
	assign FWD_W_E_rs = (`DMD_rs_E_fwd&&WriteReg_W&&(RA1_E==Waddr_W)&&Waddr_W!=0);
	assign FWD_W_E_rt = (`DMD_rt_E_fwd&&WriteReg_W&&(RA2_E==Waddr_W)&&Waddr_W!=0);
	assign FWD_W_M_rt = (`DMD_rt_M_fwd&&WriteReg_W&&(RA2_M==Waddr_W)&&Waddr_W!=0);

endmodule
