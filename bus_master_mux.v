/*
 -- =====================================================================
 FILE : bus_master_mux.v
 -- =====================================================================
*/
/*******General Headfile*******/
`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
/******* Bus Headfile*******/
`include "bus.h"
/******* master mux *******/
module bus_master_mux(
	//master 0
	input wire[`WordAddrBus] m0_addr,
	input wire m0_as_,
	input wire m0_rw,
	input wire[`WordDataBus] m0_wr_data,
	input wire m0_grnt_,
	//master 1
	input wire[`WordAddrBus] m1_addr,
	input wire m1_as_,
	input wire m1_rw,
	input wire[`WordDataBus] m1_wr_data,
	input wire m1_grnt_,
	//master 2
	input wire[`WordAddrBus] m2_addr,
	input wire m2_as_,
	input wire m2_rw,
	input wire[`WordDataBus] m2_wr_data,
	input wire m2_grnt_,
	//master 3
	input wire[`WordAddrBus] m3_addr,
	input wire m3_as_,
	input wire m3_rw,
	input wire[`WordDataBus] m3_wr_data,
	input wire m3_grnt_,
	//slave common signal
	output reg[`WordAddrBus] s_addr,
	output reg s_as_,
	output reg s_rw,
	output reg[`WordDataBus] s_wr_data
);
	/*******master mux *******/
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
	