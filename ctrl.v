`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "cpu.h"
`include "isa.h"
`define NEGATIVE_RESET
`timescale 1ns/1ns
module ctrl(clk,reset,creg_rd_addr,creg_rd_data,exe_mode,irq,int_detect,
	id_pc,mem_pc,mem_en,mem_br_flag,mem_ctrl_op,mem_dst_addr,mem_gpr_we_,
	mem_exp_code,mem_out,if_busy,ld_hazard,mem_busy,if_stall,id_stall,
	ex_stall,mem_stall,if_flush,id_flush,ex_flush,mem_flush,new_pc);

	input clk,reset;
	input[4:0] creg_rd_addr;
	input[7:0] irq;
	input[29:0] id_pc;
	input[29:0] mem_pc;
	input mem_en;
	input mem_br_flag;
	input[1:0] mem_ctrl_op;
	input[4:0] mem_dst_addr;
	input mem_gpr_we_;
	input[2:0] mem_exp_code;
	input if_busy;
	input ld_hazard;
	input mem_busy;
	
	output[31:0] creg_rd_data;
	output exe_mode;
	output int_detect;
	output[31:0] mem_out;
	output if_stall;
	output id_stall;
	output ex_stall;
	output mem_stall;
	output if_flush;
	output id_flush;
	output ex_flush;
	output mem_flush;
	output[29:0] new_pc;
	
	reg[31:0] creg_rd_data;
	reg exe_mode;
	reg int_detect;
	reg[29:0] new_pc;
	
	reg int_en;
	reg pre_exe_mode;
	reg pre_int_en;
	reg[29:0] epc;
	reg[29:0] exp_vector;
	reg[2:0] exp_code;
	reg dly_flag;
	reg[7:0] mask;
	reg[29:0] pre_pc;
	reg br_flag;
	
	wire stall = if_busy | mem_busy;
	assign if_stall = stall | ld_hazard;
	assign id_stall = stall;
	assign ex_stall = stall;
	assign mem_stall = stall;
	
	reg flush;
	assign if_flush = flush;
	assign id_flush = flush | ld_hazard;
	assign ex_flush = flush;
	assign mem_flush = flush;
	
	always@(*)
	begin
		new_pc = `WORD_ADDR_W'h0;
		flush = `DISABLE;
		
		if(mem_en == `ENABLE)
		begin
			if(mem_exp_code != `ISA_EXP_NO_EXP)
			begin
				new_pc = exp_vector;
				flush = `ENABLE;
			end
			else if(mem_ctrl_op == `CTRL_OP_EXRT)
			begin
				new_pc = epc;
				flush = `ENABLE;
			end
			else if(mem_ctrl_op == `CTRL_OP_WRCR)
			begin
				new_pc = mem_pc;
				flush = `ENABLE;
			end
		end
	end
	
	always@(*)
	begin
		if((int_en == `ENABLE) && ((|((~mask) & irq)) == `ENABLE))
		begin
			int_detect = `ENABLE;
		end
		else
		begin
			int_detect = `DISABLE;
		end
	end
	
	always@(*)
	begin
		case(creg_rd_addr)
			`CREG_ADDR_STATUS:
			begin
				creg_rd_data = {{`WORD_DATA_W-2{1'b0}},int_en,exe_mode};
			end
			`CREG_ADDR_PRE_STATUS:
			begin
				creg_rd_data = {{`WORD_DATA_W-2{1'b0},pre_int_en,pre_exe_mode};
			end
			`CREG_ADDR_PC:
			begin
				creg_rd_data = {id_pc,`BYTE_OFFSET_W'h0};
			end
			`CREG_ADDR_EPC:
			begin
				creg_rd_data = {epc,`BYTE_OFFSET_W'h0};
			end
			`CREG_ADDR_EXP_VECTOR:
			begin
				creg_rd_data = {exp_vector,`BYTE_OFFSET_W'h0};
			end
			`CREG_ADDR_CAUSE:
			begin
				creg_rd_data = {{`WORD_DATA_W-1-`ISA_EXP_W{1'b0}},dly_flag,exp_code};
			end
			`CREG_ADDR_INT_MASK:
			begin
				creg_rd_data = {{`WORD_DATA_W-`CPU_IRQ_CH{1'b0}},mask};
			end
			`CREG_ADDR_IRQ:
			begin
				creg_rd_data = {{`WORD_DATA_W-`CPU_IRQ_CH{1'b0}},irq};
			end
			`CREG_ADDR_ROM_SIZE:
			begin
				creg_rd_data = $unsigned(`ROM_SIZE);
			end
			`CREG_ADDR_SPM_SIZE:
			begin
				creg_rd_data = $unsigned(`SPM_SIZE);
			end
			`CREG_ADDR_CPU_INFO:
			begin
				creg_rd_data = {`RELEASE_YEAR,`RELEASE_MONTH,
								`RELEASE_VERSION,`RELEASE_REVISION};
			end
			default:
			begin
				creg_rd_data = `WORD_DATA_W'h0;
			end
		endcase
	end

	always@(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
		begin
			exe_mode <= #1 `CPU_KERNEL_MODE;
			int_en <= #1 `DISABLE;
			pre_exe_mode <= #1 `CPU_KERNEL_MODE;
			pre_int_en <= #1 `DISABLE;
			exp_code <= #1 `ISA_EXP_NO_EXP;
			mask <= #1 {`CPU_IRQ_CH{`ENABLE}};
			dly_flag <= #1 `DISABLE;
			epc <= #1 `WORD_ADDR_W'h0;
			exp_vector <= #1 `WORD_ADDR_W'h0;
			pre_pc <= #1 `WORD_ADDR_W'h0;
			br_flag <= #1 `DISABLE;
		end
		else 
		begin
			if((mem_en == `ENABLE) && (stall == `DISABLE))
			begin
				pre_pc <= #1 mem_pc;
				br_flag <= #1 mem_br_flag;
				if(mem_exp_code != `ISA_EXP_NO_EXP)
				begin
					exe_mode <= `CPU_KERNEL_MODE;
					int_en <= #1 `DISABLE;
					pre_exe_mode <= #1 exe_mode;
					pre_int_en <= #1 int_en;
					exp_code <= #1 mem_exp_code;
					dly_flag <= #1 br_flag;
					epc <= #1 pre_pc;
				end
				else if(mem_ctrl_op == `CTRL_OP_EXRT)
				begin
					exe_mode <= #1 pre_exe_mode;
					int_en <= #1 pre_int_en;
				end
				else if(mem_ctrl_op == `CTRL_OP_WRCR)
				begin
					case(mem_dst_addr)
						`CREG_ADDR_STATUS:
						begin
							exe_mode <= #1 mem_out[`CregExeModeLoc];
							int_en <= #1 mem_out[`CregIntEnableLoc];
						end
						`CREG_ADDR_PRE_STATUS:
						begin
							pre_exe_mode <= #1 mem_out[`CregExeModeLoc];
							pre_int_en <= #1 mem_out[`CregIntEnableLoc];
						end
						`CREG_ADDR_EPC:
						begin
							epc <= #1 mem_out[`WordAddrLoc];
						end
						`CREG_ADDR_EXP_VECTOR:
						begin
							exp_vector <= #1 mem_out[`WordAddrLoc];
						end
						`CREG_ADDR_CAUSE:
						begin
							dly_flag <= #1 mem_out[`CregDlyFlagLoc];
							exp_code <= #1 mem_out[`CregExpCodeLoc];
						end
						`CREG_ADDR_INT_MASK:
						begin
							mask <= #1 mem_out[`CPU_IRQ_CH-1:0];
						end
					endcase
				end
			end
		end
	end
