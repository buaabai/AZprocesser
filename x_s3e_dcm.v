module x_s3e_dcm(CLK_IN,RST_IN,CLK0_OUT,CLK180_OUT,LOCKED_OUT);
	input CLK_IN,RST_IN;
	output CLK0_OUT,CLK180_OUT,LOCKED_OUT;
	
	assign CLK0_OUT = CLK_IN;
	assign CLK180_OUT = ~CLK_IN;
	assign LOCKED_OUT = ~RST_IN;
	
endmodule