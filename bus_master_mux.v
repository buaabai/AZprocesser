`timescale 1ns/1ns
`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "bus.h"
module bus_master_mux(
	m0_addr,m0_as_,m0_rw,m0_wr_data,m0_grnt_,
	m1_addr,m1_as_,m1_rw,m1_wr_data,m1_grnt_,
	m2_addr,m2_as_,m2_rw,m2_wr_data,m2_grnt_,
	m3_addr,m3_as_,m3_rw,m3_wr_data,m3_grnt_,
	s_addr,s_as_,s_rw,s_wr_data
);
	input[29:0] m0_addr,m1_addr,m2_addr,m3_addr;
	input m0_as_,m1_as_,m2_as_,m3_as_;
	input m0_rw,m1_rw,m2_rw,m3_rw;
	input m0_grnt_,m1_grnt_,m2_grnt_,m3_grnt_;
	input[31:0] m0_wr_data,m1_wr_data;
	input[31:0] m2_wr_data,m3_wr_data;
	
	output[29:0] s_addr;
	output[31:0] s_wr_data;
	output s_as_;
	output s_rw;
	
	wire[29:0] m0_addr,m1_addr,m2_addr,m3_addr;
	wire m0_as_,m1_as_,m2_as_,m3_as_;
	wire m0_rw,m1_rw,m2_rw,m3_rw;
	wire m0_grnt_,m1_grnt_,m2_grnt_,m3_grnt_;
	wire[31:0] m0_wr_data,m1_wr_data;
	wire[31:0] m2_wr_data,m3_wr_data;
	
	reg[29:0] s_addr;
	reg[31:0] s_wr_data;
	reg s_as_;
	reg s_rw;
	
	always@(*)
	begin
		if(m0_grnt_ == `ENABLE_)
		begin
			s_addr = m0_addr;
			s_as_ = m0_as_;
			s_rw = m0_rw;
			s_wr_data = m0_wr_data;
		end
		else if(m1_grnt_ == `ENABLE_)
		begin
			s_addr = m1_addr;
			s_as_ = m1_as_;
			s_rw = m1_rw;
			s_wr_data = m1_wr_data;
		end
		else if(m2_grnt_ == `ENABLE_)
		begin
			s_addr = m2_addr;
			s_as_ = m2_as_;
			s_rw = m2_rw;
			s_wr_data = m2_wr_data;
		end
		else if(m3_grnt_ == `ENABLE_)
		begin
			s_addr = m3_addr;
			s_as_ = m3_as_;
			s_rw = m3_rw;
			s_wr_data = m3_wr_data;
		end
		else
		begin
			s_addr = `WORD_ADDR_W'h0;
			s_as_ = `DISABLE_;
			s_rw = `READ;
			s_wr_data = `WORD_DATA_W'h0;
		end
	end
endmodule
	