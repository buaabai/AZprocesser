`define NEGATIVE_RESET
`include "global_config.h"
`include "stddef.h"
`include "nettype.h"
`include "cpu.h"
`include "isa.h"
`timescale 1ns/1ns


module id_reg(
	clk,reset,
	alu_op,alu_in_0,alu_in_1,br_flag,mem_op,mem_wr_data,
	ctrl_op,dst_addr,gpr_we_,exp_code,
	stall,flush,
	if_pc,if_en,
	id_pc,id_en,id_alu_op,id_alu_in_0,id_alu_in_1,id_br_flag,
	id_mem_op,id_mem_wr_data,id_ctrl_op,id_dst_addr,id_gpr_we_,
	id_exp_code
);

	input clk,reset;
	input[3:0] alu_op;
	input[31:0] alu_in_0;
	input[31:0] alu_in_1;
	input br_flag;
	input[2:0] mem_op;
	input[31:0] mem_wr_data;
	input[1:0] ctrl_op;
	input[4:0] dst_addr;
	input gpr_we_;
	input[2:0] exp_code;
	
	input stall,flush;
	input[29:0] if_pc;
	input if_en;
	
	output[29:0] id_pc;
	output id_en;
	output[3:0] id_alu_op;
	output[31:0] id_alu_in_0,id_alu_in_1;
	output id_br_flag;
	output[1:0] id_mem_op;
	output[31:0] id_mem_wr_data;
	output[1:0] id_ctrl_op;
	output[4:0] id_dst_addr;
	output id_gpr_we_;
	output[2:0] id_exp_code;
	
	reg[29:0] id_pc;
	reg id_en;
	reg[3:0] id_alu_op;
	reg[31:0] id_alu_in_0,id_alu_in_1;
	reg id_br_flag;
	reg[1:0] id_mem_op;
	reg[31:0] id_mem_wr_data;
	reg[1:0] id_ctrl_op;
	reg[4:0] id_dst_addr;
	reg id_gpr_we_;
	reg[2:0] id_exp_code;
	
	always@(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
		begin
			id_pc <= #1 `WORD_ADDR_W'h0;
			id_en <= #1 `DISABLE;
			id_alu_op <= #1 `ALU_OP_NOP;
			id_alu_in_0 <= #1 `WORD_DATA_W'h0;
			id_alu_in_1 <= #1 `WORD_DATA_W'h0;
			id_br_flag <= #1 `DISABLE;
			id_mem_op <= #1 `MEM_OP_NOP;
			id_mem_wr_data <= #1 `WORD_DATA_W'h0;
			id_ctrl_op <= #1 `CTRL_OP_NOP;
			id_dst_addr <= #1 `REG_ADDR_W'h0;
			id_gpr_we_ <= #1 `DISABLE_;
			id_exp_code <= #1 `ISA_EXP_NO_EXP;
		end
		else
		begin
			if(stall == `DISABLE)
			begin
				if(flush == `ENABLE)
				begin
					id_pc <= #1 `WORD_ADDR_W'h0;
					id_en <= #1 `DISABLE;
					id_alu_op <= #1 `ALU_OP_NOP;
					id_alu_in_0 <= #1 `WORD_DATA_W'h0;
					id_alu_in_1 <= #1 `WORD_DATA_W'h0;
					id_br_flag <= #1 `DISABLE;
					id_mem_op <= #1 `MEM_OP_NOP;
					id_mem_wr_data <= #1 `WORD_DATA_W'h0;
					id_ctrl_op <= #1 `CTRL_OP_NOP;
					id_dst_addr <= #1 `REG_ADDR_W'h0;
					id_gpr_we_ <= #1 `DISABLE_;
					id_exp_code <= #1 `ISA_EXP_NO_EXP;
				end
				else
				begin
					id_pc <= #1 if_pc;
					id_en <= #1 if_en;
					id_alu_op <= #1 alu_op;
					id_alu_in_0 <= #1 alu_in_0;
					id_alu_in_1 <= #1 alu_in_1;
					id_br_flag <= #1 br_flag;
					id_mem_op <= #1 mem_op;
					id_mem_wr_data <= #1 mem_wr_data;
					id_ctrl_op <= #1 ctrl_op;
					id_dst_addr <= #1 dst_addr;
					id_gpr_we_ <= #1 gpr_we_;
					id_exp_code <= #1 exp_code;
				end
			end
		end
	end
endmodule	
	