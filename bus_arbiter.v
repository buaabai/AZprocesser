//总线仲裁器 轮询机制 round robin
`define NEGATIVE_RESET
`timescale 1ns/1ns
`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "bus.h"
`define NEGATIVE_RESET
module bus_arbiter(
		clk,reset,
		m0_req_,m0_grnt_,
		m1_req_,m1_grnt_,
		m2_req_,m2_grnt_,
		m3_req_,m3_grnt_
);
	input clk,reset;
	input m0_req_,m1_req_,m2_req_,m3_req_;
	output m0_grnt_,m1_grnt_,m2_grnt_,m3_grnt_;
	
	wire clk,reset;
	wire m0_req_,m1_req_,m2_req_,m3_req_;
	
	reg m0_grnt_,m1_grnt_,m2_grnt_,m3_grnt_;
	
	reg[1:0] owner;
	
	//赋予总线使用权
	always@(*)
	begin
		m0_grnt_ = `DISABLE;
		m1_grnt_ = `DISABLE;
		m2_grnt_ = `DISABLE;
		m3_grnt_ = `DISABLE;  //初始化
		case(owner)
			`BUS_OWNER_MASTER_0:
				m0_grnt_ = `ENABLE;
			`BUS_OWNER_MASTER_1:
				m1_grnt_ = `ENABLE;
			`BUS_OWNER_MASTER_2:
				m2_grnt_ = `ENABLE;
			`BUS_OWNER_MASTER_3:
				m3_grnt_ = `ENABLE;
		endcase
	end
	
	always@(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
			owner <= #1 `BUS_OWNER_MASTER_0;
		else
		begin
			case(owner)
				`BUS_OWNER_MASTER_0:
				begin
					if(m0_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_0;
					else if(m1_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_1;
					else if(m2_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_2;
					else if(m3_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_3;
				end
				`BUS_OWNER_MASTER_1:
				begin
					if(m1_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_1;
					else if(m2_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_2;
					else if(m3_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_3;
					else if(m0_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_0;
				end
				`BUS_OWNER_MASTER_2:
				begin
					if(m2_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_2;
					else if(m3_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_3;
					else if(m0_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_0;
					else if(m1_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_1;
				end
				`BUS_OWNER_MASTER_3:
				begin
					if(m3_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_3;
					else if(m0_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_0;
					else if(m1_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_1;
					else if(m2_req_ == `ENABLE)
						owner <= #1 `BUS_OWNER_MASTER_2;
				end
			endcase
		end
	end
endmodule