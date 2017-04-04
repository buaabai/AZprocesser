`include "global_config.h"
`include "nettype.h"
`include "stddef.h"
`include "cpu.h"
`include "isa.h"

module alu(in_0,in_1,op,out,of);
	input[31:0] in_0;
	input[31:0] in_1;
	input[3:0] op;
	
	output[31:0] out;
	output of;
	
	reg[31:0] out;
	reg of;
	
	wire signed[`WordDataBus] s_in_0 = $signed(in_0);
	wire signed[`WordDataBus] s_in_1 = $signed(in_1);
	wire signed[`WordDataBus] s_out = $signed(out);
	
	always@(*)
	begin
		case(op)
			`ALU_OP_AND:
			begin
				out = in_0 & in_1;
			end
			`ALU_OP_OR:
			begin
				out = in_0 | in_1;
			end
			`ALU_OP_XOR:
			begin
				out = in_0 ^ in_1;
			end
			`ALU_OP_ADDS:
			begin
				out = in_0 + in_1;
			end
			`ALU_OP_ADDU:
			begin
				out = in_0 + in_1;
			end
			`ALU_OP_SUBS:
			begin
				out = in_0 - in_1;
			end
			`ALU_OP_SUBU:
			begin
				out = in_0 - in_1;
			end
			`ALU_OP_SHRL:
			begin
				out = in_0 >> in_1[`ShAmountLoc];
			end
			`ALU_OP_SHLL:
			begin
				out = in_0 << in_1[`ShAmountLoc];
			end
			default:
			begin
				out = in_0;
			end
		endcase
	end
	
	always@(*)
	begin
		case(op)
			`ALU_OP_ADDS:
			begin
				if(((s_in_0 > 0) && (s_in_1 > 0) && (s_out < 0)) || 
					((s_in_0 < 0) && (s_in_1 < 0) && (s_out > 0)))
				begin
					of = `ENABLE;
				end
				else
				begin
					of = `DISABLE;
				end
			end
			`ALU_OP_SUBS:
			begin
				if(((s_in_0 < 0) && (s_in_1 > 0) && (s_out > 0))||
					((s_in_0 > 0) && (s_in_1 < 0) && (s_out <0)))
				begin
					of = `ENABLE;
				end
				else
				begin
					of = `DISABLE;
				end
			end
			default:
			begin
				of = `DISABLE;
			end
		endcase
	end
endmodule	
	