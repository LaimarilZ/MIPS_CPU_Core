`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:18:40 12/30/2016 
// Design Name: 
// Module Name:    digital_LED 
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
`define _0 8'b11111100
`define _1 8'b01100000
`define _2 8'b11011010
`define _3 8'b11110010
`define _4 8'b01100110
`define _5 8'b10110110
`define _6 8'b10111110
`define _7 8'b11100000
`define _8 8'b11111110
`define _9 8'b11110110
`define _A 8'b11101110
`define _B 8'b00111110
`define _C 8'b10011100
`define _D 8'b01111010
`define _E 8'b10011110
`define _F 8'b10001110
module digital_LED(
	//bridge ports
	CLK_I,RST_I,WE_I,DAT_I,
	DAT_O,
	//system ports
	d_LED_0_dis,d_LED_0_sel,
	d_LED_1_dis,d_LED_1_sel
   );
	//bridge ports
	input CLK_I,RST_I,WE_I;
	input[31:0]DAT_I;
	output[31:0]DAT_O;
	//system ports
	output[7:0]d_LED_0_dis,d_LED_1_dis;
	output[3:0]d_LED_0_sel,d_LED_1_sel;

	wire[3:0]digit_0,digit_1;
	
	reg[31:0]data;
	reg[18:0]counter_disp;
	reg[1:0]counter;
	
	initial begin
		data <= 32'b0;
		counter <= 2'b0;
		counter_disp <= 19'b0;
	end
	
	assign DAT_O = data;
	assign d_LED_0_sel = (counter == 2'b00) ? 4'b1000 :
								(counter == 2'b01) ? 4'b0100 :
								(counter == 2'b10) ? 4'b0010 :
								(counter == 2'b11) ? 4'b0001 : 4'b0000;
	assign d_LED_1_sel = (counter == 2'b00) ? 4'b1000 :
								(counter == 2'b01) ? 4'b0100 :
								(counter == 2'b10) ? 4'b0010 :
								(counter == 2'b11) ? 4'b0001 : 4'b0000;
	assign digit_0 = (counter == 2'b00) ? data[3:0] :
						  (counter == 2'b01) ? data[7:4] :
						  (counter == 2'b10) ? data[11:8] :
						  (counter == 2'b11) ? data[15:12] : 4'b0000;
	assign digit_1 = (counter == 2'b00) ? data[19:16] :
						  (counter == 2'b01) ? data[23:20] :
						  (counter == 2'b10) ? data[27:24] :
						  (counter == 2'b11) ? data[31:28] : 4'b0000;
	assign d_LED_0_dis = (digit_0 == 4'b0000) ? `_0 :
								(digit_0 == 4'b0001) ? `_1 :
								(digit_0 == 4'b0010) ? `_2 :
								(digit_0 == 4'b0011) ? `_3 :
								(digit_0 == 4'b0100) ? `_4 :
								(digit_0 == 4'b0101) ? `_5 :
								(digit_0 == 4'b0110) ? `_6 :
								(digit_0 == 4'b0111) ? `_7 :
								(digit_0 == 4'b1000) ? `_8 :
								(digit_0 == 4'b1001) ? `_9 :
								(digit_0 == 4'b1010) ? `_A :
								(digit_0 == 4'b1011) ? `_B :
								(digit_0 == 4'b1100) ? `_C :
								(digit_0 == 4'b1101) ? `_D :
								(digit_0 == 4'b1110) ? `_E :
								(digit_0 == 4'b1111) ? `_F : 8'b0;
	assign d_LED_1_dis = (digit_1 == 4'b0000) ? `_0 :
								(digit_1 == 4'b0001) ? `_1 :
								(digit_1 == 4'b0010) ? `_2 :
								(digit_1 == 4'b0011) ? `_3 :
								(digit_1 == 4'b0100) ? `_4 :
								(digit_1 == 4'b0101) ? `_5 :
								(digit_1 == 4'b0110) ? `_6 :
								(digit_1 == 4'b0111) ? `_7 :
								(digit_1 == 4'b1000) ? `_8 :
								(digit_1 == 4'b1001) ? `_9 :
								(digit_1 == 4'b1010) ? `_A :
								(digit_1 == 4'b1011) ? `_B :
								(digit_1 == 4'b1100) ? `_C :
								(digit_1 == 4'b1101) ? `_D :
								(digit_1 == 4'b1110) ? `_E :
								(digit_1 == 4'b1111) ? `_F : 8'b0;
	always@(posedge CLK_I or posedge RST_I)begin
		if(RST_I)
			data <= 32'b0;
		else if(WE_I)
			data <= DAT_I;
	end
	always@(posedge CLK_I or posedge RST_I)begin
		if(RST_I)begin
			counter <= 2'b0;
			counter_disp <= 19'b0;
		end
		else begin
			if((counter == 0)&&(counter_disp == 0))begin
				counter_disp <= 19'd30000;
				counter <= 2'b11;
			end
			else if(counter_disp == 0)begin
				counter_disp <= 19'd30000;
				counter <= counter - 2'b01;
			end
			else
				counter_disp <= counter_disp - 19'b1;
		end
	end

endmodule
