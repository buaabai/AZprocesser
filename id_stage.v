`include "global_config.h"
`include "stddef.h"
`include "nettype.h"
`include "cpu.h"
`include "isa.h"

module id_stage(
	if_en,if_pc,if_insn,
	gpr_rd_data_0,gpr_rd_data_1,gpr_rd_addr_0,gpr_rd_addr_1,
	exe_mode,creg_rd_data,creg_rd_addr,
	ex_fwd_data,ex_dst_addr,ex_gpr_we_,mem_fwd_data,
	br_addr,br_taken,ld_hazard,
	clk,reset,
	stall,flush,
	id_pc,id_en,id_alu_op,id_alu_in_0,id_alu_in_1,id_br_flag,
	id_mem_op,id_mem_wr_data,id_ctrl_op,id_dst_addr,id_gpr_we_,
	id_exp_code
);

	input if_en;
	input[29:0] if_pc;
	input[31:0] if_insn;
	input[31:0] gpr_rd_data_0,gpr_rd_data_1;
	input exe_mode;
	input[31:0] creg_rd_data;
	input[31:0] ex_fwd_data;
	input[4:0] ex_dst_addr;
	input ex_gpr_we_;
	input[31:0] mem_fwd_data;
	input clk,reset,stall,flush;
	
	output[4:0] gpr_rd_addr_0,gpr_rd_addr_1;
	output[4:0] creg_rd_addr;
	output[29:0] br_addr;
	output br_taken,ld_hazard;
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
	
	wire[3:0] alu_op;
	wire[31:0] alu_in_0,alu_in_1;
	wire br_flag;
	wire[1:0] mem_op;
	wire[31:0] mem_wr_data;
	wire[1:0] ctrl_op;
	wire[4:0] dst_addr;
	wire gpr_we_;
	wire[2:0] exp_code;
	
	decoder decoder(.if_pc(if_pc),.if_insn(if_insn),.gpr_rd_data_0(gpr_rd_data_0),
		.gpr_rd_data_1(gpr_rd_data_1),.gpr_rd_addr_0(gpr_rd_addr_0),.gpr_rd_addr_1(gpr_rd_addr_1),
		.exe_mode(exe_mode),.creg_rd_addr(creg_rd_addr),.creg_rd_data(creg_rd_data),
		.ex_fwd_data(ex_fwd_data),.ex_dst_addr(ex_dst_addr),.ex_gpr_we_(ex_gpr_we_),
		.mem_fwd_data(mem_fwd_data),.br_addr(br_addr),.br_taken(br_taken),.ld_hazard(ld_hazard),
		.alu_op(alu_op),.alu_in_0(alu_in_0),.alu_in_1(alu_in_1),.br_flag(br_flag),
		.mem_op(mem_op),.mem_wr_data(mem_wr_data),.ctrl_op(ctrl_op),.dst_addr(dst_addr),
		.gpr_we_(gpr_we_),.exp_code(exp_code));
	
	id_reg id_reg(.if_pc(if_pc),.if_en(if_en),.alu_op(alu_op),.alu_in_0(alu_in_0),
		.alu_in_1(alu_in_1),.br_flag(br_flag),.mem_op(mem_op),.mem_wr_data(mem_wr_data),
		.ctrl_op(ctrl_op),.dst_addr(dst_addr),.gpr_we_(gpr_we_),.exp_code(exp_code),
		.clk(clk),.reset(reset),.stall(stall),.flush(flush),
		.id_pc(id_pc),.id_en(id_en),.id_alu_op(id_alu_op),.id_alu_in_0(id_alu_in_0),
		.id_alu_in_1(id_alu_in_1),.id_br_flag(id_br_flag),.id_mem_op(id_mem_op),
		.id_mem_wr_data(id_mem_wr_data),.id_ctrl_op(id_ctrl_op),.id_dst_addr(id_dst_addr),
		.id_gpr_we_(id_gpr_we_),.id_exp_code(id_exp_code));

endmodule