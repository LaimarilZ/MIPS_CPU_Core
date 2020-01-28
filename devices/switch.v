`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:54:00 12/30/2016 
// Design Name: 
// Module Name:    switch 
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
module switch(
	CLK_I,RST_I,
	dipsw,
	DAT_O
   );
	input CLK_I,RST_I;
	input[31:0]dipsw;
	output[31:0]DAT_O;
	
	reg[31:0]_reg;
	
	assign DAT_O = _reg;
	
	initial _reg <= 0;
	
	always@(posedge CLK_I or posedge RST_I)begin
		if(RST_I)
			_reg <= 0;
		else 
			_reg <= dipsw;
	end

endmodule
