`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "cpu.h"
`include "isa.h"

module mem_ctrl(
	ex_en,ex_mem_op,ex_mem_wr_data,ex_out,
	rd_data,addr,as_,rw,wr_data,
	out,miss_align
);
	input ex_en;
	input[1:0] ex_mem_op;
	input[31:0] ex_mem_wr_data;
	input[31:0] ex_out;
	
	input[31:0] rd_data;
	
	output[29:0] addr;
	output as_;
	output rw;
	output[31:0] wr_data;
	output[31:0] out;
	output miss_align;
	
	reg as_;
	reg rw;
	reg[31:0] out;
	reg miss_align;
	
	wire[1:0] offset;
	
	assign wr_data = ex_mem_wr_data;
	assign addr = ex_out[`WordAddrLoc];
	assign offset = ex_out[`ByteOffsetLoc];
	
	always@(*)
	begin
		miss_align = `DISABLE;
		out = `WORD_DATA_W'h0;
		as_ = `DISABLE_;
		rw = `READ;
		
		if(ex_en == `ENABLE)
		begin
			case(ex_mem_op)
				`MEM_OP_LDW:
				begin
					if(offset == `BYTE_OFFSET_WORD)
					begin
						out = rd_data;
						as_ = `ENABLE_;
					end
					else
					begin
						miss_align = `ENABLE;
					end
				end
				`MEM_OP_STW:
				begin
					if(offset == `BYTE_OFFSET_WORD)
					begin
						rw = `WRITE;
						as_ = `ENABLE_;
					end
					else
					begin
						miss_align = `ENABLE;
					end
				end
				default:
				begin
					out = ex_out;
				end
			endcase
		end
	end

endmodule
	