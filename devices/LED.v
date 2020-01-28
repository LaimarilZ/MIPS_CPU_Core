`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:06:12 12/30/2016 
// Design Name: 
// Module Name:    LED 
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
module LED(
	CLK_I,RST_I,WE_I,
	DAT_I,DAT_O,
	LED
   );
	input CLK_I,RST_I,WE_I;
	input[31:0]DAT_I;
	output[31:0]DAT_O;
	output[15:0]LED;
	
	reg[31:0]_reg;
	
	assign LED = ~_reg[15:0];
	assign DAT_O = _reg;
	
	initial _reg <= 0;
	
	always@(posedge CLK_I or posedge RST_I)begin
		if(RST_I)
			_reg <= 0;
		else if(WE_I)
			_reg <= DAT_I;
	end

endmodule
