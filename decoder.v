`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "cpu.h"
`include "isa.h"
`timescale 1ns/1ns

module decoder(
	if_pc,if_insn,if_en,
	gpr_rd_data_0,gpr_rd_data_1,gpr_rd_addr_0,gpr_rd_addr_1,
	id_en,id_dst_addr,id_gpr_we_,id_dst_addr,id_mem_op,
	ex_en,ex_dst_addr,ex_gpr_we_,ex_fwd_data,
	mem_fwd_data,
	exe_mode,creg_rd_data,creg_rd_addr,
	alu_op,alu_in_0,alu_in_1,br_addr,br_taken,br_flag,
	mem_op,mem_wr_data,ctrl_op,dst_addr,gpr_we_,exp_code,ld_hazard
);

	output if_en;
	input[31:0] gpr_rd_data_0,gpr_rd_data_1;
	
	input id_en;
	input[4:0] id_dst_addr;
	input id_gpr_we_;
	input[1:0] id_mem_op;
	
	input ex_en;
	input[4:0] ex_dst_addr;
	input ex_gpr_we_;
	input[31:0] ex_fwd_data;
	
	input[31:0] mem_fwd_data;
	
	input exe_mode;
	input[31:0] creg_rd_data;
	
	output[29:0] if_pc;
	output[31:0] if_insn;
	
	output[4:0] gpr_rd_addr_0;
	output[4:0] gpr_rd_addr_1;
	
	output[4:0] creg_rd_addr;
	
	output[3:0] alu_op;
	output[31:0] alu_in_0,alu_in_1;
	output[29:0] br_addr;
	output br_taken;
	output br_flag;
	output[1:0] mem_op;
	output[31:0] mem_wr_data;
	output[1:0] ctrl_op;
	output[4:0] dst_addr;
	output gpr_we_;
	output[2:0] exp_code;
	output ld_hazard;
	
	reg[29:0] if_pc;
	reg[31:0] if_insn;
	reg if_en;
	
	reg[3:0] alu_op;
	reg[31:0] alu_in_0,alu_in_1;
	reg[29:0] br_addr;
	reg br_flag,br_taken;
	reg[1:0] mem_op;
	reg[1:0] ctrl_op;
	reg[4:0] dst_addr;
	reg gpr_we_;
	reg[2:0] exp_code;
	reg ld_hazard;
	
	wire[`IsaOpBus] op = if_insn[`IsaOpLoc];
	wire[`RegAddrBus] ra_addr = if_insn[`IsaRaAddrLoc];
	wire[`RegAddrBus] rb_addr = if_insn[`IsaRbAddrLoc];
	wire[`RegAddrBus] rc_addr = if_insn[`IsaRcAddrLoc];
	wire[`IsaImmBus] imm = if_insn[`IsaImmLoc];
	
	wire[`WordDataBus] imm_s = {{`ISA_EXT_W{imm[`ISA_IMM_MSB]}},imm};
	
	wire[`WordDataBus] imm_u = {{`ISA_EXT_W{1'b0}},imm};
	
	assign gpr_rd_addr_0 = ra_addr;
	assign gpr_rd_addr_1 = rb_addr;
	assign creg_rd_addr = ra_addr;
	
	reg[`WordDataBus] ra_data;
	wire signed[`WordDataBus] s_ra_data = $signed(ra_data);
	reg[`WordDataBus] rb_data;
	wire signed[`WordDataBus] s_rb_data = $signed(rb_data);
	assign mem_wr_data = rb_data;
	
	wire[`WordDataBus] ret_addr = if_pc + 1'b1;
	wire[`WordDataBus] br_target = if_pc + imm_s[`WORD_ADDR_MSB:0];
	wire[`WordDataBus] jr_target = ra_data[`WordAddrLoc];
	
	always@(*)
	begin
		if((id_en == `ENABLE) && (id_gpr_we_ == `ENABLE_)
			&& (id_dst_addr == ra_addr))
		begin
			ra_data = ex_fwd_data;
		end
		else if((ex_en == `ENABLE) && (id_gpr_we_ == `ENABLE_)
			&&(ex_dst_addr == ra_addr))
		begin
			ra_data = mem_fwd_data;
		end
		else
		begin
			ra_data = gpr_rd_data_0;
		end
		
		if((id_en == `ENABLE) && (id_gpr_we_ == `ENABLE_)
			&& (id_dst_addr == rb_addr))
		begin
			rb_data = ex_fwd_data;
		end
		else if((ex_en == `ENABLE) && (id_gpr_we_ == `ENABLE_)
			&& (ex_dst_addr == rb_addr))
		begin
			rb_data = mem_fwd_data;
		end
		else
		begin
			rb_data = gpr_rd_data_1;
		end
	end
	
	always@(*)
	begin
		if((id_en == `ENABLE) && (id_mem_op == `MEM_OP_LDW) 
			&& ((id_dst_addr == ra_addr)||(id_dst_addr == rb_addr)))
		begin
			ld_hazard = `ENABLE;
		end
		else
		begin
			ld_hazard = `DISABLE;
		end
	end
	
	always@(*)
	begin
		alu_op = `ALU_OP_NOP;
		alu_in_0 = ra_data;
		alu_in_1 = rb_data;
		br_taken = `DISABLE;
		br_flag = `DISABLE;
		br_addr = {`WORD_ADDR_W{1'b0}};
		mem_op = `MEM_OP_NOP;
		ctrl_op = `CTRL_OP_NOP;
		dst_addr = rb_addr;
		gpr_we_ = `DISABLE_;
		exp_code = `ISA_EXP_NO_EXP;
		
		case(op)
			`ISA_OP_ANDR:
			begin
				alu_op = `ALU_OP_AND;
				dst_addr = rc_addr;
				gpr_we_ = `ENABLE_;
			end
			`ISA_OP_ANDI:
			begin
				alu_op = `ALU_OP_AND;
				alu_in_1 = imm_u;
				gpr_we_ = `ENABLE_;
			end
			`ISA_OP_ORR:
			begin
				alu_op = `ALU_OP_OR;
				dst_addr = rc_addr;
				gpr_we_ = `ENABLE_;
			end
			`ISA_OP_ORI:
			begin
				alu_op = `ALU_OP_OR;
				alu_in_1 = imm_u;
				gpr_we_ = `ENABLE_;
			end
			`ISA_OP_XORR:
			begin
				alu_op = `ALU_OP_XOR;
				dst_addr = rc_addr;
				gpr_we_ = `ENABLE_;
			end
			`ISA_OP_XORI:
			begin
				alu_op = `ALU_OP_XOR;
				alu_in_1 = imm_u;
				gpr_we_ = `ENABLE_;
			end
			
			`ISA_OP_ADDSR:
			begin
				alu_op = `ALU_OP_ADDS;
				dst_addr = rc_addr;
				gpr_we_ = `ENABLE_;
			end
			`ISA_OP_ADDSI:
			begin
				alu_op = `ALU_OP_ADDS;
				alu_in_1 = imm_s;
				gpr_we_ = `ENABLE_;
			end
			`ISA_OP_ADDUR:
			begin
				alu_op = `ALU_OP_ADDU;
				dst_addr = rc_addr;
				gpr_we_ = `ENABLE_;
			end
			`ISA_OP_ADDUI:
			begin
				alu_op = `ALU_OP_ADDU;
				alu_in_1 = imm_u;
				gpr_we_ = `ENABLE_;
			end
			`ISA_OP_SUBSR:
			begin
				alu_op = `ALU_OP_SUBS;
				dst_addr = rc_addr;
				gpr_we_ = `ENABLE_;
			end
			`ISA_OP_SUBUR:
			begin
				alu_op = `ALU_OP_SUBU;
				dst_addr = rc_addr;
				gpr_we_ = `ENABLE_;
			end
			
			`ISA_OP_SHRLR:
			begin
				alu_op = `ALU_OP_SHRL;
				dst_addr = rc_addr;
				gpr_we_ = `ENABLE_;
			end
			`ISA_OP_SHRLI:
			begin
				alu_op = `ALU_OP_SHRL;
				alu_in_1 = imm_u;
				gpr_we_ = `ENABLE_;
			end
			`ISA_OP_SHLLR:
			begin
				alu_op = `ALU_OP_SHLL;
				dst_addr = rc_addr;
				gpr_we_ = `ENABLE_;
			end
			`ISA_OP_SHLLI:
			begin
				alu_op = `ALU_OP_SHLL;
				alu_in_1 = imm_u;
				gpr_we_ = `ENABLE_;
			end
			
			`ISA_OP_BE:
			begin
				br_addr = br_target;
				br_taken = (ra_data == rb_data) ? `ENABLE : `DISABLE;
				br_flag = `ENABLE;
			end
			`ISA_OP_BNE:
			begin
				br_addr = br_target;
				br_taken = (ra_data != rb_data) ? `ENABLE : `DISABLE;
				br_flag = `ENABLE;
			end
			`ISA_OP_BSGT:
			begin
				br_addr = br_target;
				br_taken = (s_ra_data < s_rb_data) ? `ENABLE : `DISABLE;
				br_flag = `ENABLE;
			end
			`ISA_OP_BUGT:
			begin
				br_addr = br_target;
				br_taken = (ra_data < rb_data) ? `ENABLE : `DISABLE;
				br_flag = `ENABLE;
			end
			`ISA_OP_JMP:
			begin
				br_addr = jr_target;
				br_taken = `ENABLE;
				br_flag = `ENABLE;
			end
			`ISA_OP_CALL:
			begin
				alu_in_0 = {ret_addr,{`BYTE_OFFSET_W{1'b0}}};
				br_addr = jr_target;
				br_taken = `ENABLE;
				br_flag = `ENABLE;
				dst_addr = `REG_ADDR_W'd31;
				gpr_we_ = `ENABLE_;
			end
			
			`ISA_OP_LDW:
			begin
				alu_op = `ALU_OP_ADDU;
				alu_in_1 =imm_s;
				mem_op = `MEM_OP_LDW;
				gpr_we_ = `ENABLE;
			end
			`ISA_OP_STW:
			begin
				alu_op = `ALU_OP_ADDU;
				alu_in_1 = imm_s;
				mem_op = `MEM_OP_STW;
			end
			
			`ISA_OP_TRAP:
			begin
				exp_code = `ISA_EXP_TRAP;
			end
			
			`ISA_OP_RDCR:
			begin
				if(exe_mode == `CPU_KERNEL_MODE)
				begin
					alu_in_0 = creg_rd_data;
					gpr_we_ = `ENABLE;
				end
				else
				begin
					exp_code = `ISA_EXP_PRV_VIO;
				end
			end
			`ISA_OP_WRCR:
			begin
				if(exe_mode == `CPU_KERNEL_MODE)
				begin
					ctrl_op = `CTRL_OP_WRCR;
				end
				else
				begin
					exp_code = `ISA_EXP_PRV_VIO;
				end
			end
			`ISA_OP_EXRT:
			begin
				if(exe_mode == `CPU_KERNEL_MODE)
				begin
					ctrl_op = `CTRL_OP_EXRT;
				end
				else
				begin
					exp_code = `ISA_EXP_PRV_VIO;
				end
			end
			
			default:
			begin
				exp_code = `ISA_EXP_UNDEF_INSN;
			end
		endcase
	end
	
endmodule
	
	