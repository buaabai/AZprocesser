`ifndef __GLOBAL_CONFIG_HEADER__
	`define __GLOBAL_CONFIG_HEADER__
	`ifdef POSITIVE_RESET
		`define RESET_EDGE posedge
		`define RESET_ENABLE 1'b1
		`define RESET_DISABLE 1'b0
	`endif

	`ifdef NEGATIVE_RESET
		`define RESET_EDGE negedge
		`define RESET_ENABLE 1'b0
		`define RESET_DISABLE 1'b1
	`endif

	`ifdef POSITIVE_MEMORY
		`define MEM_ENABLE 1'b1
		`define MEM_DISABLE 1'b0
	`endif

	`ifdef NEGATIVE_MEMORY
		`define MEM_ENABLE 1'b0
		`define MEM_DISABLE 1'b1
	`endif

//ifdef IMPLEMENT_TIMER
//ifdef IMPLEMENT_UART
//ifdef IMPLEMENT_GPIO
`endif

	