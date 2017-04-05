`define NEGATIVE_RESET
`include "global_config.h"
`include "stddef.h"
`include "nettype.h"
module clk_gen(clk_ref,reset_sw,clk,clk_,chip_reset);
	input clk_ref;
	input reset_sw;
	output clk;
	output clk_;
	output chip_reset;
	
	wire dcm_reset,locked;
	
	assign dcm_reset = (reset_sw == `RESET_ENABLE)?`ENABLE:`DISABLE;
	assign chip_reset = ((reset_sw == `RESET_ENABLE)||(locked == `DISABLE))?`RESET_ENABLE:`RESET_DISABLE;
	
	x_s3e_dcm x_s3e_dcm(
		.CLK_IN(clk_ref),
		.RST_IN(dcm_reset),
		.CLK0_OUT(clk),
		.CLK180_OUT(clk_),
		.LOCKED_OUT(locked)
	);
endmodule