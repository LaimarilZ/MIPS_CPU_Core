`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:13:27 12/07/2016 
// Design Name: 
// Module Name:    MULDIV 
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
module MULDIV(
	Clk,Rst,
	D1,D2,HiLo,Op,Start,We,
	Busy,HI,LO
   );
	input Clk,Rst,HiLo,Start,We;
	input[1:0]Op;
	input[31:0]D1,D2;
	output Busy;
	output[31:0]HI,LO;
	
	wire[63:0]p,p0,p1,p2,p3;
	reg[31:0]hi,lo,a,b;
	reg[5:0]counter;
	reg[1:0]op_reg;
	
	initial begin
		hi <= 32'b0;
		lo <= 32'b0;
		a <= 32'b0;
		b <= 32'b0;
		counter <= 6'b0;
		op_reg <= 2'b0;
	end
	
	assign HI = hi;
	assign LO = lo;
	assign Busy = ((counter == 6'b0)&&~Start) ? 1'b0 : 1'b1;
	
	always@(posedge Clk or posedge Rst)begin
		if(Rst)begin
			hi <= 32'b0;
			lo <= 32'b0;
			a <= 32'b0;
			b <= 32'b0;
			counter <= 6'b0;
			op_reg <= 2'b0;
		end
		else if(We)begin
			case(HiLo)
				1'b0 : lo <= D1;
				1'b1 : hi <= D1;
			endcase
		end
		else if(Start) begin
			a <= D1;
			b <= D2;
			case(Op)
				2'b00 : counter <= 6'd18;	//无符号乘法
				2'b01 : counter <= 6'd18;	//有符号乘法
				2'b10 : counter <= 6'd44;	//无符号除法
				2'b11 : counter <= 6'd45;	//有符号除法
			endcase
			op_reg <= Op;
		end
		else if(counter == 1)begin
			{hi,lo} <= p;
			counter <= counter - 6'b1;
		end
		else if(counter != 0)
			counter <= counter - 6'b1;
	end
	MUL_unsigned MUL_unsigned(
		.clk(Clk), 
		.a(a), 
		.b(b), 
		.p(p0)
	);
	MUL_signed MUL_signed(
		.clk(Clk), 
		.a(a), 
		.b(b), 
		.p(p1)
	);
	DIV_unsigned DIV_unsigned(
		.clk(Clk), 
		.dividend(a), 
		.divisor(b), 
		.quotient(p2[31:0]), 
		.fractional(p2[63:32])
	);
	DIV_signed DIV_signed(
		.clk(Clk), 
		.dividend(a), 
		.divisor(b), 
		.quotient(p3[31:0]), 
		.fractional(p3[63:32])
	);
	assign p = (op_reg == 2'b00) ? p0 :
				  (op_reg == 2'b01) ? p1 :
				  (op_reg == 2'b10) ? p2 :
				  (op_reg == 2'b11) ? p3 : 64'b0;

endmodule
