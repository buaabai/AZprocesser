`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "cpu.h"
`include "isa.h"
`timescale 1ns/1ns

module if_stage(
	clk,reset,stall,flush,new_pc,br_taken,br_addr,
	if_pc,if_insn,if_en,
	busy,spm_rd_data,spm_addr,spm_as_,spm_rw,spm_wr_data,
	bus_rd_data,bus_rdy_,bus_grnt_,bus_req_,bus_addr,
	bus_as_,bus_rw,bus_wr_data
);

	input clk,reset;
	input stall,flush;
	input[29:0] new_pc;
	input br_taken;
	input[29:0] br_addr;
	input[31:0] spm_rd_data;
	
	input[31:0] bus_rd_data;
	input bus_rdy_;
	input bus_grnt_;
	
	output[29:0] if_pc;
	output[31:0] if_insn;
	output if_en;
	
	output busy;
	output[11:0] spm_addr;
	output spm_as_;
	output spm_rw;
	output[31:0] spm_wr_data;
	
	output bus_req_;
	output[29:0] bus_addr;
	output bus_as_;
	output bus_rw;
	output[31:0] bus_wr_data;
	
	wire as_,rw;
	wire[31:0] wr_data;
	wire[31:0] rd_data;
	wire[29:0] addr;
	wire[11:0] spm_addr;
	
	assign as_ = `ENABLE_;
	assign rw_ = `READ;
	assign wr_data = `WORD_DATA_W'h0;
	
	bus_if bus_if(.busy(busy),.spm_rd_data(spm_rd_data),
		.spm_as_(spm_as_),.spm_rw(spm_rw),.spm_wr_data(spm_wr_data),
		.bus_rd_data(bus_rd_data),.bus_rdy_(bus_rdy_),.bus_grnt_(bus_grnt_),
		.bus_req_(bus_req_),.bus_addr(bus_addr),.bus_as_(bus_as_),
		.bus_rw(bus_rw),.bus_wr_data(bus_wr_data),.clk(clk),.reset(reset),
		.stall(stall),.flush(flush),.addr(addr),.as_(as_),.rw(rw),
		.wr_data(wr_data),.rd_data(rd_data),.spm_addr(spm_addr)
	);
	
	if_reg if_reg(.clk(clk),.reset(reset),.stall(stall),.flush(flush),
	.insn(rd_data),.new_pc(new_pc),.br_taken(br_taken),.br_addr(br_addr),
	.if_pc(if_pc),.if_insn(if_insn),.if_en(if_en)
	);
	
endmodule