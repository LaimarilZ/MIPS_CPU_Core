`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:31:46 12/15/2016 
// Design Name: 
// Module Name:    mips 
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
module mips(
   clk,rst_I,
	//微动开关输入信号
	dipsw3_7,dipsw3_6,dipsw3_5,dipsw3_4,dipsw3_3,dipsw3_2,dipsw3_1,dipsw3_0,
	dipsw2_7,dipsw2_6,dipsw2_5,dipsw2_4,dipsw2_3,dipsw2_2,dipsw2_1,dipsw2_0,
	dipsw1_7,dipsw1_6,dipsw1_5,dipsw1_4,dipsw1_3,dipsw1_2,dipsw1_1,dipsw1_0,
	dipsw0_7,dipsw0_6,dipsw0_5,dipsw0_4,dipsw0_3,dipsw0_2,dipsw0_1,dipsw0_0,
	//LED输出信号
	LED_15,LED_14,LED_13,LED_12,LED_11,LED_10,LED_9,LED_8,
	LED_7,LED_6,LED_5,LED_4,LED_3,LED_2,LED_1,LED_0,
	//数码管0输出信号
	d_LED_0_a,d_LED_0_b,d_LED_0_c,d_LED_0_d,d_LED_0_e,d_LED_0_f,d_LED_0_g,d_LED_0_dp,
	d0_sel_3,d0_sel_2,d0_sel_1,d0_sel_0,
	//数码管1输出信号
	d_LED_1_a,d_LED_1_b,d_LED_1_c,d_LED_1_d,d_LED_1_e,d_LED_1_f,d_LED_1_g,d_LED_1_dp,
	d1_sel_3,d1_sel_2,d1_sel_1,d1_sel_0,
	//串行接口输入输出信号
	RxD,TxD
	);
	input clk,rst_I;
	input dipsw3_7,dipsw3_6,dipsw3_5,dipsw3_4,dipsw3_3,dipsw3_2,dipsw3_1,dipsw3_0,
			dipsw2_7,dipsw2_6,dipsw2_5,dipsw2_4,dipsw2_3,dipsw2_2,dipsw2_1,dipsw2_0,
			dipsw1_7,dipsw1_6,dipsw1_5,dipsw1_4,dipsw1_3,dipsw1_2,dipsw1_1,dipsw1_0,
			dipsw0_7,dipsw0_6,dipsw0_5,dipsw0_4,dipsw0_3,dipsw0_2,dipsw0_1,dipsw0_0;
	input RxD;
	output LED_15,LED_14,LED_13,LED_12,LED_11,LED_10,LED_9,LED_8,
			 LED_7,LED_6,LED_5,LED_4,LED_3,LED_2,LED_1,LED_0;
	output d_LED_0_a,d_LED_0_b,d_LED_0_c,d_LED_0_d,d_LED_0_e,d_LED_0_f,d_LED_0_g,d_LED_0_dp,
			 d0_sel_3,d0_sel_2,d0_sel_1,d0_sel_0,
			 d_LED_1_a,d_LED_1_b,d_LED_1_c,d_LED_1_d,d_LED_1_e,d_LED_1_f,d_LED_1_g,d_LED_1_dp,
			 d1_sel_3,d1_sel_2,d1_sel_1,d1_sel_0;
	output TxD;

	wire[31:0]PrRD,PrWD,DevWD,
				 Dev1out,Dev2out,Dev3out,Dev4out,Dev5out,Dev6out;
	wire[31:2]PrAddr,DevAddr;
	wire[7:0]d_LED_0_dis,d_LED_1_dis;
	wire[7:1]DevWE,DevSel;
	wire[7:2]DevIRQ,HWInt;
	wire[3:0]PrBE,DevBE,
				d_LED_0_sel,d_LED_1_sel;
	wire clk1x,clk2x,PrWE,rst;
	
	assign rst = ~rst_I;	
	
	clock clock(
		.CLK_IN1(clk),
		.CLK_OUT1(clk1x),
		.CLK_OUT2(clk2x)
	);
	
	CPU CPU(
		.clk(clk1x),
		.clk2x(clk2x),
		.rst(rst),
		.PrRD(PrRD),
		.HWInt(HWInt),
		.PrWD(PrWD),
		.PrAddr(PrAddr),
		.PrBE(PrBE),
		.PrWE(PrWE)
	);
	
	bridge bridge(
		//input
		.PrWD(PrWD),
		.PrAddr(PrAddr),
		.PrBE(PrBE),
		.PrWE(PrWE),
		.DevIRQ(DevIRQ),
		.Dev1out(Dev1out),
		.Dev2out(Dev2out),
		.Dev3out(Dev3out),
		.Dev4out(Dev4out),
		.Dev5out(Dev5out),
		.Dev6out(Dev6out),
		//output
		.DevWE(DevWE),
		.DevSel(DevSel),
		.DevBE(DevBE),
		.DevAddr(DevAddr),
		.DevWD(DevWD),
		.PrRD(PrRD),
		.HWInt(HWInt)
	);
	//1号设备：数据存储器
	RAM_DM RAM_DM(
		.clka(clk2x),
		.wea({DevBE[3]&&DevWE[1],DevBE[2]&&DevWE[1],DevBE[1]&&DevWE[1],DevBE[0]&&DevWE[1]}),
		.addra(DevAddr[13:2]),
		.dina(DevWD),
		.douta(Dev1out)
	);
	//2号设备：定时器
	timer timer(
		.CLK_I(clk1x),
		.RST_I(rst),
		.ADD_I(DevAddr[3:2]),
		.WE_I(DevWE[2]),
		.DAT_I(DevWD),
		.DAT_O(Dev2out),
		.IRQ(DevIRQ[2])
	);
	//3号设备：32位微动开关
	switch switch(
		.CLK_I(clk1x),
		.RST_I(rst),
		.dipsw({dipsw3_7,dipsw3_6,dipsw3_5,dipsw3_4,dipsw3_3,dipsw3_2,dipsw3_1,dipsw3_0,
				  dipsw2_7,dipsw2_6,dipsw2_5,dipsw2_4,dipsw2_3,dipsw2_2,dipsw2_1,dipsw2_0,
				  dipsw1_7,dipsw1_6,dipsw1_5,dipsw1_4,dipsw1_3,dipsw1_2,dipsw1_1,dipsw1_0,
				  dipsw0_7,dipsw0_6,dipsw0_5,dipsw0_4,dipsw0_3,dipsw0_2,dipsw0_1,dipsw0_0}),
		.DAT_O(Dev3out)
	);
	//4号设备：16位LED
	LED LED(
		.CLK_I(clk1x),
		.RST_I(rst),
		.WE_I(DevWE[4]),
		.DAT_I(DevWD),
		.LED({LED_15,LED_14,LED_13,LED_12,LED_11,LED_10,LED_9,LED_8,
				LED_7,LED_6,LED_5,LED_4,LED_3,LED_2,LED_1,LED_0}),
		.DAT_O(Dev4out)
	);
	//5号设备：8位7段数码管
	digital_LED digital_LED(
		//bridge ports
		.CLK_I(clk1x),
		.RST_I(rst),
		.WE_I(DevWE[5]),
		.DAT_I(DevWD),
		.DAT_O(Dev5out),
		//system ports
		.d_LED_0_dis(d_LED_0_dis),
		.d_LED_0_sel(d_LED_0_sel),
		.d_LED_1_dis(d_LED_1_dis),
		.d_LED_1_sel(d_LED_1_sel)
	);
	assign {d_LED_0_a,d_LED_0_b,d_LED_0_c,d_LED_0_d,d_LED_0_e,d_LED_0_f,d_LED_0_g,d_LED_0_dp} = ~d_LED_0_dis;
	assign {d_LED_1_a,d_LED_1_b,d_LED_1_c,d_LED_1_d,d_LED_1_e,d_LED_1_f,d_LED_1_g,d_LED_1_dp} = ~d_LED_1_dis;
	assign {d0_sel_3,d0_sel_2,d0_sel_1,d0_sel_0} = d_LED_0_sel;
	assign {d1_sel_3,d1_sel_2,d1_sel_1,d1_sel_0} = d_LED_1_sel;
	//6号设备：UART
	MiniUART MiniUART(
		.ADD_I(DevAddr[4:2]),
		.DAT_I(DevWD),
		.DAT_O(Dev6out),
		.STB_I(DevSel[6]),
		.WE_I(DevWE[6]),
		.CLK_I(clk1x),
		.RST_I(rst),
		.RxD(RxD),
		.TxD(TxD)
	);
		
endmodule
