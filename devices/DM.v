`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:25:25 12/07/2016 
// Design Name: 
// Module Name:    DM 
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
module DM(
	We,Clk,A,BE,WD,RD
   );
	input We,Clk;
	input[12:2]A;
	input[3:0]BE;
	input[31:0]WD;
	output[31:0]RD;

	reg[31:0]dm[2047:0];
	integer i;
	
	initial for(i=0;i<2048;i=i+1) dm[i]<=0;
	
	assign RD = dm[A];
	
	always @(posedge Clk)begin
		if(We)begin
			case(BE)
				4'b1111 : dm[A] <= WD;
				4'b0011 : dm[A] <= {dm[A][31:16],WD[15:0]};
				4'b1100 : dm[A] <= {WD[15:0],dm[A][15:0]};
				4'b0001 : dm[A] <= {dm[A][31:8],WD[7:0]};
				4'b0010 : dm[A] <= {dm[A][31:16],WD[7:0],dm[A][7:0]};
				4'b0100 : dm[A] <= {dm[A][31:24],WD[7:0],dm[A][15:0]};
				4'b1000 : dm[A] <= {WD[7:0],dm[A][23:0]};
			endcase
		end
	end
	
endmodule
