`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:24:59 12/09/2016 
// Design Name: 
// Module Name:    stall_controller 
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
`define DMD_rs_D_stall (BZ_D||jr_D||B2_D)
`define DMD_rt_D_stall (B2_D)
`define DMD_rs_E_stall (Itype_D||MTHL_D||Rtype_D||Store_D)
`define DMD_rt_E_stall (Rtype_D||SUV_D)
module stall_controller(
	//data-demand classify signals
	BZ_D,jr_D,B2_D,Itype_D,MTHL_D,Rtype_D,SUV_D,Store_D,
	//data-produce classify signals
	WriteAtM_E,WriteAtW_E,WriteAtW_M,
	//status signals
	WriteReg_E,WriteReg_M,Busy,MULDIV_s_D,
	//register address
	RA1_D,RA2_D,Waddr_E,Waddr_M,
	//output signal
	STALL
   );
	input[4:0]RA1_D,RA2_D,Waddr_E,Waddr_M;
	input BZ_D,jr_D,B2_D,Itype_D,MTHL_D,Rtype_D,SUV_D,Store_D,
			WriteAtM_E,WriteAtW_E,WriteAtW_M,
			WriteReg_E,WriteReg_M,Busy,MULDIV_s_D;
	output STALL;
	
	assign STALL = (`DMD_rs_D_stall&&(((WriteAtM_E||WriteAtW_E)&&WriteReg_E&&(RA1_D==Waddr_E)&&Waddr_E!=0)||(WriteAtW_M&&WriteReg_M&&(RA1_D==Waddr_M)&&Waddr_M!=0)))||
						(`DMD_rt_D_stall&&(((WriteAtM_E||WriteAtW_E)&&WriteReg_E&&(RA2_D==Waddr_E)&&Waddr_E!=0)||(WriteAtW_M&&WriteReg_M&&(RA2_D==Waddr_M)&&Waddr_M!=0)))||
						(`DMD_rs_E_stall&&(WriteAtW_E&&WriteReg_E&&(RA1_D==Waddr_E)&&Waddr_E!=0))||
						(`DMD_rt_E_stall&&(WriteAtW_E&&WriteReg_E&&(RA2_D==Waddr_E)&&Waddr_E!=0))||
						(MULDIV_s_D&&Busy);

endmodule
