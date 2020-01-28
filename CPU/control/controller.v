`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:43:45 12/08/2016 
// Design Name: 
// Module Name:    controller 
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
`define sll (opcode==0&&funct==0)
`define srl (opcode==0&&funct==2)
`define sra (opcode==0&&funct==3)
`define sllv (opcode==0&&funct==4)
`define srlv (opcode==0&&funct==6)
`define srav (opcode==0&&funct==7)
`define jr (opcode==0&&funct==8)
`define jalr (opcode==0&&funct==9)
`define mfhi (opcode==0&&funct==16)
`define mthi (opcode==0&&funct==17)
`define mflo (opcode==0&&funct==18)
`define mtlo (opcode==0&&funct==19)
`define mult (opcode==0&&funct==24)
`define multu (opcode==0&&funct==25)
`define div (opcode==0&&funct==26)
`define divu (opcode==0&&funct==27)
`define add (opcode==0&&funct==32)
`define addu (opcode==0&&funct==33)
`define sub (opcode==0&&funct==34)
`define subu (opcode==0&&funct==35)
`define and (opcode==0&&funct==36)
`define or (opcode==0&&funct==37)
`define xor (opcode==0&&funct==38)
`define nor (opcode==0&&funct==39)
`define slt (opcode==0&&funct==42)
`define sltu (opcode==0&&funct==43)
`define bltz (opcode==1&&special==0)
`define bgez (opcode==1&&special==1)
`define j (opcode==2)
`define jal (opcode==3)
`define beq (opcode==4)
`define bne (opcode==5)
`define blez (opcode==6)
`define bgtz (opcode==7)
`define addi (opcode==8)
`define addiu (opcode==9)
`define slti (opcode==10)
`define sltiu (opcode==11)
`define andi (opcode==12)
`define ori (opcode==13)
`define xori (opcode==14)
`define lui (opcode==15)
`define lb (opcode==32)
`define lh (opcode==33)
`define lw (opcode==35)
`define lbu (opcode==36)
`define lhu (opcode==37)
`define sb (opcode==40)
`define sh (opcode==41)
`define sw (opcode==43)
`define mfc0 (opcode==16&&rs==0)
`define mtc0 (opcode==16&&rs==4)
`define eret (opcode==16&&rs==16&&funct==24)

