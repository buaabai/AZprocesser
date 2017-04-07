`timescale 1ns/1ns
`include "global_config.h"
`include "stddef.h"
`include "nettype.h"
module x_s3e_dpram(clka,wea,addra,dina,douta,
				clkb,web,addrb,dinb,doutb);
	
	input clka,clkb;
	input wea,web;
	input[11:0] addra,addrb;
	input[31:0] dina,dinb;
	
	output reg[31:0] douta,doutb;
	
	reg[31:0] mem[0:4095];
	
	always@(posedge clka)
	begin
		if((web == `ENABLE) && (addra == addrb))
		begin
			douta <= #1 dinb;
		end
		else
		begin
			douta <= #1 mem[addra];
		end
		
		if(wea == `ENABLE)
		begin
			mem[addra] <= #1 dina;
		end
	end
	
	always@(posedge clkb)
	begin
		if((wea == `ENABLE) && (addrb == addra))
		begin
			doutb <= #1 dina;
		end
		else
		begin
			doutb <= #1 mem[addrb];
		end
		
		if(web == `ENABLE)
		begin
			mem[addrb] <= #1 dinb;
		end
	end

endmodule
	