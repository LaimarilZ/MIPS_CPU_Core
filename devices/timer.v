`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:44:22 12/15/2016 
// Design Name: 
// Module Name:    timer 
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
`define CTRL regs[0]
`define PRESET regs[1]
`define COUNT regs[2]
`define mode0 regs[0][2:1]==2'b00
`define mode1 regs[0][2:1]==2'b01

module timer(
	CLK_I,RST_I,ADD_I,WE_I,DAT_I,
	DAT_O,IRQ
   );
	input CLK_I,RST_I,WE_I;
	input[3:2]ADD_I;
	input[31:0]DAT_I;
	output IRQ;
	output[31:0]DAT_O;
	
	reg[31:0]regs[2:0];
	integer i;
	
	initial begin 
		for(i=0;i<3;i=i+1) regs[i] <= 0;
	end

	assign DAT_O = regs[ADD_I];
	assign IRQ = (`CTRL[3]==1'b1)&&(`mode0)&&(`COUNT==0);
	
	always @(posedge CLK_I or posedge RST_I)begin 
		if(RST_I)
			for(i=0;i<3;i=i+1) regs[i] <= 0;
		else begin
			if(WE_I) begin
				if(ADD_I==2'b00) regs[ADD_I][3:0] <= DAT_I[3:0];
				else if(ADD_I==2'b01) begin
					regs[ADD_I] <= DAT_I;
					if(`mode0&&`COUNT==0) `COUNT <= DAT_I;
				end
			end
			if((`COUNT!=0)&&`CTRL[0]) `COUNT <= `COUNT - 1;
			else if((`COUNT==0)&&`CTRL[0]&&`mode1) `COUNT <= `PRESET;
		end
	end

endmodule
