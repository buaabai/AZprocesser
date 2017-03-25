module bus_addr_dec(
	s_addr,s0_cs_,s1_cs_,s2_cs_,s3_cs_,
	s4_cs_,s5_cs_,s6_cs_,s7_cs_
);
	input[29:0] s_addr;
	output s0_cs_,s1_cs_,s2_cs_,s3_cs_,s4_cs_;
	output s5_cs_,s6_cs_,s7_cs_;
	
	wire[29:0] s_addr;
	reg s0_cs_,s1_cs_,s2_cs_,s3_cs_,s4_cs_;
	reg s5_cs_,s6_cs_,s7_cs_;
	wire[`BusSlaveIndexBus] s_index = s_addr[`BusSlaveIndexLoc];
	
	always@(*)
	begin
		s0_cs_ = `DISABLE_;
		s1_cs_ = `DISABLE_;
		s2_cs_ = `DISABLE_;
		s3_cs_ = `DISABLE_;
		s4_cs_ = `DISABLE_;
		s5_cs_ = `DISABLE_;
		s6_cs_ = `DISABLE_;
		s7_cs_ = `DISABLE_;
		case(s_index)
			`BUS_SLAVE_0: s0_cs_ = `ENABLE_;
			`BUS_SLAVE_1: s1_cs_ = `ENABLE_;
			`BUS_SLAVE_2: s2_cs_ = `ENABLE_;
			`BUS_SLAVE_3: s3_cs_ = `ENABLE_;
			`BUS_SLAVE_4: s4_cs_ = `ENABLE_;
			`BUS_SLAVE_5: s5_cs_ = `ENABLE_;
			`BUS_SLAVE_6: s6_cs_ = `ENABLE_;
			`BUS_SLAVE_7: s7_cs_ = `ENABLE_;
		endcase
	end