`define NEGATIVE_RESET
`include "global_config.h"
`include "stddef.h"
`include "nettype.h"
`include "gpio.h"
`timescale 1ns/1ns

module gpio(clk,reset,cs_,as_,rw,addr,wr_data,
	rd_data,rdy_,gpio_in,gpio_out,gpio_io);
	
	input clk,reset;
	input cs_,as_,rw;
	input[1:0] addr;
	input[31:0] wr_data;
	input[3:0] gpio_in;
	
	output[31:0] rd_data;
	output rdy_;
	output[17:0] gpio_out;
	
	inout[15:0] gpio_io;
	
	reg[31:0] rd_data;
	reg rdy_;
	reg[17:0] gpio_out;
	
	`ifdef GPIO_IO_CH
		wire[`GPIO_IO_CH-1 : 0] io_in;
		reg[`GPIO_IO_CH-1 : 0] io_out;
		reg[`GPIO_IO_CH-1 : 0] io_dir;
		reg[`GPIO_IO_CH-1 : 0] io;
		integer i;
		
		assign io_in = gpio_io;
		assign gpio_io = io;
		
		always@(*)
		begin
			for(i = 0;i < `GPIO_IO_CH; i = i + 1)
			begin
				io[i] = (io_dir[i] == `GPIO_DIR_IN) ? 1'bz : io_out[i];
			end
		end
	`endif
	
	always@(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
		begin
			rd_data <= #1 `WORD_DATA_W'h0;
			rdy_ <= #1 `DISABLE_;
		`ifdef GPIO_OUT_CH
			gpio_out <= #1 {`GPIO_OUT_CH{`LOW}};
		`endif
		`ifdef GPIO_IO_CH
			io_out <= #1 {`GPIO_IO_CH{`LOW}};
			io_dir <= #1 {`GPIO_IO_CH{`GPIO_DIR_IN}};
		`endif
		end
		else
		begin
			if((cs_ == `ENABLE) && (as_ == `ENABLE_))
			begin
				rdy_ <= #1 `ENABLE_;
			end
			else
			begin
				rdy_ <= #1 `DISABLE_;
			end
			
			if((cs_ == `ENABLE_) && (as_ == `ENABLE_) 
			&& (rw == `READ))
			begin
				case(addr)
			`ifdef GPIO_IO_CH
				`GPIO_ADDR_IN_DATA:
				begin
					rd_data <= #1 {{`WORD_DATA_W-`GPIO_IN_CH{1'b0}},
							gpio_in};
				end
			`endif
			`ifdef GPIO_OUT_CH
				`GPIO_ADDR_OUT_DATA:
				begin
					rd_data <= #1 {{`WORD_DATA_W-`GPIO_OUT_CH{1'b0}},
							gpio_out};
				end
			`endif
			`ifdef GPIO_IO_CH
				`GPIO_ADDR_IO_DATA:
				begin
					rd_data <= #1 {{`WORD_DATA_W-`GPIO_IO_CH{1'b0}},
							io_in};
				end
				`GPIO_ADDR_IO_DIR:
				begin
					rd_data <= #1 {{`WORD_DATA_W-`GPIO_IO_CH{1'b0}},
							io_dir};
				end
			`endif
				endcase
			end
			else
			begin
				rd_data <= #1 `WORD_DATA_W'h0;
			end
			
			if((cs_ == `ENABLE) && (as_ == `ENABLE) 
				&& (rw == `WRITE))
			begin
				case(addr)
			`ifdef GPIO_OUT_CH
				`GPIO_ADDR_OUT_DATA:
				begin
					gpio_out <= #1 wr_data[`GPIO_OUT_CH-1:0];
				end
			`endif
			`ifdef GPIO_IO_CH
				`GPIO_ADDR_IO_DATA:
				begin
					io_out <= #1 wr_data[`GPIO_IO_CH-1:0];
				end
				`GPIO_ADDR_IO_DIR:
				begin
					io_dir <= #1 wr_data[`GPIO_IO_CH-1:0];
				end
			`endif
				endcase
			end
		end
	end
endmodule