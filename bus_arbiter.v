/*
 --FILE:	bus_arbiter,v
*/
/******* General Headfile *******/
`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
/******* Bus Headfile ******/
`include "bus.h"

/******* bus_arbiter *******/
module bus_arbiter(
	/******* clock & reset *******/
	input wire clk,
	input wire reset,
	/******* master 0 *******/
	input wire m0_req_,
	output reg m0_grnt_,
	/******* master 1 *******/
	input wire m1_req_,
	output reg m1_grnt_,
	/******* master 2 *******/
	input wire m2_req_,
	output reg m2_grnt_,
	/******* master 3 *******/
	input wire m3_req_,
	output reg m3_grnt_
);
	/******* signal inside *******/
	reg[`BusOwnerBus] owner;
	//give access to bus
	always@(*)
	begin
		/******* initialization *******/
		m0_grnt_ = `DISABLE_;
		m1_grnt_ = `DISABLE_;
		m2_grnt_ = `DISABLE_;
		m3_grnt_ = `DISABLE_;  
		//
		case(owner)
			`BUS_OWNER_MASTER_0:
				m0_grnt_ = `ENABLE_;
			`BUS_OWNER_MASTER_1:
				m1_grnt_ = `ENABLE_;
			`BUS_OWNER_MASTER_2:
				m2_grnt_ = `ENABLE_;
			`BUS_OWNER_MASTER_3:
				m3_grnt_ = `ENABLE_;
		endcase
	end
	
	always@(posedge clk or `RESET_EDGE reset)
	begin
		/******* asynchronous reset *******/
		if(reset == `RESET_ENABLE)
			owner <= #1 `BUS_OWNER_MASTER_0;
		else
		begin
		/******* polling mechanism *******/
			case(owner)
				`BUS_OWNER_MASTER_0:
				begin
					if(m0_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_0;
					else if(m1_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_1;
					else if(m2_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_2;
					else if(m3_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_3;
				end
				`BUS_OWNER_MASTER_1:
				begin
					if(m1_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_1;
					else if(m2_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_2;
					else if(m3_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_3;
					else if(m0_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_0;
				end
				`BUS_OWNER_MASTER_2:
				begin
					if(m2_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_2;
					else if(m3_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_3;
					else if(m0_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_0;
					else if(m1_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_1;
				end
				`BUS_OWNER_MASTER_3:
				begin
					if(m3_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_3;
					else if(m0_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_0;
					else if(m1_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_1;
					else if(m2_req_ == `ENABLE_)
						owner <= #1 `BUS_OWNER_MASTER_2;
				end
			endcase
		end
	end
	
endmodule