`include "global_config.h"
`include "nettype.h"
`include "cpu.h"
`include "isa.h"
`include "stddef.h"

module cpu(reset,clk,if_bus_rd_data,if_bus_rdy_,if_bus_grnt_,if_bus_req_,
	if_bus_addr,if_bus_as_,if_bus_rw,if_bus_wr_data,clk_,cpu_irq,mem_bus_rd_data,
	mem_bus_rdy_,mem_bus_grnt_,mem_bus_req_,mem_bus_addr,mem_bus_as_,mem_bus_rw,
	mem_bus_wr_data);
	
	input clk,reset,clk_;
	input[31:0] if_bus_rd_data;
	input if_bus_rdy_,if_bus_grnt_;
	input[7:0] cpu_irq;
	input[31:0] mem_bus_rd_data;
	input mem_bus_rdy_;
	input mem_bus_grnt_;
	
	output if_bus_req_;
	output[29:0] if_bus_addr;
	output if_bus_as_;
	output if_bus_rw;
	output[31:0] if_bus_wr_data;
	output mem_bus_req_;
	output[29:0] mem_bus_addr;
	output mem_bus_as_;
	output mem_bus_rw;
	output mem_bus_wr_data;
	
	wire if_busy,if_stall,if_flush;
	wire[29:0] new_pc;
	wire br_taken;
	wire[29:0] br_addr;
	wire[29:0] if_pc;
	wire[31:0] if_insn;
	wire if_en;
	wire[31:0] if_spm_rd_data;
	wire[29:0] if_spm_addr;
	wire if_spm_as_;
	wire if_spm_rw;
	wire[31:0] if_spm_wr_data;
	
	if_stage if_stage(.reset(reset),.clk(clk),.bus_rd_data(if_bus_rd_data),
		.bus_rdy_(if_bus_rdy_),.bus_grnt_(if_bus_grnt_),.bus_req_(if_bus_req_),
		.bus_addr(if_bus_addr),.bus_as_(if_bus_as_),.bus_rw(if_bus_rw),
		.bus_wr_data(if_bus_wr_data),.busy(if_busy),.stall(if_stall),.flush(if_flush),
		.new_pc(new_pc),.br_taken(br_taken),.br_addr(br_addr),.if_pc(if_pc),
		.if_insn(if_insn),.if_en(if_en),.spm_rd_data(if_spm_rd_data),
		.spm_addr(if_spm_addr),.spm_as_(if_spm_as_),.spm_rw(if_spm_rw),.spm_wr_data(if_spm_wr_data));
	
	spm spm(.if_spm_rd_data(if_spm_rd_data),.if_spm_addr(if_spm_addr),.if_spm_as_(if_spm_as_),
		.if_spm_rw(if_spm_rw),.if_spm_wr_data(if_spm_wr_data),.clk(clk_),.mem_spm_rd_data(spm_rd_data),
		.mem_spm_addr(spm_addr),.mem_spm_as_(spm_as_),.mem_spm_rw(spm_rw),.mem_spm_wr_data(spm_wr_data));
	
	id_stage id_stage(.clk(clk),.reset(reset),.br_taken(br_taken),.br_addr(br_addr),.if_pc(if_pc),
		.if_insn(if_insn),.if_en(if_en),.creg_rd_addr(creg_rd_addr),.ld_hazard(ld_hazard),.exe_mode(exe_mode),
		.creg_rd_data(creg_rd_data),.stall(id_stall),.flush(id_flush),.mem_fwd_data(mem_fwd_data),.ex_dst_addr(ex_dst_addr),
		.ex_gpr_we_(ex_gpr_we_),.ex_fwd_data(ex_fwd_data),.id_pc(id_pc),.id_en(id_en),.id_alu_op(id_alu_op),
		.id_alu_in_0(id_alu_in_0),.id_alu_in_1(id_alu_in_1),.id_br_flag(id_br_flag),.id_mem_op(id_mem_op),.id_mem_wr_data(id_mem_wr_data),
		.id_ctrl_op(id_ctrl_op),.id_dst_addr(id_dst_addr),.id_gpr_we_(id_gpr_we_),.id_exp_code(id_exp_code),
		.gpr_rd_data_0(gpr_rd_data_0),.gpr_rd_addr_0(gpr_rd_addr_0),.gpr_rd_addr_1(gpr_rd_addr_1),.gpr_rd_data_1(gpr_rd_data_1));
	
	gpr gpr(.rd_addr_0(gpr_rd_addr_0),.rd_data_0(gpr_rd_data_0),.rd_addr_1(gpr_rd_addr_1),.rd_data_1(gpr_rd_data_1),
		.we_(mem_gpr_we_),.wr_addr(mem_dst_addr),.wr_data(mem_out));
		
	ex_stage ex_stage(.fwd_data(ex_fwd_data),.id_pc(id_pc),.id_en(id_en),.id_alu_op(id_alu_op),.id_alu_in_0(id_alu_in_0),
		.id_alu_in_1(id_alu_in_1),.id_br_flag(id_br_flag),.id_mem_op(id_mem_op),.id_mem_wr_data(id_mem_wr_data),
		.id_ctrl_op(id_ctrl_op),.id_dst_addr(id_dst_addr),.id_gpr_we_(id_gpr_we_),.id_exp_code(id_exp_code),
		.clk(clk),.reset(reset),.int_detect(int_detect),.stall(ex_stall),.flush(ex_flush),.ex_pc(ex_pc),.ex_en(ex_en),.ex_br_flag(ex_br_flag),
		.ex_mem_op(ex_mem_op),.ex_mem_wr_data(ex_mem_wr_data),.ex_ctrl_op(ex_ctrl_op),.ex_dst_addr(ex_dst_addr),.ex_gpr_we_(ex_gpr_we_),
		.ex_exp_code(ex_exp_code),.ex_out(ex_out));
		
	mem_stage mem_stage(.reset(reset),.clk(clk),.fwd_data(mem_fwd_data),.ex_pc(ex_pc),.ex_en(ex_en),.ex_br_flag(ex_br_flag),
		.ex_mem_op(ex_mem_op),.ex_mem_wr_data(ex_mem_wr_data),.ex_ctrl_op(ex_ctrl_op),.ex_dst_addr(ex_dst_addr),.ex_gpr_we_(ex_gpr_we_),
		.ex_exp_code(ex_exp_code),.ex_out(ex_out),.spm_rd_data(spm_rd_data),.spm_addr(spm_addr),.spm_as_(spm_as_),.spm_rw(spm_rw),
		.spm_wr_data(spm_wr_data),.busy(mem_busy),.stall(mem_stall),.flush(mem_flush),.mem_pc(mem_pc),.mem_en(mem_en),.mem_br_flag(mem_br_flag),
		.mem_ctrl_op(mem_ctrl_op),.mem_dst_addr(mem_dst_addr),.mem_exp_code(mem_exp_code),.mem_out(mem_out),.mem_gpr_we_(mem_gpr_we_),
		.bus_rd_data(mem_bus_rd_data),.bus_rdy_(mem_bus_rdy_),.bus_grnt_(mem_bus_grnt_),.bus_req_(mem_bus_req_),.bus_addr(mem_bus_addr),
		.bus_as_(mem_bus_as_),.bus_rw(mem_bus_rw),.bus_wr_data(mem_bus_wr_data));
	
	ctrl ctrl(.reset(reset),.clk(clk),.id_pc(id_pc),.if_busy(if_busy),.if_stall(if_stall),.if_flush(if_flush),
		.new_pc(new_pc),.creg_rd_addr(creg_rd_addr),
		.ld_hazard(ld_hazard),.exe_mode(exe_mode),.creg_rd_data(creg_rd_data),.id_stall(id_stall),.id_flush(id_flush),
		.int_detect(int_detect),.ex_stall(ex_stall),
		.ex_flush(ex_flush),.mem_busy(mem_busy),.mem_stall(mem_stall),.mem_flush(mem_flush),.mem_pc(mem_pc),.mem_en(mem_en),.mem_br_flag(mem_br_flag),
		.mem_ctrl_op(mem_ctrl_op),.mem_dst_addr(mem_dst_addr),.mem_exp_code(mem_exp_code),.mem_out(mem_out),.irq(cpu_irq));
		
endmodule