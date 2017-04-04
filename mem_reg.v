`define NEGATIVE_RESET
`include "global_config.h"
`include "stddef.h"
`include "nettype.h"
`include "cpu.h"
`include "isa.h"

`timescale 1ns/1ns

module mem_reg(
	clk,reset,out,miss_align,stall,flush,
	ex_pc,ex_en,ex_br_flag,ex_ctrl_op,ex_dst_addr,
	ex_gpr_we_,ex_exp_code,
	mem_pc,mem_en,mem_br_flag,mem_ctrl_op,mem_dst_addr,
	mem_gpr_we_,mem_exp_code,mem_out
);

	input clk,reset;
	input[31:0] out;
	input miss_align;
	input stall,flush;
	
	input[29:0] ex_pc;
	input ex_en;
	input ex_br_flag;
	input[1:0] ex_ctrl_op;
	input[4:0] ex_dst_addr;
	input ex_gpr_we_;
	input[2:0] ex_exp_code;
	
	output[29:0] mem_pc;
	output mem_en;
	output mem_br_flag;
	output[1:0] mem_ctrl_op;
	output[4:0] mem_dst_addr;
	output mem_gpr_we_;
	output[2:0] mem_exp_code;
	output[31:0] mem_out;
	
	reg[29:0] mem_pc;
	reg mem_en;
	reg mem_br_flag;
	reg[1:0] mem_ctrl_op;
	reg[4:0] mem_dst_addr;
	reg mem_gpr_we_;
	reg[2:0] mem_exp_code;
	reg[31:0] mem_out;
	
	always@(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
		begin
			mem_pc <= #1 `WORD_ADDR_W'h0;
			mem_en <= #1 `DISABLE;
			mem_br_flag <= #1 `DISABLE;
			mem_ctrl_op <= #1 `CTRL_OP_NOP;
			mem_dst_addr <= #1 `REG_ADDR_W'h0;
			mem_gpr_we_ <= #1 `DISABLE_;
			mem_exp_code <= #1 `ISA_EXP_NO_EXP;
			mem_out <= #1 `WORD_DATA_W'h0;
		end
		else
		begin
			if(stall == `DISABLE)
			begin
				if(flush == `ENABLE)
				begin
					mem_pc <= #1 `WORD_ADDR_W'h0;
					mem_en <= #1 `DISABLE;
					mem_br_flag <= #1 `DISABLE;
					mem_ctrl_op <= #1 `CTRL_OP_NOP;
					mem_dst_addr <= #1 `REG_ADDR_W'h0;
					mem_gpr_we_ <= #1 `DISABLE_;
					mem_exp_code <= #1 `ISA_EXP_NO_EXP;
					mem_out <= #1 `WORD_DATA_W'h0;
				end
				else if(miss_align == `ENABLE)
				begin
					mem_pc <= #1 ex_pc;
					mem_en <= #1 ex_en;
					mem_br_flag <= #1 ex_br_flag;
					mem_ctrl_op <= #1 `CTRL_OP_NOP;
					mem_dst_addr <= #1 `REG_ADDR_W'h0;
					mem_gpr_we_ <= #1 `DISABLE_;
					mem_exp_code <= #1 `ISA_EXP_MISS_ALIGN;
					mem_out <= #1 `WORD_DATA_W'h0;
				end
				else
				begin
					mem_pc <= #1 ex_pc;
					mem_en <= #1 ex_en;
					mem_br_flag <= #1 ex_br_flag;
					mem_ctrl_op <= #1 ex_ctrl_op;
					mem_dst_addr <= #1 ex_dst_addr;
					mem_gpr_we_ <= #1 ex_gpr_we_;
					mem_exp_code <= #1 ex_exp_code;
					mem_out <= #1 out;
				end
			end
		end
	end
	
endmodule
	