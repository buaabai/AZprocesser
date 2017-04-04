`define NEGATIVE_RESET
`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "cpu.h"
`include "isa.h"
`timescale 1ns/1ns

module if_reg(
	clk,reset,insn,
	stall,flush,new_pc,br_taken,br_addr,
	if_pc,if_insn,if_en
);

	input clk,reset;
	input[31:0] insn;
	input stall,flush;
	input[29:0] new_pc;
	input br_taken;
	input[29:0] br_addr;
	output if_en;
	
	output[29:0] if_pc;
	output[31:0] if_insn;
	
	reg[29:0] if_pc;
	reg[31:0] if_insn;
	reg if_en;
	
	always@(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
		begin
			if_pc <= #1 `RESET_VECTOR;
			if_insn <= #1 `ISA_NOP;
			if_en <= `DISABLE;
		end
		else
		begin
			if(stall == `DISABLE)
			begin
				if(flush == `ENABLE)
				begin
					if_pc <= #1 new_pc;
					if_insn <= #1 `ISA_NOP;
					if_en <= #1 `DISABLE;
				end
				else if(br_taken == `ENABLE)
				begin
					if_pc <= #1 br_addr;
					if_insn <= #1 insn;
					if_en <= #1 `ENABLE;
				end
				else
				begin
					if_pc <= #1 if_pc + 1;
					if_insn <= #1 insn;
					if_en <= #1 `ENABLE;
				end
			end
		end
	end
endmodule
	
	