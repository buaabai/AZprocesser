`timescale 1ns/1ns
`define NEGATIVE_RESET
`include "cpu.h"
`include "isa.h"
`include "global_config.h"
`include "nettype.h"
`include "stddef.h"


module gpr(
	clk,reset,rd_addr_0,rd_addr_1,rd_data_0,rd_data_1,
	we_,wr_addr,wr_data
);

	input clk,reset;
	input[4:0] rd_addr_0,rd_addr_1;
	input[31:0] wr_addr,wr_data;
	
	output[31:0] rd_data_0,rd_data_1;
	
	reg[31:0] gpr[31:0];
	integer[31:0] i;
	
	assign rd_data_0 = ((we_ == `ENABLE_)&&(wr_addr == rd_addr_0))?
						wr_data : gpr[rd_addr_0];
	assign rd_data_1 = ((we_ == `ENABLE_)&&(wr_addr == rd_addr_1))?
						wr_data : gpr[rd_addr_1];
	
	always@(posedge clk or `RESTE_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
		begin
			for(i = 0; i < `REG_NUM; i = i + 1)
			begin
				gpr[i] <= #1 `WORD_DATA_W'h0;
			end
		end
		else
		begin
			if(we_ == `ENABLE_)
			begin
				gpr[wr_addr] <= #1 wr_data;
			end
		end
	end
endmodule