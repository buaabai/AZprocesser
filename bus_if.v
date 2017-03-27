`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "cpu.h"
`include "isa.h"

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
	output[29:0] addr;
	output bus_as_,bus_rw;
	output[31:0] bus_wr_data;
	
	reg busy;
	reg[31:0] rd_data;
	reg spm_as_;
	reg bus_req_;
	reg bus_as_;
	reg[1:0] state;
	reg[31:0] rd_buf;
	wire[2:0] s_index;
	
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
endmodule
	