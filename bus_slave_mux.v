`timescale 1ns/1ns
`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "bus.h"
module bus_slave_mux(
	s0_cs_,s0_rd_data_,s0_rdy_,
	s1_cs_,s1_rd_data_,s1_rdy_,
	s2_cs_,s2_rd_data_,s2_rdy_,
	s3_cs_,s3_rd_data_,s3_rdy_,
	s4_cs_,s4_rd_data_,s4_rdy_,
	s5_cs_,s5_rd_data_,s5_rdy_,
	s6_cs_,s6_rd_data_,s6_rdy_,
	s7_cs_,s7_rd_data_,s7_rdy_,
	m_rd_data,m_rdy_
);
	input s0_cs_,s1_cs_,s2_cs_,s3_cs_;
	input s4_cs_,s5_cs_,s6_cs_,s7_cs_;
	input s0_rdy_,s1_rdy_,s2_rdy_,s3_rdy_;
	input s4_rdy_,s5_rdy_,s6_rdy_,s7_rdy_;
	input[31:0] s0_rd_data_,s1_rd_data_;
	input[31:0] s2_rd_data_,s3_rd_data_;
	input[31:0] s4_rd_data_,s5_rd_data_;
	input[31:0] s6_rd_data_,s7_rd_data_;
	
	output m_rdy_;
	output[31:0] m_rd_data;
	
	reg[31:0] m_rd_data;
	reg m_rdy_;
	
	always@(*)
	begin
		if(s0_cs_ == `ENABLE_)
		begin
			m_rd_data = s0_rd_data_;
			m_rdy_ = s0_rdy_;
		end
		else if(s1_cs_ == `ENABLE_)
		begin
			m_rd_data = s1_rd_data_;
			m_rdy_ = s1_rdy_;
		end
		else if(s2_cs_ == `ENABLE_)
		begin
			m_rd_data = s2_rd_data_;
			m_rdy_ = s2_rdy_;
		end
		else if(s3_cs_ == `ENABLE_)
		begin
			m_rd_data = s3_rd_data_;
			m_rdy_ = s3_rdy_;
		end
		else if(s4_cs_ == `ENABLE_)
		begin
			m_rd_data = s4_rd_data_;
			m_rdy_ = s4_rdy_;
		end
		else if(s5_cs_ == `ENABLE_)
		begin
			m_rd_data = s5_rd_data_;
			m_rdy_ = s5_rdy_;
		end
		else if(s6_cs_ == `ENABLE_)
		begin
			m_rd_data = s6_rd_data_;
			m_rdy_ = s6_rdy_;
		end
		else if(s7_cs_ == `ENABLE_)
		begin
			m_rd_data = s7_rd_data_;
			m_rdy_ = s7_rdy_;
		end
		else
		begin
			m_rd_data = `WORD_DATA_W'h0;
			m_rdy_ = `DISABLE_;
		end
	end
endmodule