`timescale 1ns/1ns
`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "bus.h"
`define NEGATIVE_RESET
module bus(
	clk,reset,m0_req_,m1_req_,m2_req_,m3_req_,
	m0_grnt_,m1_grnt_,m2_grnt_,m3_grnt_,
	m0_addr,m1_addr,m2_addr,m3_addr,
	m0_as_,m1_as_,m2_as_,m3_as_,
	m0_rw,m1_rw,m2_rw,m3_rw,
	m0_wr_data,m1_wr_data,m2_wr_data,m3_wr_data,
	m_rd_data,m_rdy_,
	s_addr,s_as_,s_rw,s_wr_data,
	s0_cs_,s1_cs_,s2_cs_,s3_cs_,s4_cs_,
	s5_cs_,s6_cs_,s7_cs_,
	s0_rd_data,s1_rd_data,s2_rd_data,s3_rd_data,
	s4_rd_data,s5_rd_data,s6_rd_data,s7_rd_data,
	s0_rdy_,s1_rdy_,s2_rdy_,s3_rdy_,
	s4_rdy_,s5_rdy_,s6_rdy_,s7_rdy_
);

	input clk,reset;
	input m0_req_,m1_req_,m2_req_,m3_req_;
	input m0_addr,m1_addr,m2_addr,m3_addr;
	input m0_as_,m1_as_,m2_as_,m3_as_;
	input m0_rw,m1_rw,m2_rw,m3_rw;
	input[31:0] m0_wr_data,m1_wr_data;
	input[31:0] m2_wr_data,m3_wr_data;
	
	output m0_grnt_,m1_grnt_,m2_grnt_,m3_grnt_;
	output[31:0] m_rd_data;
	output m_rdy_;
	
	output[29:0] s_addr;
	output s_as_;
	output s_rw;
	output[31:0] s_wr_data;
	output s0_cs_,s1_cs_,s2_cs_,s3_cs_;
	output s4_cs_,s5_cs_,s6_cs_,s7_cs_;
	
	input[31:0] s0_rd_data,s1_rd_data;
	input[31:0] s2_rd_data,s3_rd_data;
	input[31:0] s4_rd_data,s5_rd_data;
	input[31:0] s6_rd_data,s7_rd_data;
	input s0_rdy_,s1_rdy_,s2_rdy_,s3_rdy_;
	input s4_rdy_,s5_rdy_,s6_rdy_,s7_rdy_;
	
	bus_arbiter arbiter(.clk(clk),.reset(reste),
	.m0_req_(m0_req_),.m1_req_(m1_req_),.m2_req_(m2_req_),
	.m3_req_(m3_req_),.m0_grnt_(m0_grnt_),.m1_grnt_(m1_grnt_),
	.m2_grnt_(m2_grnt_),.m3_grnt_(m3_grnt_)
	);
	
	bus_master_mux mastermux(.m0_grnt_(m0_grnt_),
	.m1_grnt_(m1_grnt_),.m2_grnt_(m2_grnt_),.m3_grnt_(m3_grnt_),
	.m0_addr(m0_addr),.m1_addr(m1_addr),.m2_addr(m2_addr),
	.m3_addr(m3_addr),.m0_as_(m0_as_),.m1_as_(m1_as_),
	.m2_as_(m2_as_),.m3_as_(m3_as_),.m0_rw(m0_rw),.m1_rw(m1_rw),
	.m2_rw(m2_rw),.m3_rw(m3_rw),.m0_wr_data(m0_wr_data),
	.m1_wr_data(m1_wr_data),.m2_wr_data(m2_wr_data),
	.m3_wr_data(m3_wr_data),.s_addr(s_addr),.s_as_(s_as_),
	.s_rw(s_rw),.s_wr_data(s_wr_data)
	);
	
	bus_addr_dec addrdec(.s_addr(s_addr),.s0_cs_(s0_cs_),
	.s1_cs_(s1_cs_),.s2_cs_(s2_cs_),.s3_cs_(s3_cs_),
	.s4_cs_(s4_cs_),.s5_cs_(s5_cs_),.s6_cs_(s6_cs_),
	.s7_cs_(s7_cs_)
	);
	
	bus_slave_mux slavemux(.s0_cs_(.s0_cs_),.s1_cs_(s1_cs_),.s2_cs_(s2_cs_),.s3_cs_(s3_cs_),
	.s4_cs_(s4_cs_),.s5_cs_(s5_cs_),.s6_cs_(s6_cs_),
	.s7_cs_(s7_cs_),.s0_rd_data(s0_rd_data),.s1_rd_data(s1_rd_data),
	.s2_rd_data(s2_rd_data),.s3_rd_data(s3_rd_data),.s4_rd_data(s4_rd_data),
	.s5_rd_data(s5_rd_data),.s6_rd_data(s6_rd_data),.s7_rd_data(s7_rd_data),
	.s0_rdy_(s0_rdy_),.s1_rdy_(s1_rdy_),.s2_rdy_(s2_rdy_),.s3_rdy_(s3_rdy_),
	.s4_rdy_(s4_rdy_),.s5_rdy_(s5_rdy_),.s6_rdy_(s6_rdy_),.s7_rdy_(s7_rdy_),
	.m_rd_data(m_rd_data),.m_rdy_(m_rdy_)
	);
	
endmodule