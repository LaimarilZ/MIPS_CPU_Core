`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:59:03 12/15/2016 
// Design Name: 
// Module Name:    CP0 
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
`define SR regs[12]
`define CAUSE regs[13]
`define EPC regs[14]
`define PrID regs[15]
module CP0(
   clk,rst,A,Din,PC,ExcCode,HWInt,We,BD,EXLSet,EXLClr,
	IntReq,EPC,Dout
	);
	input[31:0]Din;
	input[31:2]PC;
	input[5:0]HWInt;
	input[6:2]ExcCode;
	input[4:0]A;
	input clk,rst,We,BD,EXLSet,EXLClr;
	output[31:0]Dout;
	output[31:2]EPC;
	output IntReq;
	
	reg[31:0] regs[31:0];
	integer i;
	
	initial begin
		for(i=0;i<32;i=i+1) regs[i]<=0;
		`PrID<=335941968;
		`EPC<=32'h3000;
	end
	
	assign Dout = regs[A];
	assign EPC = `EPC[31:2];
	assign IntReq = ((`SR[1:0]==2'b01)&&
						 ((HWInt[5]==1&&`SR[15]==1)||
						 (HWInt[4]==1&&`SR[14]==1)||
						 (HWInt[3]==1&&`SR[13]==1)||
						 (HWInt[2]==1&&`SR[12]==1)||
						 (HWInt[1]==1&&`SR[11]==1)||
						 (HWInt[0]==1&&`SR[10]==1)))||
						 ExcCode!=0;
						 
	
	always @(posedge clk or posedge rst)begin
		if(rst) begin
			for(i=0;i<32;i=i+1) regs[i]<=0;
			`PrID<=32'h14061150;
			`SR[15:10]<=6'b111111;
			`SR[1:0]<=2'b01;
		end
		else begin
			if(We)
				case(A)
					5'd12 : `SR <= {16'b0,Din[15:10],8'b0,Din[1:0]};
					5'd14 : `EPC <= Din;
				endcase
			if(IntReq) begin
				`EPC <= {PC,2'b0};
				`CAUSE[31] <= BD;
				`CAUSE[15:10] <= HWInt;
				`CAUSE[6:2] <= ExcCode;
			end
			if(EXLSet) `SR[1] <= 1'b1;
			if(EXLClr) `SR[1] <= 1'b0;
		end
	end


endmodule
