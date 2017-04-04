`define NEGATIVE_RESET
`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "cpu.h"
`include "isa.h"
`include "bus.h"
`timescale 1ns/1ns

module bus_if(
	clk,reset,
	stall,flush,busy,
	addr,as_,rw,wr_data,rd_data,
	spm_rd_data,spm_addr,spm_as_,spm_rw,spm_wr_data,
	bus_rd_data,bus_rdy_,bus_grnt_,bus_req_,bus_addr,
	bus_as_,bus_rw,bus_wr_data
);

	input clk,reset;
	
	input stall,flush;
	
	input[29:0] addr;
	input as_,rw;
	input[31:0] wr_data;
	
	input[31:0] spm_rd_data;
	
	input[31:0] bus_rd_data;
	input bus_rdy_,bus_grnt_;
	
	output busy;
	
	output[31:0] rd_data;
	
	output[29:0] spm_addr;
	output spm_as_,spm_rw;
	output[31:0] spm_wr_data;
	
	output bus_req_;
	output[29:0] bus_addr;
	output bus_as_,bus_rw;
	output[31:0] bus_wr_data;
	output[29:0] bus_addr;
	
	reg busy;
	reg[31:0] rd_data;
	reg spm_as_;
	reg bus_req_;
	reg bus_as_;
	reg[1:0] state;
	reg[31:0] rd_buf;
	wire[2:0] s_index;
	reg bus_rw;
	reg[31:0] bus_wr_data;
	reg[29:0] bus_addr;
	
	assign s_index = addr[`BusSlaveIndexLoc];
	
	assign spm_addr = addr;
	assign spm_rw = rw;
	assign spm_wr_data = wr_data;
	
	always@(*)
	begin
		rd_data = `WORD_DATA_W'h0;
		spm_as_ = `DISABLE_;
		busy = `DISABLE_;
		
		case(state)
			`BUS_IF_STATE_IDLE:
			begin
				if((flush == `DISABLE) && (as_ == `ENABLE))
				begin
					if((s_index == `BUS_SLAVE_1))
					begin
						if(stall == `DISABLE)
						begin
							spm_as_ = `ENABLE;
							if(rw == `READ)
							begin
								rd_data = spm_rd_data;
							end
						end
					end
					else
					begin
						busy = `ENABLE;
					end
				end
			end
			`BUS_IF_STATE_REQ:
			begin
				busy = `ENABLE;
			end
			`BUS_IF_STATE_ACCESS:
			begin
				if(bus_rdy_ == `ENABLE)
				begin
					if(rw == `READ)
					begin
						rd_data = bus_rd_data;
					end
				end
				else
				begin
					busy = `ENABLE;
				end
			end
			`BUS_IF_STATE_STALL:
			begin
				if(rw == `READ)
				begin
					rd_data =rd_buf;
				end
			end
		endcase
	end
	
	always@(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
		begin
			state <= #1 `BUS_IF_STATE_IDLE;
			bus_req_ <= #1 `DISABLE_;
			bus_addr <= #1 `WORD_ADDR_W'h0;
			bus_as_ <= #1 `DISABLE_;
			bus_rw <= #1 `READ;
			bus_wr_data <= #1 `WORD_DATA_W'h0;
			rd_buf <= #1 `WORD_DATA_W'h0;
		end
		else
		begin
			case(state)
			`BUS_IF_STATE_IDLE:
			begin
				if((flush == `DISABLE) && (as_ == `ENABLE))
				begin
					if(s_index != `BUS_SLAVE_1)
					begin
						state <= #1 `BUS_IF_STATE_REQ;
						bus_req_ <= #1 `ENABLE;
						bus_addr <= #1 addr;
						bus_rw <= #1 rw;
						bus_wr_data <= #1 wr_data;
					end
				end
			end
			`BUS_IF_STATE_REQ:
			begin
				if(bus_grnt_ == `ENABLE)
				begin
					state <= #1 `BUS_IF_STATE_ACCESS;
					bus_as_ <= #1 `ENABLE;
				end
			end
			`BUS_IF_STATE_ACCESS:
			begin
				bus_as_ <= #1 `DISABLE;
				if(bus_rdy_ == `ENABLE_)
				begin
					bus_req_ <= #1 `DISABLE_;
					bus_addr <= #1 `WORD_ADDR_W'h0;
					bus_rw <= #1 `READ;
					bus_wr_data <= #1 `WORD_DATA_W'h0;
					
					if(bus_rw == `READ)
					begin
						rd_buf <= #1 bus_rd_data;
					end
					
					if(stall == `ENABLE)
					begin
						state <= #1 `BUS_IF_STATE_STALL;
					end
					else
					begin
						state <= #1 `BUS_IF_STATE_IDLE;
					end
				end
			end
			`BUS_IF_STATE_STALL:
			begin
				if(stall == `DISABLE)
				begin
					state <= #1 `BUS_IF_STATE_IDLE;
				end
			end
			endcase
		end
	end
endmodule
	