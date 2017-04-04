`define NEGATIVE_RESET
`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "cpu.h"
`include "isa.h"
`timescale 1ns/1ns

module mem_stage(busy,spm_rd_data,spm_addr,spm_as_,spm_rw,
	spm_wr_data,bus_rd_data,bus_rdy_,bus_grnt_,bus_req_,bus_addr,
	bus_as_,bus_rw,bus_wr_data,ex_en,ex_mem_op,ex_mem_wr_data,ex_out,
	ex_pc,ex_br_flag,ex_ctrl_op,ex_dst_addr,ex_gpr_we_,ex_exp_code,
	fwd_data,mem_pc,mem_en,mem_br_flag,mem_ctrl_op,mem_dst_addr,
	mem_gpr_we_,mem_exp_code,mem_out,
	clk,reset,stall,flush);
	
	input clk,reset;
	input stall,flush;
	input[31:0] spm_rd_data;
	input[31:0] bus_rd_data;
	input bus_rdy_;
	input bus_grnt_;
	input ex_en;
	input[1:0] ex_mem_op;
	input[31:0] ex_mem_wr_data;
	input[31:0] ex_out;
	input[29:0] ex_pc;
	input ex_br_flag;
	input[1:0] ex_ctrl_op;
	input[4:0] ex_dst_addr;
	input ex_gpr_we_;
	input[2:0] ex_exp_code;
	
	output busy;
	output[29:0] spm_addr;
	output spm_as_;
	output spm_rw;
	output[31:0] spm_wr_data;
	output bus_req_;
	output[29:0] bus_addr;
	output bus_as_;
	output bus_rw;
	output[31:0] bus_wr_data;
	output[31:0] fwd_data;
	output[29:0] mem_pc;
	output mem_en;
	output mem_br_flag;
	output[1:0] mem_ctrl_op;
	output[4:0] mem_dst_addr;
	output mem_gpr_we_;
	output[2:0] mem_exp_code;
	output[31:0] mem_out;
	
	wire[29:0] addr;
	wire as_;
	wire rw;
	wire[31:0] wr_data;
	wire[31:0] rd_data;
	wire[31:0] out;
	wire miss_align;
	wire[31:0] fwd_data = out;
	
	bus_if bus_if(.busy(busy),.spm_rd_data(spm_rd_data),.spm_addr(spm_addr),
		.spm_as_(spm_as_),.spm_rw(spm_rw),.spm_wr_data(spm_wr_data),.bus_rd_data(bus_rd_data),
		.bus_rdy_(bus_rdy_),.bus_grnt_(bus_grnt_),.bus_req_(bus_req_),.bus_addr(bus_addr),
		.bus_as_(bus_as_),.bus_rw(bus_rw),.bus_wr_data(bus_wr_data),.clk(clk),.reset(reset),
		.stall(stall),.flush(flush),.addr(addr),.as_(as_),.rw(rw),.wr_data(wr_data),.rd_data(rd_data));
	mem_ctrl mem_ctrl(.ex_en(ex_en),.ex_mem_op(ex_mem_op),.ex_mem_wr_data(ex_mem_wr_data),.ex_out(ex_out),
		.addr(addr),.as_(as_),.rw(rw),.wr_data(wr_data),.rd_data(rd_data),.out(out),.miss_align(miss_align));
	mem_reg mem_reg(.out(out),.miss_align(miss_align),.ex_pc(ex_pc),.ex_en(ex_en),.ex_br_flag(ex_br_flag),
		.ex_ctrl_op(ex_ctrl_op),.ex_dst_addr(ex_dst_addr),.ex_gpr_we_(ex_gpr_we_),.ex_exp_code(ex_exp_code),
		.clk(clk),.reset(reset),.stall(stall),.flush(flush),.mem_pc(mem_pc),.mem_en(mem_en),
		.mem_br_flag(mem_br_flag),.mem_ctrl_op(mem_ctrl_op),.mem_dst_addr(mem_dst_addr),.mem_gpr_we_(mem_gpr_we_),
		.mem_exp_code(mem_exp_code),.mem_out(mem_out));
		
endmodule