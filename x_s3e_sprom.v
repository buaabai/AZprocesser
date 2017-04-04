`timescale 1ns/1ns
`include "nettype.h"
module x_s3e_sprom(clka,addra,douta);
	input clka;
	input[10:0] addra;
	output reg[31:0] douta;
	
	reg[31:0] mem[2047:0];
	
	always@(posedge clka)
	begin
		douta <= #1 mem[addra];
	end
endmodule
	