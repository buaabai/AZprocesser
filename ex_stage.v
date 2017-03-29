`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "cpu.h"
`include "isa.h"

module ex_stage(fwd_data,id_pc,id_en,id_alu_op,id_alu_in_0,id_alu_in_1,
	id_br_flag,id_mem_op,id_mem_wr_data,id_ctrl_op,id_dst_addr,id_gpr_we_,
	id_exp_code,clk,reset,int_detect,stall,flush,ex_pc,ex_en,ex_br_flag,
	ex_mem_op,ex_mem_wr_data,ex_ctrl_op,ex_dst_addr,ex_gpr_we_,ex_exp_code,
	ex_out);

	input[29:0] id_pc;
	input id_en;
	input[3:0] id_alu_op;
	input[31:0] id_alu_in_0,id_alu_in_1;
	input id_br_flag;
	input[1:0] id_mem_op;
	input[31:0] id_mem_wr_data;
	input[1:0] id_ctrl_op;
	input[4:0] id_dst_addr;
	input id_gpr_we_;
	input[2:0] id_exp_code;
	input clk,reset;
	input int_detect;
	input stall,flush;
	
	output[31:0] fwd_data;
	output[29:0] ex_pc;
	output ex_en,ex_br_flag;
	output[1:0] ex_mem_op;
	output[31:0] ex_mem_wr_data;
	output[1:0] ex_ctrl_op;
	output[4:0] ex_dst_addr;
	output ex_gpr_we_;
	output[2:0] ex_exp_code;
	output[31:0] ex_out;
	
	wire[31:0] alu_out;
	wire alu_of;
	
	alu alu(.op(id_alu_op),.in_0(id_alu_in_0),.in_1(id_alu_in_1),
		.out(alu_out),.of(alu_of));
	
	ex_reg ex_reg(.id_pc(id_pc),.id_en(id_en),.alu_out(alu_out),.alu_of(alu_of),
		.id_br_flag(id_br_flag),.id_mem_op(id_mem_op),.id_mem_wr_data(id_mem_wr_data),
		.id_ctrl_op(id_ctrl_op),.id_dst_addr(id_dst_addr),.id_gpr_we_(id_gpr_we_),
		.id_exp_code(id_exp_code),.clk(clk),.reset(reset),.int_detect(int_detect),
		.stall(stall),.flush(flush),.ex_pc(ex_pc),.ex_en(ex_en),.ex_br_flag(ex_br_flag),
		.ex_mem_op(ex_mem_op),.ex_mem_wr_data(ex_mem_wr_data),.ex_ctrl_op(ex_ctrl_op),
		.ex_dst_addr(ex_dst_addr),.ex_gpr_we_(ex_gpr_we_),.ex_exp_code(ex_exp_code),
		.ex_out(ex_out));
		
endmodule