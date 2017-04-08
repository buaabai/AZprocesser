/*
 -- ===================================================================
 -- FILE: bus_addr_dec
 -- ===================================================================
*/
/******* General Headfile *******/
`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
/******* Bus Headfile *******/
`include "bus.h"
/******* bus address decoder *******/
module bus_addr_dec(
	input wire[`WordAddrBus] s_addr, //Slave address
	/******* Slave Chip Selection Signal *******/
	output reg s0_cs_,
	output reg s1_cs_,
	output reg s2_cs_,
	output reg s3_cs_,
	output reg s4_cs_,
	output reg s5_cs_,
	output reg s6_cs_,
	output reg s7_cs_
);
	/******* Slave number *******/
	wire[`BusSlaveIndexBus] s_index = s_addr[`BusSlaveIndexLoc];
	/******* decode *******/
	always@(*)
	begin
		s0_cs_ = `DISABLE_;
		s1_cs_ = `DISABLE_;
		s2_cs_ = `DISABLE_;
		s3_cs_ = `DISABLE_;
		s4_cs_ = `DISABLE_;
		s5_cs_ = `DISABLE_;
		s6_cs_ = `DISABLE_;
		s7_cs_ = `DISABLE_; //initialization
		case(s_index)
			`BUS_SLAVE_0: begin s0_cs_ = `ENABLE_; end
			`BUS_SLAVE_1: begin s1_cs_ = `ENABLE_; end
			`BUS_SLAVE_2: begin s2_cs_ = `ENABLE_; end
			`BUS_SLAVE_3: begin s3_cs_ = `ENABLE_; end
			`BUS_SLAVE_4: begin s4_cs_ = `ENABLE_; end
			`BUS_SLAVE_5: begin s5_cs_ = `ENABLE_; end
			`BUS_SLAVE_6: begin s6_cs_ = `ENABLE_; end
			`BUS_SLAVE_7: begin s7_cs_ = `ENABLE_; end
			//decode
		endcase
	end
	
endmodule
