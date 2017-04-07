`define NEGATIVE_RESET
`timescale 1ns/1ns
`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "rom.h"

module rom(
	clk,reset,cs_,as_,addr,rd_data,rdy_
);
	input clk,reset;
	input cs_,as_;
	input wire[10:0] addr;
	output wire[31:0] rd_data;
	output rdy_;
	
	reg rdy_;
	
	//Xilinx FPGA 块RAM
	x_s3e_sprom x_s3e_sprom(
		.clka(clka),
		.addra(addr),
		.douta(rd_data)
	);
	
	always@(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
		begin
			rdy_ <= #1 `DISABLE;
		end
		else
		begin
			if((cs_ == `ENABLE_) && (as_ == `ENABLE_))
			begin
				rdy_ <= #1 `ENABLE_;
			end
			else 
			begin
				rdy_ <= #1 `DISABLE_;
			end
		end
	end
endmodule
	