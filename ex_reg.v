`define NEGATIVE_RESET
`include "global_config.h"
`include "stddef.h"
`include "nettype.h"
`include "cpu.h"
`include "isa.h"

`timescale 1ns/1ns
module ex_reg(clk,reset,
	alu_out,alu_of,
	stall,flush,int_detect,
	id_pc,id_en,id_br_flag,id_mem_op,id_mem_wr_data,
	id_ctrl_op,id_dst_addr,id_gpr_we_,id_exp_code,
	ex_pc,ex_en,ex_br_flag,ex_mem_op,ex_mem_wr_data,
	ex_ctrl_op,ex_dst_addr,ex_gpr_we_,ex_exp_code,
	ex_out);
	
	input clk,reset;
	input[31:0] alu_out;
	input alu_of;
	input stall,flush,int_detect;
	input[29:0] id_pc;
	input id_en,id_br_flag;
	input[1:0] id_mem_op;
	input[31:0] id_mem_wr_data;
	input[1:0] id_ctrl_op;
	input[4:0] id_dst_addr;
	input id_gpr_we_;
	input[2:0] id_exp_code;
	
	output[29:0] ex_pc;
	output ex_en;
	output ex_br_flag;
	output[1:0] ex_mem_op;
	output[31:0] ex_mem_wr_data;
	output[1:0] ex_ctrl_op;
	output[4:0] ex_dst_addr;
	output ex_gpr_we_;
	output[2:0] ex_exp_code;
	output[31:0] ex_out;
	
	reg[29:0] ex_pc;
	reg ex_en;
	reg ex_br_flag;
	reg[1:0] ex_mem_op;
	reg[31:0] ex_mem_wr_data;
	reg[1:0] ex_ctrl_op;
	reg[4:0] ex_dst_addr;
	reg ex_gpr_we_;
	reg[2:0] ex_exp_code;
	reg[31:0] ex_out;
	
	always@(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
		begin
			ex_pc <= #1 `WORD_ADDR_W'h0;
			ex_en <= #1 `DISABLE;
			ex_br_flag <= #1 `DISABLE;
			ex_mem_op <= #1 `MEM_OP_NOP;
			ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
			ex_ctrl_op <= #1 `CTRL_OP_NOP;
			ex_dst_addr <= #1 `REG_ADDR_W'd0;
			ex_gpr_we_ <= #1 `DISABLE_;
			ex_exp_code <= #1 `ISA_EXP_NO_EXP;
			ex_out <= #1 `WORD_DATA_W'h0;
		end
		else
		begin
			if(stall == `DISABLE)
			begin
				if(flush == `ENABLE)
				begin
					ex_pc <= #1 `WORD_ADDR_W'h0;
					ex_en <= #1 `DISABLE;
					ex_br_flag <= #1 `DISABLE;
					ex_mem_op <= #1 `MEM_OP_NOP;
					ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
					ex_ctrl_op <= #1 `CTRL_OP_NOP;
					ex_dst_addr <= #1 `REG_ADDR_W'd0;
					ex_gpr_we_ <= #1 `DISABLE_;
					ex_exp_code <= #1 `ISA_EXP_NO_EXP;
					ex_out <= #1 `WORD_DATA_W'h0;
				end
				else if(int_detect == `ENABLE)
				begin
					ex_pc <= #1 id_pc;
					ex_en <= #1 id_en;
					ex_br_flag <= #1 id_br_flag;
					ex_mem_op <= #1 `MEM_OP_NOP;
					ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
					ex_ctrl_op <= #1 `CTRL_OP_NOP;
					ex_dst_addr <= #1 `REG_ADDR_W'd0;
					ex_gpr_we_ <= #1 `DISABLE_;
					ex_exp_code <= #1 `ISA_EXP_EXT_INT;
					ex_out <= #1 `WORD_DATA_W'h0;
				end
				else if(alu_of == `ENABLE)
				begin
					ex_pc <= #1 id_pc;
					ex_en <= #1 id_en;
					ex_br_flag <= #1 id_br_flag;
					ex_mem_op <= #1 `MEM_OP_NOP;
					ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
					ex_ctrl_op <= #1 `CTRL_OP_NOP;
					ex_dst_addr <= #1 `REG_ADDR_W'd0;
					ex_gpr_we_ <= #1 `DISABLE_;
					ex_exp_code <= #1 `ISA_EXP_OVERFLOW;
					ex_out <= #1 `WORD_DATA_W'h0;
				end
				else
				begin
					ex_pc <= #1 id_pc;
					ex_en <= #1 id_en;
					ex_br_flag <= #1 id_br_flag;
					ex_mem_op <= #1 id_mem_op;
					ex_mem_wr_data <= #1 id_mem_wr_data;
					ex_ctrl_op <= #1 id_ctrl_op;
					ex_dst_addr <= #1 id_dst_addr;
					ex_gpr_we_ <= #1 id_gpr_we_;
					ex_exp_code <= #1 id_exp_code;
					ex_out <= #1 alu_out;
				end
			end
		end
	end
endmodule