`define  POSITIVE_MEMORY
`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "spm.h"


module spm(
	clk,if_spm_addr,if_spm_as_,if_spm_rw,if_spm_wr_data,
	if_spm_rd_data,mem_spm_addr,mem_spm_as_,mem_spm_rw,
	mem_spm_wr_data,mem_spm_rd_data
);

	input clk;
	input[11:0] if_spm_addr,mem_spm_addr;
	input if_spm_as_,mem_spm_as_;
	input if_spm_rw,mem_spm_rw;
	input[31:0] if_spm_wr_data,mem_spm_wr_data;
	
	output[31:0] if_spm_rd_data,mem_spm_rd_data;
	
	reg wea,web;
	
	always@(*)
	begin
		if((if_spm_as_ == `ENABLE)&&(if_spm_rw == `WRITE))
		begin
			wea = `MEM_ENABLE;
		end
		else
		begin
			wea = `MEM_DISABLE;
		end
		if((mem_spm_as_ == `ENABLE) && (mem_spm_rw == `WRITE))
		begin
			web = `MEM_ENABLE;
		end
		else
		begin
			web = `MEM_DISABLE;
		end
	end
	
	//fpga rom 实例化
	x_s3e_dpram x_s3e_dpram(
		.clka(clk),
		.addra(if_spm_addr),
		.dina(if_spm_wr_data),
		.wea(wea),
		.douta(if_spm_rd_data),
		
		.clkb(clk),
		.addrb(mem_spm_addr),
		.dinb(mem_spm_wr_data),
		.web(web),
		.doutb(mem_spm_rd_data)
	);
	
endmodule