module controller(
	//clock
	clk,
	//instruction input
	opcode,funct,special,rs,
	//signals used in D stage
	Jump,jr,Branch,CMP_Op,WriteRt,Write31,lui,Link,LogicI,
	//signals used in E stage
	ALU_Op,SFT_Op,MULDIV_Op,HiLo,Shift,MFHL,MTHL,Start,
	//signals used in M stage
	BE_Op,Store,Load,
	//signals used in W stage
	DataEXT_Op,WriteReg,
	//data_demand classify signals
	BZ,B2,Itype,Rtype,SUV,
	//data_produce classify signals
	WriteAtE,WriteAtM,WriteAtW,
	//using multiplier signal
	MULDIV_s,
	//signals for CP0 instructions
	eret,mtc0,mfc0,BD
   );
	input clk;
	input[5:0]opcode,funct;
	input[4:0]special,rs;
	output[2:0]CMP_Op,DataEXT_Op;
	output[3:0]ALU_Op;
	output[1:0]SFT_Op,MULDIV_Op,BE_Op;
	output Jump,jr,Branch,WriteRt,
			 Write31,WriteReg,lui,Link,LogicI,
			 HiLo,Shift,MFHL,MTHL,
			 Start,Store,Load,BZ,
			 B2,Itype,Rtype,SUV,
			 WriteAtE,WriteAtM,WriteAtW,MULDIV_s,
			 eret,mfc0,mtc0,BD;
	
	reg BD_reg;
	
	initial BD_reg = 0;
	
	always @(posedge clk) BD_reg <= Jump||jr||Branch;
	
	assign CMP_Op = (`bltz) ? 3'b001 :
						 (`blez) ? 3'b010 :
					  	 (`beq) ? 3'b011 :
						 (`bne) ? 3'b100 :
						 (`bgez) ? 3'b101 :
						 (`bgtz) ? 3'b110 : 3'b0;
	assign ALU_Op = (`addu||`addiu) ? 4'b0001 :
						 (`add||`addi||`lw||`lh||`lhu||`lb||`lbu||`sw||`sh||`sb) ? 4'b0010 :
						 (`subu) ? 4'b0011 :
						 (`sub) ? 4'b0100 :
						 (`and||`andi) ? 4'b0101 :
						 (`or||`ori) ? 4'b0110 :
						 (`nor) ? 4'b0111 :
						 (`xor||`xori) ? 4'b1000 :
						 (`sltu||`sltiu) ? 4'b1001 :
						 (`slt||`slti) ? 4'b1010 : 4'b0000;
	assign SFT_Op = (`sll||`sllv) ? 2'b01 :
						 (`srl||`srlv) ? 2'b10 :
						 (`sra||`srav) ? 2'b11 : 2'b00;
	assign MULDIV_Op = (`mult) ? 2'b01 :
							 (`divu) ? 2'b10 :
							 (`div) ? 2'b11 : 2'b00;
	assign BE_Op = (`sb) ? 2'b01 :
						(`sh) ? 2'b10 :
						(`sw) ? 2'b11 : 2'b00;
	assign DataEXT_Op = (`lbu) ? 3'b001 :
							  (`lb) ? 3'b010 :
							  (`lhu) ? 3'b011 :
							  (`lh) ? 3'b100 : 3'b000;
	assign Jump = `j||`jal;
	assign jr = `jr||`jalr;
	assign Branch = `beq||`bne||`blez||`bgtz||`bltz||`bgez;
	assign WriteRt = `lui||`addi||`addiu||`andi||`ori||`slti||`sltiu||`xori||`lb||`lbu||`lh||`lhu||`lw||`mfc0;
	assign Write31 = `jal;
	assign WriteReg = `jalr||`add||`addu||`and||`mfhi||`mflo||`nor||`or||`sll||`sllv||`slt||`sltu||`sra||`srav||`srl||`srlv||`sub||`subu||`xor||
							`lui||`addi||`addiu||`andi||`ori||`slti||`sltiu||`xori||`lb||`lbu||`lh||`lhu||`lw||
							`jal||`mfc0;
	assign lui = `lui;
	assign Link = `jal||`jalr;
	assign LogicI = `andi||`ori||`xori;
	assign HiLo = `mthi||`mfhi;
	assign Shift = `sll||`sllv||`sra||`srl||`srav||`srlv;
	assign MFHL = `mfhi||`mflo;
	assign MTHL = `mthi||`mtlo;
	assign Start = `mult||`multu||`div||`divu;
	assign Store = `sb||`sh||`sw;
	assign Load = `lb||`lbu||`lh||`lhu||`lw;
	assign BZ = `bltz||`blez||`bgez||`bgtz;
	assign B2 = `bne||`beq;
	assign Itype = `addi||`addiu||`andi||`lb||`lbu||`lh||`lhu||`lw||`ori||`slti||`sltiu||`xori;
	assign Rtype = `add||`addu||`and||`div||`divu||`mult||`multu||`nor||`or||`sllv||`slt||`sltu||`srav||`srlv||`sub||`subu||`xor;
	assign SUV = `sll||`sra||`srl;
	assign WriteAtE = `jal||`jalr||`lui;
	assign WriteAtM = `add||`addu||`and||`mfhi||`mflo||`nor||`or||`sll||`sllv||`slt||`sltu||`sra||`srav||`srl||`srlv||`sub||`subu||`xor||`addi||`addiu||`andi||`ori||`slti||`sltiu||`xori;
	assign WriteAtW = `lb||`lbu||`lh||`lhu||`lw||`mfc0;
	assign MULDIV_s = `mult||`multu||`div||`divu||`mfhi||`mflo||`mthi||`mtlo;
	assign eret = `eret;
	assign mfc0 = `mfc0;
	assign mtc0 = `mtc0;
	assign BD = BD_reg;
	
endmodule
